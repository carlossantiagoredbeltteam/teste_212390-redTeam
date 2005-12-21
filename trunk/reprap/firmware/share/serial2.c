#include "serial-inc.h"

volatile byte buffer[MAX_PAYLOAD];   ///< Receive buffer
volatile byte transmitBuffer[MAX_TRANSMIT_BUFFER];
byte sendPacket[MAX_PAYLOAD];

