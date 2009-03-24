/*
 *  ThermisterDevice.cpp
 *
 *  Created by Lou Amadio on 3/2/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "Device.h"
#include "Observable.h"
#include "EventLoop.h"
#include "ThermisterDevice.h"

#define TEMPERATURE_SAMPLES 5

// Thermistor lookup table for RepRap Temperature Sensor Boards (http://make.rrrf.org/ts)
// Made with createTemperatureLookup.py (http://svn.reprap.org/trunk/reprap/firmware/Arduino/utilities/createTemperatureLookup.py)
// ./createTemperatureLookup.py --r0=100000 --t0=25 --r1=0 --r2=4700 --beta=4066 --max-adc=1023
// r0: 100000
// t0: 25
// r1: 0
// r2: 4700
// beta: 4066
// max adc: 1023
#define NUMTEMPS 20
int16_t temptable[NUMTEMPS][2] = {
   {1, 841},
   {54, 255},
   {107, 209},
   {160, 184},
   {213, 166},
   {266, 153},
   {319, 142},
   {372, 132},
   {425, 124},
   {478, 116},
   {531, 108},
   {584, 101},
   {637, 93},
   {690, 86},
   {743, 78},
   {796, 70},
   {849, 61},
   {902, 50},
   {955, 34},
   {1008, 3}
};

ThermisterDevice::ThermisterDevice(int8_t thermPin)
: _thermPin(thermPin)
, _temp(21)
{
    EventLoop::current()->addPeriodicCallback(this);
}


void ThermisterDevice::service()
{
    int raw = 0;
    
    //read in a certain number of samples
    for (byte i=0; i<TEMPERATURE_SAMPLES; i++)
        raw += analogRead(_thermPin);
        
    //average the samples
    raw /= TEMPERATURE_SAMPLES;
    
    int16_t celsius = 0;
    byte i;

    for (i=1; i<NUMTEMPS; i++)
    {
        if (temptable[i][0] > raw)
        {
            celsius  = temptable[i-1][1] + 
                (raw - temptable[i-1][0]) * 
                (temptable[i][1] - temptable[i-1][1]) /
                (temptable[i][0] - temptable[i-1][0]);

            break;
        }
    }

    // Overflow: Set to last value in the table
    if (i == NUMTEMPS) 
        celsius = temptable[i-1][1];
    // Clamp to byte
    if (celsius > 255) 
        celsius = 255; 
    else if (celsius < 0) 
        celsius = 0;
        
    if (celsius != _temp)
    {
        _temp = celsius;
        notifyObservers(ThermisterEvent_Change, this);
    }
}
