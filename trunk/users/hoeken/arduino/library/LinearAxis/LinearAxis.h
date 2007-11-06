/*
  LinearAxis.h - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

// ensure this library description is only included once
#ifndef LinearAxis_h
#define LinearAxis_h

#include <LimitSwitch.h>
#include <RepStepper.h>

// library interface description
class LinearAxis {
  public:
    
	// constructors:
    LinearAxis(int steps, int dir_pin, int step_pin, int min_pin, int max_pin);

	//these are our other object variables.
	RepStepper stepper;
//	AnalogEncoder encoder;

	//various guys to interface with class
	void readState();
	void ddaStep();
	bool canStep();
	bool doStep();
	void setDelta(float delta);
	unsigned long getPosition();
	void setPosition(unsigned long position);
	
	//our limit switch functions
	bool atMin();
	bool atMax();

  private:
	bool can_step;						//are we allowed to take a step yet?
	unsigned long current_position;		//this is our current position.
	float dda_position;					//this is our 'position' in DDA terms.	
	float delta;						//this is our change for DDA.

	LimitSwitch min_switch;
	LimitSwitch max_switch;
};

#endif
