/*
 *  LinearActuator.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
 
class LinearActuator : public Device, 
                       public Observable,
                       public Observer
{
    float _currentPos;
    float _revPerMM;
    StepperDevice& _stepper;
    OpticalInterrupt& _nearInterrupter;
    OpticalInterrupt& _farInterrupter;
    
public:
    LinearActuator(float _revPerMM, StepperDevice& stepper, OpticalInterrupt& far, OpticalInterrupt& near);
    inline float currentPosition() { return _currentPos; }
    inline void setTempRate(float rate) { _stepper.setTempRate(rate); }
    void moveTo(float newPosMM);
    void moveHome();
    virtual void notify(uint32_t eventId, void* context);
};
