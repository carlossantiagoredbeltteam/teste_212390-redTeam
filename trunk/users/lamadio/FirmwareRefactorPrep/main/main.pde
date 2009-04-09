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

void setup()
{
    Serial.begin(115200);
}

void loop()
{
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


