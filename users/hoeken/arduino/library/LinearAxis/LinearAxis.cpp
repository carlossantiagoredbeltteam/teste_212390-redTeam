/*
  LinearAxis.cpp - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

#include "LinearAxis.h"
#include "WConstants.h"

LinearAxis::LinearAxis(int steps, int dir_pin, int step_pin, int min_pin, int max_pin) : stepper(steps, dir_pin, step_pin), min_switch(min_pin), max_switch(max_pin)
{
	counter = 0;
	current = 0;
	target = 0;
	delta = 0;
	can_step = false;
	stepper.setDirection(RS_FORWARD);
}

void initTimer()
{
	//break it into 3 different resolutions
	//then essentially calculate the PWM required.
	
	int speed = stepper.getSpeed();
	byte pwm;
	 
	if (speed < 1000)
	{
		this->setTimerResolution(1);
		pwm = ((speed / 1000) > 8);
	}
	else if (speed < 10000)
	{
		this->setTimerResolution(2);
		pwm = ((speed / 10000) > 8);
	}
	else
	{
		this->setTimerResolution(3);
		pwm = ((speed / 100000L) > 8);
	}

	this->setTimerFrequency(pwm);
}

void setTimerResolution(byte r)
{
	//this guy uses TIMER0
	if (id == 'x')
	{
		// ~4 usec intervals
		if (r == 1)
		{
			
		}
		// ~40 usec intervals
		else if (r == 2)
		{
			
		}
		// ~400 usec intervals
		else
		{
			
		}
	}
	
	//this guy uses TIMER2
	if (id == 'y')
	{
		// ~4 usec intervals
		if (r == 1)
		{
			
		}
		// ~40 usec intervals
		else if (r == 2)
		{
			
		}
		// ~400 usec intervals
		else
		{
			
		}
	}
	
	//this guy uses TIMER2
	if (id == 'z')
	{
		// ~4 usec intervals
		if (r == 1)
		{
			
		}
		// ~40 usec intervals
		else if (r == 2)
		{
			
		}
		// ~400 usec intervals
		else
		{
			
		}
	}
}

void setTimerFrequency(byte f)
{
	if (id == 'x')
		OCR0A = f;
	
	if (id == 'y')
		OCR1A = f;

	if (id == 'z')
		OCR2A = f
}

void handleInterrupt()
{
	if (can_step && !this->atTarget())
		stepper.pulse();
}

void LinearAxis::readState()
{
	//encoder.readState();

	min_switch.readState();
	max_switch.readState();
	
	can_step = (
		(current != target) && (
			(!this->atMin() && !this->atMax()) ||
			(this->atMin() && stepper.getDirection() == RS_FORWARD) ||
			(this->atMax() && stepper.getDirection() == RS_REVERSE)
		)
	);	
}

bool LinearAxis::atMin()
{
	return min_switch.getState();
}

bool LinearAxis::atMax()
{
	return max_switch.getState();
}

void LinearAxis::initDDA(long max_delta)
{
	counter = -max_delta/2;
}

void LinearAxis::ddaStep(long max_delta)
{
	counter += delta;

	if (counter > 0)
	{
		this->doStep();
		counter -= max_delta;
	}
}

void LinearAxis::doStep()
{
	//record our step
	if (stepper.getDirection())
		current++;
	else
		current--;
	
	//do our step!
	stepper.pulse();
}

long LinearAxis::getPosition()
{
	return current;
}

void LinearAxis::setPosition(long position)
{
	current = position;
	
	//recalculate stuff.
	this->setTarget(target);
}

long LinearAxis::getTarget()
{
	return target;
}

void LinearAxis::setTarget(long t)
{
	target = t;
	
	if (target > current)
		stepper.setDirection(RS_FORWARD);
	else
		stepper.setDirection(RS_REVERSE);

	delta = abs(target - current);
}

bool LinearAxis::atTarget()
{
	return (target == current);
}

long LinearAxis::getDelta()
{
	return delta;
}

long LinearAxis::getCounter()
{
	return counter;
}
