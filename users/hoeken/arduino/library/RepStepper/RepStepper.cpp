
#include "RepStepper.h"

/*
 * two-wire constructor.
 * Sets which wires should control the motor.
 */
RepStepper::RepStepper(int number_of_steps, int step_pin, int direction_pin)
{
	//init our variables.
	this->direction = 1;
	this->setRPM(60);
	this->last_step_time = 0;

	//get our parameters
	this->number_of_steps = number_of_steps;
	this->step_pin = step_pin;
	this->direction_pin = direction_pin;
	
	// setup the pins on the microcontroller:
	pinMode(this->step_pin, OUTPUT);
	pinMode(this->direction_pin, OUTPUT);
}

/*
  Sets the speed in revs per minute
*/
void RepStepper::setSpeed(int speed)
{
	this->step_delay = speed;
	
	if (this->step_delay > 0);
		this->rpm = 60000000L / (this->step_delay * this->number_of_steps);
}

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
		this->step_delay = 60000000L / this->number_of_steps / this->rpm;
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
	
	unsigned int now = this->micros();
	
	//if its like this, its normal.
	if (this->last_step_time < now)
	{
		if (now > this->last_step_time + this->step_delay)
			return true;
	}
	//nope, we're probably dealing with overflow.
	else
	{
		if (this->step_delay < (65535 - this->last_step_time + now))
			return true;
	}
	
	//okay, nobody said they're ready, bail.
	return false;
}

void RepStepper::step()
{  
	digitalWrite(this->step_pin, HIGH);
	digitalWrite(this->step_pin, LOW);
	
	this->last_step_time = this->micros();
}

int RepStepper::version(void)
{
  return 1;
}

unsigned int RepStepper::micros()
{
	return TCNT1;
}
