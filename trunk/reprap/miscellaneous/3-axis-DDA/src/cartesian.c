/*

  RepRap
  ------

  The Replicating Rapid Prototyper Project


  Copyright (C) 2005
  Adrian Bowyer & The RepRap Researchers

  http://reprap.org

  Principal author:

     Adrian Bowyer
     Department of Mechanical Engineering
     Faculty of Engineering and Design
     University of Bath
     Bath BA2 7AY
     U.K.

     e-mail: A.Bowyer@bath.ac.uk

  RepRap is free; you can redistribute it and/or
  modify it under the terms of the GNU Library General Public
  Licence as published by the Free Software Foundation; either
  version 2 of the Licence, or (at your option) any later version.

  RepRap is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Library General Public Licence for more details.

  For this purpose the words "software" and "library" in the GNU Library
  General Public Licence are taken to mean any and all computer programs
  computer files data results documents and other copyright information
  available from the RepRap project.

  You should have received a copy of the GNU Library General Public
  Licence along with RepRap; if not, write to the Free
  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA,
  or see

      http://www.gnu.org/

==================================================================================

This is the C program for the PIC that controls the cartesian X, Y, Z movement.

It uses a DDA to drive three steppers together to make a line in space in exactly the
same way that Bressenham's algorithm draws a straight line in pixels on a graphics
screen, except that it works in 3D rather than 2.

The line is swapped about so it is always in the first octant (x > 0, y > 0, z > 0) and so
that the X movement is bigger than the Y and the Z.  This is recorded in the bits in
negswap, which is then used to unravel this and to plot the line in the right place in space.

Version 1.  16 December 2005

*/

#include "cartesian.h"

// PIC configuration bits

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
  _WDT_OFF &
  _BODEN_OFF &
  _PWRTE_ON &
  _INTRC_OSC_NOCLKOUT &
  _MCLRE_OFF &
  _LVP_OFF;

// Global variables

byte temp_byte;    // General temporary storage for byte swaps etc
int temp_int;      // Ditto for integers
byte echo;         // True - echo input; false - don't
int flash_d;       // Number of times round the control loop to flash the LED
byte fl;           // LED flash state
int delay;         // Number of times round the control loop for one motor step
int del;           // Count for the above
byte byte_to_send; // Byte to send is need be  

byte x_idle;       // Count for how long since X last changed...
byte y_idle;       // ...and Y...
byte z_idle;       // ...and Z
byte idle;         // How long a motor remains unused before it's powered off
byte x_bits;       // 0 - 3; the point in the X stepper phase
byte y_bits;       // ...and the Y...
byte z_bits;       // ...and the Z.
byte portA_byte;   // The bit pattern to write to PORT A for the steppers

// Bressenham DDA

byte motor_step_x; // True - step X motor one step; false - don't..
byte motor_step_y; // ...and the Y...
byte motor_step_z; // ...and the Z.
int old_x;         // The X coordinate of the point in space we're moving from...
int old_y;         // ...and the Y...
int old_z;         // ...and the Z.
int new_x;         // The X coordinate of the point in space we're moving to...
int new_y;         // ...and the Y...
int new_z;         // ...and the Z.
byte negswap;      // Flag bits for +/- swaps and X/Y and X/Z swaps
byte line_done;    // True - line movement complete; false - line being traversed
int ixkj;          // new_x - old_x (but see swapping)
int iykj;          // ...and the Y...
int izkj;          // ...and the Z.
int ix;            // Count of points along the line
int is1;           // DDA step Y for how many Xs
int is2;           // DDA step Z for how many Xs

// Prototypes needed by menu function

void setEndOfLine();
void power(byte on);

// ************************************************************************

// COMMUNICATIONS


// Send a byte out of the PIC's USART.

void sendByte(byte c)
{
  while(!TRMT); 
  TXREG = c;
}

// Send a string
// This provokes some compiler bug that I
// Can't be bothered to find...

void sendString(char* s)
{
  byte b;
  b = 0;
  while(s[b]) sendByte(s[b++]);
}


// If a byte is available from the USART 
// return and echo it, otherwise return 0.  
// NB - this means it can't get a 0 as input; 
// a serious limitation that ought to be corrected...

byte rcvByte()
{
  byte b;
  if(!RCIF) return 0;
  b = RCREG;
  if(echo)
    sendByte(b);   
  return b;
}


// Wait for a byte from the USART

byte waitByte()
{
  byte b;
  while(!(b = rcvByte()));
  return b;
}


// Send a 1-byte number in hex.

void sendNumber(byte n)
{
  byte b;
  b = n >> 4;
  if(b >= 10)
    sendByte(b + ('a' - 10));
  else
    sendByte(b + '0');
  b = n & 0x0f;
  if(b >= 10)
    sendByte(b + ('a' - 10));
  else
    sendByte(b + '0');
}

// Send an integer in hex

void sendInteger()
{
  byte b;
  b = (temp_int >> 8) & 0xff;
  sendNumber(b);
  b = temp_int & 0xff;
  sendNumber(b);
}

// Get a number in hex

byte waitNumber()
{
  byte b, n;
  b = waitByte();
  if(b > '9')
    b = b - 'a' + 10;
  else
    b = b - '0';
  n = waitByte();
  if(n > '9')
    n = n - 'a' + 10;
  else
    n = n - '0';
  n = n | (b << 4);
  return n;
}

// Get an integer in hex

void waitInteger()
{
  byte b;
  b = waitNumber();
  temp_int = (b << 8);
  b = waitNumber();
  temp_int = temp_int | b;
}

// Send a new line.

void crlf()
{  
  if(!echo)
    return;
  sendByte('\r');
  sendByte('\n');
}

// Send a "> " prompt.

void prompt()
{
  if(!echo)
    return;
  crlf();
  sendByte('>');
  sendByte(' ');
}

// Deal with user input (single letter command in b)

void menu(byte b)
{
  byte v;

  switch(b)
    {
      // Turn echo off/on

    case 'e':
      echo = 0;
      break;

    case 'E':
      echo = 1;
      break;

      // Set the target position coordinates

    case 'X':
      waitInteger();
      new_x = temp_int;
      break;

    case 'Y':
      waitInteger();
      new_y = temp_int;
      break;

    case 'Z':
      waitInteger();
      new_z = temp_int;
      break;

      // Execute the line

    case 'L':
      setEndOfLine();
      break;

      // Set the delay between steps

    case 'D':
      waitInteger();
      delay = temp_int;
      del = delay;
      break;

      // Return the last-achieved position

    case 'p':
      temp_int = old_x;
      sendInteger();
      temp_int = old_y;
      sendInteger();
      temp_int = old_z;
      sendInteger();
      break;
 
      // Return the current delay

    case 'd':
      temp_int = delay;
      sendInteger();
      break;

      // Set the current position to be the target position without moving.
      // Useful for re-zeroing, restoring positions etc.

    case 'N':
      old_x = new_x;
      old_y = new_y;
      old_z = new_z;
      break;

      // Set and return the idle time till stepper turn-off

    case 'i':
      sendNumber(idle);
      break;

    case 'I':
      idle = waitNumber();
      break;

      // Is the line being plotted?

    case 'v':
      v = line_done;
      sendNumber(v);
      break;

      // Power the motors up and down

    case '1':
      power(1);
      break;

    case '0':
      power(0);
      break;

      // Uh?

    default:
      sendByte('?');
    }
  prompt();
}

// ******************************************************************************

// Turn the stepper field coils on or off

void xPower(byte on)
{
  if(on)
    PORTB7 = 0;
  else
    PORTB7 = 1;
}

void yPower(byte on)
{
  if(on)
    PORTB6 = 0;
  else
    PORTB6 = 1;
}

void zPower(byte on)
{
  if(on)
    PORTB5 = 0;
  else
    PORTB5 = 1;
}

// All at once

void power(byte on)
{
  xPower(on);
  yPower(on);
  zPower(on);
}


// See if any motors have been idle for a while, and if so turn their coils off

void motorsIdle()
{
  x_idle--;
  if(x_idle <= 0)
    {
      xPower(0);
      x_idle = 1;
    }

  y_idle--;
  if(y_idle <= 0)
    {
      yPower(0);
      y_idle = 1;
    }

  z_idle--;
  if(z_idle <= 0)
    {
      zPower(0);
      z_idle = 1;
    }
}



// Move the X axis to the step number in x_bits

void stepRealX()
{
  byte a;

  // Fire up the motor in case it's idle

  xPower(1);

  // Keep x_bits modulo 4

  x_bits = x_bits & 3;

  // Sequence is 0, 1, 3, 2 (one bit changes per step).

  if(x_bits & BIN(00000010))
    a = x_bits ^ 1;
  else
    a = x_bits;

  // Bits 0 and 1 are the X stepper

  portA_byte = portA_byte & BIN(11111100);

  // Do the step

  portA_byte = portA_byte | a;
  PORTA = portA_byte;

  // X motor has just been used, so reset its idle count

  x_idle = idle;
}


// Move the Y axis to the step number in y_bits (see comments in stepRealX())

void stepRealY()
{
  byte a;
  yPower(1);

  y_bits = y_bits & 3;

  if(y_bits & BIN(00000010))
    a = y_bits ^ 1;
  else
    a = y_bits;

  portA_byte = portA_byte & BIN(11110011);
  portA_byte = portA_byte | (a << 2);
  PORTA = portA_byte;
  y_idle = idle;
}


// Move the Z axis to the step number in z_bits (see comments in stepRealX())

void stepRealZ()
{
  byte a;
  zPower(1);

  z_bits = z_bits & 3;

  if(z_bits & BIN(00000010))
    a = z_bits ^ 1;
  else
    a = z_bits;

  portA_byte = portA_byte & BIN(00111111);
  portA_byte = portA_byte | (a << 6);
  PORTA = portA_byte;
  z_idle = idle;
}


// Record new position at the end of the line and flag it as complete

void lineFinished()
{
      old_x = new_x;
      old_y = new_y;
      old_z = new_z;
      line_done = 1;
      byte_to_send = 'f';
}


// Set up a new line from where we are to new_ x, y, and z.

void setEndOfLine()
{
  // How far to go?

  ixkj = new_x - old_x;
  iykj = new_y - old_y;
  izkj = new_z - old_z;

  // Record the octant we're in, and swap/negate to get us in the first

  negswap = 0;
  if(ixkj < 0)
    {
      negswap = negswap | NEGX;
      ixkj = -ixkj;
    }
  if(iykj < 0)
    {
      negswap = negswap | NEGY;
      iykj = -iykj;
    }
  if(izkj < 0)
    {
      negswap = negswap | NEGZ;
      izkj = -izkj;
    }
  if(ixkj < iykj)
    {
      negswap = negswap | SWAPXY;
      temp_int = ixkj;
      ixkj = iykj;
      iykj = temp_int;
    }
  if(ixkj < izkj)
    {
      negswap = negswap | SWAPXZ;
      temp_int = ixkj;
      ixkj = izkj;
      izkj = temp_int;
    }

  // Initialize the step count and set all motors not to move 
  
  ix = 0;
  motor_step_x = 0;
  motor_step_y = 0;
  motor_step_z = 0;

  // -(X difference)/2

  is1 = -(ixkj >> 1);
  is2 = is1;

  // Line is live

  line_done = 0;
}

// Move one step to the new point along the line, as instructed by motor_step_ x, y, and z

void newPointOnLine()
{
  // Unravel swapping

  if(negswap & SWAPXZ)
    {
      temp_byte = motor_step_x;
      motor_step_x = motor_step_z;
      motor_step_z = temp_byte;
    }

  if(negswap & SWAPXY)
    {
      temp_byte = motor_step_x;
      motor_step_x = motor_step_y;
      motor_step_y = temp_byte;
    }

  // Need to move in X?

  if(motor_step_x)
    {
      if(negswap & NEGX)
	x_bits--;
      else
	x_bits++;
      stepRealX();
    } 

  // And/or Y?

  if(motor_step_y)
    {
      if(negswap & NEGY)
	y_bits--;
      else
	y_bits++;
      stepRealY();
    } 

  // And/or Z?

  if(motor_step_z)
    {
      if(negswap & NEGZ)
	z_bits--;
      else
	z_bits++;
      stepRealZ();
    } 

  // Reset step flags for next time

  motor_step_x = 0;
  motor_step_y = 0;
  motor_step_z = 0;
}


// Compute the new point one step along the line

void oneStepAlongLine()
{
  // Anything to do?

  if(line_done)
    return;

  // At the end yet?

  if(ix <= ixkj)
    {
      // Move to the last set point

      newPointOnLine();

      // Increment the step count

      ix++;

      // As swapping makes X the biggest difference, X always steps

      motor_step_x = 1;

      // Step Y too?

      is1 = is1 + iykj;
      if(is1 > 0)
	{
	  is1 = is1 - ixkj;
	  motor_step_y = 1;
	}

      // Step Z too?

      is2 = is2 + izkj;
      if(is2 > 0)
	{
	  is2 = is2 - ixkj;
	  motor_step_z = 1;
	}
    } else
    {
      lineFinished();
    }
}

// Time delay for the steps along the line just counts number 
// of times round the main loop

void doLine()
{
  del--;
  if(del <= 0)
    {
      del = delay;
      oneStepAlongLine();
      motorsIdle();
    }
}

// ***************************************************************************

// Flash the LED when the motors are running; keep it
// constant when not.

void doFlash()
{
  flash_d--;
  if(flash_d <= 0)
    {
      flash_d = FLASH_DELAY;
      fl = 1 - fl;
      if(line_done)
	PORTB0 = 0;
      else
	{
	  if(fl)
	    PORTB0 = 1;
	  else
	    PORTB0 = 0;
	}
    }
}

	  

//******************************************************************************

// Set everything up

void init()
{
  OPTION_REG = BIN(01011000); // Disable TMR0 on RA4,
                              // Enable Port B pullups

  CMCON = BIN(00000010);      // Comparator module defaults: compare RA0
                              // With the internal reference

  TRISA = BIN(00000000);      // Port A outputs
  
  TRISB = BIN(00000010);      // Port B outputs (except 1 for serial)

  CCPR1L = 0;
  PR2 = 0xff;
  T2CON = BIN(00000111);
  CCP1CON = 0;

  PIE1 = BIN(00000000);       // All peripheral interrupts initially disabled
  INTCON = BIN(00000000);     // Interrupts disabled
  PIR1 = 0;                   // Clear peripheral interrupt flags
  SPBRG = 12;                 // 12 ~= 19200 baud @ 4MHz
  TXSTA = BIN(00000100);      // 8 bit high speed 
  RCSTA = BIN(10000000);      // Enable port for 8 bit receive

  TXEN = 1;              // Enable transmit

  CREN = 1;              // Start reception

  WREN = 0;              // Disable EEPROM writes

  T0CS = 0;
  T0IE = 0;

  // Clear the output pins

  PORTA = 0;
  PORTB = 0;

  // Set up defaults and initial values

  x_bits = 0;
  y_bits = 0;
  z_bits = 0;
  new_x = 0;
  new_y = 0;
  new_z = 0;
  delay = DEF_DELAY;
  del = delay;
  flash_d = FLASH_DELAY;
  fl = 0;
  portA_byte = 0;
  echo = 1;
  idle = 10;
  byte_to_send = 0;
  lineFinished();
  power(0);
 }


// Main program initialises everything, then runs an infinite loop listening
// for commands and controlling the peripherals by repeated function calls -
// i.e. crude process timesharing without interrupts.  Note menu items
// that need further input stop the loop until that input is complete.

void main()
{
  byte b;

  init();

  prompt();

  while(1)
    {
      b = rcvByte();    // Incomming from serial port...
      if(b) menu(b);    // ...?  If yes use menu() to find what was said
      if(byte_to_send)  // Anything to transmit?
	{
	  sendByte(byte_to_send);
	  byte_to_send = 0;
	}
      doLine();         // Line steps with delay
      doFlash();        // Flash the LED, or not
    }
}

