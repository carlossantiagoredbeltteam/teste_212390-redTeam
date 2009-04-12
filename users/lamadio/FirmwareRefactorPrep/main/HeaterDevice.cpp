/*
 *  HeaterDevice.h
 *
 *  Created by Lou Amadio on 3/2/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *     Provided under GPLv3 per gpl-3.0.txt
 *
 */
#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "Device.h"
#include "HeaterDevice.h"

HeaterDevice::HeaterDevice(int8_t heaterPin)
: _heaterPin(heaterPin)
{
    pinMode(_heaterPin, OUTPUT);
}

void HeaterDevice::set(int8_t value)
{
    _value = value;
    Serial.print("Heating to");
    Serial.println(value, DEC);
    analogWrite(_heaterPin, value);
}

void HeaterDevice::off()
{
    analogWrite(_heaterPin, 0);
    _value = 0;
}
