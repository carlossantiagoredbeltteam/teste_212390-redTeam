#include "parameters.h"
#include "pins.h"
#include "extruder.h"
#include "cartesian_dda.h"


// Initialise X, Y and Z.  The extruder is initialized
// separately.

cartesian_dda::cartesian_dda()
{
  // Default is going forward
  
        x_direction = 1;
        y_direction = 1;
        z_direction = 1;
        e_direction = 1;
        
  // Default to the origin and not going anywhere
  
	current_position.x = 0.0;
	current_position.y = 0.0;
	current_position.z = 0.0;
	current_position.e = 0.0;
	target_position.x = 0.0;
	target_position.y = 0.0;
	target_position.z = 0.0;
	target_position.e = 0.0;

  // Set up the pin directions
  
	pinMode(X_STEP_PIN, OUTPUT);
	pinMode(X_DIR_PIN, OUTPUT);

	pinMode(Y_STEP_PIN, OUTPUT);
	pinMode(Y_DIR_PIN, OUTPUT);

	pinMode(Z_STEP_PIN, OUTPUT);
	pinMode(Z_DIR_PIN, OUTPUT);

#ifdef SANGUINO
	pinMode(X_ENABLE_PIN, OUTPUT);
	pinMode(Y_ENABLE_PIN, OUTPUT);
	pinMode(Z_ENABLE_PIN, OUTPUT);
#endif

  //turn the motors off at the start.

	disable_steppers();

#if ENDSTOPS_MIN_ENABLED == 1
	pinMode(X_MIN_PIN, INPUT);
	pinMode(Y_MIN_PIN, INPUT);
	pinMode(Z_MIN_PIN, INPUT);
#endif

#if ENDSTOPS_MAX_ENABLED == 1
	pinMode(X_MAX_PIN, INPUT);
	pinMode(Y_MAX_PIN, INPUT);
	pinMode(Z_MAX_PIN, INPUT);
#endif
	
        // Default units are mm
        
        set_units(true);
}

// Switch between mm and inches

void cartesian_dda::set_units(bool using_mm)
{
    if(using_mm)
    {
      x_units = X_STEPS_PER_MM;
      y_units = Y_STEPS_PER_MM;
      z_units = Z_STEPS_PER_MM;
      e_units = E_STEPS_PER_MM;
    } else
    {
      x_units = X_STEPS_PER_INCH;
      y_units = Y_STEPS_PER_INCH;
      z_units = Z_STEPS_PER_INCH;
      e_units = E_STEPS_PER_INCH;      
    }
    calculate_deltas();
}


// Run the DDA

void cartesian_dda::dda_move(float feedrate)
{
  
  // How long between steps?
  
        int milli_delay;
        long micro_delay = calculate_feedrate_delay(feedrate);

  // Use milli- or micro-seconds, as appropriate
  
	if (micro_delay >= 16383)
		milli_delay = micro_delay / 1000;
	else
		milli_delay = 0;

  // Set up the DDA
  
	long x_counter = -total_steps/2;
	long y_counter = -total_steps/2;
	long z_counter = -total_steps/2;
        long e_counter = -total_steps/2;

	bool x_can_step = 0;
	bool y_can_step = 0;
	bool z_can_step = 0;
	bool e_can_step = 0;

  //turn on steppers to start moving =)
  
	enable_steppers();

  //do our DDA line!

	do
	{
		x_can_step = can_step(X_MIN_PIN, X_MAX_PIN, current_steps.x, target_steps.x, x_direction);
		y_can_step = can_step(Y_MIN_PIN, Y_MAX_PIN, current_steps.y, target_steps.y, y_direction);
		z_can_step = can_step(Z_MIN_PIN, Z_MAX_PIN, current_steps.z, target_steps.z, z_direction);
                e_can_step = can_step(-1, -1, current_steps.e, target_steps.e, e_direction);
                
		if (x_can_step)
		{
			x_counter += delta_steps.x;
			
			if (x_counter > 0)
			{
				do_x_step();
				x_counter -= total_steps;
				
				if (x_direction)
					current_steps.x++;
				else
					current_steps.x--;
			}
		}

		if (y_can_step)
		{
			y_counter += delta_steps.y;
			
			if (y_counter > 0)
			{
				do_y_step();
				y_counter -= total_steps;

				if (y_direction)
					current_steps.y++;
				else
					current_steps.y--;
			}
		}
		
		if (z_can_step)
		{
			z_counter += delta_steps.z;
			
			if (z_counter > 0)
			{
				do_z_step();
				z_counter -= total_steps;
				
				if (z_direction)
					current_steps.z++;
				else
					current_steps.z--;
			}
		}

		if (e_can_step)
		{
			e_counter += delta_steps.e;
			
			if (e_counter > 0)
			{
				do_e_step();
				e_counter -= total_steps;
				
				if (e_direction)
					current_steps.e++;
				else
					current_steps.e--;
			}
		}
		
      // keep it hot =)
    
		manage_all_extruders();
				
      // wait for next step.
    
		if (milli_delay > 0)
			delay(milli_delay);			
		else
			delayMicrosecondsInterruptible(micro_delay);
	}
	while (x_can_step || y_can_step || z_can_step  || e_can_step);
	
  //set my current position to be where I now am.

	current_position.x = target_position.x;
	current_position.y = target_position.y;
	current_position.z = target_position.z;
	current_position.e = target_position.e;

  // Keep stuff up-to-date
  
	calculate_deltas();

  // Motors off
  
        disable_steppers();
}

bool cartesian_dda::can_step(byte min_pin, byte max_pin, long current, long target, byte dir)
{

  //stop us if we're on target

	if (target == current)
		return false;

#if ENDSTOPS_MIN_ENABLED == 1

  //stop us if we're home and still going
  
	else if(min_pin >= 0)
        {
          if (read_switch(min_pin) && !dir)
		return false;
        }
#endif

#if ENDSTOPS_MAX_ENABLED == 1

  //stop us if we're at max and still going
  
	else if(max_pin >= 0)
        {
 	    if (read_switch(max_pin) && dir)
 		return false;
        }
#endif

  // All OK - we can step
  
	return true;
}



bool cartesian_dda::read_switch(byte pin)
{
	//dual read as crude debounce

	#if ENDSTOPS_INVERTING == 1
		return !digitalRead(pin) && !digitalRead(pin);
	#else
		return digitalRead(pin) && digitalRead(pin);
	#endif
}



void cartesian_dda::set_target(float x, float y, float z, float e)
{
	target_position.x = x;
	target_position.y = y;
	target_position.z = z;
	target_position.e = e;
	
	calculate_deltas();
}



void cartesian_dda::set_position(float x, float y, float z, float e)
{
	current_position.x = x;
	current_position.y = y;
	current_position.z = z;
	current_position.e = e;
	
	calculate_deltas();
}

void cartesian_dda::calculate_deltas()
{
	//figure our deltas.
	delta_position.x = abs(target_position.x - current_position.x);
	delta_position.y = abs(target_position.y - current_position.y);
	delta_position.z = abs(target_position.z - current_position.z);
	delta_position.e = abs(target_position.e - current_position.e);
				
	//set our steps current, target, and delta
	current_steps.x = to_steps(x_units, current_position.x);
	current_steps.y = to_steps(y_units, current_position.y);
	current_steps.z = to_steps(z_units, current_position.z);
	current_steps.e = to_steps(e_units, current_position.e);

	target_steps.x = to_steps(x_units, target_position.x);
	target_steps.y = to_steps(y_units, target_position.y);
	target_steps.z = to_steps(z_units, target_position.z);
	target_steps.e = to_steps(e_units, target_position.e);

	delta_steps.x = abs(target_steps.x - current_steps.x);
	delta_steps.y = abs(target_steps.y - current_steps.y);
	delta_steps.z = abs(target_steps.z - current_steps.z);
	delta_steps.e = abs(target_steps.e - current_steps.e);
	
	//what is our direction
	x_direction = (target_position.x >= current_position.x);
	y_direction = (target_position.y >= current_position.y);
	z_direction = (target_position.z >= current_position.z);
	e_direction = (target_position.e >= current_position.e);

	//set our direction pins as well
#if INVERT_X_DIR == 1
	digitalWrite(X_DIR_PIN, !x_direction);
#else
	digitalWrite(X_DIR_PIN, x_direction);
#endif

#if INVERT_Y_DIR == 1
	digitalWrite(Y_DIR_PIN, !y_direction);
#else
	digitalWrite(Y_DIR_PIN, y_direction);
#endif

#if INVERT_Z_DIR == 1
	digitalWrite(Z_DIR_PIN, !z_direction);
#else
	digitalWrite(Z_DIR_PIN, z_direction);
#endif
        if(e_direction)
          ext->set_direction(1);
        else
          ext->set_direction(0);        
}


long cartesian_dda::calculate_feedrate_delay(float feedrate)
{
	//how long is our line length?

	float distance = sqrt(delta_position.x*delta_position.x + 
                              delta_position.y*delta_position.y + 
                              delta_position.z*delta_position.z + 
                              delta_position.e*delta_position.e);  // This must be here in case it is the only non-0 one.
	
	//find the dominant axis.

        total_steps = max(delta_steps.x, delta_steps.y);
        total_steps = max(total_steps, delta_steps.z);
        total_steps = max(total_steps, delta_steps.e);
        
	// Calculate delay between steps in microseconds.  Here it is in English:
        // (feedrate is in mm/minute)
	// 60000000.0*distance/feedrate  = move duration in microseconds
	// move duration/master_steps = time between steps for master axis.

	return ((distance * 60000000.0) / feedrate) / total_steps;	
}


void cartesian_dda::enable_steppers()
{
#ifdef SANGUINO
  if(target_position.x != current_position.x)
    digitalWrite(X_ENABLE_PIN, ENABLE_ON);
  if(target_position.y != current_position.y)    
    digitalWrite(Y_ENABLE_PIN, ENABLE_ON);
  if(target_position.z != current_position.z)
    digitalWrite(Z_ENABLE_PIN, ENABLE_ON);
  if(target_position.e != current_position.e)
    ext->enableStep();   
#endif  
}



void cartesian_dda::disable_steppers()
{
#ifdef SANGUINO 
	//disable our steppers
	digitalWrite(X_ENABLE_PIN, !ENABLE_ON);
	digitalWrite(Y_ENABLE_PIN, !ENABLE_ON);
	digitalWrite(Z_ENABLE_PIN, !ENABLE_ON);

        // Disabling the extrude stepper causes the backpressure to
        // turn the motor the wrong way.  Leave it on.
        
        //ext->disableStep();       
#endif
}

void cartesian_dda::delayMicrosecondsInterruptible(unsigned int us)
{

#if F_CPU >= 16000000L
    // for the 16 MHz clock on most Arduino boards

	// for a one-microsecond delay, simply return.  the overhead
	// of the function call yields a delay of approximately 1 1/8 us.
	if (--us == 0)
		return;

	// the following loop takes a quarter of a microsecond (4 cycles)
	// per iteration, so execute it four times for each microsecond of
	// delay requested.
	us <<= 2;

	// account for the time taken in the preceeding commands.
	us -= 2;
#else
    // for the 8 MHz internal clock on the ATmega168

    // for a one- or two-microsecond delay, simply return.  the overhead of
    // the function calls takes more than two microseconds.  can't just
    // subtract two, since us is unsigned; we'd overflow.
	if (--us == 0)
		return;
	if (--us == 0)
		return;

	// the following loop takes half of a microsecond (4 cycles)
	// per iteration, so execute it twice for each microsecond of
	// delay requested.
	us <<= 1;
    
    // partially compensate for the time taken by the preceeding commands.
    // we can't subtract any more than this or we'd overflow w/ small delays.
    us--;
#endif

	// busy wait
	__asm__ __volatile__ (
		"1: sbiw %0,1" "\n\t" // 2 cycles
		"brne 1b" : "=w" (us) : "0" (us) // 2 cycles
	);
}

