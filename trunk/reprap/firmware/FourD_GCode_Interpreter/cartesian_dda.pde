#include "parameters.h"
#include "pins.h"
#include "extruder.h"
#include "vectors.h"
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
        t_direction = 1;
        
  // Default to the origin and not going anywhere
  
	current_position.x = 0.0;
	current_position.y = 0.0;
	current_position.z = 0.0;
	current_position.e = 0.0;
        current_position.f = SLOW_XY_FEEDRATE;
	target_position.x = 0.0;
	target_position.y = 0.0;
	target_position.z = 0.0;
	target_position.e = 0.0;
        target_position.f = SLOW_XY_FEEDRATE;

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
      units.x = X_STEPS_PER_MM;
      units.y = Y_STEPS_PER_MM;
      units.z = Z_STEPS_PER_MM;
      units.e = E_STEPS_PER_MM;
      units.f = 1.0;
    } else
    {
      units.x = X_STEPS_PER_INCH;
      units.y = Y_STEPS_PER_INCH;
      units.z = Z_STEPS_PER_INCH;
      units.e = E_STEPS_PER_INCH;
      units.f = 1.0;  
    }
}




bool cartesian_dda::set_target(const FloatPoint& p)
{
        target_position = p;
        
	//figure our deltas.

	delta_position = fabsv(target_position - current_position);

        // The feedrate values refer to distance in (X, Y, Z) space, so ignore e and f
        // values unless they're the only thing there.

        FloatPoint squares = delta_position*delta_position;
        distance = squares.x + squares.y + squares.z;
        // If we are 0, only thing changing is e
        if(distance <= 0.0)
          distance = squares.e;
        // If we are still 0, only thing changing is f
        if(distance <= 0.0)
          distance = squares.f;
        distance = sqrt(distance);          
                                                                         
                          			
	//set our steps current, target, and delta

	current_steps = to_steps(units, current_position);
	target_steps = to_steps(units, target_position);
	delta_steps = absv(target_steps - current_steps);

	// find the dominant axis.
        // NB we ignore the t values here, as it takes no time to take a step in time :-)

        total_steps = max(delta_steps.x, delta_steps.y);
        total_steps = max(total_steps, delta_steps.z);
        total_steps = max(total_steps, delta_steps.e);
  
        // If we're not going anywhere, flag the fact
        
        if(total_steps == 0)
          return false;    

#ifdef ACCELERATION_ON
        //current_steps.t = calculate_feedrate_delay(current_position.f);
#else
        //current_steps.t = calculate_feedrate_delay(target_position.f);
        current_steps.t = round(target_position.f);
#endif
        //if(current_steps.t <= 0)
         // return false;
          
        //target_steps.t = calculate_feedrate_delay(target_position.f);
        delta_steps.t = abs(target_steps.t - current_steps.t);
        t_scale = 1;
        if(delta_steps.t > total_steps)
        {
            t_scale = delta_steps.t/total_steps;
            if(t_scale >= 3)
            {
              target_steps.t = target_steps.t/t_scale;
              current_steps.t = current_steps.t/t_scale;
              delta_steps.t = abs(target_steps.t - current_steps.t);
              if(delta_steps.t > total_steps)
                total_steps =  delta_steps.t;
            } else
            {
              t_scale = 1;
              total_steps =  delta_steps.t;
            }
        } 
        	
	//what is our direction?

	x_direction = (target_position.x >= current_position.x);
	y_direction = (target_position.y >= current_position.y);
	z_direction = (target_position.z >= current_position.z);
	e_direction = (target_position.e >= current_position.e);
	t_direction = (target_position.f >= current_position.f);

	dda_counter.x = -total_steps/2;
	dda_counter.y = dda_counter.x;
	dda_counter.z = dda_counter.x;
        dda_counter.e = dda_counter.x;
        dda_counter.t = dda_counter.x;
  
        return true;        
}


// Run the DDA

void cartesian_dda::dda_move()
{
  // Set up the DDA
  
        long timestep;
        int extcount;
  
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
  
    //turn on steppers to start moving =)
    
	enable_steppers();

        bool real_move; // Flag to know if we've changed something physical
        
        extcount = 0;

  //do our DDA line!

	do
	{
		x_can_step = can_step(X_MIN_PIN, X_MAX_PIN, current_steps.x, target_steps.x, x_direction);
		y_can_step = can_step(Y_MIN_PIN, Y_MAX_PIN, current_steps.y, target_steps.y, y_direction);
		z_can_step = can_step(Z_MIN_PIN, Z_MAX_PIN, current_steps.z, target_steps.z, z_direction);
                e_can_step = can_step(-1, -1, current_steps.e, target_steps.e, e_direction);
                t_can_step = can_step(-1, -1, current_steps.t, target_steps.t, t_direction);
                
                real_move = false;
                
		if (x_can_step)
		{
			dda_counter.x += delta_steps.x;
			
			if (dda_counter.x > 0)
			{
				do_x_step();
                                real_move = true;
				dda_counter.x -= total_steps;
				
				if (x_direction)
					current_steps.x++;
				else
					current_steps.x--;
			}
		}

		if (y_can_step)
		{
			dda_counter.y += delta_steps.y;
			
			if (dda_counter.y > 0)
			{
				do_y_step();
                                real_move = true;
				dda_counter.y -= total_steps;

				if (y_direction)
					current_steps.y++;
				else
					current_steps.y--;
			}
		}
		
		if (z_can_step)
		{
			dda_counter.z += delta_steps.z;
			
			if (dda_counter.z > 0)
			{
				do_z_step();
                                real_move = true;
				dda_counter.z -= total_steps;
				
				if (z_direction)
					current_steps.z++;
				else
					current_steps.z--;
			}
		}

		if (e_can_step)
		{
			dda_counter.e += delta_steps.e;
			
			if (dda_counter.e > 0)
			{
				do_e_step();
                                real_move = true;
				dda_counter.e -= total_steps;
				
				if (e_direction)
					current_steps.e++;
				else
					current_steps.e--;
			}
		}
		
		if (t_can_step)
		{
			dda_counter.t += delta_steps.t;
			
			if (dda_counter.t > 0)
			{
				dda_counter.t -= total_steps;
				if (t_direction)
					current_steps.t++;
				else
					current_steps.t--;
			}
		}

				
      // wait for next step.
      // Use milli- or micro-seconds, as appropriate
      // If the only thing that changed was t; don't bother to delay
  
                if(real_move)
                {
                  // keep it hot =)
                  extcount++;
                  if(extcount > 50)
                  {
                    extcount = 0;
		    manage_all_extruders();
                  }
                  if(t_scale > 1)
                    timestep = t_scale*current_steps.t;
                  else
                    timestep = current_steps.t;
                  timestep = calculate_feedrate_delay((float) timestep);
	          if (timestep >= 16383)
		    delay(timestep/1000);
	          else
		    delayMicrosecondsInterruptible(timestep);
                }
                
	} while (x_can_step || y_can_step || z_can_step  || e_can_step || t_can_step);
	
  //set my current position to be where I now am.

	current_position = target_position;

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

