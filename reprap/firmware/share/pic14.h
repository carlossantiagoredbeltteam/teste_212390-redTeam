#ifndef _pic14_h
#define _pic14_h

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

/*BIT_AT(PORTA_ADDR, 0) PORTA0;
BIT_AT(PORTA_ADDR, 1) PORTA1;
BIT_AT(PORTA_ADDR, 2) PORTA2;
BIT_AT(PORTA_ADDR, 3) PORTA3;
BIT_AT(PORTA_ADDR, 4) PORTA4;
BIT_AT(PORTA_ADDR, 5) PORTA5;
BIT_AT(PORTA_ADDR, 6) PORTA6;
BIT_AT(PORTA_ADDR, 7) PORTA7;*/

#endif
