#ifndef _extruder_h
#define _extruder_h

#include "pic14.h"

void init2();
void processCommand();
void motorTick();
void timerTick();
void checkTemperature();

extern byte PWMPeriod;

#endif
