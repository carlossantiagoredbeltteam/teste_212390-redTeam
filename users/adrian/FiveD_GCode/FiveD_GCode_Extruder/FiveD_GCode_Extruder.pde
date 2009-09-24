/*
 * 5D GCode Interpreter
 * Arduino code to load into the extruder controller
 * 
  * Adrian Bowyer 3 July 2009
 */
 
 /*
 ***NOTE***
 This program changes the frequency of Timer 0 so that PWM on pins H1E and H2E goes at
 a very high frequency (64kHz see: 
 http://tzechienchu.typepad.com/tc_chus_point/2009/05/changing-pwm-frequency-on-the-arduino-diecimila.html)
This will mess up timings in the delay() and similar functions; they will no longer work in
 milliseconds, but 64 times faster.
 */
  
#ifndef __AVR_ATmega168__
#error Oops!  Make sure you have 'Arduino Diecimila' selected from the boards menu.
#endif

#include <ctype.h>
#include <HardwareSerial.h>
#include "WProgram.h"
#include "configuration.h"
#include "extruder.h"
#include "intercom.h"



extruder ex;
intercom talker(&ex);
int loopBlink;

void setup() 
{
  pinMode(DEBUG_PIN, OUTPUT);
  loopBlink = 0;
  rs485Interface.begin(RS485_BAUD);
} 

void loop() 
{ 
  //if(rs485Interface.available())
  //    rs485Interface.print(rs485Interface.read(), BYTE); 
  
  talker.tick();
  
  // Keep me at the right temp etc.
  
  ex.manage();
  
  loopBlink++;
  if(loopBlink & 0x2000)
   digitalWrite(DEBUG_PIN, 1);
  else
   digitalWrite(DEBUG_PIN, 0); 
} 

void delayMicrosecondsInterruptible(unsigned int us)
{
  // for a one-microsecond delay, simply return.  the overhead
  // of the function call yields a delay of approximately 1 1/8 us.
  if (--us == 0)
    return;

  // the following loop takes a quarter of a microsecond (4 cycles)
  // per iteration, so execute it four times for each microsecond of
  // delay requested.
  us <<= 2;

  // account for the time taken in the preceeding commands.
  us -= 2;

  // busy wait
  __asm__ __volatile__ ("1: sbiw %0,1" "\n\t" // 2 cycles
"brne 1b" : 
  "=w" (us) : 
  "0" (us) // 2 cycles
    );
}

