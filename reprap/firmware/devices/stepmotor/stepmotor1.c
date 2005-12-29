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

void init1()
{

  OPTION_REG = BIN(11011111); // Disable TMR0 on RA4, 1:128 WDT
  CMCON = 0xff;               // Comparator module defaults
  TRISA = BIN(00110111);      // Port A outputs except 0,1,2,4,5
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
}

void main() {
  byte syncEnabled = 0;

  init1();
  init2();
  serial_init();

  // Clear up any boot noise from the TSR
  uartTransmit(0);
 
  if (PORTA2) // Only enable if PORTA2 is by default high
    syncEnabled = 1;

  for(;;) {
    if (packetReady()) {
      processCommand();
      releaseLock();
    }
    if (syncEnabled && !PORTA2) {
      // Sync line has dropped
      // Spin until it goes high again (we trigger on the rising edge)
      while(!PORTA2)
	;
      syncStrobe();
    }
  }
}
