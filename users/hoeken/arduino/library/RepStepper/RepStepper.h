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

extern volatile unsigned long timer0_overflow_count;


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
	
    //various methods dealing with stepping.
    boolean nonBlockingStep();
	void blockingStep(int steps);
	boolean canStep();
	void pulse();

	//random other functions
    int version();

  private:

	//various internal variables
    bool direction;				// Direction of rotation
	unsigned int rpm;					// Speed in RPMs
	unsigned int step_delay;   // delay between steps, in microseconds, based on speed
    unsigned int number_of_steps;		// total number of steps this motor can take

	//our time counter variables.
	unsigned long last_step_time;			// time stamp in ticks of when our last step was.
    unsigned long next_step_time;			// time stamp in ticks of when the next step can be.
    unsigned long now;						// the 'current' timestamp in ticks of right now.
	
    // motor pin numbers:
    int step_pin;				//the step signal pin.
    int direction_pin;			//the direction pin.

	//our time function
	unsigned long hpticks(void);
};

#endif
