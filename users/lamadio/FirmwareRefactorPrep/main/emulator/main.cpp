/*
 *  main.cpp
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 4/12/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */


#include "WProgram.h"
#include "Collections.h"
#include "EventLoop.h"
#include "EventLoop.h"
#include "Collections.h"
#include "Observable.h"
#include "Device.h"
#include "OpticalInterrupt.h"
#include "StepperDevice.h"
#include "LinearActuator.h"
#include "CartesianDevice.h"
#include "ThermisterDevice.h"
#include "HeaterDevice.h"
#include "ExtruderDevice.h"
#include "GCodeBehavior.h"

extern void incrementMillis();
class heartbeat : public PeriodicCallback
{
public:
    virtual void service()
	{
		incrementMillis();
	}
	
};

int main()
{
	heartbeat hb;
	EventLoop::current()->addPeriodicCallback(&hb);
	
    // XAxis
	StepperDevice xAxisStepper(2, 3, 300, 1000);
	OpticalInterrupt xAxisFar(10);
	OpticalInterrupt xAxisNear(11);
	LinearActuator xLinearActuator(4.5f, xAxisStepper, xAxisFar, xAxisNear);
	
    // ZAxis
	StepperDevice yAxisStepper(2, 3, 300, 1000);
	OpticalInterrupt yAxisFar(10);
	OpticalInterrupt yAxisNear(11);
	LinearActuator yLinearActuator(4.5f, yAxisStepper, yAxisFar, yAxisNear);
	
    // ZAxis
	StepperDevice zAxisStepper(2, 3, 300, 1000);
	OpticalInterrupt zAxisFar(10);
	OpticalInterrupt zAxisNear(11);
	LinearActuator zLinearActuator(4.5f, zAxisStepper, zAxisFar, zAxisNear);
	
    // Cartesian Bot
    //CartesianDevice bot(xLinearActuator, yLinearActuator, zLinearActuator);
    FakeBot bot;
    
    // Extruder
	StepperDevice extruderStepper(2, 3, 300, 1000);
    HeaterDevice heater(1);
    ThermisterDevice thermister(1);
    ExtruderDevice extruder(200, extruderStepper, thermister, heater);
	
    GCodeBehavior gcoder(extruder, bot);
	
	EventLoop::current()->run();
}


