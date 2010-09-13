#ifndef _pic14_h
#define _pic14_h

#if defined __16f627
#include <pic/pic16f627.h>
#elif defined __16f628
#include <pic/pic16f628.h>
#elif defined __GNUC__
// Ignore when calculating dependencies
#else
#error No processor or unknown processor specified
#endif

typedef unsigned char byte;

//unsigned short _moduint(unsigned short, unsigned short);
//unsigned short _divuint(unsigned short, unsigned short);

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

BIT_AT(PORTA_ADDR, 0) PORTA0;
BIT_AT(PORTA_ADDR, 1) PORTA1;
BIT_AT(PORTA_ADDR, 2) PORTA2;
BIT_AT(PORTA_ADDR, 3) PORTA3;
BIT_AT(PORTA_ADDR, 4) PORTA4;
BIT_AT(PORTA_ADDR, 5) PORTA5;
BIT_AT(PORTA_ADDR, 6) PORTA6;
BIT_AT(PORTA_ADDR, 7) PORTA7;

BIT_AT(PORTB_ADDR, 0) PORTB0;
BIT_AT(PORTB_ADDR, 1) PORTB1;
BIT_AT(PORTB_ADDR, 2) PORTB2;
BIT_AT(PORTB_ADDR, 3) PORTB3;
BIT_AT(PORTB_ADDR, 4) PORTB4;
BIT_AT(PORTB_ADDR, 5) PORTB5;
BIT_AT(PORTB_ADDR, 6) PORTB6;
BIT_AT(PORTB_ADDR, 7) PORTB7;

BIT_AT(TRISA_ADDR, 0) TRISA0;
BIT_AT(TRISA_ADDR, 1) TRISA1;
BIT_AT(TRISA_ADDR, 2) TRISA2;
BIT_AT(TRISA_ADDR, 3) TRISA3;
BIT_AT(TRISA_ADDR, 4) TRISA4;
BIT_AT(TRISA_ADDR, 5) TRISA5;
BIT_AT(TRISA_ADDR, 6) TRISA6;
BIT_AT(TRISA_ADDR, 7) TRISA7;

BIT_AT(TRISB_ADDR, 0) TRISB0;
BIT_AT(TRISB_ADDR, 1) TRISB1;
BIT_AT(TRISB_ADDR, 2) TRISB2;
BIT_AT(TRISB_ADDR, 3) TRISB3;
BIT_AT(TRISB_ADDR, 4) TRISB4;
BIT_AT(TRISB_ADDR, 5) TRISB5;
BIT_AT(TRISB_ADDR, 6) TRISB6;
BIT_AT(TRISB_ADDR, 7) TRISB7;

#endif
