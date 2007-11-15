
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
	this->next_step_time = 1;

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
	step_delay = speed;
	
	if (step_delay > 0);
		rpm = 15000000UL / (step_delay * number_of_steps);
}

/*
  Gets the speed in ticks per step
*/
int RepStepper::getSpeed()
{
	return step_delay;
}

/*
  Sets the speed in revs per minute
*/
void RepStepper::setRPM(int new_rpm)
{
	if (new_rpm == 0)
	{
		step_delay = 0;
		rpm = 0;
	}
	else
	{
		rpm = new_rpm;
		
		//our high precision time is measured in 4us ticks, so get the # of ticks in 1 minute / 
		// number of steps per rev / number of revolutions per minute = ticks per step
		step_delay = (15000000UL / number_of_steps) / rpm;
	}
}

int RepStepper::getRPM()
{
	return rpm;
}

void RepStepper::setSteps(int steps)
{
	number_of_steps = steps;
	
	//recalculate our speed.
	this->setRPM(this->getRPM());
}

int RepStepper::getSteps()
{
	return number_of_steps;
}

void RepStepper::setDirection(bool direction)
{
	this->direction = direction;
	digitalWrite(this->direction_pin, this->direction);
}

bool RepStepper::getDirection()
{
	return direction;
}

bool RepStepper::canStep()
{
	//bail if we have no speed.
	if (!step_delay)
		return false;
	
	//get our current time
	now = this->hpticks();
	
	//if its like this, its normal.
	if (last_step_time < next_step_time)
	{
		if (now > next_step_time)
			return true;
	}
	//nope, we're probably dealing with overflow.
	else
	{
		//is the time since our last step bigger than our delay?
		if ((4294967295UL - last_step_time + now) > step_delay)
			return true;
	}
	
	//okay, nobody said they're ready, bail.
	return false;
}

void RepStepper::step()
{
	this->pulse();

	//calculate our next step.
	last_step_time = this->hpticks();
	next_step_time = last_step_time + step_delay;
}

void RepStepper::pulse()
{
	//this sends a pulse to our stepper controller.
	digitalWrite(step_pin, HIGH);
	digitalWrite(step_pin, LOW);
}

void RepStepper::moveTo(int steps)
{
	int i;
	
	//use steps to figure out the direction.
	if (steps > 0)
		this->setDirection(RS_FORWARD);
	else
		this->setDirection(RS_REVERSE);
	
	//we only want the number of steps now.
	steps = abs(steps);
	
	//okay, now step it!
	for (i=0; i<steps; i++)
	{
		//do our step.
		this->pulse();
		
		//our ticks are 4 microseconds each, so multiply by 4
		delayMicroseconds(step_delay * 4);
	}
}

int RepStepper::version(void)
{
  return 1;
}

unsigned long RepStepper::hpticks(void)
{
	return (timer0_overflow_count << 8) + TCNT0;
}
