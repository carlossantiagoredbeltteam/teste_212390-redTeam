#include "parameters.h"
#include "pins.h"
#include "extruder.h"

//FloatPoint current_units;
FloatPoint target_units;
FloatPoint delta_units;

FloatPoint current_steps;
FloatPoint target_steps;
FloatPoint delta_steps;

//our direction vars
byte x_direction = 1;
byte y_direction = 1;
byte z_direction = 1;
byte e_direction = 1;

//init our variables

long x_counter;
long y_counter;
long z_counter;
long e_counter;
bool x_can_step;
bool y_can_step;
bool z_can_step;
bool e_can_step;
int milli_delay;

// Variables for acceleration calculations

long total_steps;
long micro_delay_ends;
long micro_delay_fast;
long start_steps;
long end_steps;

// Initialise X, Y and Z.  The extruder is initialized
// separately.

void init_steppers()
{
	//init our points.
	current_units.x = 0.0;
	current_units.y = 0.0;
	current_units.z = 0.0;
	current_units.e = 0.0;
	target_units.x = 0.0;
	target_units.y = 0.0;
	target_units.z = 0.0;
	target_units.e = 0.0;
	
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

	//turn them off to start.
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
	
	//figure our stuff.
	calculate_deltas();
}

inline void do_x_step()
{
	digitalWrite(X_STEP_PIN, HIGH);
	delayMicroseconds(5);
	digitalWrite(X_STEP_PIN, LOW);
}

inline void do_y_step()
{
	digitalWrite(Y_STEP_PIN, HIGH);
	delayMicroseconds(5);
	digitalWrite(Y_STEP_PIN, LOW);
}

inline void do_z_step()
{
	digitalWrite(Z_STEP_PIN, HIGH);
	delayMicroseconds(5);
	digitalWrite(Z_STEP_PIN, LOW);
}

inline void do_e_step()
{
        ex[extruder_in_use]->step();
}


void move(float x, float y, float z, float e, float feedrate)
{
  set_target(x, y, z, e);
  dda_move(calculate_feedrate_delay(feedrate));
}


void dda_move(long micro_delay)
{
	//figure out our deltas
	//total_steps = max(delta_steps.x, delta_steps.y);
	//total_steps = max(delta_steps.z, total_steps);
	//total_steps = max(delta_steps.e, total_steps);

	//init stuff.
	long x_counter = -total_steps/2;
	long y_counter = -total_steps/2;
	long z_counter = -total_steps/2;
        long e_counter = -total_steps/2;
	
	//our step flags
	bool x_can_step = 0;
	bool y_can_step = 0;
	bool z_can_step = 0;
	bool e_can_step = 0;

	//how long do we delay for?
	if (micro_delay >= 16383)
		milli_delay = micro_delay / 1000;
	else
		milli_delay = 0;

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
		
		//keep it hot =)
		manage_all_extruders();
				
		//wait for next step.
		if (milli_delay > 0)
			delay(milli_delay);			
		else
			delayMicrosecondsInterruptible(micro_delay);
	}
	while (x_can_step || y_can_step || z_can_step  || e_can_step);
	
	//set our points to be the same
	current_units.x = target_units.x;
	current_units.y = target_units.y;
	current_units.z = target_units.z;
	current_units.e = target_units.e;
	calculate_deltas();
        disable_steppers();
}

bool can_step(byte min_pin, byte max_pin, long current, long target, byte dir)
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

	//default to being able to step
	return true;
}



bool read_switch(byte pin)
{
	//dual read as crude debounce
	#if ENDSTOPS_INVERTING == 1
		return !digitalRead(pin) && !digitalRead(pin);
	#else
		return digitalRead(pin) && digitalRead(pin);
	#endif
}

long to_steps(float steps_per_unit, float units)
{
	return steps_per_unit * units;
}

void set_target(float x, float y, float z, float e)
{
	target_units.x = x;
	target_units.y = y;
	target_units.z = z;
	target_units.e = e;
	
	calculate_deltas();
}


void set_target_home()
{
	target_units.x = 0.0;
	target_units.y = 0.0;
	target_units.z = 0.0;
	target_units.e = current_units.e;
	
	calculate_deltas();
}


void set_position(float x, float y, float z, float e)
{
	current_units.x = x;
	current_units.y = y;
	current_units.z = z;
	current_units.e = e;
	
	calculate_deltas();
}

void calculate_deltas()
{
	//figure our deltas.
	delta_units.x = abs(target_units.x - current_units.x);
	delta_units.y = abs(target_units.y - current_units.y);
	delta_units.z = abs(target_units.z - current_units.z);
	delta_units.e = abs(target_units.e - current_units.e);
				
	//set our steps current, target, and delta
	current_steps.x = to_steps(x_units, current_units.x);
	current_steps.y = to_steps(y_units, current_units.y);
	current_steps.z = to_steps(z_units, current_units.z);
	current_steps.e = to_steps(e_units, current_units.e);

	target_steps.x = to_steps(x_units, target_units.x);
	target_steps.y = to_steps(y_units, target_units.y);
	target_steps.z = to_steps(z_units, target_units.z);
	target_steps.e = to_steps(e_units, target_units.e);

	delta_steps.x = abs(target_steps.x - current_steps.x);
	delta_steps.y = abs(target_steps.y - current_steps.y);
	delta_steps.z = abs(target_steps.z - current_steps.z);
	delta_steps.e = abs(target_steps.e - current_steps.e);
	
	//what is our direction
	x_direction = (target_units.x >= current_units.x);
	y_direction = (target_units.y >= current_units.y);
	z_direction = (target_units.z >= current_units.z);
	e_direction = (target_units.e >= current_units.e);

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
          ex[extruder_in_use]->set_direction(1);
        else
          ex[extruder_in_use]->set_direction(0);        
}


long calculate_feedrate_delay(float feedrate)
{
	//how long is our line length?
	float distance = sqrt(delta_units.x*delta_units.x + 
                              delta_units.y*delta_units.y + 
                              delta_units.z*delta_units.z + 
                              delta_units.e*delta_units.e);  // Should this be here?  Hyperdistance?
	
	//find the dominant axis.

        total_steps = max(delta_steps.x, delta_steps.y);
        total_steps = max(total_steps, delta_steps.z);
        total_steps = max(total_steps, delta_steps.e);
        
	//calculate delay between steps in microseconds.  this is sort of tricky, but not too bad.
	//the formula has been condensed to save space.  here it is in english:
        // (feedrate is in mm/minute)
	// 60000000.0*distance/feedrate  = move duration in microseconds
	// move duration/master_steps = time between steps for master axis.

	return ((distance * 60000000.0) / feedrate) / total_steps;	
}

long getMaxSpeed()
{
	if (delta_steps.z > 0)
		return calculate_feedrate_delay(FAST_Z_FEEDRATE);
	else
		return calculate_feedrate_delay(FAST_XY_FEEDRATE);
}

void enable_steppers()
{
#ifdef SANGUINO
  if(target_units.x != current_units.x)
    digitalWrite(X_ENABLE_PIN, ENABLE_ON);
  if(target_units.y != current_units.y)    
    digitalWrite(Y_ENABLE_PIN, ENABLE_ON);
  if(target_units.z != current_units.z)
    digitalWrite(Z_ENABLE_PIN, ENABLE_ON);
  if(target_units.e != current_units.e)
    ex[extruder_in_use]->enableStep();   
#endif  
}



void disable_steppers()
{
#ifdef SANGUINO 
	//disable our steppers
	digitalWrite(X_ENABLE_PIN, !ENABLE_ON);
	digitalWrite(Y_ENABLE_PIN, !ENABLE_ON);
	digitalWrite(Z_ENABLE_PIN, !ENABLE_ON);

        // Disabling the extrude stepper causes the backpressure to
        // turn the motor the wrong way.  Leave it on.
        
        //ex[extruder_in_use]->disableStep();       
#endif
}

void delayMicrosecondsInterruptible(unsigned int us)
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

#ifdef TEST_MACHINE

void X_motor_test()
{
    Serial.println("Moving X forward by 100 mm at half maximum speed.");
    set_target(100, 0, 0);
    enable_steppers();
    dda_move(calculate_feedrate_delay(FAST_XY_FEEDRATE/2));
    
    Serial.println("Pause for 2 seconds.");
    delay(2000);
    
    Serial.println("Moving X back to the start.");
    set_target(0, 0, 0);
    enable_steppers();
    dda_move(calculate_feedrate_delay(FAST_XY_FEEDRATE/2));
    
    Serial.println("Pause for 2 seconds."); 
    delay(2000);   
}

void Y_motor_test()
{

    Serial.println("Moving Y forward by 100 mm at half maximum speed.");
    set_target(0, 100, 0);
    enable_steppers();
    dda_move(calculate_feedrate_delay(FAST_XY_FEEDRATE/2));
    
    Serial.println("Pause for 2 seconds.");
    delay(2000);
    
    Serial.println("Moving Y back to the start.");
    set_target(0, 0, 0);
    enable_steppers();
    dda_move(calculate_feedrate_delay(FAST_XY_FEEDRATE/2));
    
    Serial.println("Pause for 2 seconds."); 
    delay(2000);     
}

void Z_motor_test()
{
    Serial.println("Moving Z down by 5 mm at half maximum speed.");
    set_target(0, 0, 5);
    enable_steppers();
    dda_move(calculate_feedrate_delay(FAST_Z_FEEDRATE/2));
    
    Serial.println("Pause for 2 seconds.");
    delay(2000);
    
    Serial.println("Moving Z back to the start.");
    set_target(0, 0, 0);
    enable_steppers();
    dda_move(calculate_feedrate_delay(FAST_Z_FEEDRATE/2));
    
    Serial.println("Pause for 2 seconds."); 
    delay(2000);     
}

#endif
