/*
	LinearAxis.h - RepRap Linear Axis library for Arduino

	The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder

	Memory Usage Estimate: 25 + repstepper usage.

	History:
	* (0.1) Created library by Zach Smith.
	* (0.2) Optimized for less memory usage and faster performance

	License: GPL v2.0
*/

// ensure this library description is only included once
#ifndef LinearAxis_h
#define LinearAxis_h

#include <RepStepper.h>

// library interface description
class LinearAxis {
  public:
    
	// constructors:
    LinearAxis(char id, int steps, byte dir_pin, byte step_pin, byte min_pin, byte max_pin, byte enable_pin);

	//these are our other object variables.
	RepStepper stepper;

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
	void setMax(long m);
	long getMax();
	
	void forward1();
	void reverse1();
		
	//our limit switch functions
	bool atMin();
	bool atMax();

	char id;					//what is our id? x, y, z, etc.
	bool can_step;				//are we capable of taking a step yet?
	byte function;				//what function are we at?

	long delta;					//our delta for our DDA moves.
	long counter;				//our dda counter for dda moves.

  private:
	byte min_pin;
	byte max_pin;
	long current;				//this is our current position.
	long target;				//this is our target position.
	long max;					//this is our max coordinate.
	
	//LimitSwitch min_switch;
	//LimitSwitch max_switch;
};

#endif
