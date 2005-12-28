#include "stepmotor.h"
#include "serial.h"

// Simple stepper controller.
//
// This is for a common ground, 4 coil stepper.
//
// A total of 8 steps are achieved for finer movement by also making
// use of "half-steps".
//
// Other stepper motor types are supported by changing the
// stepCount value and the stepValue function.  Currently
// stepCount must be a power of 2.

// I/O ports:
//   B0-B1 - Unused: Output low
//   B2 - UART Receive
//   B3 - UART Transmit
//   B4-B7 - Stepper motor connections
//   A0 - Min optointerrupter (optional)
//   A1 - Max optointerrupter (optional)
//   A2 - Sync input/output (optional)

#define stepCount 8

volatile static byte coilPosition = 0;

enum functions {
  func_idle,
  func_forward,
  func_reverse,
  func_syncwait,   // Waiting for sync prior to seeking
  func_seek,
  func_findmin,    // Calibration, finding minimum
  func_findmax     // Calibration, finding maximum
};
volatile static byte function = func_idle;

volatile static byte speed = 0;

volatile static byte seekNotify = 255;

volatile static union addressableInt {
  int ival;
  byte bytes[2];
} currentPosition, seekPosition, maxPosition;

enum sync_modes {
  sync_none,     // no sync (default)
  sync_slave,    // sync slave (monitors sync line)
  sync_master,   // sync master (send sync pulse when seek starts)
  sync_inc,      // inc motor on each pulse
  sync_dec       // dec motor on each pulse
  sync_ddamaster // master for DDA sync
};
static byte sync_mode = sync_none;

void init()
{
  /// @todo Remove some of these when intialisers fixed
  speed = 0;
  function = func_idle;
  coilPosition = 0;
  sync_mode = sync_none;
  seekNotify = 255;

  currentPosition.bytes[0] = 0;
  currentPosition.bytes[1] = 0;
  seekPosition.bytes[0] = 0;
  seekPosition.bytes[1] = 0;
  maxPosition.bytes[0] = 0;
  maxPosition.bytes[1] = 0;
}

byte stepValue()
{
  switch(coilPosition) {
  case 0:
    return BIN(00010000);
  case 1:
    return BIN(00110000);
  case 2:
    return BIN(00100000);
  case 3:
    return BIN(01100000);
  case 4:
    return BIN(01000000);
  case 5:
    return BIN(11000000);
  case 6:
    return BIN(10000000);
  case 7:
    return BIN(10010000);
  }
  return 0;
}

#pragma save
#pragma nooverlay
void forward1()
{
  currentPosition.ival++;
  coilPosition = (coilPosition + 1) & (stepCount - 1);
  PORTB = stepValue();
_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _coilPosition;
_endasm;
}
#pragma restore

#pragma save
#pragma nooverlay
void reverse1()
{
  currentPosition.ival--;
  coilPosition = (coilPosition + stepCount - 1) & (stepCount - 1);
  PORTB = stepValue();
_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _coilPosition;
_endasm;
}
#pragma restore

#pragma save
#pragma nooverlay
void setTimer(byte newspeed)
{
  speed = newspeed;
  if (speed) {
    TMR1H = speed;
    TMR1L = 0;
    TMR1ON = 1;
  } else {
    TMR1ON = 0;
  }
_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _coilPosition;
_endasm;
}
#pragma restore

#pragma save
#pragma nooverlay
void timerTick()
{
  switch(function) {
  case func_idle:
    TMR1ON = 0;
    break;
  case func_forward:
    forward1();
    break;
  case func_reverse:
    reverse1();
    break;
  case func_seek:
    if (currentPosition.ival < seekPosition.ival) {
      forward1();
    } else if (currentPosition.ival > seekPosition.ival) {
      reverse1();
    } else {
      // Reached, switch to 0 speed
      speed = 0;
      // Uncomment next line to remove torque on arrival
      //PORTB = 0;
      if (seekNotify != 255) {
	sendMessage(seekNotify);
	sendDataByte(7);
	sendDataByte(currentPosition.bytes[0]);
	sendDataByte(currentPosition.bytes[1]);
	endMessage();
      }
    }
    break;
  case func_findmin:
    if (!PORTA0) {
      currentPosition.bytes[0] = 0;
      currentPosition.bytes[1] = 0;
      function = func_findmax;
    } else {
      reverse1();
    }
    break;
  case func_findmax:
    if (!PORTA1) {
      maxPosition.bytes[0] = currentPosition.bytes[0];
      maxPosition.bytes[1] = currentPosition.bytes[1];
      function = func_idle;
      if (seekNotify != 255) {
	sendMessage(seekNotify);
	sendDataByte(9);
	sendDataByte(currentPosition.bytes[0]);
	sendDataByte(currentPosition.bytes[1]);
	endMessage();
      }
    } else {
      forward1();
    }
    break;
  }
  setTimer(speed);
_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _coilPosition;
_endasm;
}
#pragma restore

void processCommand()
{
  switch(buffer[0]) {
  case 0:
    sendReply();
    sendDataByte(0);  // Response type 0
    sendDataByte(0);  // Minor
    sendDataByte(2);  // Major
    endMessage();
    break;

  case 1:
    // Forward speed
    function = func_forward;
    setTimer(buffer[1]);
    break;

  case 2:
    // Reverse speed
    function = func_reverse;
    setTimer(buffer[1]);    
    break;

  case 3:
    // Set (reset) position counter
    currentPosition.bytes[0] = buffer[1];
    currentPosition.bytes[1] = buffer[2];
    break;

  case 4:
    // Get position counter
    sendReply();
    sendDataByte(4);
    sendDataByte(currentPosition.bytes[0]);
    sendDataByte(currentPosition.bytes[1]);
    endMessage();
    break;

  case 5:
    // Goto position
    seekPosition.bytes[0] = buffer[2];
    seekPosition.bytes[1] = buffer[3];

    function = func_seek;
    setTimer(buffer[1]);
    break;

  case 6:
    // Free motor (release torque)
    PORTB = 0;
    function = func_idle;
    break;

  case 7:
    // Set seek completion (and calibration) notification
    seekNotify = buffer[1];
    break;

  case 8:
    // Set sync mode
    sync_mode = buffer[1];
    break;

  case 9:
    // Request calibration (search at given speed)
    function = func_findmin;
    setTimer(buffer[1]);
    break;

  case 10:
    // Request range
    sendReply();
    sendDataByte(10);
    sendDataByte(maxPosition.bytes[0]);
    sendDataByte(maxPosition.bytes[1]);
    endMessage();
    break;

  }
_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _coilPosition;
_endasm;
}
