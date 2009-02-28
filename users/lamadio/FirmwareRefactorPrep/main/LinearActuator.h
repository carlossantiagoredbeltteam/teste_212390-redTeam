/*
 *  LinearActuator.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

const uint32_t StepperLinearActuator_CompletedMove = 'SLAC';
const uint32_t StepperLinearActuator_Extent = 'SLAF';
const uint32_t StepperLinearActuator_Homed = 'SLAH';

class StepperLinearActuator : public Device, Observer, Observable
{
	float _currentPos;
	float _revPerMM;
	StepperDevice& _stepper;
	OpticalInterrupt& _nearInterrupter;
	OpticalInterrupt& _farInterrupter;
	
public:
	StepperLinearActuator(float _revPerMM, StepperDevice& stepper, OpticalInterrupt& far, OpticalInterrupt& near);
	
	void moveTo(float newPosMM);
    virtual void notify(uint32_t eventId, void* context);
};