#include "extruder.h"
#include "serial.h"

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_NOCLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;

byte deviceAddress = PORT;

static void isr() interrupt 0 {
  serialInterruptHandler();

  if (RBIF)
    motorTick();
}

void init1()
{
  byte v = 0;

  OPTION_REG = BIN(11011111); // Disable TMR0 on RA4, 1:128 WDT
  CMCON = 0xff;               // Comparator module defaults
  TRISA = BIN(00100000);      // Port A outputs (except 5)
                              // RA5 can only be used as an input
  TRISB = BIN(10000110);      // Port B outputs, except 1/2 for serial and
                              // RB7 for optointerrupter input
  // Note port B3 will be used for PWM output (CCP1)
  PIE1 = BIN(00000000);       // All peripheral interrupts initially disabled
  INTCON = BIN(00000000);     // Interrupts disabled
  PIR1 = 0;                   // Clear peripheral interrupt flags
  SPBRG = 12;                 // 12 = ~19200 baud @ 4MHz
  TXSTA = BIN(00000100);      // 8 bit high speed 
  RCSTA = BIN(10000000);      // Enable port for 8 bit receive

  RCIE = 1;  // Enable receive interrupts
  CREN = 1;  // Start reception

  TXEN = 1;  // Enable transmit
  RBIE = 1;  // Enable RB port change interrupt

  PEIE = 1;  // Peripheral interrupts on
  GIE = 1;   // Now turn on interrupts

  PORTB = 0;
  PORTA = 0;

  PR2 = PWMPeriod;          // Initial PWM period
  CCP1CON = BIN(00111100);  // Enable PWM mode (low two bits set)
  CCPR1L = 0;               // Start turned off
  
  T2CON = BIN(00000100);    // Enable timer 2 and set prescale to 1
}

void main() {
  init1();
  init2();
  serial_init();

  // Clear up any boot noise from the TSR
  uartTransmit(0);

  for(;;) {
    waitForPacket();
    processCommand();
    releaseLock();
  }
}
