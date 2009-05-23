/*
 *  LinearActuator.cpp
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *     Provided under GPLv3 per gpl-3.0.txt
 *
 */
#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "EventLoop.h"
#include "Observable.h"
#include "Device.h"
#include "OpticalInterrupt.h"
#include "StepperDevice.h"
#include "LinearActuator.h"

LinearActuator::LinearActuator(float revPerMM, StepperDevice& stepper, 
                                             OpticalInterrupt& far, OpticalInterrupt& near)
: _currentPos(-1.0f)
, _revPerMM(revPerMM)
, _stepper(stepper)
, _nearInterrupter(near)
, _farInterrupter(far)
{
    _nearInterrupter.addObserver(this);
    _farInterrupter.addObserver(this);
    _stepper.addObserver(this);
}

void LinearActuator::moveTo(float newPosMM)
{
    float revs;
    if (_currentPos < 0.0f)
    {
        _stepper.goBackward();
        _stepper.start();
    }
    else
    {
        if (newPosMM < _currentPos)
        {
            revs = (_currentPos - newPosMM) / _revPerMM;
            _stepper.goForward();
        }
        else
        {
            revs = (newPosMM - _currentPos) / _revPerMM;
            _stepper.goBackward();
        }
        
        Serial.print("Turning ");
        Serial.println((int)revs);
        _stepper.turn(revs);
    }
}

void LinearActuator::moveHome()
{
    moveTo(0.0f);
}

void LinearActuator::moveToExtent()
{
    _stepper.goForward();
    _stepper.start();
}

void LinearActuator::notify(uint32_t eventId, void* context)
{
    switch (eventId)
    {
        case StepperEvent_Complete:
            notifyObservers(LinearActuator_CompletedMove, this);
            break;
        case OpticalInterrupt_Interrupted:
            if (_stepper.running())
            {
                if (context == &_nearInterrupter && !_stepper.goingForward())
                {
                    _stepper.stop();
                    _currentPos = 0.0f;
                    notifyObservers(LinearActuator_Homed, this);
                }
                else if (context == &_farInterrupter && _stepper.goingForward())
                {
                    _stepper.stop();
                    notifyObservers(LinearActuator_Extent, this);
                }
            }
            break;
    }
}

