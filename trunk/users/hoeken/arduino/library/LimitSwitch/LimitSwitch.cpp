
#include "LimitSwitch.h"
#include "WConstants.h"

LimitSwitch::LimitSwitch()
{
	this->pin = -1;
}

LimitSwitch::LimitSwitch(int pin)
{
	this->pin = pin;
	
	pinMode(pin, INPUT);
}

bool LimitSwitch::getState()
{
	return this->state;
}

bool LimitSwitch::readState()
{
	if (this->pin >= 0)
		this->state = digitalRead(pin);
	else
		this->state = false;
		
	return this->state;
}

//random other functions
int LimitSwitch::version()
{
	return 1;
}
