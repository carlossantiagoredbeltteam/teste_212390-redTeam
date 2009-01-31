#include <Servo.h>

int current_temperature;
int target_temperature;

// motor control states.
typedef enum {
  MC_PWM = 0,
  MC_ENCODER
} 
MotorControlStyle;

typedef enum {
	MC_FORWARD = 0,
	MC_REVERSE = 1
}
MotorControlDirection;

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

void init_extruder()
{
	
}

void manage_temperature()
{
	
}

void enable_motor_1()
{
	
}

void disable_motor_1()
{
	
}

void enable_fan()
{
	
}

void disable_fan()
{
	
}

void open_valve()
{
	
}

void close_valve()
{
	
}

byte is_tool_ready()
{
	//are we within 5% of the temperature?
	if (current_temperature > (int)(target_temperature * 0.95))
		return 1;
	else
		return 0;
}