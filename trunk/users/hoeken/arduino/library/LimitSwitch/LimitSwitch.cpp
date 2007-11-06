
#include "LimitSwitch.h"
#include "WConstants.h"

LimitSwitch::LimitSwitch(int pin)
{
	this->pin = pin;

	if (this->pin >= 0)
		pinMode(pin, INPUT);
}

bool LimitSwitch::getState()
{
	if (this->pin >= 0)
		return digitalRead(pin);
	
	return false;
}
