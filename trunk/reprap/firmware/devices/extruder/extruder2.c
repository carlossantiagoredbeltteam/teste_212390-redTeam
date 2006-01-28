#include "extruder.h"
#include "serial.h"

byte PWMPeriod = 255;
static byte currentDirection = 0;

// Non-zero indicates seeking is in progress (and its speed)
static byte seekSpeed = 0;

static byte lastPortB = 0;

// Note: when reversing motor direction, the speed should be set to 0
// and then delayed long enough for the motor to come to rest.
// Failing to do this could result in miscalculated motor position
// because the code bases the calculation on expected direction, not
// actual direction (and the motor may take a little while to actually
// reverse direction).

typedef union {
  int ival;
  byte bytes[2];
} addressableInt;

addressableInt currentPosition, seekPosition;

#define CMD_VERSION   0
#define CMD_FORWARD   1
#define CMD_REVERSE   2
#define CMD_SETPOS    3
#define CMD_GETPOS    4
#define CMD_SEEK      5
#define CMD_FREE      6
#define CMD_NOTIFY    7
#define CMD_ISEMPTY   8
#define CMD_PWMPERIOD 50
#define CMD_PRESCALER 51


void init2()
{
  PWMPeriod = 255;
  currentDirection = 0;
  seekSpeed = 0;
  lastPortB = 0;
  currentPosition.bytes[0] = 0;
  currentPosition.bytes[1] = 0;
  seekPosition.bytes[0] = 0;
  seekPosition.bytes[1] = 0;
}

void setSpeed(byte speed, byte direction)
{
  if (speed == 0) {
    PORTB = 0;
  } else {
    if (direction == 0)
      PORTB = BIN(00010000);  // Set forward output enable
    else
      PORTB = BIN(00100000);  // Set reverse output enable
  }
  CCPR1L = speed;
  if (speed == 255)
    PR2 = 0;
  else
    PR2 = PWMPeriod;
    
  currentDirection = direction;
}

void motorTick()
{
  char changes, current;

  // Clear interrupt flag
  RBIF = 0;

  current = PORTB;  // Store so it doesn't change half way through processing
  PORTB = current;  // properly reset change ??
  changes = lastPortB ^ current;

  if (changes & 0x80) {
    // Our opto-marker changed
    if (current & 0x80) {
      // If input is set, we hit the opto-marker.  If it's not set
      // it's come off the marker, and we only want to deal with one
      // of them or we'll double increment everything
      
      // Adjust counter appropriately based on last known direction
      if (currentDirection)
	currentPosition.ival--;
      else
	currentPosition.ival++;
      
      if (seekSpeed != 0 && currentPosition.ival == seekPosition.ival) {
	seekSpeed = 0;
	PORTB = 0;
	CCPR1L = 0;
      }
    }
  }

  lastPortB = current;

}

void processCommand()
{
  switch(buffer[0]) {
  case CMD_VERSION:
    sendReply();
    sendDataByte(0);  // These don't really mean much right now
    sendDataByte(1);
    endMessage();
    break;

  case CMD_FORWARD:
    // Forward speed
    setSpeed(buffer[1], 0);
    break;

  case CMD_REVERSE:
    // Reverse speed
    setSpeed(buffer[1], 1);
    break;

  case CMD_SETPOS:
    // Set (reset) position counter
    currentPosition.bytes[0] = buffer[1];
    currentPosition.bytes[1] = buffer[2];
    break;

  case CMD_GETPOS:
    // Get position counter
    sendReply();
    sendDataByte(currentPosition.bytes[0]);
    sendDataByte(currentPosition.bytes[1]);
    endMessage();
    break;

  case CMD_SEEK:
    // Goto position
    seekPosition.bytes[0] = buffer[2];
    seekPosition.bytes[1] = buffer[3];

    if (seekPosition.ival != currentPosition.ival) {
      seekSpeed = buffer[1];
      if (currentPosition.ival > seekPosition.ival)
	setSpeed(seekSpeed, 1);
      else
	setSpeed(seekSpeed, 0);
    }

    break;

  case CMD_FREE:
    // Free motor.  There is no torque hold for a DC motor,
    // so all we do is switch off
    setSpeed(0, 0);
    break;

  case CMD_NOTIFY:
    // To be implemented
    break;

// "Hidden" low level commands
  case CMD_PWMPERIOD:
    // Set PWM period
    PWMPeriod = buffer[1];
    PR2 = PWMPeriod;
    break;

  case CMD_PRESCALER:
    // Set timer prescaler
    T2CON = BIN(00000100) | (buffer[1] & 3);
    break;
  }
}

// To work around sdcc issue
void dummy()
{
  INTCON = 0;
}
