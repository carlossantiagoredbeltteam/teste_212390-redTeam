/*
  LimitSwitch.h - RepRap Limit Switch library for Arduino - Version 0.1

  This library is used to interface with a reprap optical limit switch.

  History:
  * Created intiial library (0.1) by Zach Smith.

*/

// ensure this library description is only included once
#ifndef CartesianBot_h
#define CartesianBot_h

#include <LinearAxis.h>
#include <RepStepper.h>
#include <LimitSwitch.h>

#define POINT_QUEUE_SIZE 64

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
	
	// our queue stuff
	bool queuePoint(Point &point);
	struct Point unqueuePoint();
	void clearQueue();
	bool isQueueFull();
	bool isQueueEmpty();
	int getQueueSize();
	
	//cartesian bot specific.
	void setTargetPoint(Point &point);
	void setCurrentPoint(Point &point);

	void stop();
	void start();

	//our interface methods
	void readState();
	void move();
	void abort();
	
	//boring version stuff
    int version();

	//our variables
	LinearAxis x;
	LinearAxis y;
	LinearAxis z;

  private:
	
	uint8_t mode;
	bool atPoint(Point &point);
		

	//this is for tracking to a point.
	uint8_t head;
	uint8_t tail;
	int size;
	Point point_queue[POINT_QUEUE_SIZE];
};

#endif
