/*
 *
 * RepRap, The Replicating Rapid Prototyper Project
 *
 * http://reprap.org/
 *
 * RepRap is copyright (C) 2005-6 University of Bath, the RepRap
 * researchers (see the project's People webpage), and other contributors.
 *
 * RepRap is free; you can redistribute it and/or modify it under the
 * terms of the GNU Library General Public Licence as published by the
 * Free Software Foundation; either version 2 of the Licence, or (at your
 * option) any later version.
 *
 * RepRap is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
 * Licence for more details.
 *
 * For this purpose the words "software" and "library" in the GNU Library
 * General Public Licence are taken to mean any and all computer programs
 * computer files data results documents and other copyright information
 * available from the RepRap project.
 *
 * You should have received a copy of the GNU Library General Public
 * Licence along with RepRap (in reports, it will be one of the
 * appendices, for example); if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA, or see
 *
 * http://www.gnu.org/
 *
 */

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

#define stepCount 8

volatile static byte coilPosition = 0;

// Non-zero indicates seeking is in progress (and its speed)
enum functions {
  func_idle,
  func_forward,
  func_reverse,
  func_seek
};
volatile static byte function = func_idle;

volatile static byte speed = 0;

volatile static union addressableInt {
  int ival;
  byte bytes[2];
} currentPosition, seekPosition;

void init()
{
  /// @todo Remove some of these when intialisers fixed
  speed = 0;
  function = func_idle;
  coilPosition = 0;

  currentPosition.bytes[0] = 0;
  currentPosition.bytes[1] = 0;
  seekPosition.bytes[0] = 0;
  seekPosition.bytes[1] = 0;
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
    sendDataByte(1);  // Major
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
  }
_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _coilPosition;
_endasm;
}
