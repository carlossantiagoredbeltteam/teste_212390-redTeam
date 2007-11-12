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
	this->position = 0;
	this->target = 0;
	this->delta = 0;
	this->can_step = false;
	stepper.setDirection(RS_FORWARD);
}

void LinearAxis::readState()
{
	//encoder.readState();
	//min_switch.readState();
	//max_switch.readState();
}

bool LinearAxis::atMin()
{
	return min_switch.getState();
}

bool LinearAxis::atMax()
{
	return max_switch.getState();
}

void LinearAxis::initDDA(long counter)
{
	this->counter = counter;
}

void LinearAxis::ddaStep(long max_delta)
{
	counter += delta;

	if (counter > 0)
	{
		can_step = true;
		counter -= max_delta;
	}
	else
		can_step = false;
}

bool LinearAxis::canStep()
{
	return this->can_step;
}

bool LinearAxis::doStep()
{
	if (!this->atMin() && !this->atMax())
	{
		if (stepper.nonBlockingStep())
		{
			//dont let any more steps happen
			can_step = false;
			
			//record our step
			if (stepper.getDirection())
				position++;
			else
				position--;
			
			//record our delta change
			delta--;

			return true;
		}
	}
	
	return false;
}

long LinearAxis::getPosition()
{
	return this->current_position;
}

void LinearAxis::setPosition(long position)
{
	this->current = position;
	this->can_step = false;
	
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

void LinearAxis::getDelta()
{
	return delta;
}
