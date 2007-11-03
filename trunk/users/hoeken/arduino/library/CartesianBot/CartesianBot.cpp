
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
	
}

void CartesianBot::setCurrentPoint(Point &point)
{
	
}

void CartesianBot::stop()
{
	this->mode = MODE_PAUSE;
}

void CartesianBot::start()
{
	this->mode = MODE_SEEK;
}

void CartesianBot::readState()
{
	
}

void CartesianBot::move()
{
	
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
