//this is the version of our host software
unsigned int host_version = 0;

//these are our packet classes
Packet hostPacket(0);
Packet slavePacket(1);

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

//our point queue variables
byte rawPointBuffer[POINT_QUEUE_SIZE * POINT_SIZE];
CircularBuffer pointBuffer(POINT_QUEUE_SIZE * POINT_SIZE, rawPointBuffer);

//buffer for our commands
uint8_t underlyingBuffer[COMMAND_BUFFER_SIZE];
CircularBuffer commandBuffer(COMMAND_BUFFER_SIZE, underlyingBuffer);

//how many queued commands have we processed?
//this will be used to keep track of our current progress.
unsigned long finishedCommands = 0;

byte currentToolIndex = 0;