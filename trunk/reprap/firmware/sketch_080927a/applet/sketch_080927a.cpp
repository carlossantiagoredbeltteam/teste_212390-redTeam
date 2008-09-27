#include "WProgram.h"
#define EXTRUDER_MOTOR_SPEED_PIN  13
#define EXTRUDER_MOTOR_DIR_PIN    20
#define EXTRUDER_HEATER_PIN       12
#define EXTRUDER_FAN_PIN          19
#define VALVE_DIR_PIN             21
#define VALVE_ENABLE_PIN          22  

void setup()
{
  pinMode(EXTRUDER_MOTOR_SPEED_PIN, OUTPUT);
  pinMode(EXTRUDER_MOTOR_DIR_PIN, OUTPUT);
  pinMode(EXTRUDER_HEATER_PIN, OUTPUT);
  pinMode(EXTRUDER_FAN_PIN, OUTPUT);
  pinMode(VALVE_DIR_PIN, OUTPUT);
  pinMode(VALVE_ENABLE_PIN, OUTPUT);  
}
void loop()
{
  digitalWrite(EXTRUDER_MOTOR_SPEED_PIN, 0);
  digitalWrite(EXTRUDER_MOTOR_DIR_PIN, 0);
  digitalWrite(EXTRUDER_HEATER_PIN, 0);
  digitalWrite(EXTRUDER_FAN_PIN, 0);
  digitalWrite(VALVE_DIR_PIN, 0);
  digitalWrite(VALVE_ENABLE_PIN, 0);
  
  delay(1000);
  
  digitalWrite(EXTRUDER_MOTOR_SPEED_PIN, 1);
  digitalWrite(EXTRUDER_MOTOR_DIR_PIN, 1);
  digitalWrite(EXTRUDER_HEATER_PIN, 1);
  digitalWrite(EXTRUDER_FAN_PIN, 1);
  digitalWrite(VALVE_DIR_PIN, 1);
  digitalWrite(VALVE_ENABLE_PIN, 1);
  
  delay(1000);
  
  digitalWrite(EXTRUDER_MOTOR_DIR_PIN, 0);
  digitalWrite(VALVE_DIR_PIN, 0);
}
int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

