#include "motor.h"
#include "serial-inc2.c"

byte PWMPeriod = 255;

void processCommand()
{
  switch(buffer[0]) {
  case 0:
    sendReply();
    sendDataByte(0);  // These don't really mean much right now
    sendDataByte(1);
    endMessage();
    break;
  case 1:
    // Forward speed
    if (buffer[1] == 0) {
      PORTB = 0;
    } else {
      PORTB = BIN(00010000);  // Set forward output enable
    }
    CCPR1L = buffer[1];
    if (buffer[1] == 255)
      PR2 = 0;
    else
      PR2 = PWMPeriod;
    break;
  case 2:
    // Reverse speed
    // Set PWM duty cycle
    if (buffer[1] == 0) {
      PORTB = 0;
    } else {
      PORTB = BIN(00100000);  // Set reverse output enable
    }
    CCPR1L = buffer[1];
    if (buffer[1] == 255)
      PR2 = 0;
    else
      PR2 = PWMPeriod;
    break;
  case 3:
    // Set PWM period
    PWMPeriod = buffer[1];
    PR2 = PWMPeriod;
    break;
  case 4:
    // Set timer prescaler
    T2CON = BIN(00000100) | (buffer[1] & 3);
    break;
  }
}

