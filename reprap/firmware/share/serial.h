#ifndef _serial_inc_h
#define _serial_inc_h

#define __16f627
#include <pic/pic16f627.h>
#include "pic14.h"

#define MAX_TRANSMIT_BUFFER 16  ///< Transmit buffer size.

#define MAX_PAYLOAD 16         ///< Size of largest possible message.

void uartTransmit(byte c);
void sendReply();
void sendDataByte(byte c);
void endMessage();
void releaseLock();
void serialInterruptHandler();
byte packetReady();
void sendMessage(byte dest);
void sendDataByte(byte c);

extern byte buffer[];


// REMOVE
void uartNotifyReceive();


#endif
