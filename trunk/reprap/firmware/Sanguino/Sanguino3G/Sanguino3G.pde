/*********************************************************************************************************
 *  Sanguino 3rd Generation Firmware
 *
 *  Specification for this protocol is located at: http://docs.google.com/Doc?id=dd5prwmp_14ggw37mfp
 *  
 *  License: GPLv2
 *  Authors: Marius Kintel, Adam Mayer, and Zach Hoeken
 *
 *  Version History:
 *
 *  0.1: Initial structure and basic layout of the firmware
 *
 *********************************************************************************************************/

#define VERSION_MAJOR 0
#define VERSION_MINOR 1

//we store all queueable commands in one big giant buffer.
#define COMMAND_BUFFER_SIZE 2048
#include "CircularBuffer.h"

// Explicitly allocate memory at compile time for buffer.
byte underlyingBuffer[COMMAND_BUFFER_SIZE];
CircularBuffer commandBuffer(COMMAND_BUFFER_SIZE, underlyingBuffer);

//set up our firmware for actual usage.
void setup()
{
  //setup our firmware to a default state.
  initialize();

  //this is a simple text string that identifies us.
  Serial.print("S3G v");
  Serial.print(VERSION_MAJOR);
  Serial.print(',');
  Serial.println(VERSION_MINOR);
}

//this function takes us back to our default state.
void initialize()
{
  init_serial();
  init_commands();
  init_steppers();
  init_tools();
}

//start our hardware serial drivers
void init_serial()
{
   Serial.begin(38400);
   Serial1.begin(115200);
}


//handle various things we're required to do.
void loop()
{
  process_packets();
  handle_commands();
}
