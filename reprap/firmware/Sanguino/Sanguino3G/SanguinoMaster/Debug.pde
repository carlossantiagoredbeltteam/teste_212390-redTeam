#ifdef ENABLE_DEBUG

void check_tool_version(byte id)
{
  ping_tool(id);

  int version = slavePacket.get_16(1);

  //print_tool(id);
  //Serial.print("version: ");
  //Serial.println(version);
}

void print_tool(byte id)
{
  Serial.print("tool #");
  Serial.print(id, DEC);
  Serial.print(" ");
}

void get_tool_temp(byte id)
{
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_GET_TEMP);
  send_packet();

  int temp = slavePacket.get_16(1);
  print_tool(id);
  Serial.print("temp: ");
  Serial.println(temp, DEC);
}

void set_tool_temp(byte id, unsigned int temp)
{
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_SET_TEMP);
  slavePacket.add_16(temp);
  send_packet();

  print_tool(id);
  Serial.print("set temp to: ");
  Serial.println(temp, DEC);
}

void set_motor1_pwm(byte id, byte pwm)
{
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_SET_MOTOR_1_PWM);
  slavePacket.add_8(pwm);
  send_packet();

  //print_tool(id);
  //Serial.print("set motor1 pwm to: ");
  //Serial.println(pwm, DEC);
}

void set_motor2_pwm(byte id, byte pwm)
{
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_SET_MOTOR_2_PWM);
  slavePacket.add_8(pwm);
  send_packet();

  //print_tool(id);
  //Serial.print("set motor2 pwm to: ");
  //Serial.println(pwm, DEC);
}


void set_motor1_rpm(byte id, int rpm)
{

}

void toggle_motor1(byte id, boolean dir, boolean enable)
{
  byte flags = 0;

  if (enable)
	flags += 1;

  if (dir)
	flags += 2;
	
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_TOGGLE_MOTOR_1);
  slavePacket.add_8(flags);
  send_packet();
}

void toggle_motor2(byte id, boolean dir, boolean enable)
{
  byte flags = 0;

  if (enable)
	flags += 1;

  if (dir)
	flags += 2;
	
  slavePacket.init();
  slavePacket.add_8(id);
  slavePacket.add_8(SLAVE_CMD_TOGGLE_MOTOR_2);
  slavePacket.add_8(flags);
  send_packet();
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
