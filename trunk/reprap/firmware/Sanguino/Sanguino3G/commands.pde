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
      //get our host version
      host_version_major = packet_data[2];
      host_version_minor = packet_data[1];
      
      //send our version back.
	  add_reply_8(VERSION_MINOR);
	  add_reply_8(VERSION_MAJOR);
	  break;

    case HOST_CMD_INIT:
      //just initialize
      initialize();
      break;
      
    case HOST_CMD_GET_BUFFER_SIZE:
      //send our remaining buffer size.
      add_reply_16(commandBuffer.remainingCapacity());
      break;

    case HOST_CMD_CLEAR_BUFFER:
      //just clear it.
      commandBuffer.clear();
      break;

    case HOST_CMD_GET_POSITION:
      //send our position
      add_reply_32(current_steps.x);
      add_reply_32(current_steps.y);
      add_reply_32(current_steps.z);
      add_reply_8(get_endstop_states());
      break;

    case HOST_CMD_GET_RANGE:
      //send our range
      add_reply_32(range_steps.x);
      add_reply_32(range_steps.y);
      add_reply_32(range_steps.z);
      break;

    case HOST_CMD_SET_RANGE:
      //set our range to what the host tells us
      range_steps.x = make_uint32_t(packet_data[1], packet_data[2], packet_data[3], packet_data[4]);
      range_steps.x = make_uint32_t(packet_data[5], packet_data[6], packet_data[7], packet_data[8]);
      range_steps.x = make_uint32_t(packet_data[9], packet_data[10], packet_data[11], packet_data[12]);
      
      //write it back to eeprom
      write_range_to_eeprom();
      break;

    case HOST_CMD_ABORT:
      //support a microcontrollers right to choice.
      abort_print();
      break;

    case HOST_CMD_PAUSE:
      if (is_machine_paused)
      {
        //unpause our machine.
	    is_machine_paused = false;

	    //TODO: unpause our tool?
	    
	    //resume stepping.
	    enableTimer1Interrupt();
        enable_steppers();
      }
      else
      {
        //pause our activity.
        is_machine_paused = true;

	    //TODO: pause our tool?
        
        //pause stepping
        disableTimer1Interrupt();
        disable_steppers();
      }
      break;

    case HOST_CMD_PROBE:
      //we dont support this yet.
      response_packet_code = RC_CMD_UNSUPPORTED;
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
		queue_incremental_point(
			make_uint16_t(commandBuffer.remove(), commandBuffer.remove()),
			make_uint16_t(commandBuffer.remove(), commandBuffer.remove()),
			make_uint16_t(commandBuffer.remove(), commandBuffer.remove()),
			commandBuffer.remove(),
			make_uint16_t(commandBuffer.remove(), commandBuffer.remove())			
		);
        break;

      case HOST_CMD_QUEUE_POINT_ABS:
		queue_absolute_point(
			make_uint32_t(commandBuffer.remove(), commandBuffer.remove(), commandBuffer.remove(), commandBuffer.remove()),
			make_uint32_t(commandBuffer.remove(), commandBuffer.remove(), commandBuffer.remove(), commandBuffer.remove()),
			make_uint32_t(commandBuffer.remove(), commandBuffer.remove(), commandBuffer.remove(), commandBuffer.remove()),
			commandBuffer.remove(),
			make_uint16_t(commandBuffer.remove(), commandBuffer.remove())			
		);
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
