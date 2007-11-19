/*
  LinearAxis.cpp - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

#include "LinearAxis.h"
#include "WConstants.h"

LinearAxis::LinearAxis(byte id, int steps, int dir_pin, int step_pin, int min_pin, int max_pin) : stepper(steps, dir_pin, step_pin), min_switch(min_pin), max_switch(max_pin)
{
	this->id = id;
	current = 0;
	target = 0;
	can_step = false;

	stepper.setDirection(RS_FORWARD);
	this->enableTimerInterrupt();
}

void LinearAxis::readState()
{
	//encoder.readState();

	min_switch.readState();
	max_switch.readState();
	
	// we can only step if we're not at our target and one of the following:
	// 1. we're not at an endstop, 2. we're at home and moving away, or 3. we're at max and moving home.
	can_step = (
		(current != target) && (
			(!this->atMin() && !this->atMax()) ||
			(this->atMin() && stepper.getDirection() == RS_FORWARD) ||
			(this->atMax() && stepper.getDirection() == RS_REVERSE)
		)
	);	
}

bool LinearAxis::canStep()
{
	return can_step;
}

bool LinearAxis::atMin()
{
	return min_switch.getState();
}

bool LinearAxis::atMax()
{
	return max_switch.getState();
}

void LinearAxis::initDDA(long max_delta)
{
	//calculate our new speed.
	this->setTimer((this->getDelta() / max_delta) * stepper.getSpeed());
}

void LinearAxis::doStep()
{
	//record our step
	if (stepper.getDirection())
		current++;
	else
		current--;
	
	//do our step!
	stepper.pulse();
}

long LinearAxis::getPosition()
{
	return current;
}

void LinearAxis::setPosition(long position)
{
	current = position;
	
	//recalculate stuff.
	this->setTarget(target);
}

long LinearAxis::getTarget()
{
	return target;
}

void LinearAxis::setTarget(long t)
{
	target = t;
	
	if (target > current)
		stepper.setDirection(RS_FORWARD);
	else
		stepper.setDirection(RS_REVERSE);
}

bool LinearAxis::atTarget()
{
	return (target == current);
}

long LinearAxis::getDelta()
{
	return abs(target - current);
}

void LinearAxis::enableTimerInterrupt()
{
	//x uses TIMER0
	if (id == 'x')
	{
		//enable our timer interrupt!
		TIMSK0 |=  (1<<OCIE0A);

		//output mode = 10 (clear OC0A on match)
		TCCR0A |=  (1<<COM0A1); 
		TCCR0A &= ~(1<<COM0A0); 

		//waveform generation = 010 = CTC
		TCCR0B &= ~(1<<WGM02);
		TCCR0A |=  (1<<WGM01); 
		TCCR0A &= ~(1<<WGM00);
	}
	//y uses TIMER1
	else if (id == 'y')
	{
		//enable our timer interrupt!
		TIMSK1 |=  (1<<OCIE1A);

		//output mode = 10 (clear OC1A on match)
		TCCR1A |=  (1<<COM1A1); 
		TCCR1A &= ~(1<<COM1A0); 

		//waveform generation = 0100 = CTC
		TCCR1B &= ~(1<<WGM13);
		TCCR1B |=  (1<<WGM12);
		TCCR1A &= ~(1<<WGM11); 
		TCCR1A &= ~(1<<WGM10);
	}
	//z uses TIMER2
	else if (id == 'z')
	{
		//enable our timer interrupt!
		TIMSK2 |=  (1<<OCIE2A);

		//output mode = 10 (clear OC1A on match)
		TCCR2A |=  (1<<COM2A1); 
		TCCR2A &= ~(1<<COM2A0);
		
		//waveform generation = 010 = CTC
		TCCR2B &= ~(1<<WGM22);
		TCCR2A |=  (1<<WGM21); 
		TCCR2A &= ~(1<<WGM20);
	}
}

void LinearAxis::disableTimerInterrupt()
{
	//x uses TIMER0
	if (id == 'x')
		TIMSK0 &= ~(1<<OCIE0A);
	//y uses TIMER1
	else if (id == 'y')
		TIMSK1 &= ~(1<<OCIE1A);
	//z uses TIMER2
	else if (id == 'z')
		TIMSK2 &= ~(1<<OCIE2A);
}

void LinearAxis::setTimer(int speed)
{
	//break it into 3 different resolutions
	//then essentially calculate the PWM required.
	byte pwm;
	 
	// our slowest speed at our highest resolution (1020 usecs)
	if (speed <= 1020)
	{
		this->setTimerResolution(1);
		pwm = (speed * 256L) / 1020L;
	}
	// our slowest speed at our medium resolution (4080 usecs)
	else if (speed <= 4080)
	{
		this->setTimerResolution(2);
		pwm = (speed * 256L) / 4080L;
	}
	// our slowest speed at our lowest resolution (16320 usecs)
	else if (speed <= 16320)
	{
		this->setTimerResolution(3);
		pwm = (speed * 256L) / 16320L;
	}
	//its really slow... hopefully we can just get by with super slow.
	else
	{
		//otherwise, set it to our slowest speed.
		this->setTimerResolution(3);
		pwm = 255;
	}

	//now update our clock!!
	this->setTimerFrequency(pwm);
}

void LinearAxis::setTimerResolution(byte r)
{
	//this guy uses TIMER0
	if (id == 'x')
	{
		// prescale of /64 == 4 usec tick
		if (r == 1)
		{
			// 011 = clk/64
			TCCR0B &= ~(1<<CS02);
			TCCR0B |=  (1<<CS01);
			TCCR0B |=  (1<<CS00);
		}
		// prescale of /256 == 16 usec tick
		else if (r == 2)
		{
			// 100 = clk/256
			TCCR0B |=  (1<<CS02);
			TCCR0B &= ~(1<<CS01);
			TCCR0B &= ~(1<<CS00);
		}
		// prescale of /1024 == 64 usec tick
		else
		{
			// 101 = clk/1024
			TCCR0B |=  (1<<CS02);
			TCCR0B &= ~(1<<CS01);
			TCCR0B |=  (1<<CS00);
		}
	}
	
	//this guy uses TIMER1
	if (id == 'y')
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
	
	//this guy uses TIMER2
	if (id == 'z')
	{
		// prescale of /64 == 4 usec tick
		if (r == 1)
		{
			// 100 = clk/64
			TCCR2B |=  (1<<CS22);
			TCCR2B &= ~(1<<CS21);
			TCCR2B &= ~(1<<CS20);
		}
		// prescale of /256 == 16 usec tick
		else if (r == 2)
		{
			// 110 = clk/256
			TCCR2B |=  (1<<CS22);
			TCCR2B |=  (1<<CS21);
			TCCR2B &= ~(1<<CS20);
		}
		// prescale of /1024 == 64 usec tick
		else
		{
			// 111 = clk/1024
			TCCR2B |=  (1<<CS22);
			TCCR2B |=  (1<<CS21);
			TCCR2B |=  (1<<CS20);
		}
	}
}

void LinearAxis::setTimerFrequency(byte f)
{
	if (id == 'x')
		OCR0A = f;
	
	if (id == 'y')
		OCR1A = f;

	if (id == 'z')
		OCR2A = f;
}
