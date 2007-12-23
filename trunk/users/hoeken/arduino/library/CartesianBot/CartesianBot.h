/*
	LinearAxis.h - RepRap Linear Axis library for Arduino - Version 0.1

	This library is used to interface with a RepRap Cartesian Bot

	History:
	* Created intial library (0.1) by Zach Smith.

	License: GPL v2.0
*/

// ensure this library description is only included once
#ifndef CartesianBot_h
#define CartesianBot_h

//#include "HardwareSerial.h"
#include "LinearAxis.h"
#include "RepStepper.h"
#include "WConstants.h"

// how big do we want our point queue?
#define POINT_QUEUE_SIZE 16

#define MODE_PAUSE 0
#define MODE_SEEK 1
#define MODE_DDA 2
#define MODE_HOMERESET 3
#define MODE_FIND_MIN 4
#define MODE_FIND_MAX 5

// our point structure to make things nice.
struct Point {
	unsigned long x;
	unsigned long y;
 	unsigned long z;
};

// library interface description
class CartesianBot {
  public:

    // constructors:
    CartesianBot(
		char x_id, int x_steps, byte x_dir_pin, byte x_step_pin, byte x_min_pin, byte x_max_pin, byte x_enable_pin,
		char y_id, int y_steps, byte y_dir_pin, byte y_step_pin, byte y_min_pin, byte y_max_pin, byte y_enable_pin,
		char z_id, int z_steps, byte z_dir_pin, byte z_step_pin, byte z_min_pin, byte z_max_pin, byte z_enable_pin
	);
	
	// our queue stuff
	bool queuePoint(Point &point);
	struct Point unqueuePoint();
	void clearQueue();
	bool isQueueFull();
	bool isQueueEmpty();
	byte getQueueSize();
	
	//cartesian bot specific.
	void setTargetPoint(Point &point);
	void setCurrentPoint(Point &point);
	void getNextPoint();
	void calculateDDA();
	bool atTarget();
	bool atHome();
	
	//mode commands
	void stop();
	void startSeek();
	void startHomeReset();
	void startCalibration();
	byte getMode();

	//our interface methods
	void readState();
	
	//our timer interrupt interface functions.
	void setupTimerInterrupt();
	void enableTimerInterrupt();
	void disableTimerInterrupt();
	void setTimer(unsigned long delay);
	void setTimerResolution(byte r);
	void setTimerCeiling(unsigned int c);
	byte getTimerResolution(unsigned long delay);
	unsigned int getTimerCeiling(unsigned long delay);
	
	//our variables
	LinearAxis x;
	LinearAxis y;
	LinearAxis z;

	//for DDA stuff.
	long max_delta;

	//this is the mode we're currently in... started/stopped
	byte mode;
	
  private:

	//this is for our queue of points.
	byte head;
	byte tail;
	byte size;

	Point point_queue[POINT_QUEUE_SIZE];
};

#endif
