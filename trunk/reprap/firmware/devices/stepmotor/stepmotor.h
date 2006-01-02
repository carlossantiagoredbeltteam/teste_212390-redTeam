#ifndef _stepmotor_h
#define _stepmotor_h

#include "pic14.h"

void init2();
void timerTick();
void processCommand();
void syncStrobe();

#define SYNCA       PORTA2
#define SYNCA_TRIS  TRISA2

#define MINSENSOR   PORTB0
#define MAXSENSOR   PORTB3

#endif
