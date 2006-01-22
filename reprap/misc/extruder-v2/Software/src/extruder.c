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

This is the C program for the PIC that controls the polymer extruder head.

Version 1.1  18 September 2005

*/

#include "extruder.h"

// PIC configuration bits

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_CLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;

// Global variables

byte set_temp;   // The temperature required
byte low_ref;    // Use low or high voltage reference
byte motor;      // 0 for stop, or FORWARD, or REVERSE
byte speed;      // Motor speed
byte f_count1;   // LED flash...
byte f_count2;   // ...counters
byte f_val;      // LED on (1) or off (0)

byte a_to_d();  // Function prototype

// ***********************************************************************

// Save and load from EEPROM

// This function saves the current set speed, 
// temperature, and voltage reference into the EEPROM.  See the PIC
// data sheet for details of how it works.

void eeSave()
{
  // while(GIE) GIE = 0;

  while(WR);
  EEADR = SPEED_ADDR;
  EEDATA = speed;
  WREN = 1;
  EECON2 = 0x55;
  EECON2 = 0xaa;
  WR = 1;

  while(WR);
  EEADR = TEMP_ADDR;
  EEDATA = set_temp;
  WREN = 1;
  EECON2 = 0x55;
  EECON2 = 0xaa;
  WR = 1;

  while(WR);
  EEADR = HL_ADDR;
  EEDATA = low_ref;
  WREN = 1;
  EECON2 = 0x55;
  EECON2 = 0xaa;
  WR = 1;

  // GIE = 1;
}


// This function loads the saved speed, 
// temperature and voltage reference from the EEPROM.  See the PIC
// data sheet for details of how it works.

void eeLoad()
{
  while(RD); 
  EEADR = SPEED_ADDR;
  RD = 1;
  speed = EEDATA;

  while(RD); 
  EEADR = TEMP_ADDR;
  RD = 1;
  set_temp = EEDATA;

  while(RD); 
  EEADR = HL_ADDR;
  RD = 1;
  low_ref = EEDATA;
}

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


// Send a number in hex.

void sendNumber(byte n)
{
  byte b;
  sendByte('0');
  sendByte('x');
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


// Get a number in hex (no leading 0x needed).

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

// Send a new line.

void crlf()
{
  sendByte('\r');
  sendByte('\n');
}

// Send a "> " prompt.

void prompt()
{
  crlf();
  sendByte('>');
  sendByte(' ');
}

// Deal with user input (single letter command in b)

void menu(byte b)
{
    switch(b)
    {
    // Return the set temperature
    case 't':
      sendNumber(set_temp);
      break;

    // Set a new temperature
    case 'T':
      set_temp = waitNumber();
      break;

    // Return the actual temperature
    case 'v':
      sendNumber(a_to_d());
      break;

    // Turn the motor off
    case 'm':
      motor = 0;
      break;

    // Turn the motor on
    case 'F':
      motor = FORWARD;
      break;

    // Reverse the motor on
    case 'R':
      motor = REVERSE;
      break;

    // Return the speed
    case 's':
      sendNumber(speed);
      break;

    // Set a new speed
    case 'S':
      speed = waitNumber();
      break;

    // Set the A to D range
    case 'L':
      low_ref = 1;
      VRCON = V_REF_LO;
      break;
    case 'H':
      low_ref = 0;
      VRCON = V_REF_HI;
      break;

    // Report the A->D range
    case 'l':
      sendNumber(low_ref);
      break;

    // Uh?
    default:
      sendByte('?');
    }
    prompt();

    // Save any changes to the set speed or temperature

    eeSave();
}


//**************************************************************************

// CONTROL OF LEDS, HEATER, AND MOTOR


// Should the motor be on?

byte motor_on()
{
  if(motor) return motor;     // Request from the user via the menu or...
  if(!PORTB5) return FORWARD; // ... the control pin is grounded
  return 0;
}

// This flashes the blue LED when the motor is running, or
// puts it on continuously when it is not. 

void flash()
{
  if(motor_on())
  {
    f_count1++;
    if(!f_count1)
    {
      f_count2--;
      if(!f_count2)
      {
	f_count2 = F_DEF;
        f_val = 1 - f_val;
	if(f_val)
	  PORTB7 = 0;
	else
	  PORTB7 = 1;
       }
    }
  } else
  {
    PORTB7 = 1;
  }
}


// Crude 4-bit A to D converter
// According to the spec a delay > 10 us should
// be needed after each bit VRx is set.  But it 
// seems to work without, so let sleeping dogs lie...

byte a_to_d()
{
  byte b;

  // Low or high range?

  if(low_ref)
      VRCON = V_REF_LO;
  else
      VRCON = V_REF_HI;

  //Initialise the voltage returned value to 0

  VREN = 1;
  VRCON = VRCON & 0xf0;

  b = 0x0f;

  // 4-bit succesive approximation register

  VR3 = 1;
  if(C1OUT)
  {
    b = b & BIN(00000111);
    VR3 = 0;
  }
  VR2 = 1;
  if(C1OUT)
  {
    b = b & BIN(00001011);
    VR2 = 0;
  }
  VR1 = 1;
  if(C1OUT)
  {
    b = b & BIN(00001101);
    VR1 = 0;
  }
  VR0 = 1;
  if(C1OUT)
  {
    b = b & BIN(00001110);
    VR0 = 0;
  }

  VREN = 0;
  return b;
}

// The thermostat

void temperature()
{
  byte t = a_to_d();
  if(t < set_temp)
    PORTA1 = 1;    // Heater on
  else
    PORTA1 = 0;    // Heater off
}

// Controlling the motor

void stopMotor()
{
  CCP1CON = 0;
  CCPR1L = 0;
  PORTB3 = 0;
  PORTB4 = 0;
}

void motorControl()
{

  // Turn off the motor if we're not (almost) up to the set temp.

  if(set_temp - a_to_d() > 1) 
  { 
    stopMotor();
    return; 
  }

  // Otherwise do what motor_on() says

  switch(motor_on())
  {
  case FORWARD:
    CCPR1L = speed;
    CCP1CON = BIN(00001100);
    PORTB4 = 0;
    break;

  case REVERSE:
    CCPR1L = 255 - speed;
    CCP1CON = BIN(00001100);
    PORTB4 = 1;
    break;
  
  default:
    stopMotor();
  }
}

//******************************************************************************

// Set everything up

void init()
{
  OPTION_REG = BIN(01011111); // Disable TMR0 on RA4, 1:128 WDT
                              // Enable Port B pullups

  CMCON = BIN(00000010);      // Comparator module defaults: compare RA0
                              // With the internal reference

  TRISA = BIN(00110001);      // Port A outputs (except 0/4/5)
                              // RA0 is input from the temp. sensor
                              // RA1 drives the heater
                              // RA4 is used for clock out (debugging)
                              // RA5 is motor-demand input for autonomous running
                              // RA7 drives the activity/motor LED
  
  TRISB = BIN(00100110);      // Port B outputs (except 1/2 for serial and
                              // 5 - motor control)

  CCPR1L = 0;
  PR2 = 0xff;
  T2CON = BIN(00000111);
  CCP1CON = 0;

  PIE1 = BIN(00000000);       // All peripheral interrupts initially disabled
  INTCON = BIN(00000000);     // Interrupts disabled
  PIR1 = 0;                   // Clear peripheral interrupt flags
  SPBRG = 25;                 // 25 = 2400 baud @ 4MHz
  TXSTA = BIN(00000000);      // 8 bit low speed 
  RCSTA = BIN(10000000);      // Enable port for 8 bit receive

  TXEN = 1;              // Enable transmit

  CREN = 1;              // Start reception
  VRCON = V_REF_LO;      // V reference - low range

  WREN = 0;              // Disable EEPROM writes

  // Clear the output pins

  PORTA = 0;
  PORTB = 0;

  // Set the motor stopped and the blue flash values

  motor = 0;
  f_count2 = F_DEF;
  f_val = 0;

  // Load the saved speed and temperature from the EEPROM

  eeLoad();

  // Blow the trumpet...

  crlf();
  sendByte('R');
  sendByte('e');
  sendByte('p');
  sendByte('R');
  sendByte('a');
  sendByte('p');
  crlf();


  //sendString("\n\rRepRap\n\r");
}


// Main program initialises everything, then runs an infinite loop listening
// for commands and controlling the peripherals by repeated function calls -
// i.e. crude process timesharing without interrupts.  Note menu items
// that need further input stop the loop until that input is complete, so don't
// sit scratching your head thinking what to type when the heater's on, for example...

void main()
{
  byte b;

  init();

  prompt();

  while(1)
  {
    b = rcvByte();  // Incomming from serial port...
    if(b) menu(b);  // ...?  If yes use menu() to find what was said
    temperature();  // Heater on or off as need be
    motorControl(); // Motor on or off as need be
    flash();        // Blue LED on or off as need be...
  }
}
