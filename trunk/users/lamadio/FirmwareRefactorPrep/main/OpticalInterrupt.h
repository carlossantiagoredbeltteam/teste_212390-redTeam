/*
 *  OpticalInterrupt.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

const uint32_t OpticalInterrupt_Interrupted = 'OPTI';



class OpticalInterrupt : public Device, Observable, PeriodicCallback
{
	int _inputPin;
public:
	OpticalInterrupt(int pin);
    virtual void service();
};

