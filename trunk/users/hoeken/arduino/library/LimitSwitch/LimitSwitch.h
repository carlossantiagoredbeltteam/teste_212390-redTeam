/*
  LimitSwitch.h - RepRap Limit Switch library for Arduino - Version 0.1

  This library is used to interface with a reprap optical limit switch.

  History:
  * Created intiial library (0.1) by Zach Smith.

*/

// ensure this library description is only included once
#ifndef LimitSwitch_h
#define LimitSwitch_h

// library interface description
class LimitSwitch {
  public:

    // constructors:
    LimitSwitch(int pin);

	//our interface method
	bool getState();

  private:

    int pin;		//the switch state pin.
};

#endif
