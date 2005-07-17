#include "motor.h"
#include "serial-inc2.c"

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

union addressableInt {
  int ival;
  byte bytes[2];
} currentPosition, seekPosition;

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

void getpos1()
{
  sendReply();
  sendDataByte(currentPosition.bytes[0]);
}

void getpos2()
{
  sendDataByte(currentPosition.bytes[1]);
  endMessage();
}

void processCommand()
{
  switch(buffer[0]) {
  case 0:
    sendReply();
    sendDataByte(0);  // These don't really mean much right now
    sendDataByte(1);
    endMessage();
    break;
  case 1:
    // Forward speed
    setSpeed(buffer[1], 0);
    break;

  case 2:
    // Reverse speed
    setSpeed(buffer[1], 1);
    break;

  case 3:
    // Set (reset) position counter
    currentPosition.bytes[0] = buffer[1];
    currentPosition.bytes[1] = buffer[2];
    break;

  case 4:
    // Get position counter
    getpos1();
    getpos2();
    break;

  case 5:
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

// "Hidden" low level commands
  case 6:
    // Set PWM period
    PWMPeriod = buffer[1];
    PR2 = PWMPeriod;
    break;

  case 7:
    // Set timer prescaler
    T2CON = BIN(00000100) | (buffer[1] & 3);
    break;
  }
}
