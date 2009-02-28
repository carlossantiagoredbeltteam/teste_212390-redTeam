/*
 *  Device.cpp
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Collections.h"
#include "Device.h"

static DArray s_deviceMap;

void Device::map(size_t pin, Device* toDevice)
{
	s_deviceMap.set(pin, toDevice);
}

Device* Device::get(size_t pin)
{
	return (Device*)s_deviceMap[pin];
}

