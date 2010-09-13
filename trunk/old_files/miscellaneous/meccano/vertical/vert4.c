#define __16f628a
#include"pic/pic16f628a.h"

/* Vertical stepper code. Drives the RepRap vertical stepper
 * down a few turns, pauses, then raises the platform up 
 * until it whacks the limit switch. 
 * NOTE: Uses stepper2 so I can recycle an old, buggered PIC.*/

typedef unsigned int word;
//__CONFIG = 0x3f72;
//word at 0x2007 __CONFIG = 0x3D18;
typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_CLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;


unsigned char count;	// Step shift for stepper 1
unsigned char count2;	// Step shift for stepper 2
unsigned char inport;
unsigned char portFinal;
unsigned char portFinal2;
unsigned int cdelay;
unsigned int goneForward;
unsigned int yStepCount=0;

unsigned char direction;
unsigned char direction2;

unsigned char yState;
unsigned char tmp;

#define YSTATE_INITIALISE		0
#define YSTATE_SYNC_BACKWARDS		1
#define YSTATE_SEEK_ENDSTOP		2
#define YSTATE_SEEK_CENTRE		3
#define YSTATE_AWAIT_BRS		4
#define YSTATE_START_GOING_ROUND	5
#define YSTATE_GOING_FORWARD		6
#define YSTATE_GOING_BACKWARD		7
#define YSTATE_GOING_ROUND		8
#define YSTATE_BRIEF_DROP		9
#define YSTATE_WAIT_FOR_NO_MAGNET	10
#define YSTATE_AWAIT_SECOND_CLEAR	11

#define DIRECTION_NONE		0
#define DIRECTION_FORWARD	1
#define DIRECTION_BACKWARD	2

#define FORWARD_ENDSTOP_SENSOR	1
#define	MANUAL_UP_SENSOR	2
#define MANUAL_DOWN_SENSOR	4
#define MAGNETIC_SENSOR		8

void main(void) {

	// Set PORTA pins to input
	CMCON=7;
	// Set the I/O Direction magick
        TRISB = 0;
        TRISA = 15;
        count = 1;
	count2 = 1;
	yStepCount=0;
	direction = DIRECTION_NONE;
	direction2 = DIRECTION_NONE;
	yState=YSTATE_INITIALISE;

        while(1) {
	
		switch (yState) {
			case YSTATE_INITIALISE:
				// First, set counters etc. so we traverse 100 steps back.
				yState=YSTATE_SYNC_BACKWARDS;
				direction2 = DIRECTION_BACKWARD;
				direction = DIRECTION_NONE;
				yStepCount=200;
				break;

			case YSTATE_SYNC_BACKWARDS:
				// Until our step count is zero, we keep going.
				if (yStepCount>0) {
					yStepCount-=1;
				} else {
					// We hit zero. Seek the endstop
					yState=YSTATE_SEEK_ENDSTOP;
					direction2 = DIRECTION_FORWARD;
				}
				break;

			case YSTATE_SEEK_ENDSTOP:
				// If we bump into it, wind back a little
				inport=PORTA;
				inport=inport&FORWARD_ENDSTOP_SENSOR;
				if (inport==FORWARD_ENDSTOP_SENSOR) {
					yState=YSTATE_SEEK_CENTRE;
					direction2 = DIRECTION_BACKWARD;
					yStepCount=240;
				}
				break;

			case YSTATE_SEEK_CENTRE:
				// When our long march is done, stop dead.
				if (yStepCount>0) {
					yStepCount--;
				} else {
					// We hit zero. Now we can draw ovals etc.
					direction2 = DIRECTION_NONE;
					yState=YSTATE_AWAIT_BRS;
				}
				break;

			case YSTATE_AWAIT_BRS:
				// And so we wait. Tum te tum.
				// Oh, all right. Look for the manual override.
				inport=PORTA;
				direction2 = DIRECTION_NONE;
				if ((inport&MANUAL_DOWN_SENSOR)==MANUAL_DOWN_SENSOR) {
					direction2=DIRECTION_BACKWARD;
				} else if ((inport&MANUAL_UP_SENSOR)==MANUAL_UP_SENSOR) {
					direction2=DIRECTION_FORWARD;
				}
				// Make sure we're not whacking the limiting  switch.
				tmp=inport & FORWARD_ENDSTOP_SENSOR;
				if (tmp==FORWARD_ENDSTOP_SENSOR) {
					if (direction2==DIRECTION_FORWARD)
						direction2=DIRECTION_NONE;
				}
				// Look for excuse to drop down.
				tmp=inport&MAGNETIC_SENSOR;
				if (tmp==MAGNETIC_SENSOR) {
					yState=YSTATE_BRIEF_DROP;
					yStepCount=26;	// Drop 0.25mm approx.
				}

				break;
			
			case YSTATE_BRIEF_DROP:
				// We drop down a few turns.
				if (yStepCount>0) {
					direction2=DIRECTION_BACKWARD;
					yStepCount--;
				} else {
					// We hit zero. Now we debounce the magnet.
					direction2 = DIRECTION_NONE;
					yState=YSTATE_WAIT_FOR_NO_MAGNET;
					yStepCount=5;
				}
				break;
				
			case YSTATE_WAIT_FOR_NO_MAGNET:
				// Wait for the magnet to go away for a bit.
				inport=PORTA;
				if ((inport&MAGNETIC_SENSOR)==MAGNETIC_SENSOR) 	{
					yStepCount=5;
				}  else {
					if (yStepCount>0) {
						yStepCount--;
					} else {
						yState=YSTATE_AWAIT_BRS;
					}
				}
				break;

		}
	
	
		// Shift back or forth, depending on direction.
		portFinal=0;
		switch (direction) {
			case DIRECTION_BACKWARD:
				portFinal = count;
				count<<=1;
				break;
			
			case DIRECTION_FORWARD:
				portFinal = count;
				count>>=1;
				break;
			
			case DIRECTION_NONE:
				portFinal=0;
				break;
		}

		switch (direction2) {
			case DIRECTION_BACKWARD:
				portFinal2 = count2;
				count2<<=1;
				break;
			
			case DIRECTION_FORWARD:
				portFinal2 = count2;
				count2>>=1;
				break;
			
			case DIRECTION_NONE:
				portFinal2=0;
				break;
		}

		// Only change the first 4 bits of steppers 1 & 2.
		if (count>8) {
			count=1;
		} else if (count==0) {
			count=8;
		}
		if (count2>8) {
			count2=1;
		} else if (count2==0) {
			count2=8;
		}

		// Put 2 stepper outputs on separate halves of port
		PORTB=portFinal+(portFinal2<<4);

		cdelay=800;
		while ((--cdelay)>0);
        }

}
