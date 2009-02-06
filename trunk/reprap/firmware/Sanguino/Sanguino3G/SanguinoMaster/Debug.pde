#ifdef ENABLE_DEBUG

void check_tool_version(byte id)
{
  ping_tool(id);

  int version = slavePacket.get_16(1);

  //print_tool(id);
  //Serial.print("version: ");
  //Serial.println(version);
}

void exercise_heater()
{
  set_tool_temp(1, 100);
  while (1)
  {
    get_tool_temp(1);
    delay(500);
  }
}

void exercise_motors()
{
  boolean dir = true;

  for (int i=0; i<256; i++)
  {
    set_motor1_pwm(1, i);
    toggle_motor1(1, dir, 1);
    set_motor2_pwm(1, i);
    toggle_motor2(1, dir, 1);
  }

  dir = !dir;
}

void print_stats()
{
  Serial.println("Stats:");
  Serial.print("Slave TX Count:");
  Serial.println(rs485_tx_count, DEC);
  Serial.print("Slave RX Count:");
  Serial.println(rs485_rx_count, DEC);
  Serial.print("Slave Packet Count: ");
  Serial.println(rs485_packet_count, DEC);
  Serial.print("Slave CRC Errors: ");
  Serial.println(slave_crc_errors, DEC);
  Serial.print("Slave timeouts: ");
  Serial.println(slave_timeouts, DEC);
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
