/*
  LinearAxis.cpp - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

#include "LinearAxis.h"
#include "WConstants.h"

LinearAxis::LinearAxis()
{
	this->current_position = 0;
	this->dda_position = 0;
	this->delta = 0.0;
	this->can_step = false;
}

void LinearAxis::ddaStep()
{
	this->dda_position += this->delta;
	
	//can we step now?
	if ((int)this->dda_position != this->current_position)
		this->can_step = true;
	else
		this->can_step = false;
}

bool LinearAxis::canStep()
{
	return this->can_step;
}

void LinearAxis::setDelta(float delta)
{
	this->delta = delta;
}

int LinearAxis::getPosition()
{
	return this->current_position;
}

void LinearAxis::setPosition(int position)
{
	this->current_position = position;
	this->dda_position = position;
	this->can_step = false;
}

int LinearAxis::version()
{
	return 1;
}
