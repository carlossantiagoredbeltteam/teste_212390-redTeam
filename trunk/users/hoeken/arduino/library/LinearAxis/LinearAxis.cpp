#include "LinearAxis.h"
#include "WConstants.h"

LinearAxis::LinearAxis(char id, int steps, byte dir_pin, byte step_pin, byte min_pin, byte max_pin, byte enable_pin) : stepper(steps, dir_pin, step_pin, enable_pin)
{
	this->id = id;
	this->current = 0;
	this->target = 0;
	this->max = 0;
	this->min_pin = min_pin;
	this->max_pin = max_pin;

	this->stepper.setDirection(RS_FORWARD);

	this->readState();
}

void LinearAxis::readState()
{
	//stop us if we're on target
	if (this->atTarget())
		this->can_step = false;
	//stop us if we're at home and still going 
	else if (digitalRead(this->min_pin) && (this->stepper.getDirection() == RS_REVERSE))
		this->can_step = false;
	//stop us if we're at max and still going
	else if (digitalRead(this->max_pin) && (this->stepper.getDirection() == RS_FORWARD))
		this->can_step = false;
	//default to being able to step
	else
		this->can_step = true;
}

bool LinearAxis::atMin()
{
	return digitalRead(this->min_pin);
}

bool LinearAxis::atMax()
{
	return digitalRead(this->max_pin);
}

void LinearAxis::doStep()
{
	//record our step
	if (stepper.getDirection())
		this->current++;
	else
		this->current--;
	
	//do our step!
	stepper.pulse();

	//stop us from stepping if we're there.
//	if (this->current == this->target)
//		this->can_step = false;
}

void LinearAxis::forward1()
{
	stepper.setDirection(RS_FORWARD);
	stepper.pulse();
	
	this->current++;
}

void LinearAxis::reverse1()
{
	stepper.setDirection(RS_REVERSE);
	stepper.pulse();
	
	this->current--;
}

long LinearAxis::getPosition()
{
	return this->current;
}

void LinearAxis::setPosition(long position)
{
	this->current = position;
	
	//recalculate stuff.
	this->setTarget(target);
}

long LinearAxis::getTarget()
{
	return this->target;
}

void LinearAxis::setTarget(long t)
{
	this->target = t;
	
	if (target >= current)
		stepper.setDirection(RS_FORWARD);
	else
		stepper.setDirection(RS_REVERSE);
		
	this->delta = this->getDelta();
}

void LinearAxis::setMax(long m)
{
	this->max = m;
}

long LinearAxis::getMax()
{
	return this->max;
}

bool LinearAxis::atTarget()
{
	return (this->target == this->current);
}

long LinearAxis::getDelta()
{
	return abs(this->target - this->current);
}

void LinearAxis::initDDA(long max_delta)
{
	this->counter = -max_delta/2;
	this->delta = this->getDelta();
}

void LinearAxis::ddaStep(long max_delta)
{
	this->counter += this->delta;

	if (this->counter > 0)
	{
		this->doStep();
		this->counter -= max_delta;
	}
}

