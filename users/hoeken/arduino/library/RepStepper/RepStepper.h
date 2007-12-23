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
    RepStepper(unsigned int number_of_steps, byte dir_pin, byte step_pin, byte enable_pin);

    // various setters methods:
	void setRPM(unsigned int rpm);
    void setSpeed(unsigned long speed);
	void setDirection(bool direction);
	void setSteps(unsigned int steps);

	//our getter methods to help us out
	unsigned int getRPM();
	unsigned long getSpeed();
	bool getDirection();
	unsigned int getSteps();
	
    //various methods dealing with stepping.
	void pulse();
	void enable();
	void disable();
	bool isEnabled();

  private:

	//various internal variables
    bool direction;						// Direction of rotation
	bool enabled;						// whether or not we're enabled.
	unsigned int rpm;					// Speed in RPMs
	unsigned long step_delay;  			// delay between steps, in microseconds, based on speed
    unsigned int number_of_steps;		// total number of steps this motor can take

    // motor pin numbers:
    byte step_pin;						//the step signal pin.
    byte direction_pin;					//the direction pin.
    byte enable_pin;					//the enable pin.
};

#endif
