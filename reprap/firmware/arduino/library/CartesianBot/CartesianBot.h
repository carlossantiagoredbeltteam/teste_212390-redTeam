/*
  LimitSwitch.h - RepRap Limit Switch library for Arduino - Version 0.1

  This library is used to interface with a reprap optical limit switch.

  History:
  * Created intiial library (0.1) by Zach Smith.

*/

// ensure this library description is only included once
#ifndef CartesianBot_h
#define CartesianBot_h

#define POINT_QUEUE_SIZE 64

// include types & constants of Wiring core API
#include "WConstants.h"
#include "RepStepper.h"

// our point structure to make things nice.
struct Point {
	int x;
	int y;
	int z;
};

#define MODE_PAUSE 0
#define MODE_SEEK 1

// library interface description
class CartesianBot {
  public:

	Point target_point;
	Point current_position;
	
    // constructors:
    CartesianBot();
	
	// add in various points
	bool queuePoint(Point &point);
	void clearQueue();
	void setTargetPoint(Point &point);
	void setCurrentPoint(Point &point);

	void stop();
	void start();

	//our interface methods
	bool readState();
	void move();
	void abort();
	
	//boring version stuff
    int version();

	//our variables
	LinearAxis x;
	LinearAxis y;
	LinearAxis z;

  private:
	
	byte mode;
	bool atPoint(Point &point);
	struct Point unqueuePoint();
		

	//this is for tracking to a point.
	byte point_index = 0;
	Point point_queue[POINT_QUEUE_SIZE];
};

#endif
