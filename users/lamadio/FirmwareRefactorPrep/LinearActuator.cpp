/*
 *  LinearActuator.cpp
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Collections.h"
#include "EventLoop.h"
#include "Observable.h"
#include "Device.h"
#include "OpticalInterrupt.h"
#include "StepperDevice.h"
#include "LinearActuator.h"

StepperLinearActuator::StepperLinearActuator(float revPerMM, StepperDevice& stepper, 
											 OpticalInterrupt& far, OpticalInterrupt& near)
: _currentPos(0.0f)
, _revPerMM(revPerMM)
, _stepper(stepper)
, _nearInterrupter(near)
, _farInterrupter(far)
{
}

void StepperLinearActuator::moveTo(float newPosMM)
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

void StepperLinearActuator::notify(uint32_t eventId, void* context)
{
	switch (eventId)
	{
		case StepperEvent_Complete:
			notify(StepperLinearActuator_CompletedMove, this);
			break;
		case OpticalInterrupt_Interrupted:
			_stepper.stop();
			if (context == &_nearInterrupter)
			{
				notify(StepperLinearActuator_Homed, this);
			}
			else if (context == &_farInterrupter)
			{
				notify(StepperLinearActuator_Extent, this);
			}
			break;
	}
}

