#ifndef _serial_inc_h
#define _serial_inc_h

#ifdef SDCC
#define MAX_TRANSMIT_BUFFER 8  ///< Transmit buffer size.
#else
#define MAX_TRANSMIT_BUFFER 16  ///< Transmit buffer size.
#endif

#define MAX_PAYLOAD 16         ///< Size of largest possible message.

void uartTransmit(byte c);
void sendReply();
void sendDataByte(byte c);
void endMessage();
void releaseLock();

#endif
