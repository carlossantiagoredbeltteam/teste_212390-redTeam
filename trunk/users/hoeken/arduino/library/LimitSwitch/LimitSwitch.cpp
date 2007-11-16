
#include "LimitSwitch.h"
#include "WConstants.h"

LimitSwitch::LimitSwitch(int pin)
{
	this->pin = pin;
	state = false;

	if (pin >= 0)
		pinMode(pin, INPUT);
}

void LimitSwitch::readState()
{
	if (pin >= 0)
		state = digitalRead(pin);
	else
		state = false;
}

bool LimitSwitch::getState()
{
	return state;
}
