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

//this is for handling query commands that need a response.
void handle_query()
{
  //which one did we get?
  switch (packet_data[0])
  {
    case HOST_CMD_VERSION:
	  add_reply_byte(VERSION_MAJOR);
	  add_reply_byte(VERSION_MINOR);
	  break;

    case HOST_CMD_INIT:
      initialize();
      break;
      
    case HOST_CMD_GET_BUFFER_SIZE:
      //TODO: send this:
      //commandBuffer.remainingCapacity();
      break;

    case HOST_CMD_CLEAR_BUFFER:
      commandBuffer.clear();
      break;

    case HOST_CMD_GET_POSITION:
      //TODO: send current position
      break;

    case HOST_CMD_GET_RANGE:
      //TODO: send range.
      break;

    case HOST_CMD_SET_RANGE:
      //TODO: get range.
      break;

    case HOST_CMD_ABORT:
      //TODO: abort our job!
      break;

    case HOST_CMD_PAUSE:
      //TODO: pause the machine.
      break;

    case HOST_CMD_PROBE:
      break;
  }
}

//this is for handling buffered commands with no response
void handle_commands()
{
  //do we have any commands?
  if (commandBuffer.size())
  {
    //okay, which command are we handling?
	byte cmd = commandBuffer.remove();
    switch(cmd)
    {
      case HOST_CMD_QUEUE_POINT_INC:
        break;

      case HOST_CMD_QUEUE_POINT_ABS:
        initialize();
        break;
      
      case HOST_CMD_SET_POSITION:
        break;

      case HOST_CMD_FIND_AXES_MINIMUM:
        break;

      case HOST_CMD_FIND_AXES_MAXIMUM:
        break;

      case HOST_CMD_DELAY:
        break;

      case HOST_CMD_CHANGE_TOOL:
        break;

      case HOST_CMD_WAIT_FOR_TOOL:
        break;
    }
  }
}
