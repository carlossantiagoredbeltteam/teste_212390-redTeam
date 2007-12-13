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
	long getDelta();
	void initDDA(long max_delta);
	void ddaStep(long max_delta);
	
	//various position things.
	long getPosition();
	void setPosition(long position);
	long getTarget();
	void setTarget(long t);
	bool atTarget();
	
	void forward1();
	void reverse1();
		
	//our limit switch functions
	bool atMin();
	bool atMax();

	byte id;					//what is our id? x, y, z, etc.
	bool can_step;				//are we capable of taking a step yet?
	int function;				//what function are we at?

  private:
	long current;				//this is our current position.
	long target;				//this is our target position.
	long delta;					//our delta for our DDA moves.
	long counter;				//our dda counter for dda moves.
	
	LimitSwitch min_switch;
	LimitSwitch max_switch;
};

#endif
