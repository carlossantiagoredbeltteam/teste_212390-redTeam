// These are our query commands from the host
#define SLAVE_CMD_VERSION			0
#define SLAVE_CMD_INIT				1
#define SLAVE_CMD_GET_TEMP			2
#define SLAVE_CMD_SET_TEMP			3
#define SLAVE_CMD_SELECT_TOOL		21
#define SLAVE_CMD_IS_TOOL_READY		22

byte currentToolIndex = 0;

//initialize our tools
void init_tools()
{
  //do a scan of tools from address 0-255?
  //with a 1 millisecond timeout, this takes ~0.256 seconds.
  //we may also want to store which tools are available in eeprom?
  for (int i=0; i<256; i++)
  {
	//are you out there?
	if (ping_tool(i))
	{
		init_tool(i);
	}
  }
}

//ask a tool if its there.
boolean ping_tool(byte i)
{
	slavePacket.init();
	
	slavePacket.add_8(i);
	slavePacket.add_8(SLAVE_CMD_VERSION);
	slavePacket.add_16(FIRMWARE_VERSION);
	slavePacket.sendPacket();
	
	return read_tool_response(1);
}

//initialize a tool to its default state.
void init_tool(byte i)
{
	slavePacket.init();
	
	slavePacket.add_8(i);
	slavePacket.add_8(SLAVE_CMD_INIT);
	slavePacket.sendPacket();
	
	read_tool_response(1);
}

//select a tool as our current tool, and let it know.
void select_tool(byte tool)
{
  currentToolIndex = tool;
  
  slavePacket.init();

  slavePacket.add_8(tool);
  slavePacket.add_8(SLAVE_CMD_SELECT_TOOL);
  slavePacket.sendPacket();

  read_tool_response(1);
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
	unsigned long now = millis();
	unsigned long end = now + (timeout_seconds * 1000);
	
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
boolean is_tool_ready(byte tool)
{
	slavePacket.init();
	
	slavePacket.add_8(tool);
	slavePacket.add_8(SLAVE_CMD_IS_TOOL_READY);
	slavePacket.sendPacket();
	
	//did we get a response?
	if (read_tool_response(1))
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
	slavePacket.sendPacket();
	read_tool_response(60000);
	
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
	slavePacket.sendPacket();
	read_tool_response(60000);
}

boolean read_tool_response(int timeout)
{
	//figure out our timeout stuff.
	long start = millis();
	long end = start + timeout;
	
	//keep reading until we got it.
	while (!slavePacket.isFinished())
	{
	  //read through our available data
	  if (Serial.available() > 0)
	  {
	    //grab a byte and process it.
	    byte d = Serial1.read();
	    slavePacket.process_byte(d);

		//our timeout guy.
		if (millis() > end)
			return false;
	  }
	}
	
	return true;
}
