
#include "RepStepper.h"

/*
 * two-wire constructor.
 * Sets which wires should control the motor.
 */
RepStepper::RepStepper(int number_of_steps, int step_pin, int direction_pin)
{
	//init our variables.
	this->direction = 1;
	this->setSpeed(0);
	this->last_step_time = 0;
	this->next_step_time = 0;

	//get our parameters
	this->number_of_steps = number_of_steps;
	this->step_pin = step_pin;
	this->direction_pin = direction_pin;
	
	// setup the pins on the microcontroller:
	pinMode(this->step_pin, OUTPUT);
	pinMode(this->direction_pin, OUTPUT);
}

/*
  Sets the speed in ticks per step
*/
void RepStepper::setSpeed(int speed)
{
	this->step_delay = speed;
	
	if (this->step_delay > 0);
		this->rpm = 15000000L / (this->step_delay * this->number_of_steps);
}

/*
  Gets the speed in ticks per step
*/
int RepStepper::getSpeed()
{
	return this->step_delay;
}

/*
  Sets the speed in revs per minute
*/
void RepStepper::setRPM(int rpm)
{
	if (rpm <= 0)
	{
		this->step_delay = 0;
		this->rpm = 0;
	}
	else
	{
		this->rpm = rpm;
		
		//our high precision time is measured in 4us ticks, so get the # of ticks in 1 minute / 
		// number of steps per rev / number of revolutions per minute = ticks per step
		this->step_delay = 15000000L / this->number_of_steps / this->rpm;
	}
}

int RepStepper::getRPM()
{
	return this->rpm;
}

void RepStepper::setSteps(int steps)
{
	this->number_of_steps = steps;
	
	//recalculate our speed.
	this->setRPM(this->getRPM());
}

int RepStepper::getSteps()
{
	return this->number_of_steps;
}

void RepStepper::setDirection(bool direction)
{
	this->direction = direction;
	digitalWrite(this->direction_pin, this->direction);
}

bool RepStepper::canStep()
{
	//bail if we have no speed.
	if (!this->step_delay)
		return false;
	
	unsigned long now = this->hpticks();
	
	//if its like this, its normal.
	if (last_step_time <= next_step_time)
	{
		if (now >= this->next_step_time);
			return true;
	}
	//nope, we're probably dealing with overflow.
	else
	{
		//is the time since our last step bigger than our delay?
		if ((4294967295L - this->last_step_time + now) >= this->step_delay)
			return true;
	}
	
	//okay, nobody said they're ready, bail.
	return false;
}

void RepStepper::step()
{  
	digitalWrite(this->step_pin, HIGH);
	digitalWrite(this->step_pin, LOW);
	
	//calculate our next step.
	this->last_step_time = this->hpticks();
	this->next_step_time = this->last_step_time + $this->step_delay;
}

int RepStepper::version(void)
{
  return 1;
}

unsigned long RepStepper::hpticks()
{
	return (timer0_overflow_count << 8) + TCNT0;
}
