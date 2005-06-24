#include "master.h"

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_CLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;

byte deviceAddress = 1;

// Support routines for bank 1
#include "serial-inc.c"

static void isr() interrupt 0 {
  serialInterruptHandler();
}

void main()
{
  OPTION_REG = 0xdf; // 11011111:  Disable TMR0 and RA4
  CMCON = 0xff;
  TRISA = 0x30;   // 00110000: Port A outputs
  TRISB = 0x06;   // 00000110: Port B outputs
  INTCON = BIN(11000000); // Interrupts enabled
  PIE1 = BIN(00110000);   // RX and TX interrupts enabled
  PIR1 = 0;
  SPBRG = 25;     // 25 = 2400 baud @ 4MHz
  TXSTA = 0x22;   // 8 bit low speed async mode
  RCSTA = 0x80;   // Enable port for 8 bit receive

  RCIE = 1;  // Enable interrupts
  CREN = 1;  // Start reception

  // Turn off outputs
  PORTA = 0;
  PORTB = 0;

  RCREG = BIN(01010100);
  uartNotifyReceive();

  RCREG = BIN(01010001);  //hdb2
  uartNotifyReceive();

  RCREG = BIN(00110001);  //hdb1
  uartNotifyReceive();

  RCREG = 1;  //dest
  uartNotifyReceive();

  RCREG = 0;  //src
  uartNotifyReceive();

  RCREG = 0x10;  //data
  uartNotifyReceive();

  RCREG = 0x00;  //crc
  uartNotifyReceive();

  for(;;) {
  }

}
