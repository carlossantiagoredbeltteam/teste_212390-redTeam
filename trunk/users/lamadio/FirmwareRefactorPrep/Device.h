/*
 *  Device.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

class Device
{
public:
	Device() {}
	virtual ~Device() {}
	
	static void map(size_t pin, Device* toDevice);
	static Device* get(size_t pin);
};
