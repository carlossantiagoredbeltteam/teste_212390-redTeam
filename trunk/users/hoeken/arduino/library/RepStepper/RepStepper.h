/*
  RepStepper.h - RepRap Stepper library for Arduino - Version 0.1
  
  Based on Stepper library by Tom Igoe & others: http://www.arduino.cc/en/Reference/Stepper

  History:
  * Forked library (0.1) by Zach Smith.

  Drives a bipolar stepper motor using 2 wires: Step and Direction.
*/

// ensure this library description is only included once
#ifndef RepStepper_h
#define RepStepper_h

#include "WConstants.h"

#define RS_FORWARD 1
#define RS_REVERSE 0

// library interface description
class RepStepper {
  public:
    // constructors:
    RepStepper(int number_of_steps, int step_pin, int dir_pin);

    // various setters methods:
	void setRPM(int rpm);
    void setSpeed(int speed);
	void setDirection(bool direction);
	void setSteps(int steps);

	//our getter methods to help us out
	int getRPM();
	int getSpeed();
	bool getDirection();
	int getSteps();
	
    // mover method:
    void step();

	// info stuff
	bool canStep();

	//random other functions
    int version();

  private:

	unsigned int micros();
    
	//various internal variables
    bool direction;				// Direction of rotation
	int rpm;					// Speed in RPMs
	int step_delay;   			// delay between steps, in microseconds, based on speed
    int number_of_steps;		// total number of steps this motor can take
	
    // motor pin numbers:
    int step_pin;				//the step signal pin.
    int direction_pin;			//the direction pin.
    
	//our time counter variables.
	unsigned long last_step_time;			// time stamp in ticks of when our last step was.
    unsigned long next_step_time;			// time stamp in ticks of when the next step can be.
};

#endif
