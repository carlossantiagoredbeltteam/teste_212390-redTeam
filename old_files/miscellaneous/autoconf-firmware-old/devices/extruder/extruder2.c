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


#include "extruder.h"
#include "serial.h"

byte PWMPeriod = 255;
volatile static byte currentDirection = 0;

// Non-zero indicates seeking is in progress (and its speed)
volatile static byte seekSpeed = 0;

volatile static byte seekNotify = 255;

volatile static byte lastPortB = 0;

static byte requestedHeat0 = 0;
static byte requestedHeat1 = 0;
volatile static byte heatCounter = 0;
static byte temperatureLimit0 = 0;
static byte temperatureLimit1 = 0;

volatile static byte delay_counter;
static byte lastTemperature = 0;
static byte lastTemperatureRef = 0;

static byte temperatureVRef = 3;

static byte portaval = 0;

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

volatile static addressableInt currentPosition, seekPosition;

#define CMD_VERSION       0
#define CMD_FORWARD       1
#define CMD_REVERSE       2
#define CMD_SETPOS        3
#define CMD_GETPOS        4
#define CMD_SEEK          5
#define CMD_FREE          6
#define CMD_NOTIFY        7
#define CMD_ISEMPTY       8
#define CMD_SETHEAT       9
#define CMD_GETTEMP       10
#define CMD_SETCOOLER     11
#define CMD_PWMPERIOD     50
#define CMD_PRESCALER     51
#define CMD_SETVREF       52
#define CMD_SETTEMPSCALER 53

#define HEATER_PWM_PERIOD 255

void init2()
{
  PWMPeriod = 255;
  currentDirection = 0;
  seekSpeed = 0;
  seekNotify = 255;
  lastPortB = 0;
  currentPosition.bytes[0] = 0;
  currentPosition.bytes[1] = 0;
  seekPosition.bytes[0] = 0;
  seekPosition.bytes[1] = 0;
  requestedHeat0 = 0;
  requestedHeat1 = 0;
  heatCounter = 0;
  lastTemperature = 0;
  lastTemperatureRef = 0;
  temperatureVRef = 3;
  portaval = 0;
  TMR1H = HEATER_PWM_PERIOD;
  TMR1L = 0;
}

#pragma save
#pragma nooverlay
void setSpeed(byte speed, byte direction)
{
  if (speed == 0) {
    PORTB4 = 0;
    PORTB5 = 0;
    // Also turn off PWM completely
    CCP1CON = BIN(00000000);
    PR2 = 255;
    PORTB3 = 0;
    CCPR1L = 0;
    return;
  } else {
    if (direction == 0) {
      // Set forward output enable
      PORTB5 = 0;
      PORTB4 = 1;
    } else {
      // Set reverse output enable
      PORTB4 = 0;
      PORTB5 = 1;
    }
    // Turn on PWM if it wasn't already
    CCP1CON = BIN(00111100);
  }
  CCPR1L = speed;
  if (speed == 255)
    PR2 = 0;
  else
    PR2 = PWMPeriod;
    
  currentDirection = direction;
 _asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _currentPosition
 _endasm;
}
#pragma restore

#pragma save
#pragma nooverlay
void timerTick()
{
  // There are two temperatures temperatureLimit0 and temperatureLimit1.
  // When colder than temperatureLimit0, the heater runs at
  // the power specified by requestedHeat1.  If it is between
  // temperatureLimit0 and temperatureLimit1 then it runs at the
  // lower power setting requestedHeat0.  If it is hotter than
  // temperatureLimit1, the power shuts down completely.
  if (lastTemperature <= temperatureLimit1) {
    // Reached critical limit, so power off
    PORTB0 = 0;
  } else if (lastTemperature <= temperatureLimit0 &&
	     heatCounter >= requestedHeat0 && requestedHeat0 != 255) {
    // In medium zone, heater off period (based on low heat)
    PORTB0 = 0;
  } else if (lastTemperature > temperatureLimit0 &&
	     heatCounter >= requestedHeat1 && requestedHeat1 != 255) {
    // In low zone, heater off period (based on high heat)
    PORTB0 = 0;
  } else {
    // Heater on
    PORTB0 = 1;
  }
  heatCounter++;
  TMR1H = HEATER_PWM_PERIOD;
  TMR1L = 0;

_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _currentPosition
_endasm;
}
#pragma restore


#pragma save
#pragma nooverlay
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
	// Set speed to 0 and turn off motor
	seekSpeed = 0;
	PORTB4 = 0;
	PORTB5 = 0;
	// Also turn off PWM
	CCP1CON = BIN(00000000);
	PR2 = 255;
	PORTB3 = 0;
	CCPR1L = 0;
      }
    }
  }
  if (changes & 0x40) {
    // Material detector changed
    if (!PORTB6 && seekNotify != 255) {
      sendMessage(seekNotify);
      sendDataByte(CMD_ISEMPTY);
      sendDataByte(1);
      endMessage();
    }
  }

  lastPortB = current;
 _asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _currentPosition
 _endasm;
}
#pragma restore

void delay_10us()
{
_asm
  BANKSEL _delay_counter
DELAY_10US_1:
  CLRWDT
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  DECFSZ _delay_counter, F
  GOTO DELAY_10US_1
_endasm;
}

void checkTemperature()
{
  // Assumes:
  // A6 is a reference resistor
  // A7 is thermistor
  // A1 is comparator

  byte val = 0;

  // Assume capacitor is discharged from previous round or powerup

  // Set Timer0 to timer mode and use watchdog prescaler
  T0CS = 0;
  PSA = 0;

  // Set vref to test level and give it time to stabilise
  VRCON = BIN(10000000) | temperatureVRef;
  CMCON = BIN(00000010);
  delay_10us();

  T0IF = 0;
  // Set A6 to high, float others
  TRISA = BIN(10000010) | PORTATRIS;
  PORTA = portaval | BIN(01000000);

  // Wait for cap to reach vref
  TMR0 = 0;
  while (C2OUT)
    ;
  if (T0IF)
    lastTemperatureRef = 255;
  else
    lastTemperatureRef = TMR0;

  // Discharge cap
  // Set A1 to low, float others
  PORTA = portaval;
  TRISA = BIN(11000000) | PORTATRIS;

  // Set vref to low
  VRCON = BIN(10100001); // should be 1010xxxx to not output value
  delay_10us();
  // Wait for voltage to go low
  while (!C2OUT)
    ;
  // Extra delay for full discharge
  delay_10us();

  // Set vref to test level and give it time to stabilise
  VRCON = BIN(10000000) | temperatureVRef;
  delay_10us();

  T0IF = 0;
  // Set A7 to high, float others
  PORTA = portaval | BIN(10000000);
  TRISA = BIN(01000010) | PORTATRIS;

  // Use 8 bit Timer0 to measure time
  // Wait for cap to reach vref
  TMR0 = 0;
  while (C2OUT)
    ;
  if (T0IF)
    lastTemperature = 255;
  else
    lastTemperature = TMR0;

  // Discharge cap
  // Set A1 to low, float others
  PORTA = portaval;
  TRISA = BIN(11000000) | PORTATRIS;

  // Set vref to low
  VRCON = BIN(10100001); // should be 1010xxxx to not output value
  delay_10us();
  // Wait for voltage to reach 0
  while (!C2OUT)
    ;
  // Extra delay for full discharge
  delay_10us();

  TRISA = BIN(11000010) | PORTATRIS;
  VRCON = 0;  // Turn of vref

_asm  /// @todo Remove when sdcc bug fixed
  BANKSEL _currentPosition
_endasm;
}

void processCommand()
{
  switch(buffer[0]) {
  case CMD_VERSION:
    sendReply();
    sendDataByte(CMD_VERSION);  // Response type 0
    sendDataByte(0);  // These don't really mean much right now
    sendDataByte(2);
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
    sendDataByte(CMD_GETPOS);
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
    // Set seek completion (and calibration) notification
    seekNotify = buffer[1];
    break;

  case CMD_ISEMPTY:
    sendReply();
    sendDataByte(CMD_ISEMPTY);
    sendDataByte(!PORTB6);
    endMessage();
    break;

  case CMD_SETHEAT:
    requestedHeat0 = buffer[1];
    requestedHeat1 = buffer[2];
    temperatureLimit0 = buffer[3];
    temperatureLimit1 = buffer[4];
    break;

  case CMD_GETTEMP:
    sendReply();
    sendDataByte(CMD_GETTEMP);
    sendDataByte(lastTemperature);
    sendDataByte(lastTemperatureRef);
    endMessage();
    break;

  case CMD_SETCOOLER:
    if (buffer[1])
      portaval |= BIN(00000100);
    else
      portaval &= BIN(11111011);
    PORTA = portaval;
    break;

// "Hidden" low level commands
  case CMD_PWMPERIOD:
    // Set PWM period
    PWMPeriod = buffer[1];
    PR2 = PWMPeriod;
    break;

  case CMD_PRESCALER:
    // Set timer prescaler (for PWM)
    T2CON = BIN(00000100) | (buffer[1] & 3);
    break;

  case CMD_SETVREF:
    temperatureVRef = buffer[1];
    break;

  case CMD_SETTEMPSCALER:
    OPTION_REG = (OPTION_REG & BIN(11111000)) | (buffer[1] & BIN(111));
    break;

  }

}

// To work around sdcc issue
void dummy()
{
  INTCON = 0;
}
