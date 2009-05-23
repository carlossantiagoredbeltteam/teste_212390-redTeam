/*
 *  OpticalInterrupt.cpp
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "EventLoop.h"
#include "Device.h"
#include "Observable.h"
#include "OpticalInterrupt.h"

OpticalInterrupt::OpticalInterrupt(int pin, bool inverted)
: _inputPin(pin)
, _inverted(inverted)
{
    pinMode(pin, INPUT);
	EventLoop::current()->addPeriodicCallback(this);
}

void OpticalInterrupt::service()
{
	if (digitalRead(_inputPin) == _inverted?HIGH:LOW)
	{
		notifyObservers(OpticalInterrupt_Interrupted, this);
	}
}
