/*
 *  StepperDevice.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

const uint32_t StepperEvent_Start = 'STPS';
const uint32_t StepperEvent_Stop = 'STPE';
const uint32_t StepperEvent_Complete = 'STPC';

class StepperDevice : public EventLoopTimer, Device, Observable
{
	int8_t _stepPin;
	int8_t _dirPin;
	bool _forward;
	int _currentTick;
	int _targetTick;
	int _ticksPerRev;
public:
	StepperDevice(int8_t stepPin, int8_t dirPin, int ticksPerRev, milliclock_t rate);
	
	void goForward();
	void goBackward();
	void turn(float numberOfRevolutions);
	void start();
	void stop();
    virtual void fire();
};

