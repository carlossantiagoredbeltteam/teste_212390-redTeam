/*
  LinearAxis.cpp - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

#include "LinearAxis.h"
#include "WConstants.h"

LinearAxis::LinearAxis(char id, int steps, byte dir_pin, byte step_pin, byte min_pin, byte max_pin, byte enable_pin) : stepper(steps, dir_pin, step_pin, enable_pin)
{
	this->id = id;
	current = 0;
	target = 0;
	max = 0;
	this->min_pin = min_pin;
	this->max_pin = max_pin;

	stepper.setDirection(RS_FORWARD);
	//this->setupTimerInterrupt();
}

void LinearAxis::readState()
{
	//stop us if we're on target
	if (this->atTarget())
		can_step = false;
	//stop us if we're at home and still going 
	else if (this->atMin() && stepper.getDirection() == RS_REVERSE)
		can_step = false;
	//stop us if we're at max and still going
	else if (this->atMax() && stepper.getDirection() == RS_FORWARD)
		can_step = false;
	//default to being able to step
	else
		can_step = true;
}

bool LinearAxis::atMin()
{
	return digitalRead(min_pin);
}

bool LinearAxis::atMax()
{
	return digitalRead(max_pin);
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

	//stop us from stepping if we're there.
	if (current == target)
		can_step = false;
}

void LinearAxis::forward1()
{
	stepper.setDirection(RS_FORWARD);
	stepper.pulse();
	current++;
}

void LinearAxis::reverse1()
{
	stepper.setDirection(RS_REVERSE);
	stepper.pulse();
	current--;
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
		
	delta = this->getDelta();
}

void LinearAxis::setMax(long m)
{
	max = m;
}

long LinearAxis::getMax()
{
	return max;
}

bool LinearAxis::atTarget()
{
	return (target == current);
}

long LinearAxis::getDelta()
{
	return abs(target - current);
}

void LinearAxis::initDDA(long max_delta)
{
	counter = -max_delta/2;
	delta = this->getDelta();
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

