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

This is the C program header for the PIC that controls the polymer extruder head.

Version 1.1  18 September 2005

*/

#ifndef _extruder_h
#define _extruder_h

#define __16f628
#include <pic/pic16f628.h>

typedef unsigned char byte;

// No binary literals in sdcc, so add our own
#define BIN_BIT(value, bit, dec) \
  (((((unsigned long)(value##.0))/dec)&1 == 1)? (1<<bit) : 0)

#define BIN(value) \
( BIN_BIT(value,  0, 1) | \
  BIN_BIT(value,  1, 10) | \
  BIN_BIT(value,  2, 100) | \
  BIN_BIT(value,  3, 1000) | \
  BIN_BIT(value,  4, 10000) | \
  BIN_BIT(value,  5, 100000) | \
  BIN_BIT(value,  6, 1000000) | \
  BIN_BIT(value,  7, 10000000))

BIT_AT(PORTA_ADDR, 0) PORTA0;
BIT_AT(PORTA_ADDR, 1) PORTA1;
BIT_AT(PORTA_ADDR, 2) PORTA2;
BIT_AT(PORTA_ADDR, 3) PORTA3;
BIT_AT(PORTA_ADDR, 4) PORTA4;
BIT_AT(PORTA_ADDR, 5) PORTA5;
BIT_AT(PORTA_ADDR, 6) PORTA6;
BIT_AT(PORTA_ADDR, 7) PORTA7;

BIT_AT(PORTB_ADDR, 0) PORTB0;
BIT_AT(PORTB_ADDR, 1) PORTB1;
BIT_AT(PORTB_ADDR, 2) PORTB2;
BIT_AT(PORTB_ADDR, 3) PORTB3;
BIT_AT(PORTB_ADDR, 4) PORTB4;
BIT_AT(PORTB_ADDR, 5) PORTB5;
BIT_AT(PORTB_ADDR, 6) PORTB6;
BIT_AT(PORTB_ADDR, 7) PORTB7;


#define T_DEF 0                // Default temperature
#define F_DEF 5                // Default LED flash rate
#define FORWARD 1              // Motor directions...
#define REVERSE 2              // ...
#define S_DEF 0x80             // Default motor speed
#define V_REF_LO BIN(00100000) // Low and high...
#define V_REF_HI BIN(00000000) // ...voltage reference

// Addresses in EEPROM where the temperature and speed settings are
// saved through power-down/power-up.

enum
  {
    TEMP_ADDR,
    SPEED_ADDR,
    HL_ADDR
  };


#endif
