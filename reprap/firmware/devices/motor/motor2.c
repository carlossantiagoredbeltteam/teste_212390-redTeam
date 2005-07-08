#include "motor.h"
#include "serial-inc2.c"

byte PWMPeriod = 255;
static byte currentSpeed = 0;
static byte currentDirection = 0;

// Non-zero indicates seeking is in progress (and its speed)
static byte seekSpeed = 0;


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

byte toggle = 0;

void setSpeed(byte speed, byte direction)
{
  // Note: this function may be called from an interrupt
  // so it could re-enter itself
  // @todo Deal with re-entrancy
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
    
  currentSpeed = speed;
  currentDirection = direction;
}

void motorTick()
{
  // Clear interrupt flag
  _asm
    movf PORTB,w
  _endasm;
  RBIF = 0;

  if (toggle) {
    toggle = 0;
    _asm
      banksel PORTB
      bsf PORTB, 6
      banksel _currentSpeed
    _endasm;
  } else {
    toggle = 1;
    _asm
      banksel PORTB
      bcf PORTB, 6
      banksel _currentSpeed
    _endasm;
  }

  // Adjust counter appropriately
  if (currentSpeed != 0) {
    if (currentDirection)
      currentPosition.ival--;
    else
      currentPosition.ival++;
  }

  if (seekSpeed != 0) {
    if (currentPosition.ival == seekPosition.ival) {
      seekSpeed = 0;
      setSpeed(0, 0);
    }
  }

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
