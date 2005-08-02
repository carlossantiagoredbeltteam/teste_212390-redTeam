#include "master.h"

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_CLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;

byte deviceAddress = 4;  ///@todo #define or const?

// Support routines for bank 1
#include "serial-inc.c"

static void isr() interrupt 0 {
  serialInterruptHandler();
}

void main()
{
  byte v = 0;

  OPTION_REG = BIN(11011111); // Disable TMR0 on RA4, 1:128 WDT
  CMCON = 0xff;               // Comparator module defaults
  TRISA = BIN(00110000);      // Port A outputs (except 4/5)
                              // RA4 is used for clock out (debugging)
                              // RA5 can only be used as an input
  TRISB = BIN(00000110);      // Port B outputs (except 1/2 for serial)
  PIE1 = BIN(00000000);       // All peripheral interrupts initially disabled
  INTCON = BIN(00000000);     // Interrupts disabled
  PIR1 = 0;                   // Clear peripheral interrupt flags
  SPBRG = 25;                 // 25 = 2400 baud @ 4MHz
  TXSTA = BIN(00000000);      // 8 bit low speed 
  RCSTA = BIN(10000000);      // Enable port for 8 bit receive

  TXEN = 1;  // Enable transmit
  RCIE = 1;  // Enable receive interrupts
  CREN = 1;  // Start reception

  PEIE = 1;  // Peripheral interrupts on
  GIE = 1;   // Now turn on interrupts

  // Put pattern on outputs
  PORTB = 0x55;
  PORTA = 0x55;

  // Make sure TSR is clean for first transmit.
  // A 0 byte should be ignored by anybody to start with (no sync)
  uartTransmit(0);

  /*sendMessage(0);
  sendDataByte('I');
  sendDataByte('N');
  sendDataByte('I');
  sendDataByte('T');
  endMessage();*/

  RCREG = 0x54; uartNotifyReceive();
  RCREG = 0x51; uartNotifyReceive();
  RCREG = 0x32; uartNotifyReceive();
  RCREG = 0x04; uartNotifyReceive();
  RCREG = 0x00; uartNotifyReceive();
  RCREG = 0x01; uartNotifyReceive();
  RCREG = 0x0a; uartNotifyReceive();
  RCREG = 0xaa; uartNotifyReceive();

  for(;;) {
    if (processingLock) {
      processCommand();
      releaseLock();
    }
  }
}
