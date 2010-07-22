// Class for controlling each extruder
//
// Adrian Bowyer 14 May 2009

#ifndef EXTRUDER_H
#define EXTRUDER_H

#define EXTRUDER_FORWARD LOW
#define EXTRUDER_REVERSE HIGH

#define EXTRUDER_COUNT 1

void manage_all_extruders();

class extruder
{
private:
// NEW ERIK
#if TEMP_PID
    float temp_pGain;
    float temp_iGain;
    float temp_dGain;

    int temp_dState;
    long temp_iState;
    float temp_iState_max; // set in update_windup
    float temp_iState_min; // set in update_windup
#endif
  // NEW ERIK
  unsigned long temp_prev_time; // ms
  bool temp_control_enabled;
  int temp_update(int dt);  
//these our the default values for the extruder.
    byte e_speed;
    int target_temperature;
    int max_temperature;
    int current_temperature;
    byte heater_low;
    byte heater_high;
    byte heater_current;
    int extrude_step_count;

// These are used for temperature control    
    byte count ;
    int oldT, newT;
    
//this is for doing encoder based extruder control
    int rpm;
    long e_delay;
    int error;
    int last_extruder_error;
    int error_delta;
    bool e_direction;
    bool valve_open;

// The pins we control
    byte motor_dir_pin, motor_speed_pin, heater_pin, fan_pin, temp_pin, valve_dir_pin, valve_en_pin, step_en_pin;
    
public:

   extruder(byte md_pin, byte ms_pin, byte h_pin, byte f_pin, byte t_pin, byte vd_pin, byte ve_pin, byte se_pin);
   void wait_for_temperature();
   //byte wait_till_cool();
   byte wait_till_hot();
   void temperature_error();  
   void valve_set(bool open, int millis);
   void set_direction(bool direction);
//   void set_speed(float es);
   void set_cooler(byte e_speed);
   void set_temperature(int temp);
   int get_temperature();
   int sample_temperature(byte pin);
   void manage();
   
   // NEW ERIK
   void temp_pid_update_windup();
   
   // Interrupt setup and handling functions for stepper-driven extruders
   
   void interrupt();
   void step();

   void enableStep();
   void disableStep();
   
};

inline void extruder::enableStep()
{
  if(step_en_pin < 0)
    return;
  digitalWrite(step_en_pin, LOW); //ERIK // Should be ENABLE_ON, but I have a mix of controllers
}

inline void extruder::disableStep()
{
  if(step_en_pin < 0)
    return;
  digitalWrite(step_en_pin, HIGH);//ERIK
//  Serial.println("disableStep");
}

inline void extruder::step()
{
//   for(int a=0;a<50;a++)
//   {
//   digitalWrite(motor_dir_pin,digitalRead(motor_dir_pin));
   digitalWrite(motor_speed_pin, LOW);//ERIK
   //
   delayMicroseconds(5);
   digitalWrite(motor_speed_pin, HIGH); //ERIK
   //delay(1000);
//   }
//  Serial.print("step. Dir pin: ");
  //if(digitalRead(motor_dir_pin)) 
//  Serial.println(motor_dir_pin);
  //else  Serial.println(" reverse");
}

inline void extruder::temperature_error()
{
      Serial.print("E: ");
      Serial.println(get_temperature());  
}

//warmup if we're too cold; cool down if we're too hot
inline void extruder::wait_for_temperature()
{
/*
  if(wait_till_cool())
   {
      temperature_error();
      return;
   }
*/
   if(wait_till_hot())
     temperature_error();
}

inline void extruder::set_direction(bool dir)
{
	e_direction = dir;
	digitalWrite(motor_dir_pin, !e_direction);
}

inline void extruder::set_cooler(byte sp)
{
  if(step_en_pin >= 0) // Step enable conflicts with the fan
    return;
  analogWrite(fan_pin, sp);
}

#endif
