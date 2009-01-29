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

//include some basic libraries.
#include <stdint.h>
#include "_misc.h"
#include "CircularBuffer.h"
#include "MasterPacketProcessor.h"

//this is our firmware version
#define FIRMWARE_VERSION 0001

//this is the version of our host software
unsigned int host_version = 0;

//we store all queueable commands in one big giant buffer.
// Explicitly allocate memory at compile time for buffer.
#define COMMAND_BUFFER_SIZE 2048
byte underlyingBuffer[COMMAND_BUFFER_SIZE];
CircularBuffer commandBuffer(COMMAND_BUFFER_SIZE, underlyingBuffer);

//are we paused?
boolean is_machine_paused = false;
boolean is_machine_aborted = false;

//init our variables
volatile long max_delta;

volatile long x_counter;
volatile bool x_can_step;
volatile bool x_direction;

volatile long y_counter;
volatile bool y_can_step;
volatile bool y_direction;

volatile long z_counter;
volatile bool z_can_step;
volatile bool z_direction;

//our position tracking variables
volatile LongPoint current_steps;
volatile LongPoint target_steps;
volatile LongPoint delta_steps;
volatile LongPoint range_steps;

//our point queue variables
#define POINT_QUEUE_SIZE 32
#define POINT_SIZE 9
byte rawPointBuffer[POINT_QUEUE_SIZE * POINT_SIZE];
CircularBuffer pointBuffer(POINT_QUEUE_SIZE * POINT_SIZE, rawPointBuffer);

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
  is_machine_paused = false;
  
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
  //if we've aborted, dont do anything.
  if (!is_machine_aborted)
  {
    //check for and handle any packets that come in.
    process_packets();
 
    //only handle our buffer if we're unpaused. 
    if (!is_machine_paused && !is_machine_aborted)
	  handle_commands();
  }
}

//handle the abortion of a print job
void abort_print()
{
  //yes, we're done here.
  is_machine_aborted = true;
  
  //TODO: turn off all of our tools.

  //turn off steppers too.
  disableTimer1Interrupt();
  disable_steppers();

  //initalize everything to the beginning
  initialize();
}
