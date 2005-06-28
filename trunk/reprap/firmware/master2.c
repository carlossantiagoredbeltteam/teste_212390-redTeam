#include "master.h"
#include "serial-inc2.c"

byte zero = 0; // sdcc bug workaround

void dummy()
{
}

/*void processCommand()
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
    if (buffer[1]) {
      PORTA = 0xff;
    } else {
      PORTA = 0;
    }
    sendReply();
    sendDataByte('L');
    sendDataByte('E');
    sendDataByte('D');
    endMessage();
  }
}
*/
