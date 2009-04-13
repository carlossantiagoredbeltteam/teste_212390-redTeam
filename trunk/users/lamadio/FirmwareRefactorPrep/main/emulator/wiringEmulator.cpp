/*
 *  wiringEmulator.cpp
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 9/26/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include "WProgram.h"
#include "Collections.h"
#include "EventLoop.h"

milliclock_t g_milli = 0;
void incrementMillis()
{
    g_milli++;
    if (g_milli >= MILLICLOCK_MAX)
        g_milli = 0;
}

uint16_t  millis()
{
    return g_milli;
}

SerialAgent Serial;

// nothing fancy for now.
int g_input = 0;

bool SerialAgent::available()
{
	return true;
}

uint8_t SerialAgent::read()
{
	char ch;
	if (g_input == 0)
	{
		g_input = open("test.gcode", O_RDONLY);
	}
	
	if (g_input)
	{
		::read(g_input, &ch, 1);
	}
	return ch;
}

void SerialAgent::write(uint8_t)
{
	
}

void SerialAgent::print(char)
{
	
}

void SerialAgent::print(const char[])
{
	
}

void SerialAgent::print(uint8_t)
{
	
}

void SerialAgent::print(int)
{
	
}

void SerialAgent::print(unsigned int)
{
	
	
}

void SerialAgent::print(long)
{
	
}

void SerialAgent::print(unsigned long)
{
	
}

void SerialAgent::print(long, int)
{
	
}

void SerialAgent::print(double)
{
	
}

void SerialAgent::println(void)
{
	
}

void SerialAgent::println(char)
{
	
}

void SerialAgent::println(const char[])
{
	
}

void SerialAgent::println(uint8_t)
{
	
}

void SerialAgent::println(int)
{
	
}

void SerialAgent::println(unsigned int)
{
	
	
}

void SerialAgent::println(long)
{
	
}

void SerialAgent::println(unsigned long)
{
	
}

void SerialAgent::println(long, int)
{
	
}

void SerialAgent::println(double)
{
	
}


void pinMode(int pin, int i)
{
	
}

void analogWrite(int pin, uint16_t val)
{
	
}

uint32_t analogRead(int pin)
{
	return 124;
}

int digitalRead(int pin)
{
	return 0;
 }

void digitalWrite(int pin, int value)
{
	
}

void delayMicroseconds(int num)
{
	
}

void delay(int s)
{
	
}

