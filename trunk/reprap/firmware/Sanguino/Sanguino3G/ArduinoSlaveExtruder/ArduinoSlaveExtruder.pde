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
#include "_misc.h"
#include "Packet.h"

//this is our firmware version
#define FIRMWARE_VERSION 0001

//this is the version of our host software
unsigned int master_version = 0;

//these are our packet classes
Packet masterPacket(0);

//are we paused?
boolean is_tool_paused = false;
boolean is_tool_aborted = false;

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
  init_tool();
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
  process_master_packets();
}

//handle the abortion of a print job
void abort_print()
{
  //yes, we're done here.
  is_tool_aborted = true;
  
  //initalize everything to the beginning
  initialize();
}
