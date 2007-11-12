
#include "WConstants.h"
#include "CartesianBot.h"

CartesianBot::CartesianBot(
	int x_steps, int x_dir_pin, int x_step_pin, int x_min_pin, int x_max_pin,
	int y_steps, int y_dir_pin, int y_step_pin, int y_min_pin, int y_max_pin,
	int z_steps, int z_dir_pin, int z_step_pin, int z_min_pin, int z_max_pin
) : x(x_steps, x_dir_pin, x_step_pin, x_min_pin, x_max_pin), y(y_steps, y_dir_pin, y_step_pin, y_min_pin, y_max_pin), z(z_steps, z_dir_pin, z_step_pin, z_min_pin, z_max_pin)
{
	this->mode = MODE_PAUSE;

	this->head = 0;
	this->tail = 0;
}

int CartesianBot::getQueueSize()
{
	return this->size;
}

bool CartesianBot::isQueueEmpty()
{
	if (this->head == this->tail)
		return true;
	else
		return false;
}

bool CartesianBot::isQueueFull()
{
	//is our queue full?
	if (this->tail+1 == this->head || (this->tail+1 == POINT_QUEUE_SIZE && !this->head))
		return true;
	else
		return false;
}

bool CartesianBot::queuePoint(Point &point)
{
	if (this->isQueueFull())
		return false;
		
	//increment our tail pointer.
	this->tail++;
	if (this->tail == POINT_QUEUE_SIZE)
		this->tail = 0;
	
	//keep track
	this->size++;
		
	//queue up our point!
	this->point_queue[this->tail] = point;

	return true;
}

struct Point CartesianBot::unqueuePoint()
{
	//move our head to the new item to return.
	this->head++;
	if (this->head == POINT_QUEUE_SIZE)
		this->head = 0;
	
	//keep track.
	this->size--;
	
	return this->point_queue[this->head];
}

void CartesianBot::clearQueue()
{
	this->head = 0;
	this->tail = 0;
	this->size = 0;
}

void CartesianBot::setTargetPoint(Point &point)
{
	this->target_point = point;
	this->calculateDDA();
}

void CartesianBot::setCurrentPoint(Point &point)
{
	this->current_position = point;
	this->calculateDDA();
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
	long steps;
	
	//what is the biggest one?
	max_delta = max(x.getDelta(), y.getDelta());
	max_delta = max(max_delta, z.getDelta());

	//do our dda calculation
	steps = -max_delta/2;
	
	//save it into each object.
	x.initDDA(steps);
	y.initDDA(steps);
	z.initDDA(steps);
}

void CartesianBot::stop()
{
	this->mode = MODE_PAUSE;
}

void CartesianBot::start()
{
	this->mode = MODE_SEEK;
}

void CartesianBot::home()
{
	Point p;
	boolean home = false;
	
	//going towards 0
	x.stepper.setDirection(RS_REVERSE);
	y.stepper.setDirection(RS_REVERSE);
	z.stepper.setDirection(RS_REVERSE);
	
	//move us home!
	while (!home)
	{
		if (!x.atMin())
			x.stepper.nonBlockingStep();
		if (!y.atMin())
			y.stepper.nonBlockingStep();
		if (!z.atMin())
			z.stepper.nonBlockingStep();

		if (x.atMin() && y.atMin() && z.atMin())
			home = true;
	}
	
	//mark us as home.
	p.x = 0;
	p.y = 0;
	p.z = 0;
	this->setCurrentPoint(p);
}

void CartesianBot::readState()
{
	x.readState();
	y.readState();
	z.readState();
}

void CartesianBot::move()
{
	if (this->mode == MODE_SEEK)
	{
		if (x.canStep() || y.canStep() || z.canStep())
		{
			if (x.canStep())
				x.doStep();
			if (y.canStep())
				y.doStep();
			if (z.canStep())
				z.doStep();

			//are we at the point?
			if (x.atTarget() && y.atTarget() && z.atTarget())
				this->getNextPoint();
		}
		else
		{
			x.ddaStep(max_delta);
			y.ddaStep(max_delta);
			z.ddaStep(max_delta);
		}
	}
}

void CartesianBot::notifyTargetReached()
{
	packet.create(HOST_ADDRESS, MY_ADDRESS);
	packet.add(CMD_GET_POS);
	packet.add(current_position.x);
	packet.add(current_position.y);
	packet.add(current_position.z);
	packet.send();
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

bool CartesianBot::atPoint(Point &point)
{
	return (
		point.x == this->current_position.x &&
		point.y == this->current_position.y &&
		point.z == this->current_position.z
	);
}
