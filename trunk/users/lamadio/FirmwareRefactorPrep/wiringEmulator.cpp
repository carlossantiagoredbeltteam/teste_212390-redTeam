/*
 *  wiringEmulator.cpp
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 9/26/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"

milliclock_t g_milli = 0;
void incrementMillis()
{
    g_milli++;
    if (g_milli >= MILLICLOCK_MAX)
        g_milli = 0;
}

milliclock_t  millis()
{
    return g_milli;
}

void delay(int ms)
{
	for(int i = 0; i < ms * 1000; i++);
}

void pinMode(int pin, WIRINGMODE mode)
{
}

void digitalWrite(int pin, WIRINGVALUE mode)
{
}


int digitalRead(int pin)
{
	return HIGH;
}
