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

int main (int argc, char * const argv[]) 
{
	StepperDevice xAxisStepper(1, 2, 300, 20);
	OpticalInterrupt xAxisFar(10);
	OpticalInterrupt xAxisNear(11);
	StepperLinearActuator linearActuator(4.5f, xAxisStepper, xAxisFar, xAxisNear);
	
	return 0;
}
