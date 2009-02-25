/*
 *  wprogram.h
 *
 *  Created by Lou Amadio on 9/26/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */

#define __STDC_LIMIT_MACROS 1
#include <stdint.h>
#include <stdio.h>
const int MILLICLOCK_MAX = 17;
typedef uint16_t milliclock_t;
void incrementMillis();
milliclock_t millis();
void delay(int ms);


enum WIRINGMODE
{
	INPUT,
	OUTPUT
};

void pinMode(int pin, WIRINGMODE mode);

enum WIRINGVALUE
{
	HIGH,
	LOW
} ;

void digitalWrite(int pin, WIRINGVALUE mode);

int digitalRead(int pin);


