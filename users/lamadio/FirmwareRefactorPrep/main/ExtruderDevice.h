/*
 *  ExtruderDevice.h
 *
 *  Created by Lou Amadio on 3/2/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

class ExtruderDevice : public Device, 
                       public Observer, 
                       public Observable
{
    enum ExtruderStates
    {
        Idle,
        Heating,
        Preheating,
        Extruding
    } _state;
    
    StepperDevice& _stepper;
    ThermisterDevice& _thermister;
    HeaterDevice& _heater;
    int16_t _extrusionTemp;
    
public:
    ExtruderDevice(int16_t extrusionTemp, StepperDevice& step, 
            ThermisterDevice& therm, HeaterDevice& hd);
    
    void extrude();
    void stop();
    void preheat();
    
    virtual void notify(uint32_t eventId, void* context);
};

