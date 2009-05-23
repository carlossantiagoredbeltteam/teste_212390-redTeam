/*
 *  StepperDevice.cpp
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "Device.h"
#include "Observable.h"
#include "EventLoop.h"
#include "StepperDevice.h"

StepperDevice::StepperDevice(int8_t stepPin, int8_t dirPin, 
                             int8_t enablePin, int ticksPerRev, 
                             milliclock_t rate, bool inverted)
: EventLoopTimer(rate)
, _stepPin(stepPin)
, _dirPin(dirPin)
, _enablePin(enablePin)
, _ticksPerRev(ticksPerRev)
, _currentTick(0)
, _targetTick(0)
, _maxRate(rate)
, _forward(false)
, _running(false)
, _inverted(inverted)
{
    pinMode(stepPin, OUTPUT);
    pinMode(dirPin, OUTPUT);
    pinMode(enablePin, OUTPUT);
    digitalWrite(_dirPin, HIGH);
	
	enable(false);
}

void StepperDevice::setTempRate(float rate)
{
    setPeriod((int)(_maxRate * rate));
}

void StepperDevice::start()
{
	enable(true);
    _running = true;
    notifyObservers(StepperEvent_Start, this);
    EventLoop::current()->addTimer(this);
}

void StepperDevice::pause()
{
    EventLoop::current()->removeTimer(this);
}

void StepperDevice::stop()
{
    _running = false;
    setPeriod(_maxRate);
    
    _targetTick = 0;
    _currentTick = 0;
    
	enable(false);

    notifyObservers(StepperEvent_Stop, this);
    EventLoop::current()->removeTimer(this);
}

void StepperDevice::goForward()
{
    _forward = true;
    stop();
    digitalWrite(_dirPin, _inverted?LOW:HIGH);
}

void StepperDevice::goBackward()
{
    _forward = false;
    stop();
    digitalWrite(_dirPin, _inverted?HIGH:LOW);
}

void StepperDevice::enable(bool enable)
{
    digitalWrite(_enablePin, enable?HIGH:LOW);
}

void StepperDevice::turn(float numberOfRevolutions)
{
    if (_currentTick)
    {
        stop();
    }
    
    
    _targetTick = (int)(_ticksPerRev * numberOfRevolutions);

	enable(true);
    _running = true;
    notifyObservers(StepperEvent_Start, this);
    EventLoop::current()->addTimer(this);
}

void StepperDevice::fire()
{
    digitalWrite(_stepPin, HIGH);
    delayMicroseconds(5);
    digitalWrite(_stepPin, LOW);

    ++_currentTick;
    
    if (_targetTick && (_currentTick == _targetTick))
    {
        notifyObservers(StepperEvent_Complete, this);
        stop();
    }
}

