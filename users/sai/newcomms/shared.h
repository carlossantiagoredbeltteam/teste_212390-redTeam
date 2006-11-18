#ifndef _SHARED_H
#define _SHARED_H

typedef unsigned char byte;

extern void timer_ping();
extern void uartNotifyReceive();
extern void releaseReceiveBuffer();
extern void sendMessage(byte dest);
extern void sendDataByte(byte c);
extern void endMessage();

extern void packetNotifyReceive(byte *data, byte length);


extern byte RCREG;

extern byte address;

// No binary literals in sdcc, so add our own
#define BIN_BIT(value, bit, dec) \
  (((((unsigned long)(value##.0))/dec)&1 == 1)? (1<<bit) : 0)

#define BIN(value) \
( BIN_BIT(value,  0, 1) | \
  BIN_BIT(value,  1, 10) | \
  BIN_BIT(value,  2, 100) | \
  BIN_BIT(value,  3, 1000) | \
  BIN_BIT(value,  4, 10000) | \
  BIN_BIT(value,  5, 100000) | \
  BIN_BIT(value,  6, 1000000) | \
  BIN_BIT(value,  7, 10000000))

#endif
