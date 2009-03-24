/*
 *  OpticalInterrupt.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */


class OpticalInterrupt : public Device, 
                         public Observable, 
                         public PeriodicCallback
{
    int _inputPin;
public:
    OpticalInterrupt(int pin);
    virtual void service();
};

