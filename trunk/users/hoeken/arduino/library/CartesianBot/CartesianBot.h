/*
	LimitSwitch.h - RepRap Limit Switch library for Arduino - Version 0.1

	This library is used to interface with a RepRap Cartesian Bot

	History:
	* Created intial library (0.1) by Zach Smith.

	License: GPL v2.0
*/

// ensure this library description is only included once
#ifndef CartesianBot_h
#define CartesianBot_h

#include "LinearAxis.h"
#include "WConstants.h"

// 21 is so we can send our whole queue in one PackIt: 21 * 4 * 3 = 252 bytes
#define POINT_QUEUE_SIZE 21
#define MODE_PAUSE 0
#define MODE_SEEK 1

// our point structure to make things nice.
struct Point {
	unsigned long x;
	unsigned long y;
 	unsigned long z;
};

// library interface description
class CartesianBot {
  public:

	Point target_point;
	Point current_position;
	
    // constructors:
    CartesianBot(
		int x_steps, int x_dir_pin, int x_step_pin, int x_min_pin, int x_max_pin,
		int y_steps, int y_dir_pin, int y_step_pin, int y_min_pin, int y_max_pin,
		int z_steps, int z_dir_pin, int z_step_pin, int z_min_pin, int z_max_pin
	);
	
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
	void getNextPoint();

	void stop();
	void start();

	//our interface methods
	void readState();
	void move();
	void home();
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
	void calculateDDA();
	void notifyTargetReached();	

	//this is for tracking to a point.
	uint8_t head;
	uint8_t tail;
	int size;
	Point point_queue[POINT_QUEUE_SIZE];
};

#endif
