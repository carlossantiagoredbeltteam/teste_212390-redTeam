// These are our query commands from the host
#define SLAVE_CMD_VERSION			0
#define SLAVE_CMD_INIT				1
#define SLAVE_CMD_GET_TEMP			2
#define SLAVE_CMD_SET_TEMP			3
#define SLAVE_CMD_SET_MOTOR_1_PWM	4
#define SLAVE_CMD_SET_MOTOR_2_PWM	5
#define SLAVE_CMD_SET_MOTOR_1_RPM	6
#define SLAVE_CMD_SET_MOTOR_2_RPM	7
#define SLAVE_CMD_SET_MOTOR_1_DIR	8
#define SLAVE_CMD_SET_MOTOR_2_DIR	9
#define SLAVE_CMD_TOGGLE_MOTOR_1	10
#define SLAVE_CMD_TOGGLE_MOTOR_2	11
#define SLAVE_CMD_TOGGLE_FAN		12
#define SLAVE_CMD_TOGGLE_VALVE		13
#define SLAVE_CMD_SET_SERVO_1_POS	14
#define SLAVE_CMD_SET_SERVO_2_POS	15
#define SLAVE_CMD_FILAMENT_STATUS	16
#define SLAVE_CMD_GET_MOTOR_1_PWM	17
#define SLAVE_CMD_GET_MOTOR_2_PWM	18
#define SLAVE_CMD_GET_MOTOR_1_RPM	19
#define SLAVE_CMD_GET_MOTOR_2_RPM	20
#define SLAVE_CMD_SELECT_TOOL		21
#define SLAVE_CMD_IS_TOOL_READY		22

//initialize the firmware to default state.
void init_commands()
{
  finishedCommands = 0;
}

//handle our packets.
void process_packets()
{
  unsigned long start = millis();
  unsigned long end = start + PACKET_TIMEOUT;

  //is there serial data available?
  if (Serial.available() > 0)
  {
    //read through our available data
    while (!masterPacket.isFinished())
    {
      //only try to grab it if theres something in the queue.
      if (Serial.available() > 0)
      {
        //grab a byte and process it.
        byte d = Serial.read();
        masterPacket.process_byte(d);

		//keep us goign while we have data coming in.
		start = millis();
		end = start + PACKET_TIMEOUT;
      }

      //have we timed out?
      if (millis() >= end)
        return;
    }

    //do we have a finished packet?
    if (masterPacket.isFinished())
    {
      //only process packets intended for us.
      if (masterPacket.get_8(0) == RS485_ADDRESS)
      {
        //take some action.
        handle_query();		

        //okay, send our response
        masterPacket.sendReply();

        //how many have we processed?
        finishedCommands++;
      }
    }

	//always clean up the packet.
    masterPacket.init();
  }
}

//this is for handling query commands that need a response.
void handle_query()
{
  byte temp;

  //which one did we get?
  switch (masterPacket.getData(1))
  {
  case SLAVE_CMD_VERSION:
    //get our host version
    master_version = masterPacket.get_16(2);

    //send our version back.
    masterPacket.add_16(FIRMWARE_VERSION);
    break;

  case SLAVE_CMD_INIT:
    //just initialize
    initialize();
    break;

  case SLAVE_CMD_GET_TEMP:
    masterPacket.add_16(current_temperature);
    break;

  case SLAVE_CMD_SET_TEMP:
    target_temperature = masterPacket.get_16(2);
    break;

  case SLAVE_CMD_SET_MOTOR_1_PWM:
    motor1_control = MC_PWM;
    motor1_pwm = masterPacket.get_8(2);
    break;

  case SLAVE_CMD_SET_MOTOR_2_PWM:
    motor2_control = MC_PWM;
    motor2_pwm = masterPacket.get_8(2);
    break;

  case SLAVE_CMD_SET_MOTOR_1_RPM:
    motor1_control = MC_ENCODER;
    motor1_target_rpm = masterPacket.get_32(2);
    break;

  case SLAVE_CMD_SET_MOTOR_2_RPM:
    motor2_control = MC_ENCODER;
    motor2_target_rpm = masterPacket.get_32(2);
    break;

  case SLAVE_CMD_SET_MOTOR_1_DIR:
    temp = masterPacket.get_8(2);
    if (temp & 1)
      motor1_dir = MC_FORWARD;
    else
      motor1_dir = MC_REVERSE;    
    break;

  case SLAVE_CMD_SET_MOTOR_2_DIR:
    temp = masterPacket.get_8(2);
    if (temp & 1)
      motor2_dir = MC_FORWARD;
    else
      motor2_dir = MC_REVERSE;    
    break;

  case SLAVE_CMD_TOGGLE_MOTOR_1:
    temp = masterPacket.get_8(2);
    if (temp & 1<<2)
      motor1_dir = MC_FORWARD;
    else
      motor1_dir = MC_REVERSE;

    if (temp & 1)
      enable_motor_1();
    else
      disable_motor_1();
    break;

  case SLAVE_CMD_TOGGLE_MOTOR_2:
    temp = masterPacket.get_8(2);
    if (temp & 1<<2)
      motor2_dir = MC_FORWARD;
    else
      motor2_dir = MC_REVERSE;

    if (temp & 1)
      enable_motor_2();
    else
      disable_motor_2();
    break;

  case SLAVE_CMD_TOGGLE_FAN:
    temp = masterPacket.get_8(2);
    if (temp & 1)
      enable_fan();
    else
      disable_fan();
    break;

  case SLAVE_CMD_TOGGLE_VALVE:
    temp = masterPacket.get_8(2);
    if (temp & 1)
      open_valve();
    else
      close_valve();
    break;

  case SLAVE_CMD_SET_SERVO_1_POS:
    servo1.attach(9);
    servo1.write(masterPacket.get_8(2));
    break;

  case SLAVE_CMD_SET_SERVO_2_POS:
    servo2.attach(10);
    servo2.write(masterPacket.get_8(2));
    break;

  case SLAVE_CMD_FILAMENT_STATUS:
    //TODO: figure out how to detect this.
    masterPacket.add_8(255);
    break;

  case SLAVE_CMD_GET_MOTOR_1_PWM:
    masterPacket.add_8(motor1_pwm);
    break;

  case SLAVE_CMD_GET_MOTOR_2_PWM:
    masterPacket.add_8(motor2_pwm);
    break;

  case SLAVE_CMD_GET_MOTOR_1_RPM:
    masterPacket.add_32(motor1_current_rpm);
    break;

  case SLAVE_CMD_GET_MOTOR_2_RPM:
    masterPacket.add_32(motor1_current_rpm);
    break;

  case SLAVE_CMD_SELECT_TOOL:
    //do we do anything?
    break;

  case SLAVE_CMD_IS_TOOL_READY:
    masterPacket.add_8(is_tool_ready());
    break;
  }
}
