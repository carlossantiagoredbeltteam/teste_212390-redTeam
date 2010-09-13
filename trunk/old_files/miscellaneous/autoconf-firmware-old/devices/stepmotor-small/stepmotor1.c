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

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_CLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;

byte deviceAddress = PORT;

static void isr() interrupt 0 {
  serialInterruptHandler();
  
  if (TMR1IF) {
    timerTick();
    TMR1IF = 0;
  }
}

void main()
{

  OPTION_REG = BIN(11011111); // Disable TMR0 on RA4, 1:128 WDT
  CMCON = 0xff;               // Comparator module defaults
  TRISA = BIN(00110000);      // Port A outputs (except 4/5)
                              // RA4 is used for clock out (debugging)
                              // RA5 can only be used as an input
  TRISB = BIN(00000110);      // Port B outputs (except 1/2 for serial)
  PIE1 = BIN(00000000);       // All peripheral interrupts initially disabled
  INTCON = BIN(00000000);     // Interrupts disabled
  PIR1 = 0;                   // Clear peripheral interrupt flags
  SPBRG = 12;                 // 12 = 19200 (actually 19230) baud @ 4MHz
  TXSTA = BIN(00000100);      // 8 bit high speed 
  RCSTA = BIN(10000000);      // Enable port for 8 bit receive

  PORTB = 0;

  RCIE = 1;  // Enable receive interrupts
  CREN = 1;  // Start reception

  TXEN = 1;  // Enable transmit
  PEIE = 1;  // Peripheral interrupts on
  GIE = 1;   // Now turn on interrupts

  PORTB = 0;
  PORTA = 0;

  TMR1IE = 0;

  T1CON = BIN(00000000);  // Timer 1 in clock mode with 1:1 scale
  TMR1IE = 1;  // Enable timer interrupt

  init();
  serial_init();

  // Clear up any boot noise from the TSR
  uartTransmit(0);

  for(;;) {
    waitForPacket();
    processCommand();
    releaseLock();
  }
}
