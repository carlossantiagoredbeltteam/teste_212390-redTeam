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
: _currentPos(0.0f)
, _revPerMM(revPerMM)
, _stepper(stepper)
, _nearInterrupter(near)
, _farInterrupter(far)
{
}

void LinearActuator::moveTo(float newPosMM)
{
    float revs;
    if (newPosMM == 0)
    {
        _stepper.goBackward();
        _stepper.start();
    }
    else
    {
        if (newPosMM < _currentPos)
        {
            revs = (_currentPos - newPosMM) / _revPerMM;
            _stepper.goBackward();
        }
        else
        {
            revs = (newPosMM - _currentPos) / _revPerMM;
            _stepper.goForward();
        }
        
        _stepper.turn(revs);
    }
}

void  LinearActuator::moveHome()
{
    moveTo(0.0f);
}

void LinearActuator::notify(uint32_t eventId, void* context)
{
    switch (eventId)
    {
        case StepperEvent_Complete:
            notify(LinearActuator_CompletedMove, this);
            break;
        case OpticalInterrupt_Interrupted:
            _stepper.stop();
            if (context == &_nearInterrupter)
            {
                notify(LinearActuator_Homed, this);
            }
            else if (context == &_farInterrupter)
            {
                notify(LinearActuator_Extent, this);
            }
            break;
    }
}

