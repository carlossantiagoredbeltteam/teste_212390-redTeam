byte currentToolIndex = 0;

//initialize our tools
void init_tools()
{
  //perhaps do a scan of tools from address 0-255?
  //with a 10 millisecond timeout, this takes 2.56 seconds.
  //we may also want to store which tools are available in eeprom?
}

//select a tool as our current tool, and let it know.
void select_tool(byte tool)
{
  currentToolIndex = tool;
  
  //TODO: send a "you've been selected packet to the tool"
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
	//TODO: make this!
	
	return true;
}
