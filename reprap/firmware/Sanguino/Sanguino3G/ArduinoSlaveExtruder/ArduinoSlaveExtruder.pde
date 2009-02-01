/*********************************************************************************************************
 *  RepRap 3rd Generation Firmware (R3G)
 *
 *  Slave Extruder Firmware for Extruder Controller v2.x
 *
 *  Board documentation at: http://make.rrrf.org/ec-2.0
 *  Specification for this protocol is located at: http://docs.google.com/Doc?id=dd5prwmp_14ggw37mfp
 *  
 *  License: GPLv2
 *  Authors: Marius Kintel, Adam Mayer, and Zach Hoeken
 *
 *  Version History:
 *
 *  0001: Initial release of the protocol and firmware.
 *
 *********************************************************************************************************/

//include some basic libraries.
#include <WProgram.h>
#include <Servo.h>

#include "Configuration.h"
#include "Datatypes.h"
#include "Packet.h"
#include "Variables.h"
#include "ThermistorTable.h"

//this is our firmware version
#define FIRMWARE_VERSION 0001

//set up our firmware for actual usage.
void setup()
{
  //setup our firmware to a default state.
  initialize();

  //this is a simple text string that identifies us.
  Serial.print("R3G Slave v");
  Serial.print(FIRMWARE_VERSION);
}

//this function takes us back to our default state.
void initialize()
{
  is_tool_paused = false;
  
  init_serial();
  init_extruder();
}

//start our hardware serial drivers
void init_serial()
{
   Serial.begin(115200);
}

//handle various things we're required to do.
void loop()
{
  //check for and handle any packets that come in.
  process_packets();

  //manage our extruder stuff.
  manage_temperature();
}

//handle the abortion of a print job
void abort_print()
{
  //TODO: shut down all things

  //initalize everything to the beginning
  initialize();
}

void delayMicrosecondsInterruptible(unsigned int us)
{
	// for a one-microsecond delay, simply return.  the overhead
	// of the function call yields a delay of approximately 1 1/8 us.
	if (--us == 0)
		return;

	// the following loop takes a quarter of a microsecond (4 cycles)
	// per iteration, so execute it four times for each microsecond of
	// delay requested.
	us <<= 2;

	// account for the time taken in the preceeding commands.
	us -= 2;

	// busy wait
	__asm__ __volatile__ (
		"1: sbiw %0,1" "\n\t" // 2 cycles
		"brne 1b" : "=w" (us) : "0" (us) // 2 cycles
	);
}