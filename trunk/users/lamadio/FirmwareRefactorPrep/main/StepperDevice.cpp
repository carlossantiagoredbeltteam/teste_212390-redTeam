/*
 *  StepperDevice.cpp
 *  FirmwareRefactorPrep
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

#define FORWARD HIGH
#define BACKWARD LOW

StepperDevice::StepperDevice(int8_t stepPin, int8_t dirPin, int ticksPerRev, milliclock_t rate)
: EventLoopTimer(rate)
, _stepPin(stepPin)
, _dirPin(dirPin)
, _ticksPerRev(ticksPerRev)
, _currentTick(0)
, _targetTick(0)
, _maxRate(rate)
{
    pinMode(stepPin, OUTPUT);
    pinMode(dirPin, OUTPUT);
    digitalWrite(_dirPin, FORWARD);
}

void StepperDevice::setTempRate(float rate)
{
    setPeriod((int)(_maxRate * rate));
}

void StepperDevice::start()
{
    if (!_currentTick)
    {
        _currentTick = _targetTick = 0;
        notifyObservers(StepperEvent_Start, this);
        EventLoop::current()->addTimer(this);
    }
}

void StepperDevice::stop()
{
    setPeriod(_maxRate);
    
    if (_currentTick)
    {
        _currentTick = 0;
        notifyObservers(StepperEvent_Stop, this);
        EventLoop::current()->removeTimer(this);
    }
}

void StepperDevice::goForward()
{
    stop();
    digitalWrite(_dirPin, FORWARD);
}

void StepperDevice::goBackward()
{
    stop();
    digitalWrite(_dirPin, BACKWARD);
}

void StepperDevice::turn(float numberOfRevolutions)
{
    if (_currentTick)
    {
        stop();
    }
    
    _targetTick = (int)(numberOfRevolutions / _ticksPerRev);

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

