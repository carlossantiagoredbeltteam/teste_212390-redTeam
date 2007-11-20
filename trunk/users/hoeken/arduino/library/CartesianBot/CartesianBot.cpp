
#include "WConstants.h"
#include "CartesianBot.h"

CartesianBot::CartesianBot(
	byte x_id, int x_steps, int x_dir_pin, int x_step_pin, int x_min_pin, int x_max_pin,
	byte y_id, int y_steps, int y_dir_pin, int y_step_pin, int y_min_pin, int y_max_pin,
	byte z_id, int z_steps, int z_dir_pin, int z_step_pin, int z_min_pin, int z_max_pin
) : x(x_id, x_steps, x_dir_pin, x_step_pin, x_min_pin, x_max_pin), y(y_id, y_steps, y_dir_pin, y_step_pin, y_min_pin, y_max_pin), z(z_id, z_steps, z_dir_pin, z_step_pin, z_min_pin, z_max_pin)
{
	this->stop();
	this->clearQueue();
}

byte CartesianBot::getQueueSize()
{
	return size;
}

bool CartesianBot::isQueueEmpty()
{
	return (size == 0);
}

bool CartesianBot::isQueueFull()
{
	return (size == POINT_QUEUE_SIZE);
}

bool CartesianBot::queuePoint(Point &point)
{
	if (this->isQueueFull())
		return false;
		
	//queue up our point (at the old tail spot)!
	point_queue[tail] = point;
	
	//keep track
	size++;

	//move our tail to the next tail location
	tail++;
	if (tail == POINT_QUEUE_SIZE)
		tail = 0;
	
	return true;
}

struct Point CartesianBot::unqueuePoint()
{
	//save our old head.
	byte oldHead = head;
	
	//move our head to the head for next time.
	head++;
	if (head == POINT_QUEUE_SIZE)
		head = 0;

	//keep track.
	size--;
			
	return point_queue[oldHead];
}

void CartesianBot::clearQueue()
{
	head = 0;
	tail = 0;
	size = 0;
}

void CartesianBot::getNextPoint()
{
	Point p;
	
	if (!this->isQueueEmpty())
	{
		p = this->unqueuePoint();

		x.setTarget(p.x);
		y.setTarget(p.y);
		z.setTarget(p.z);
	}
	else
	{
		x.setTarget(x.getPosition());
		y.setTarget(y.getPosition());
		z.setTarget(z.getPosition());
	}
	
	this->calculateDDA();
}

void CartesianBot::calculateDDA()
{
	long max_delta;
	
	//what is the biggest one?
	max_delta = max(x.getDelta(), y.getDelta());
	max_delta = max(max_delta, z.getDelta());

	//save it into each object.
	x.initDDA(max_delta);
	y.initDDA(max_delta);
	z.initDDA(max_delta);
}

void CartesianBot::stop()
{
	mode = MODE_PAUSE;

	x.disableTimerInterrupt();
	y.disableTimerInterrupt();
	z.disableTimerInterrupt();
}

void CartesianBot::start()
{
	mode = MODE_SEEK;

	x.enableTimerInterrupt();
//	y.enableTimerInterrupt();
	z.enableTimerInterrupt();
}

byte CartesianBot::getMode()
{
	return mode;
}

void CartesianBot::home()
{

	//pause it to disable our interrupt handler.
	this->stop();

	//get an initial reading.
	this->readState();
	
	//going towards 0
	x.stepper.setDirection(RS_REVERSE);
	y.stepper.setDirection(RS_REVERSE);
	z.stepper.setDirection(RS_REVERSE);

	//move us home!
	while (!this->atHome())
	{
		if (!x.atMin() && x.stepper.canStep())
			x.stepper.step();
		if (!y.atMin() && y.stepper.canStep())
			y.stepper.step();
		if (!z.atMin() && z.stepper.canStep())
			z.stepper.step();

		this->readState();
	}
	
	//mark us as home.
	x.setPosition(0);
	y.setPosition(0);
	z.setPosition(0);
	
	//set our new target
	x.setTarget(0);
	y.setTarget(0);
	z.setTarget(0);

	//start it up (ie... enable interrupt handler)
	this->start();

	//do our dda calcs.
	this->calculateDDA();
}

bool CartesianBot::atHome()
{
	return (x.atMin() && y.atMin() && z.atMin());
}

void CartesianBot::readState()
{
	x.readState();
	y.readState();
	z.readState();
}

bool CartesianBot::atTarget()
{
	return (x.atTarget() && y.atTarget() && z.atTarget());
}

void CartesianBot::abort()
{
	this->stop();
	this->clearQueue();
}

int CartesianBot::version()
{
	return 1;
}
