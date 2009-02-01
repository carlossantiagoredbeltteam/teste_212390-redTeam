//this is the version of our host software
unsigned int master_version = 0;

//how many queued commands have we processed?
//this will be used to keep track of our current progress.
unsigned long finishedCommands = 0;

//these are our packet classes
Packet masterPacket(0);

//are we paused?
boolean is_tool_paused = false;

int current_temperature;
int target_temperature;

MotorControlStyle motor1_control = MC_PWM;
MotorControlDirection motor1_dir = MC_FORWARD;
byte motor1_pwm = 0;
long motor1_target_rpm = 0;
long motor1_current_rpm = 0;

MotorControlStyle motor2_control = MC_PWM;
MotorControlDirection motor2_dir = MC_FORWARD;
byte motor2_pwm = 0;
long motor2_target_rpm = 0;
long motor2_current_rpm = 0;

Servo servo1;
Servo servo2;