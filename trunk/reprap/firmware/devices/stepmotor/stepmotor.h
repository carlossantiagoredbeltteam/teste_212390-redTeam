#ifndef _stepmotor_h
#define _stepmotor_h

#include "pic14.h"

void init2();
void timerTick();
void processCommand();
void syncStrobe();

#endif
