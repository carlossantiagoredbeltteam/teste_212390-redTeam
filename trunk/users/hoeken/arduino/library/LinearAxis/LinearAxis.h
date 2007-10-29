/*
  LinearAxis.h - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

// ensure this library description is only included once
#ifndef LinearAxis_h
#define LinearAxis_h

// include types & constants of Wiring core API
#include "WConstants.h"

// library interface description
class LinearAxis {
  public:
    
	RepStepper stepper;
	
	LimitSwitch min;
	LimitSwitch max;
	
	AnalogEncoder encoder;
	
	int current;			//this is our current position.
	float dda_position;		//this is our 'position' in DDA terms.	
	float delta;			//this is our change for DDA.
	bool can_move;			//are we allowed to take a step yet?
	
	// constructors:
    LinearAxis();

	//this guy tells us to do a DDA move.
	void dda_move();
	
	//random other functions
    int version();

  private:

};

#endif
