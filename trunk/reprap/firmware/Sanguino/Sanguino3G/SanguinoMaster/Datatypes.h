//#include <stddef.h>
#include <stdint.h>

// our point structure to make things nice.
struct LongPoint {
  long x;
  long y;
  long z;
};

// packet states
typedef enum {
  PS_START = 0,
  PS_LEN,
  PS_PAYLOAD,
  PS_CRC,
  PS_LAST
} 
PacketState;

// various error codes
typedef enum {
  RC_GENERIC_ERROR   = 0,
  RC_OK              = 1,
  RC_BUFFER_OVERFLOW = 2,
  RC_CRC_MISMATCH    = 3,
  RC_PACKET_TOO_BIG  = 4,
  RC_CMD_UNSUPPORTED = 5
} 
ResponseCode;
