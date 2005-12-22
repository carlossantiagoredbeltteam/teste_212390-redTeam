#ifndef _serial_h
#define _serial_h

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

extern volatile byte buffer[];

// REMOVE
void uartNotifyReceive();
void serial_init();

#endif
