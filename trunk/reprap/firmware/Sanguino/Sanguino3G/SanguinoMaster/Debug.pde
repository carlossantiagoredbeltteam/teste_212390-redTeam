#ifdef ENABLE_DEBUG

void check_tool_version(byte id)
{
  Serial.println("checking version");

  ping_tool(id);

  int version = slavePacket.get_16(1);

  print_tool(id);
  Serial.print("version: ");
  Serial.println(version);

  Serial.print("Length: ");
  Serial.println(slavePacket.getLength(), DEC);

  Serial.print("Data: ");
  for (byte i=0; i<3; i++)
  {
	Serial.print(slavePacket.get_8(i), DEC);
	Serial.print(" ");
  }
  Serial.println(".");
}

void print_tool(byte id)
{
  Serial.print("tool #");
  Serial.print(id, DEC);
  Serial.print(" ");
}

void stress_test_tool(byte id)
{
  for (int i=0; i<30000; i++)
  {
    check_tool_version(id);
    delay(250);
  }
}

void get_tool_temp(byte id)
{
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_GET_TEMP);
  slavePacket.sendPacket();

  if (read_tool_response(PACKET_TIMEOUT))
  {
    int temp = slavePacket.get_16(1);
    print_tool(id);
    Serial.print("temp: ");
    Serial.println(temp, DEC);
  }
  else
  {
    print_tool(id);
    Serial.println("failed to get temp!");
  }
}

void set_tool_temp(byte id, unsigned int temp)
{
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_SET_TEMP);
  slavePacket.add_16(temp);
  slavePacket.sendPacket();

  print_tool(id);
  Serial.print("set temp to: ");
  Serial.println(temp, DEC);
}

void set_motor1_pwm(byte id, byte pwm)
{

}

void set_motor1_rpm(byte id, int rpm)
{

}

void toggle_motor1(byte id, boolean dir, boolean enable)
{

}

void toggle_fan(byte id, boolean enable)
{

}

void toggle_valve(byte id, boolean open)
{

}

void get_motor1_pwm(byte id)
{

}

void get_motor1_rpm(byte id)
{

}

void get_filament_status(byte id)
{

}

#endif
