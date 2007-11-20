/*
  LinearAxis.h - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

// ensure this library description is only included once
#ifndef LinearAxis_h
#define LinearAxis_h

#include "HardwareSerial.h"
#include <LimitSwitch.h>
#include <RepStepper.h>

// library interface description
class LinearAxis {
  public:
    
	// constructors:
    LinearAxis(byte id, int steps, int dir_pin, int step_pin, int min_pin, int max_pin);

	//these are our other object variables.
	RepStepper stepper;
//	AnalogEncoder encoder;

	//various guys to interface with class
	void readState();
	void doStep();

	//our DDA based functions
	int calculateDDASpeed(long max_delta);
	long getDelta();
	
	//our function for full on timer based stepping.
	void setTimer(int speed);
	void setTimerResolution(byte r);
	void setTimerFrequency(byte f);
	void setupTimerInterrupt();
	void enableTimerInterrupt();
	void disableTimerInterrupt();
	
	//various position things.
	long getPosition();
	void setPosition(long position);
	long getTarget();
	void setTarget(long t);
	bool atTarget();
	
	//our limit switch functions
	bool atMin();
	bool atMax();

	byte id;					//what is our id? x, y, z, etc.
	bool can_step;				//are we capable of taking a step yet?
	bool dda_ready;				//are we allowed to take a step yet?

  private:
	long current;				//this is our current position.
	long target;				//this is our target position.

	LimitSwitch min_switch;
	LimitSwitch max_switch;
};

#endif
