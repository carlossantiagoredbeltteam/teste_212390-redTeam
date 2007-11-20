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

	stepper.setDirection(RS_FORWARD);
	this->setupTimerInterrupt();
}

void LinearAxis::readState()
{
	//encoder.readState();
	min_switch.readState();
	max_switch.readState();
	
	//stop us if we're on target
	if (current == target)
		this->disableTimerInterrupt();
	
	//stop us if we're at home and still going 
	if (this->atMin() && stepper.getDirection() == RS_REVERSE)
		this->disableTimerInterrupt();

	//stop us if we're at max and still going
	if (this->atMax() && stepper.getDirection() == RS_FORWARD)
		this->disableTimerInterrupt();
}

bool LinearAxis::atMin()
{
	return min_switch.getState();
}

bool LinearAxis::atMax()
{
	return max_switch.getState();
}

int LinearAxis::calculateDDASpeed(long max_delta)
{
	int new_speed = (int)(((float)max_delta / (float)this->getDelta()) * (float)(stepper.getSpeed() << 2));

/*	
	Serial.print("dda for ");
	Serial.print(id);
	Serial.print(": ");
	Serial.print(max_delta, DEC);
	Serial.print(" / ");
	Serial.print(this->getDelta(), DEC);
	Serial.print(" * ");
	Serial.print((stepper.getSpeed() << 2), DEC);
	Serial.print(" = ");
	Serial.print(new_speed);
	Serial.println(" ");
*/	
	//calculate our new speed.
	this->setTimer(new_speed);
	
	//send it back
	return new_speed;
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

void LinearAxis::setupTimerInterrupt()
{
	//x uses TIMER0
	if (id == 'x')
	{	
		//clear the registers
		TCCR0A = 0;
		TCCR0B = 0;
		TIMSK0 = 0;
	
		//waveform generation = 010 = CTC
		TCCR0B &= ~(1<<WGM02);
		TCCR0A |=  (1<<WGM01); 
		TCCR0A &= ~(1<<WGM00);

		//output mode = 10 (clear OC0A on match)
		TCCR0A |=  (1<<COM0A1); 
		TCCR0A &= ~(1<<COM0A0);
	}
	//y uses TIMER1
	else if (id == 'y')
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

		//output mode = 10 (clear OC1A on match)
		TCCR1A |=  (1<<COM1A1); 
		TCCR1A &= ~(1<<COM1A0);
	}
	//z uses TIMER2
	else if (id == 'z')
	{
		//clear the registers
		TCCR2A = 0;
		TCCR2B = 0;
		TIMSK2 = 0;
		
		//waveform generation = 010 = CTC
		TCCR2B &= ~(1<<WGM22);
		TCCR2A |=  (1<<WGM21); 
		TCCR2A &= ~(1<<WGM20);

		//output mode = 10 (clear OC1A on match)
		TCCR2A |=  (1<<COM2A1); 
		TCCR2A &= ~(1<<COM2A0);
	}
	
	//start off with a slow frequency.
	this->setTimerResolution(3);
	this->setTimerFrequency(255);
}

void LinearAxis::enableTimerInterrupt()
{
	//reset our timer to 0 for reliable timing
	//then enable our interrupt!
	
	//x uses TIMER0
	if (id == 'x')
	{
		TCNT0 = 0;
		TIMSK0 |= (1<<OCIE0A);
	}
	//y uses TIMER1
	else if (id == 'y')
	{
		TCNT1 = 0;
		TIMSK1 |= (1<<OCIE1A);
	}
	//z uses TIMER2
	else if (id == 'z')
	{
		TCNT2 = 0;
		TIMSK2 |= (1<<OCIE2A);
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
	else if (id == 'y')
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
	else if (id == 'z')
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
