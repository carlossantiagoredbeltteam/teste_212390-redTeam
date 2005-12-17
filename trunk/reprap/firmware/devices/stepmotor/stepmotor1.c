#include "stepmotor.h"
#include "serial-inc.h"

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_CLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;

byte deviceAddress = 2;

static void isr() interrupt 0 {
  serialInterruptHandler();
  
  if (TMR1IF) {
    //timerTick();
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
  SPBRG = 25;                 // 25 = 2400 baud @ 4MHz
  TXSTA = BIN(00000000);      // 8 bit low speed 
  RCSTA = BIN(10000000);      // Enable port for 8 bit receive

  PORTB = 0;

PORTB=0x10;

  RCIE = 1;  // Enable receive interrupts
  CREN = 1;  // Start reception

  TXEN = 1;  // Enable transmit
  PEIE = 1;  // Peripheral interrupts on
  GIE = 1;   // Now turn on interrupts

  PORTB = 0;
  PORTA = 0;
PORTB=0x20;

  TMR1IE = 0;

  T1CON = BIN(00000000);  // Timer 1 in clock mode with 1:1 scale
  //TMR1IE = 1;  // Enable timer interrupt
PORTB=0x30;

  init();

  // Clear up any boot noise from the TSR
PORTB=0x50;

  uartTransmit('t');
  uartTransmit('e');
  uartTransmit('s');
  uartTransmit('t');

  /*uartTransmit(0);

  sendMessage(0);
  sendDataByte('I');
  sendDataByte('N');
  sendDataByte('I');
  sendDataByte('T');
  endMessage();*/

  RCREG = 0x54;
  uartNotifyReceive();
  

  for(;;) {
    if (packetReady()) {
      processCommand();
      releaseLock();
    }
  }
}
