#include "master.h"
#include "serial-inc2.c"

byte zero = 0; // sdcc bug workaround

void dummy()
{
}

void processCommand()
{
  byte c;
  c = buffer[zero];
  if (c == 0) {
    sendReply();
    sendDataByte('S');
    sendDataByte('D');
    sendDataByte('M');
    endMessage();
  } else if (c == 1) {
    uartTransmit('X');
    if (buffer[1]) {
      uartTransmit('Y');
      _asm
	banksel PORTA
	movlw 0xff
	movwf PORTA
     _endasm;
    } else {
      uartTransmit('Z');
      _asm
	banksel PORTA
	movlw 0x00
	movwf PORTA
     _endasm;
    }
    sendReply();
    sendDataByte('L');
    sendDataByte('E');
    sendDataByte('D');
    endMessage();
  }
}
