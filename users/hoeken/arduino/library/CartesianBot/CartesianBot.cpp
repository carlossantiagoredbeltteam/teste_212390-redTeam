
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

void CartesianBot::setupInterrupt()
{
	//enable our timer interrupt!
	TIMSK1 |= (1<<OCIE1A);
	
	//output mode = compare output, non pwm clear OC2A on match
	TCCR1A |= (1<<COM1A1); 
	TCCR1A &= ~(1<<COM1A0); 

	//waveform generation = mode 4 = CTC
	TCCR1B &= ~(1<<WGM13);
	TCCR1B |= (1<<WGM12);
	TCCR1A &= ~(1<<WGM11); 
	TCCR1A &= ~(1<<WGM10);
	
	//set our prescaler to 64. one tick == 4 microsecond.
	TCCR1B &= ~(1<<CS12);
	TCCR1B |= (1<<CS11);
	TCCR1B |= (1<<CS10);

	//set the max counter here.  interrupt every time the X stepper would be ready to step.
	OCR1A = x.stepper.getSpeed();
}

void CartesianBot::handleInterrupt()
{
	//make sure we're in seek mode
	if (mode == MODE_SEEK)
	{
		//do our DDA maths.
		x.ddaStep(max_delta);
		y.ddaStep(max_delta);
		z.ddaStep(max_delta);
		
		//did we make it?	
		if (this->atTarget())
		{
			this->notifyTargetReached();
			this->getNextPoint();
		}
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
