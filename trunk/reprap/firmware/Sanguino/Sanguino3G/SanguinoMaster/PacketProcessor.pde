// Yep, this is actually -*- c++ -*-

//initialize the firmware to default state.
inline void init_commands()
{
  finishedCommands = 0;
}

//handle our packets.
void process_host_packets()
{
  unsigned long start = millis();
  unsigned long end = start + PACKET_TIMEOUT;

#ifdef ENABLE_COMMS_DEBUG
    //Serial.print("IN: ");
#endif

  //do we have a finished packet?
  while (!hostPacket.isFinished())
  {
    if (Serial.available() > 0)
    {
      digitalWrite(DEBUG_PIN, HIGH);

      //grab a byte and process it.
      byte d = Serial.read();
      hostPacket.process_byte(d);

#ifdef ENABLE_COMMS_DEBUG
      //Serial.print(d, HEX);
      //Serial.print(" ");
#endif
      serial_rx_count++;

      //keep us goign while we have data coming in.
      start = millis();
      end = start + PACKET_TIMEOUT;

      if (hostPacket.getResponseCode() == RC_CRC_MISMATCH)
      {
        //host_crc_errors++;

#ifdef ENABLE_COMMS_DEBUG
        Serial.println("Host CRC Mismatch");
#endif
      }

      digitalWrite(DEBUG_PIN, LOW);
    }

    //are we sure we wanna break mid-packet?
    //have we timed out?
    if (millis() >= end)
    {
#ifdef ENABLE_COMMS_DEBUG
      Serial.println("Host timeout");
#endif
      break;  
    }
  }

  if (hostPacket.isFinished())
  {
    serial_packet_count++;

    byte b = hostPacket.get_8(0);
    // top bit high == bufferable command packet (eg. #128-255)
    if (b & 0x80)
    {
      //do we have room?
      if (commandBuffer.remainingCapacity() >= hostPacket.getLength())
      {
        //okay, throw it in the buffer.
        for (byte i=0; i<hostPacket.getLength(); i++)
          commandBuffer.append(hostPacket.get_8(i));
      }
      else
      {
        hostPacket.overflow();
      }
    }
    // top bit low == reply needed query packet (eg. #0-127)
    else
      handle_query(b);
  }

  //okay, send our response
  hostPacket.sendReply();
}

//this is for handling query commands that need a response.
void handle_query(byte cmd)
{
  //which one did we get?
  switch (cmd)
  {
    //WORKS
    case HOST_CMD_VERSION:
      //get our host version
      host_version = hostPacket.get_16(1);

      //send our version back.
      hostPacket.add_16(FIRMWARE_VERSION);
      break;

    //WORKS
    case HOST_CMD_INIT:
      //just initialize
      initialize();
      break;

    case HOST_CMD_GET_BUFFER_SIZE:
      //send our remaining buffer size.
      hostPacket.add_16(commandBuffer.remainingCapacity());
      break;

    case HOST_CMD_CLEAR_BUFFER:
      //just clear it.
      commandBuffer.clear();
      break;

    case HOST_CMD_GET_POSITION:
      //send our position
      hostPacket.add_32(current_steps.x);
      hostPacket.add_32(current_steps.y);
      hostPacket.add_32(current_steps.z);
      hostPacket.add_8(get_endstop_states());
      break;

    case HOST_CMD_GET_RANGE:
      //send our range
      hostPacket.add_32(range_steps.x);
      hostPacket.add_32(range_steps.y);
      hostPacket.add_32(range_steps.z);
      break;

    case HOST_CMD_SET_RANGE:
      //set our range to what the host tells us
      range_steps.x = (long)hostPacket.get_32(1);
      range_steps.y = (long)hostPacket.get_32(5);
      range_steps.z = (long)hostPacket.get_32(9);

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

        //unpause our tools
        set_tool_pause_state(false);

        //resume stepping.
        enable_needed_steppers();
        enableTimer1Interrupt();
      }
      else
      {
        //pause our activity.
        is_machine_paused = true;

        //pause our tools
        set_tool_pause_state(true);

        //pause stepping
        disableTimer1Interrupt();
        disable_steppers();
      }
      break;

    case HOST_CMD_PROBE:
      //we dont support this yet.
      hostPacket.unsupported();
      break;

    //WORKS
    case HOST_CMD_TOOL_QUERY:
      send_tool_query();
      break;
  
    default:
      hostPacket.unsupported();
  }
}

//this is for handling buffered commands with no response
void handle_commands()
{
  byte flags = 0;
  
  long x;
  long y;
  long z;
  unsigned long step_delay;
  byte cmd;

  //do we have any commands?
  if (commandBuffer.size() > 0)
  {
    /*
    Serial.print("size: ");
    Serial.println(commandBuffer.size(), DEC);
    */
    
    //peek at our command.
    cmd = commandBuffer[0];

    //TODO: only jump in if its command we can handle now
    //ie: queue at zero, or queue has room and its a queue point cmd.
    //then remove all the wait until target reached.
    //queue point?  do we have enough room?
    /*  HOST_CMD_QUEUE_POINT_INC is deprecated.
    if ((cmd == HOST_CMD_QUEUE_POINT_INC || cmd == HOST_CMD_QUEUE_POINT_INC) && pointBuffer.remainingCapacity() < POINT_SIZE)
      return;
    */
    //okay, which command are we handling?
    cmd = commandBuffer.remove_8();

    /*
    Serial.print("cmd: ");
    Serial.println(cmd, DEC);
    */
    
    switch(cmd)
    {
      case HOST_CMD_QUEUE_POINT_ABS:
        x = (long)commandBuffer.remove_32();
        y = (long)commandBuffer.remove_32();
        z = (long)commandBuffer.remove_32();
        step_delay = (unsigned long)commandBuffer.remove_32();
          
        queue_absolute_point(x, y, z, step_delay);
      
        break;

      case HOST_CMD_SET_POSITION:
        wait_until_target_reached(); //dont want to get hasty.

        current_steps.x = (long)commandBuffer.remove_32();
        current_steps.y = (long)commandBuffer.remove_32();
        current_steps.z = (long)commandBuffer.remove_32();
        break;

      //TODO: TEST
      case HOST_CMD_FIND_AXES_MINIMUM:
        wait_until_target_reached(); //dont want to get hasty.

        //no dda interrupts.
        disableTimer1Interrupt();

        //which ones are we going to?
        flags = commandBuffer.remove_8();

        //find them!
        seek_minimums(
          flags & 1,
          flags & 2,
          flags & 4,
          commandBuffer.remove_32(),
          commandBuffer.remove_16());

        //turn on point seeking agian.
        enableTimer1Interrupt();

        break;

      //TODO: TEST
      case HOST_CMD_FIND_AXES_MAXIMUM:
        wait_until_target_reached(); //dont want to get hasty.

        //no dda interrupts.
        disableTimer1Interrupt();

        //find them!
        seek_maximums(
          flags & 1,
          flags & 2,
          flags & 4,
          commandBuffer.remove_32(),
          commandBuffer.remove_16());

        //turn on point seeking agian.
        enableTimer1Interrupt();

        break;

      case HOST_CMD_DELAY:
        wait_until_target_reached(); //dont want to get hasty.

        //take it easy.
        delay(commandBuffer.remove_32());
        break;

      case HOST_CMD_CHANGE_TOOL:
        wait_until_target_reached(); //dont want to get hasty.

        //extruder, i choose you!
        select_tool(commandBuffer.remove_8());
        break;

      case HOST_CMD_WAIT_FOR_TOOL:
        wait_until_target_reached(); //dont want to get hasty.

        //get your temp in gear, you lazy bum.
        
        //what tool / timeout /etc?
        currentToolIndex = commandBuffer.remove_8();
        toolPingDelay = (unsigned int)commandBuffer.remove_16();
        toolTimeout = (unsigned int)commandBuffer.remove_16();

        //check to see if its ready now
        if (!is_tool_ready(currentToolIndex))
        {
          //how often to ping?
          toolNextPing = millis() + toolPingDelay;
          toolTimeoutEnd = millis() + (toolTimeout * 1000);
          
          //okay, put us in ping-tool-until-ready mode
          commandMode = COMMAND_MODE_WAIT_FOR_TOOL;
        }
        break;

      case HOST_CMD_TOOL_COMMAND:
        wait_until_target_reached(); //dont want to get hasty.
        
        send_tool_command();
        break;
  
      default:
        hostPacket.unsupported();
    }
  }
}
