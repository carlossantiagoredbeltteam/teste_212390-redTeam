/*
 *  Device.cpp
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "Device.h"

void* Device::getInterface(uint32_t interfaceId)
{
    if (interfaceId == IDevice)
    {
        return this;
    }
    
    return NULL;
}
