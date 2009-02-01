// Yep, this is actually -*- c++ -*-

// These are our query commands from the host
#define SLAVE_CMD_VERSION                0
#define SLAVE_CMD_INIT                   1
#define SLAVE_CMD_GET_TEMP               2
#define SLAVE_CMD_SET_TEMP               3
#define SLAVE_CMD_SET_MOTOR_1_PWM        4
#define SLAVE_CMD_SET_MOTOR_2_PWM        5
#define SLAVE_CMD_SET_MOTOR_1_RPM        6
#define SLAVE_CMD_SET_MOTOR_2_RPM        7
#define SLAVE_CMD_SET_MOTOR_1_DIR        8
#define SLAVE_CMD_SET_MOTOR_2_DIR        9
#define SLAVE_CMD_TOGGLE_MOTOR_1        10
#define SLAVE_CMD_TOGGLE_MOTOR_2        11
#define SLAVE_CMD_TOGGLE_FAN            12
#define SLAVE_CMD_TOGGLE_VALVE          13
#define SLAVE_CMD_SET_SERVO_1_POS       14
#define SLAVE_CMD_SET_SERVO_2_POS       15
#define SLAVE_CMD_FILAMENT_STATUS       16
#define SLAVE_CMD_GET_MOTOR_1_PWM       17
#define SLAVE_CMD_GET_MOTOR_2_PWM       18
#define SLAVE_CMD_GET_MOTOR_1_RPM       19
#define SLAVE_CMD_GET_MOTOR_2_RPM       20
#define SLAVE_CMD_SELECT_TOOL           21
#define SLAVE_CMD_IS_TOOL_READY         22

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
bool ping_tool(byte i)
{
  slavePacket.init();

  slavePacket.add_8(i);
  slavePacket.add_8(SLAVE_CMD_VERSION);
  slavePacket.add_16(FIRMWARE_VERSION);
  slavePacket.sendPacket();

  return read_tool_response(PACKET_TIMEOUT);
}

//initialize a tool to its default state.
void init_tool(byte i)
{
  slavePacket.init();

  slavePacket.add_8(i);
  slavePacket.add_8(SLAVE_CMD_INIT);
  slavePacket.sendPacket();

  read_tool_response(PACKET_TIMEOUT);
}

//select a tool as our current tool, and let it know.
void select_tool(byte tool)
{
  currentToolIndex = tool;

  slavePacket.init();

  slavePacket.add_8(tool);
  slavePacket.add_8(SLAVE_CMD_SELECT_TOOL);
  slavePacket.sendPacket();

  read_tool_response(PACKET_TIMEOUT);
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
  slavePacket.sendPacket();

  //did we get a response?
  if (read_tool_response(PACKET_TIMEOUT))
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
  read_tool_response(PACKET_TIMEOUT);

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
  read_tool_response(PACKET_TIMEOUT);
}

bool read_tool_response(int timeout)
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

        //keep processing while there's data. 
        start = millis();
        end = start + timeout;
    }

    //our timeout guy.
    if (millis() > end)
      return false;
  }

  return true;
}

void set_tool_pause_state(bool paused)
{
  //TODO: pause/unpause tool.
}
