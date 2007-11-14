
#include "WConstants.h"
#include "CartesianBot.h"

CartesianBot::CartesianBot(
	int x_steps, int x_dir_pin, int x_step_pin, int x_min_pin, int x_max_pin,
	int y_steps, int y_dir_pin, int y_step_pin, int y_min_pin, int y_max_pin,
	int z_steps, int z_dir_pin, int z_step_pin, int z_min_pin, int z_max_pin
) : x(x_steps, x_dir_pin, x_step_pin, x_min_pin, x_max_pin), y(y_steps, y_dir_pin, y_step_pin, y_min_pin, y_max_pin), z(z_steps, z_dir_pin, z_step_pin, z_min_pin, z_max_pin)
{
	this->stop();
	this->clearQueue();

	//output mode = compare output, non pwm clear OC0A on match
	TCCR0A &= (1<<COM0A1); 
	TCCR0A &= (0<<COM0A0); 

	//waveform generation = mode 3 = CTC
	TCCR0B &= (0<<WGM02)
	TCCR0A &= (1<<WGM01); 
	TCCR0A &= (1<<WGM00);
	
	//set our prescaler to 8. one tick == 0.5 microseconds.
	TCCR0B &= (0<<CS02);
	TCCR0B &= (1<<CS01);
	TCCR0B &= (0<<CS00);

	//set the max counter here.  interrupt every 50 microseconds.
	OCR0A = 100;
}

byte CartesianBot::getQueueSize()
{
	return size;
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
	size++;
		
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
	size--;
	
	return this->point_queue[this->head];
}

void CartesianBot::clearQueue()
{
	this->head = 0;
	this->tail = 0;
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
}

void CartesianBot::start()
{
	mode = MODE_SEEK;
}

byte CartesianBot::getMode()
{
	return mode;
}

void CartesianBot::home()
{
	//pause it to disable our interrupt handler.
	mode = MODE_PAUSE;
	
	//going towards 0
	x.stepper.setDirection(RS_REVERSE);
	y.stepper.setDirection(RS_REVERSE);
	z.stepper.setDirection(RS_REVERSE);
	
	//move us home!
	while (!this->atHome())
	{
		if (!x.atMin())
			x.stepper.nonBlockingStep();
		if (!y.atMin())
			y.stepper.nonBlockingStep();
		if (!z.atMin())
			z.stepper.nonBlockingStep();
	}
	
	//mark us as home.
	x.setPosition(0);
	y.setPosition(0);
	z.setPosition(0);
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

void CartesianBot::move()
{
	//are we in moving mode?
	if (mode == MODE_SEEK)
	{
		//only do a DDA step if we're waiting to send a step signal.
		if (!x.canStep() && !y.canStep() && !z.canStep())
		{
			//are we at the point?
			if (this->atTarget())
				this->getNextPoint();

			//do our steps
			x.ddaStep(max_delta);
			y.ddaStep(max_delta);
			z.ddaStep(max_delta);
		}
	}
}

void CartesianBot::handleInterrupt()
{
	stepper_ticks++;
	
	//make sure we're in seek mode
	if (mode == MODE_SEEK)
	{
		//check each axis and move it if necessary.
		if (x.canStep())
			x.doStep();

		if (y.canStep())
			y.doStep();

		if (z.canStep())
			z.doStep();
	}
}

bool CartesianBot::atTarget()
{
	return (x.atTarget() && y.atTarget() && z.atTarget());
}

void CartesianBot::notifyTargetReached()
{
/*
	packet.create(HOST_ADDRESS, MY_ADDRESS);
	packet.add(CMD_GET_POS);
	packet.add(current_position.x);
	packet.add(current_position.y);
	packet.add(current_position.z);
	packet.send();
*/
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
