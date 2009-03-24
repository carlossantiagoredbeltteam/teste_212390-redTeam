/*
 *  StepperDevice.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

class StepperDevice : public EventLoopTimer, 
                      public Device, 
                      public Observable
{
    int8_t _stepPin;
    int8_t _dirPin;
    bool _forward;
    int _currentTick;
    int _targetTick;
    int _ticksPerRev;
    milliclock_t _maxRate;
public:
    StepperDevice(int8_t stepPin, int8_t dirPin, int ticksPerRev, milliclock_t rate);
    
    void goForward();
    void goBackward();
    void turn(float numberOfRevolutions = 0.0f);
    void start();
    void stop();
    void setTempRate(float rate);
    virtual void fire();
};

