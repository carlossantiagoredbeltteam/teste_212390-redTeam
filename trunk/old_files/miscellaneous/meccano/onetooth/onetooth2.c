#define __16f628a
#include"pic/pic16f628a.h"

/* Code to produce a wheel with one tooth. Why? 'Cos we'll
 * beat everyone to a non-circular object. */

typedef unsigned int word;
//__CONFIG = 0x3f72;
//word at 0x2007 __CONFIG = 0x3D18;
typedef unsigned int config;

config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_NOCLKOUT &    // <--- this is the important one
 _MCLRE_OFF &
 _LVP_OFF;

unsigned char count;	// Step shift for stepper 1
unsigned char count2;	// Step shift for stepper 2
unsigned char inport;
unsigned char portFinal;
unsigned char tempa;	// For fixing unwanted ADD to PORTA
unsigned char tempb;	// For fixing broken (>>2)
unsigned char portFinal2;
unsigned int cdelay;
unsigned int goneForward;
unsigned int xStepCount=0;

unsigned char direction;
unsigned char direction2;

unsigned char xState;

#define XSTATE_INITIALISE		0
#define XSTATE_SYNC_BACKWARDS		1
#define XSTATE_SEEK_ENDSTOP		2
#define XSTATE_SEEK_CENTRE		3
#define XSTATE_AWAIT_BRS		4
#define XSTATE_START_GOING_ROUND	5
#define XSTATE_GOING_FORWARD		6
#define XSTATE_GOING_BACKWARD		7
#define XSTATE_GOING_ROUND		8
#define XSTATE_ROTATE_TOOTH		9

#define DIRECTION_NONE		0
#define DIRECTION_FORWARD	1
#define DIRECTION_BACKWARD	2

#define FORWARD_ENDSTOP_SENSOR	16	// A2
#define	MAGNETIC_SENSOR		8	// A3
#define BRS_SENSOR		4	// A4

void main(void) {

	// Set PORTA pins to input
	CMCON=7;
	// Set the I/O Direction magick
        TRISB = 0;
        TRISA = BRS_SENSOR+MAGNETIC_SENSOR+FORWARD_ENDSTOP_SENSOR;
        count = 1;
	count2 = 1;
	xStepCount=0;
	direction = DIRECTION_NONE;
	direction2 = DIRECTION_NONE;
	xState=XSTATE_INITIALISE;

        while(1) {
	
		switch (xState) {
			case XSTATE_INITIALISE:
				// First, set counters etc. so we traverse 100 steps back.
				xState=XSTATE_SYNC_BACKWARDS;
				direction = DIRECTION_BACKWARD;
				direction2 = DIRECTION_NONE;
				xStepCount=100;
				break;

			case XSTATE_SYNC_BACKWARDS:
				// Until our step count is zero, we keep going.
				if (xStepCount>0) {
					xStepCount-=1;
				} else {
					// We hit zero. Seek the endstop
					xState=XSTATE_SEEK_ENDSTOP;
					direction = DIRECTION_FORWARD;
				}
				break;

			case XSTATE_SEEK_ENDSTOP:
				// If we bump into it, start our long march back.
				inport=PORTA;
				inport=inport&FORWARD_ENDSTOP_SENSOR;
				if (inport==FORWARD_ENDSTOP_SENSOR) {
					xState=XSTATE_SEEK_CENTRE;
					direction = DIRECTION_BACKWARD;
					xStepCount=3000;
				}
				break;

			case XSTATE_SEEK_CENTRE:
				// When our long march is done, start going around.
				if (xStepCount>0) {
					xStepCount--;
				} else {
					// We hit zero. Now we can draw ovals etc.
					direction = DIRECTION_NONE;
					xState=XSTATE_AWAIT_BRS;
				}
				break;

			case XSTATE_AWAIT_BRS:
				// Hang fire until the user hits the big, red switch (BRS)
				inport=PORTA;
				inport=inport&BRS_SENSOR;
				if (inport==BRS_SENSOR) {
					xState=XSTATE_START_GOING_ROUND;
				}
				break;

			case XSTATE_START_GOING_ROUND:
				direction = DIRECTION_NONE;
				direction2 = DIRECTION_FORWARD;
				xState=XSTATE_GOING_ROUND;
				// Drop in to state below...
	
			case XSTATE_GOING_ROUND:
				/* See if someone is waving a magnet. */
				inport=PORTA;
				inport&=MAGNETIC_SENSOR;
				if (inport!=0) {
					direction=DIRECTION_FORWARD;
					goneForward=0;
					// Stop the turntable.
					direction2=DIRECTION_NONE;
					xState=XSTATE_GOING_FORWARD;
				}
				break;

			case XSTATE_GOING_FORWARD:
				goneForward+=1;
				/* One revolution of the turntable is 20x57 steps = 1140
				 * So 1/4 that is 285. Coming back 285 gives an ovoid
				 * bulge over 1/2 a revolution. */
				if (goneForward > 130) {
					direction=DIRECTION_NONE;
					direction2=DIRECTION_FORWARD;
					xState=XSTATE_ROTATE_TOOTH;
					xStepCount=130;
				}
				break;

			case XSTATE_ROTATE_TOOTH:
				/* Revolve a little. */
				xStepCount--;
				if (xStepCount == 0) {
					direction=DIRECTION_BACKWARD;
					direction2=DIRECTION_NONE;
					xState=XSTATE_GOING_BACKWARD;
				}
				break;

			case XSTATE_GOING_BACKWARD:
				// Backtrack to complete tooth.
				goneForward-=1;
				if (goneForward == 0) {
					// Start the turntable again.
					direction2=DIRECTION_NONE;
					xState=XSTATE_START_GOING_ROUND;
					break;
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

		// At the moment, we can only move forwards with stepper 2
		if (direction2==DIRECTION_NONE) {
			portFinal2=0;
		} else {
			count2<<=1;
			// Only change the first 4 bits of steppers 1 & 2.
			if (count2>8) {
				count2=1;
			}
			portFinal2=count2;
		}

		// Only change the first 4 bits of steppers 1 & 2.
		if (count>8) {
			count=1;
		} else if (count==0) {
			count=8;
		}

		/* Put 2 stepper outputs on separate ports.
		 * Drive in this order: A6,A7,A0,A1
		 * tempa is for hiding a compiler bug. PORTA is read only!
		 */
		tempa=portFinal&3;	// These two go to A6 & A7
		tempa=tempa<<6;
		// Mask off the lower 2 bits and add them into the mix.
		tempb=(portFinal>>2);
		tempa=tempa|tempb;//((portFinal>>2)&3);
		PORTA=tempa;
		PORTB=(portFinal2<<4);

		// Fast, or slow?
		//cdelay=4000;
		cdelay=650;	// 500 is maximum speed, I think.
		while ((--cdelay)>0);
        }

}
