// Yep, this is actually -*- c++ -*-

//initialize our tools
void init_tools()
{
  //do a scan of tools from address 0-255?
  //with a 1 millisecond timeout, this takes ~0.256 seconds.
  //we may also want to store which tools are available in eeprom?
#ifdef SCAN_TOOLS_ON_STARTUP
  for (int i=0; i<256; i++)
  {
    //are you out there?
    if (ping_tool(i))
    {
      init_tool(i);
    }
  }
#endif
}

//ask a tool if its there.
bool ping_tool(byte i)
{
  slavePacket.init();

  slavePacket.add_8(i);
  slavePacket.add_8(SLAVE_CMD_VERSION);
  slavePacket.add_16(FIRMWARE_VERSION);
  return send_packet();
}

//initialize a tool to its default state.
void init_tool(byte i)
{
  slavePacket.init();

  slavePacket.add_8(i);
  slavePacket.add_8(SLAVE_CMD_INIT);
  send_packet();
}

//select a tool as our current tool, and let it know.
void select_tool(byte tool)
{
  currentToolIndex = tool;

  slavePacket.init();

  slavePacket.add_8(tool);
  slavePacket.add_8(SLAVE_CMD_SELECT_TOOL);
  send_packet();
}

//ping the tool until it tells us its ready
void wait_for_tool_ready_state(byte tool, int delay_millis, int timeout_seconds)
{
  //setup some defaults
  if (delay_millis == 0)
    delay_millis = 100;
  if (timeout_seconds == 0)
    timeout_seconds = 60;

  //check for our end time.
  unsigned long end = millis() + (timeout_seconds * 1000);

  //do it until we hear something, or time out.
  while (1)
  {
    //did we time out yet?
    if (millis() >= end)
      return;

    //did we hear back from the tool?
    if (is_tool_ready(tool))
      return;

    //try again...
    delay(delay_millis);
  }
}

//is our tool ready for action?
bool is_tool_ready(byte tool)
{
  slavePacket.init();

  slavePacket.add_8(tool);
  slavePacket.add_8(SLAVE_CMD_IS_TOOL_READY);

  //did we get a response?
  if (send_packet())
  {
    //is it true?
    if (slavePacket.get_8(1) == 1)
      return true;
  }

  //bail.
  return false;
}

void send_tool_query()
{
  //zero out our packet
  slavePacket.init();

  //load up our packet.
  for (byte i=1; i<hostPacket.getLength(); i++)
    slavePacket.add_8(hostPacket.get_8(i));

  //send it and then get our response
  send_packet();
  
  //now load it up into the host.
  for (byte i=0; i<slavePacket.getLength(); i++)
    hostPacket.add_8(slavePacket.get_8(i));
}

void send_tool_command()
{
  //zero out our packet
  slavePacket.init();

  //add in our tool id and command.
  slavePacket.add_16(commandBuffer.remove_16());

  //load up our packet.
  byte len = commandBuffer.remove_8();
  for (byte i=0; i<len; i++)
    slavePacket.add_8(commandBuffer.remove_8());

  //send it and then get our response
  send_packet();
}

boolean send_packet()
{
#ifdef ENABLE_COMMS_DEBUG
  Serial.println("sending packet.");
#endif

  slavePacket.sendPacket();
  
  //wait for guy to catch up?
  delayMicrosecondsInterruptible(50);
  
  return read_tool_response(PACKET_TIMEOUT);
}

bool read_tool_response(int timeout)
{
  //figure out our timeout stuff.
  long start = millis();
  long end = start + timeout;

#ifdef ENABLE_COMMS_DEBUG
  Serial.println("reading response.");
#endif

  //keep reading until we got it.
  while (!slavePacket.isFinished())
  {
    //read through our available data
    if (Serial1.available() > 0)
    {
      //grab a byte and process it.
      byte d = Serial1.read();
      slavePacket.process_byte(d);

#ifdef ENABLE_COMMS_DEBUG
      Serial.print("IN:");
      Serial.print(d, HEX);
      Serial.print("/");
      Serial.println(d, BIN);
#endif
      //keep processing while there's data. 
      start = millis();
      end = start + timeout;
    }

    //not sure if we need this yet.
    //our timeout guy.
    //if (millis() > end)
    //  return false;
  }

  return true;
}

void set_tool_pause_state(bool paused)
{
  //TODO: pause/unpause tool.
}
