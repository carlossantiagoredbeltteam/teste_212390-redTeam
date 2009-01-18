// our point structure to make things nice.
struct LongPoint {
	long x;
	long y;
 	long z;
};

//init our variables
long max_delta;

long x_counter;
bool x_can_step;
bool x_direction;

long y_counter;
bool y_can_step;
bool y_direction;

long z_counter;
bool z_can_step;
bool z_direction;

//our position tracking variables
LongPoint current_steps;
LongPoint target_steps;
LongPoint delta_steps;
LongPoint range_steps;

//initialize our stepper drivers
void init_steppers()
{
  //load the range from EEPROM?

	//initialize all our pins.
	pinMode(X_STEP_PIN, OUTPUT);
	pinMode(X_DIR_PIN, OUTPUT);
	pinMode(X_ENABLE_PIN, OUTPUT);
	pinMode(X_MIN_PIN, INPUT);
	pinMode(X_MAX_PIN, INPUT);
	
	pinMode(Y_STEP_PIN, OUTPUT);
	pinMode(Y_DIR_PIN, OUTPUT);
	pinMode(Y_ENABLE_PIN, OUTPUT);
	pinMode(Y_MIN_PIN, INPUT);
	pinMode(Y_MAX_PIN, INPUT);
	
	pinMode(Z_STEP_PIN, OUTPUT);
	pinMode(Z_DIR_PIN, OUTPUT);
	pinMode(Z_ENABLE_PIN, OUTPUT);
	pinMode(Z_MIN_PIN, INPUT);
	pinMode(Z_MAX_PIN, INPUT);

	//turn them off to start.
	disable_steppers();
	
	//figure our stuff.
	calculate_deltas();
}

void prepare_dda()
{
	//enable our steppers
	digitalWrite(X_ENABLE_PIN, HIGH);
	digitalWrite(Y_ENABLE_PIN, HIGH);
	digitalWrite(Z_ENABLE_PIN, HIGH);
	
	//figure out our deltas
	max_delta = 0;
	max_delta = max(delta_steps.x, delta_steps.y);
	max_delta = max(delta_steps.z, max_delta);

	//init stuff.
	x_counter = -max_delta/2;
	y_counter = -max_delta/2;
	z_counter = -max_delta/2;
}

void dda_step()
{
	//do a single step on our DDA line!
	x_can_step = can_step(X_MIN_PIN, X_MAX_PIN, current_steps.x, target_steps.x, x_direction);
	y_can_step = can_step(Y_MIN_PIN, Y_MAX_PIN, current_steps.y, target_steps.y, y_direction);
	z_can_step = can_step(Z_MIN_PIN, Z_MAX_PIN, current_steps.z, target_steps.z, z_direction);

	if (x_can_step)
	{
		x_counter += delta_steps.x;
		
		if (x_counter > 0)
		{
			do_step(X_STEP_PIN);
			x_counter -= max_delta;
			
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
			do_step(Y_STEP_PIN);
			y_counter -= max_delta;

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
			do_step(Z_STEP_PIN);
			z_counter -= max_delta;
			
			if (z_direction)
				current_steps.z++;
			else
				current_steps.z--;
		}
	}	

	//we're either at our target, or we're stuck.
	if (!x_can_step && !y_can_step && !z_can_step)
	{
		//grab next point or something?
	}
}

bool can_step(byte min_pin, byte max_pin, long current, long target, byte direction)
{
	//stop us if we're on target
	if (target == current)
		return false;
	//stop us if we're at home and still going 
	else if (read_switch(min_pin) && !direction)
		return false;
	//stop us if we're at max and still going
	else if (read_switch(max_pin) && direction)
		return false;

	//default to being able to step
	return true;
}

void do_step(byte step_pin)
{
	digitalWrite(step_pin, HIGH);
	delayMicrosecondsInterruptible(5);
	digitalWrite(step_pin, LOW);
}

bool read_switch(byte pin)
{
	//dual read as crude debounce
	if ( SENSORS_INVERTING )
		return !digitalRead(pin) && !digitalRead(pin);
	else
		return digitalRead(pin) && digitalRead(pin);
}

void calculate_deltas()
{
	//figure our deltas.
	delta_steps.x = abs(target_steps.x - current_steps.x);
	delta_steps.y = abs(target_steps.y - current_steps.y);
	delta_steps.z = abs(target_steps.z - current_steps.z);
	
	//what is our direction
	x_direction = (target_steps.x >= current_steps.x);
	y_direction = (target_steps.y >= current_steps.y);
	z_direction = (target_steps.z >= current_steps.z);

	//set our direction pins as well
	digitalWrite(X_DIR_PIN, x_direction);
	digitalWrite(Y_DIR_PIN, y_direction);
	digitalWrite(Z_DIR_PIN, z_direction);
}

void disable_steppers()
{
	//disable our steppers
	digitalWrite(X_ENABLE_PIN, LOW);
	digitalWrite(Y_ENABLE_PIN, LOW);
	digitalWrite(Z_ENABLE_PIN, LOW);
}

