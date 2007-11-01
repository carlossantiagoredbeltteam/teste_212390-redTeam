/*
  LinearAxis.h - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

// ensure this library description is only included once
#ifndef LinearAxis_h
#define LinearAxis_h

// library interface description
class LinearAxis {
  public:
    
	RepStepper stepper;
	
	LimitSwitch min;
	LimitSwitch max;
	
//	AnalogEncoder encoder;
	
	// constructors:
    LinearAxis();

	//various guys to interface with class
	void ddaStep();
	bool canStep();
	void setDelta(float delta);
	int getPosition();
	void setPosition(int position);

	//random other functions
    int version();

  private:
	bool can_step;			//are we allowed to take a step yet?
	int current_position;			//this is our current position.
	float dda_position;		//this is our 'position' in DDA terms.	
	float delta;			//this is our change for DDA.
};

#endif
