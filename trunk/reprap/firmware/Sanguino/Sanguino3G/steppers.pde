//init our variables
volatile long max_delta;

volatile long x_counter;
volatile bool x_can_step;
volatile bool x_direction;

volatile long y_counter;
volatile bool y_can_step;
volatile bool y_direction;

volatile long z_counter;
volatile bool z_can_step;
volatile bool z_direction;

//our position tracking variables
volatile LongPoint current_steps;
volatile LongPoint target_steps;
volatile LongPoint delta_steps;
volatile LongPoint range_steps;

//our point queue variables
#define POINT_QUEUE_SIZE 32
#define POINT_SIZE 9
byte rawPointBuffer[POINT_QUEUE_SIZE * POINT_SIZE];
CircularBuffer pointBuffer(POINT_QUEUE_SIZE * POINT_SIZE, rawPointBuffer);

//initialize our stepper drivers
void init_steppers()
{
	//clear our point buffer
	pointBuffer.clear();
	
	//pull in our saved values.
	read_range_from_eeprom();
	
	//prep timer 1 for handling DDA stuff.
	setupTimer1Interrupt();

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

//prepare our variables for a bresenham DDA run.
void prepare_dda()
{
	//enable our steppers
	if (delta_steps.x > 0)
		digitalWrite(X_ENABLE_PIN, STEPPER_ENABLE);
	if (delta_steps.y > 0)
		digitalWrite(Y_ENABLE_PIN, STEPPER_ENABLE);
	if (delta_steps.z > 0)
		digitalWrite(Z_ENABLE_PIN, STEPPER_ENABLE);
	
	//figure out our deltas
	max_delta = 0;
	max_delta = max(delta_steps.x, delta_steps.y);
	max_delta = max(delta_steps.z, max_delta);

	//init stuff.
	x_counter = -max_delta/2;
	y_counter = -max_delta/2;
	z_counter = -max_delta/2;
}

//do a single step on our DDA line!
inline void dda_step()
{
	//check endstops, position, etc.
	x_can_step = can_step(X_MIN_PIN, X_MAX_PIN, current_steps.x, target_steps.x, x_direction);
	y_can_step = can_step(Y_MIN_PIN, Y_MAX_PIN, current_steps.y, target_steps.y, y_direction);
	z_can_step = can_step(Z_MIN_PIN, Z_MAX_PIN, current_steps.z, target_steps.z, z_direction);

	//increment our x counter, and take steps if required.
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

	//increment our y counter, and take steps if required.
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
	
	//increment our z counter, and take steps if required.
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
		//grab next point?
		if (pointBuffer.size() >= POINT_SIZE)
		{
			
		}
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

//actually send a step signal.
void do_step(byte step_pin)
{
	digitalWrite(step_pin, HIGH);
	delayMicrosecondsInterruptible(5);
	digitalWrite(step_pin, LOW);
}

//figure out if we're at a switch or not
bool read_switch(byte pin)
{
	//dual read as crude debounce
	if (SENSORS_INVERTING)
		return !digitalRead(pin) && !digitalRead(pin);
	else
		return digitalRead(pin) && digitalRead(pin);
}

//prepare our deltas and such for our DDA action
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

//turn off steppers to save juice / keep things cool.
void disable_steppers()
{
	//disable our steppers
	digitalWrite(X_ENABLE_PIN, STEPPER_DISABLE);
	digitalWrite(Y_ENABLE_PIN, STEPPER_DISABLE);
	digitalWrite(Z_ENABLE_PIN, STEPPER_DISABLE);
}

//read all of our states into a single byte.
byte get_endstop_states()
{
	byte state = 0;
	
	//each one is its own bit in the byte.
	state |= read_switch(Z_MAX_PIN) << 5;
	state |= read_switch(Z_MIN_PIN) << 4;
	state |= read_switch(Y_MAX_PIN) << 3;
	state |= read_switch(Y_MIN_PIN) << 2;
	state |= read_switch(X_MAX_PIN) << 1;
	state |= read_switch(X_MIN_PIN);
	
	return state;
}

//TODO: make me work!
void write_range_to_eeprom()
{

}

//TODO: make me work!
void read_range_from_eeprom()
{

}

//queue a point for us to move to
void queue_incremental_point(int x, int y, int z, byte prescaler, unsigned int count)
{
	//wait until we have free space
	while (pointBuffer.remainingCapacity() > POINT_SIZE)
		delayMicrosecondsInterruptible(500);
		
	//okay, add in our points.
	// x
	pointBuffer.append(x & 0xff);
	pointBuffer.append(x >> 8);
	// y
	pointBuffer.append(y & 0xff);
	pointBuffer.append(y >> 8);
	// z
	pointBuffer.append(z & 0xff);
	pointBuffer.append(z >> 8);
	// prescaler
	pointBuffer.append(prescaler);
	// counter
	pointBuffer.append(count & 0xff);
	pointBuffer.append(count >> 8);

	//turn our interrupt on.
	enableTimer1Interrupt();
}

//TODO: make this proportional based on the delta proportions.
//queue a point for us to move to
void queue_absolute_point(long x, long y, long z, byte prescaler, unsigned int count)
{
	//calculate our total travel in steps
	unsigned long delta_x = abs(x - current_steps.x);
	unsigned long delta_y = abs(y - current_steps.y);
	unsigned long delta_z = abs(z - current_steps.z);

	//setup some variables.
	int x_inc = 0;
	int y_inc = 0;
	int z_inc = 0;

	//keep queueing points while we can.
	while (delta_x >= 0 || delta_y >= 0 || delta_z >= 0)
	{
		//figure out our incremental points.
		x_inc = get_increment_from_absolute(delta_x, current_steps.x, x);
		y_inc = get_increment_from_absolute(delta_y, current_steps.y, y);
		z_inc = get_increment_from_absolute(delta_z, current_steps.z, z);

		//queue our point.
		queue_incremental_point(x_inc, y_inc, z_inc, prescaler, count);

		//remove them from our deltas.
		delta_x -= x_inc;
		delta_x -= y_inc;
		delta_x -= z_inc;
	}
}

int get_increment_from_absolute(unsigned long delta, long current, long target)
{
	if (delta > 32767)
	{
		if (target < current)
			return -32767;
		else
			return 32767;
	}
	else
	{
		if (target < current)
			return -((int)delta);
		else
			return (int)delta;
	}
}

