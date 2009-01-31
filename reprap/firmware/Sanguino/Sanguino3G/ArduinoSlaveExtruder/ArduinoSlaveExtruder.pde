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

#include <Servo.h>

int current_temperature;
int target_temperature;

// motor control states.
typedef enum {
  MC_PWM = 0,
  MC_ENCODER
} 
MotorControlStyle;

typedef enum {
	MC_FORWARD = 0,
	MC_REVERSE = 1
}
MotorControlDirection;

MotorControlStyle motor1_control = MC_PWM;
MotorControlDirection motor1_dir = MC_FORWARD;
byte motor1_pwm = 0;
long motor1_target_rpm = 0;
long motor1_current_rpm = 0;

MotorControlStyle motor2_control = MC_PWM;
MotorControlDirection motor2_dir = MC_FORWARD;
byte motor2_pwm = 0;
long motor2_target_rpm = 0;
long motor2_current_rpm = 0;

Servo servo1;
Servo servo2;

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
