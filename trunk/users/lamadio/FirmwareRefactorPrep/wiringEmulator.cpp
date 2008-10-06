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