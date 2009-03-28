//#include <stddef.h>
#include <stdint.h>

// our point structure to make things nice.
struct LongPoint {
  long x;
  long y;
  long z;
};

#define COMMAND_MODE_IDLE 0
#define COMMAND_MODE_WAIT_FOR_TOOL 1