// Yep, this is actually -*- c++ -*-
/*********************************************************************************************************
 *  Sanguino 3rd Generation Firmware (S3G)
 *
 *  Specification for this protocol is located at: http://docs.google.com/Doc?id=dd5prwmp_14ggw37mfp
 *  
 *  License: GPLv2
 *  Authors: Marius Kintel, Adam Mayer, and Zach Hoeken
 *
 *  Version History:
 *
 *  0001: Initial release of the protocol and firmware.
 *
 *********************************************************************************************************/

//include some basic libraries.
#include <WProgram.h>

#include "Configuration.h"
#include "Datatypes.h"
#include "CircularBuffer.h"
#include "Packet.h"
#include "Variables.h"
#ifdef USE_SD_CARD
#include <RepRapSDCard.h>
#endif

//this is our firmware version
#define FIRMWARE_VERSION 0001

//set up our firmware for actual usage.
void setup()
{
  //setup our firmware to a default state.
  initialize();

  //this is a simple text string that identifies us.
  Serial.print("R3G Master v");
  Serial.println(FIRMWARE_VERSION, DEC);
}

//this function takes us back to our default state.
void initialize()
{
  is_machine_paused = false;

  init_serial();
  init_commands();
  init_steppers();
  init_tools();
}

//start our hardware serial drivers
void init_serial()
{
  Serial.begin(HOST_SERIAL_SPEED);
  Serial1.begin(SLAVE_SERIAL_SPEED);
}

//handle various things we're required to do.
void loop()
{
  //if we've aborted, dont do anything.
  //if (!is_machine_aborted)
  //{
    //check for and handle any packets that come in.
    process_host_packets();

    //only handle our buffer if we're unpaused. 
    if (!is_machine_paused && !is_machine_aborted)
      handle_commands();
  //}
}

//handle the abortion of a print job
void abort_print()
{
  //yes, we're done here.
  is_machine_aborted = true;

  //TODO: turn off all of our tools.

  //turn off steppers too.
  disableTimer1Interrupt();
  disable_steppers();

  //initalize everything to the beginning
  initialize();
}

void delayMicrosecondsInterruptible(unsigned int us)
{

#if F_CPU >= 16000000L
  // for the 16 MHz clock on most Arduino boards

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
#else
  // for the 8 MHz internal clock on the ATmega168

  // for a one- or two-microsecond delay, simply return.  the overhead of
  // the function calls takes more than two microseconds.  can't just
  // subtract two, since us is unsigned; we'd overflow.
  if (--us == 0)
    return;
  if (--us == 0)
    return;

  // the following loop takes half of a microsecond (4 cycles)
  // per iteration, so execute it twice for each microsecond of
  // delay requested.
  us <<= 1;

  // partially compensate for the time taken by the preceeding commands.
  // we can't subtract any more than this or we'd overflow w/ small delays.
  us--;
#endif

  // busy wait
  __asm__ __volatile__ (
  "1: sbiw %0,1" "\n\t" // 2 cycles
"brne 1b" : 
  "=w" (us) : 
  "0" (us) // 2 cycles
    );
}
