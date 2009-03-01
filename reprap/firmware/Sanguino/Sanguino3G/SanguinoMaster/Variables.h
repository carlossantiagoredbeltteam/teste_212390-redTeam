//this is the version of our host software
unsigned int host_version = 0;

//these are our packet classes
SimplePacket hostPacket(serial_tx);
SimplePacket slavePacket(rs485_tx);

//are we paused?
boolean is_machine_paused = false;
boolean is_machine_aborted = false;

//init our variables
volatile long max_delta;

volatile long x_counter;
volatile bool x_can_step;
volatile bool x_direction;

volatile long y_counter;
volatile bool y_can_step;
volatile bool y_direction;

volatile long z_counter;
volatile bool z_can_step;
volatile bool z_direction;

//our position tracking variables
volatile LongPoint current_steps;
volatile LongPoint target_steps;
volatile LongPoint delta_steps;
volatile LongPoint range_steps;
volatile LongPoint eventual_steps; //eventual position at end of point queue.

//our point queue variables
byte rawPointBuffer[POINT_QUEUE_SIZE * POINT_SIZE];
CircularBuffer pointBuffer((POINT_QUEUE_SIZE * POINT_SIZE), rawPointBuffer);

//buffer for our commands
uint8_t underlyingBuffer[COMMAND_BUFFER_SIZE];
CircularBuffer commandBuffer(COMMAND_BUFFER_SIZE, underlyingBuffer);

//how many queued commands have we processed?
//this will be used to keep track of our current progress.
unsigned long finishedCommands = 0;
unsigned long finishedPoints = 0;
boolean firstPoint = false;

byte currentToolIndex = 0;

#ifdef USE_SD_CARD
//SD CARD STUFF.
RepRapSDCard card;
File f;
#endif

//our buffer of bytes.
#define BUFFSIZE 64
char buffer[BUFFSIZE];
byte bufferIndex = 0;
byte error = 0;
