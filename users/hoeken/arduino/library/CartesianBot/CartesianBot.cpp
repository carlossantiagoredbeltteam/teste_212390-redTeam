
#include "WConstants.h"
#include "CartesianBot.h"

CartesianBot::CartesianBot(
	byte x_id, int x_steps, int x_dir_pin, int x_step_pin, int x_min_pin, int x_max_pin,
	byte y_id, int y_steps, int y_dir_pin, int y_step_pin, int y_min_pin, int y_max_pin,
	byte z_id, int z_steps, int z_dir_pin, int z_step_pin, int z_min_pin, int z_max_pin
) : x(x_id, x_steps, x_dir_pin, x_step_pin, x_min_pin, x_max_pin), y(y_id, y_steps, y_dir_pin, y_step_pin, y_min_pin, y_max_pin), z(z_id, z_steps, z_dir_pin, z_step_pin, z_min_pin, z_max_pin)
{
	this->setupTimerInterrupt();
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
}

void CartesianBot::calculateDDA()
{
	//let us do the maths before stepping.
	this->disableTimerInterrupt();
	
	//what is the biggest one?
	max_delta = max(x.getDelta(), y.getDelta());
	max_delta = max(max_delta, z.getDelta());

	//calculate speeds for each axis.
	x.initDDA(max_delta);
	y.initDDA(max_delta);
	z.initDDA(max_delta);
	
	//we're in dda mode
	mode = MODE_DDA;
	
	//okies, go!
	this->enableTimerInterrupt();
}

void CartesianBot::stop()
{
	this->disableTimerInterrupt();
	mode = MODE_PAUSE;
}

void CartesianBot::startSeek()
{
	mode = MODE_SEEK;
	this->enableTimerInterrupt();
}

byte CartesianBot::getMode()
{
	return mode;
}

/*!
  Synchronously move to home.
*/
void CartesianBot::home()
{
	//get an initial reading.
	this->readState();
	
	//going towards home
	x.setTarget(-9000000);
	y.setTarget(-9000000);
	z.setTarget(-9000000);

	//okay, enable our movement!
	this->startSeek();
	
	//move us home!
	while (!this->atHome())
	{
		this->readState();
	}
	
	//stop movement now.
	this->stop();
	
	//mark us as home.
	x.setPosition(0);
	y.setPosition(0);
	z.setPosition(0);
	
	//set our new target
	x.setTarget(0);
	y.setTarget(0);
	z.setTarget(0);

	//seek to our point!
	this->startSeek();
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


void CartesianBot::setupTimerInterrupt()
{
	//clear the registers
	TCCR1A = 0;
	TCCR1B = 0;
	TCCR1C = 0;
	TIMSK1 = 0;
	
	//waveform generation = 0100 = CTC
	TCCR1B &= ~(1<<WGM13);
	TCCR1B |=  (1<<WGM12);
	TCCR1A &= ~(1<<WGM11); 
	TCCR1A &= ~(1<<WGM10);

	//output mode = 00 (disconnected)
	TCCR1A &= ~(1<<COM1A1); 
	TCCR1A &= ~(1<<COM1A0);

	//start off with a slow frequency.
	this->setTimerResolution(1);
	this->setTimerCeiling(65535);
}

void CartesianBot::enableTimerInterrupt()
{
	//reset our timer to 0 for reliable timing
	TCNT1 = 0;

	//then enable our interrupt!
	TIMSK1 |= (1<<OCIE1A);
}

void CartesianBot::disableTimerInterrupt()
{
	TIMSK1 &= ~(1<<OCIE1A);
}

void CartesianBot::setTimerResolution(byte r)
{
	// prescale of /64 == 4 usec tick
	if (r == 1)
	{
		// 011 = clk/64
		TCCR1B &= ~(1<<CS12);
		TCCR1B |=  (1<<CS11);
		TCCR1B |=  (1<<CS10);
	}
	// prescale of /256 == 16 usec tick
	else if (r == 2)
	{
		// 100 = clk/256
		TCCR1B |=  (1<<CS12);
		TCCR1B &= ~(1<<CS11);
		TCCR1B &= ~(1<<CS10);
	}
	// prescale of /1024 == 64 usec tick
	else
	{
		// 101 = clk/1024
		TCCR1B |=  (1<<CS12);
		TCCR1B &= ~(1<<CS11);
		TCCR1B |=  (1<<CS10);
	}
}

void CartesianBot::setTimer(unsigned long speed)
{
	//speed is the delay between steps in microseconds.
	//
	//we break it into 3 different resolutions
	//then essentially calculate the timer ceiling required. (ie what the counter counts to)
	//the way we do that is to take the ratio of speed to the max of the resolution,
	//multiply it by the the max value of the counter... except in a different order
	//due to integer math.  we then set that as the timer value so it fires an interrupt every
	//x microseconds.
	byte ceiling = 255;
	 
	if (speed <= 255L)
	{
		this->setTimerResolution(1);
		ceiling = speed;
	}
	else if (speed <= 1020L)
	{
		this->setTimerResolution(2);
		ceiling = speed / 4;
	}
	// our slowest speed at our lowest resolution ((2^16-1) * 64 usecs = 4194240 usecs)
	else if (speed <= 4080L)
	{
		this->setTimerResolution(3);
		ceiling = speed / 16;
	}
	//its really slow... hopefully we can just get by with super slow.
	else
	{
		//otherwise, set it to our slowest speed.
		this->setTimerResolution(3);
		ceiling = 255;
	}

	//now update our clock!!
	this->setTimerCeiling(ceiling);
}

void CartesianBot::setTimerCeiling(unsigned int f)
{
	OCR1A = f;
}

/*
// I cannot for the life of me get the atmega to use the full 16 bits of the OCR1A, it only uses the lower 8 bits.
// TODO: fix it to use full 16 bits.

void CartesianBot::setTimer(unsigned long speed)
{
	//speed is the delay between steps in microseconds.
	//
	//we break it into 3 different resolutions
	//then essentially calculate the timer ceiling required. (ie what the counter counts to)
	//the way we do that is to take the ratio of speed to the max of the resolution,
	//multiply it by the the max value of the counter... except in a different order
	//due to integer math.  we then set that as the timer value so it fires an interrupt every
	//x microseconds.
	unsigned int ceiling = 65535;
	 
	// our slowest speed at our highest resolution ( (2^16-1) * 4 usecs = 262140 usecs)
	if (speed <= 65535L)
	{
		this->setTimerResolution(1);
		ceiling = speed & 0xffff;
	}
	// our slowest speed at our medium resolution ( (2^16-1) * 16 usecs = 1048560 usecs)
	else if (speed <= 262140L)
	{
		this->setTimerResolution(2);
		ceiling = speed / 4;
	}
	// our slowest speed at our lowest resolution ((2^16-1) * 64 usecs = 4194240 usecs)
	else if (speed <= 1048560L)
	{
		this->setTimerResolution(3);
		ceiling = speed / 16;
	}
	//its really slow... hopefully we can just get by with super slow.
	else
	{
		//otherwise, set it to our slowest speed.
		this->setTimerResolution(3);
		ceiling = 65535;
	}

	//now update our clock!!
	this->setTimerCeiling(ceiling);
}



void CartesianBot::setTimerCeiling(unsigned int f)
{
	unsigned char sreg;
	
	//disable global interrupts
	sreg = SREG;
	SREG &= ~(1<<7);
	
	//disable our timer interrupt
	this->disableTimerInterrupt();

// none of these calls work.
//	OCR1A = f;	
//	OCR1AH = (f >> 8);
//	OCR1AL = (f & 0xff);
	OCR1A = f & 0xffff;
	
	//re-enable interrupts.
	SREG = sreg;
	this->enableTimerInterrupt();
}
*/
