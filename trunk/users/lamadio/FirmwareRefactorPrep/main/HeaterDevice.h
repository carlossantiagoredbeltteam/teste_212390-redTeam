/*
 *  HeaterDevice.h
 *
 *  Created by Lou Amadio on 3/2/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

class HeaterDevice : public Device
{
    int8_t _heaterPin;
    int8_t _value;
public:
    HeaterDevice(int8_t heaterPin);
    
    inline bool on() { return _value != 0; }
    int8_t value() { return _value; }
    void set(int8_t value);
    void off();
};

