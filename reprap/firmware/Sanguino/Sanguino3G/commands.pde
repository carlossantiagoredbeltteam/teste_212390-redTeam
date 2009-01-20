// These are our query commands from the host
#define HOST_CMD_VERSION			0
#define HOST_CMD_INIT				1
#define HOST_CMD_GET_BUFFER_SIZE	2
#define HOST_CMD_CLEAR_BUFFER		3
#define HOST_CMD_GET_POSITION		4
#define HOST_CMD_GET_RANGE			5
#define HOST_CMD_SET_RANGE			6
#define HOST_CMD_ABORT				7
#define HOST_CMD_PAUSE				8
#define HOST_CMD_PROBE				9

// These are our bufferable commands from the host
#define HOST_CMD_QUEUE_POINT_INC	128
#define HOST_CMD_QUEUE_POINT_ABS	129
#define HOST_CMD_SET_POSITION		130
#define HOST_CMD_FIND_AXES_MINIMUM	131
#define HOST_CMD_FIND_AXES_MAXIMUM	132
#define HOST_CMD_DELAY				133
#define HOST_CMD_CHANGE_TOOL		134
#define HOST_CMD_WAIT_FOR_TOOL		135

//how many queued commands have we processed?
//this will be used to keep track of our current progress.
unsigned long finishedCommands = 0;

//initialize the firmware to default state.
void init_commands()
{
  finishedCommands = 0;
}

void handle_query()
{
}

void handle_commands()
{
  
}
