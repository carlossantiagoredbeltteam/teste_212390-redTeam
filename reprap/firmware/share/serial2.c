#include "serial.h"

volatile byte buffer[MAX_PAYLOAD];   ///< Receive buffer
volatile byte transmitBuffer[MAX_TRANSMIT_BUFFER];
byte sendPacket[MAX_PAYLOAD];

void clearwdt()
{
_asm
  CLRWDT
  _endasm;
}
