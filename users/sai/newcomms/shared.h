#ifndef _SHARED_H
#define _SHARED_H

#include <sys/time.h>
#include <stdio.h>

#define ACT_NONE   0
#define ACT_FLIP   1
#define ACT_DROP   2
#define ACT_INSERT 3

typedef unsigned char byte;

extern byte action;
extern byte action_value;
extern int act_after;
extern int exitAfter;

extern void timer_ping();
extern void uartNotifyReceive();
extern void releaseReceiveBuffer();
extern void sendMessage(byte dest);
extern void sendDataByte(byte c);
extern void endMessage();

extern void packetNotifyReceive(byte *data, byte length);

extern void printTime();

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
