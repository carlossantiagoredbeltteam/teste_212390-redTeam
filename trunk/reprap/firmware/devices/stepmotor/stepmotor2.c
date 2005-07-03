#include "stepmotor.h"
#include "serial-inc2.c"

void processCommand()
{
  switch(buffer[0]) {
  case 0:
    sendReply();
    sendDataByte('t');
    sendDataByte('e');
    sendDataByte('s');
    sendDataByte('t');
    endMessage();
    break;
  case 1:
    PORTA = buffer[1];
    break;
  }
}

