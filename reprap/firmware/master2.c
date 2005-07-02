#include "master.h"
#include "serial-inc2.c"

void processCommand()
{
  switch(buffer[0]) {
  case 0:
    PORTA = buffer[1];
    break;
  case 1:
    sendReply();
    sendDataByte('t');
    sendDataByte('e');
    sendDataByte('s');
    sendDataByte('t');
    endMessage();
    break;
  }
}

