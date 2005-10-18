#include "master.h"
#include "serial-inc2.c"

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
    PORTA = buffer[1];
    break;

  case 2:
    sendReply();
    sendDataByte('t');
    sendDataByte('e');
    sendDataByte('s');
    sendDataByte('t');
    endMessage();
    break;
  }
}

