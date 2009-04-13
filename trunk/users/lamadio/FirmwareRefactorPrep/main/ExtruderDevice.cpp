/*
 *  ExtruderDevice.cpp
 *
 *  Created by Lou Amadio on 3/2/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "Device.h"
#include "Observable.h"
#include "EventLoop.h"
#include "ThermisterDevice.h"
#include "StepperDevice.h"
#include "HeaterDevice.h"
#include "ExtruderDevice.h"


#define TEMP_RANGE 2
#define HEATER_HIGH 255
#define HEATER_MEDIUM 128
#define HEATER_MIN 64

ExtruderDevice::ExtruderDevice(int16_t extrusionTemp, StepperDevice& step, 
    ThermisterDevice& therm, HeaterDevice& hd)
: _stepper(step)
, _thermister(therm)
, _heater(hd)
, _state(ExtruderDevice::Idle)
, _extrusionTemp(extrusionTemp)
{
    _thermister.addObserver(this);
}

void ExtruderDevice::extrude()
{
    _stepper.goForward();
    if (_state == ExtruderDevice::Idle)
    {
        _heater.set(HEATER_MEDIUM);
        _state = ExtruderDevice::Heating;
    }
}

void ExtruderDevice::backup()
{
    _stepper.goBackward();
}

void ExtruderDevice::setTemp(int16_t temp) 
{ 
	_extrusionTemp = temp; 
}

void ExtruderDevice::preheat()
{
    _heater.set(HEATER_MEDIUM);
    _state = ExtruderDevice::Preheating;
	
	// early escape if already at temp
	if (_thermister.temp() >= _extrusionTemp - TEMP_RANGE &&
		_thermister.temp() <  _extrusionTemp + TEMP_RANGE)
	{
		notifyObservers(ExtruderDevice_AtTemp, this);
	}
}

void ExtruderDevice::stop()
{
    _heater.set(0);
    _stepper.stop();
    _state = ExtruderDevice::Idle;
}

void ExtruderDevice::notify(uint32_t eventId, void* context)
{
    if (_state == ExtruderDevice::Idle)
        return;
        
    switch (eventId)
    {
        case ThermisterEvent_Change:
        {
            int16_t currentTemp = ((ThermisterDevice*)context)->temp();
            Serial.print("Temp Change: now - ");
            Serial.println(currentTemp, DEC);
            if (currentTemp < _extrusionTemp - TEMP_RANGE)
            {
                notifyObservers(ExtruderDevice_OutOfTemp, this);
                _heater.set(HEATER_HIGH);
                _stepper.stop();
                _state = ExtruderDevice::Heating;
            }
            else if (currentTemp > _extrusionTemp + TEMP_RANGE)
            {
                notifyObservers(ExtruderDevice_OutOfTemp, this);
                _heater.set(HEATER_MIN);
            }
            else
            {
                notifyObservers(ExtruderDevice_AtTemp, this);
                if (_state == ExtruderDevice::Heating)
                {
                    _state = ExtruderDevice::Extruding;
                    _stepper.start();
                }
            }
        }
        break;
    }
    
}
