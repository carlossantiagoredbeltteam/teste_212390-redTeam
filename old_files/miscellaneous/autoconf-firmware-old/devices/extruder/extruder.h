#ifndef _extruder_h
#define _extruder_h

#include "pic14.h"

void init2();
void processCommand();
void motorTick();
void timerTick();
void checkTemperature();

extern byte PWMPeriod;

// RA1 is A/D converter input
// RA3 is cooler output
// RA4 is LED output
// RA6,7 are used for A/D converter
//#define PORTATRIS BIN(00101001)
#define PORTATRIS BIN(00100001)

#endif
