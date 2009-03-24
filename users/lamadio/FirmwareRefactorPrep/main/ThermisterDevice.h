/*
 *  ThermisterDevice.h
 *
 *  Created by Lou Amadio on 3/2/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

class ThermisterDevice : public PeriodicCallback, 
                         public Device, 
                         public Observable
{
    int16_t _thermPin;
    int _temp;
public:
    ThermisterDevice(int8_t thermPin);
    
    int temp() { return _temp; }
    
    virtual void service();
};

