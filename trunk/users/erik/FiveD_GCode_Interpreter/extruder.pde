#include "parameters.h"
#include "pins.h"
#include "ThermistorTable.h"
#include "extruder.h" 

void manage_all_extruders()
{
    for(byte i = 0; i < EXTRUDER_COUNT; i++)
       ex[i]->manage();
}
   
extruder::extruder(byte md_pin, byte ms_pin, byte h_pin, byte f_pin, byte t_pin, byte vd_pin, byte ve_pin, byte se_pin)
{
         motor_dir_pin = md_pin;
         motor_speed_pin = ms_pin;
         heater_pin = h_pin;
         fan_pin = f_pin;
         temp_pin = t_pin;
         valve_dir_pin = vd_pin;
         valve_en_pin = ve_pin;
         step_en_pin = se_pin;
         
	//setup our pins
	pinMode(motor_dir_pin, OUTPUT);
	pinMode(motor_speed_pin, OUTPUT);
	//NOT NEEDED: pinMode(heater_pin, OUTPUT);

	pinMode(temp_pin, INPUT);
	//pinMode(valve_dir_pin, OUTPUT); 
        //pinMode(valve_en_pin, OUTPUT);

	//initialize values
	digitalWrite(motor_dir_pin, EXTRUDER_FORWARD);
	analogWrite(heater_pin, 64);
	//digitalWrite(heater_pin, LOW);//ERIK: changed to digital, LOW
	digitalWrite(motor_speed_pin, 0);// ERIK: changed to digital
	//digitalWrite(valve_dir_pin, false);
	///digitalWrite(valve_en_pin, 0);


// The step enable pin and the fan pin are the same...
// We can have one, or the other, but not both

        if(step_en_pin >= 0)
        {
          pinMode(step_en_pin, OUTPUT);
	  disableStep();
        } else
        {
	  pinMode(fan_pin, OUTPUT);
          analogWrite(fan_pin, 0);
        }

// From makerbot branch:
#if TEMP_PID
  temp_iState = 0;
  temp_dState = 0;
  temp_pGain = TEMP_PID_PGAIN;
  temp_iGain = TEMP_PID_IGAIN;
  temp_dGain = TEMP_PID_DGAIN;
  
  temp_pid_update_windup();
#endif

  temp_control_enabled = true;
  current_temperature = 0;
  target_temperature = 100; // target_celcius
  max_temperature = 0; // max_celcius

  //these our the default values for the extruder.
        e_speed = 0;
        byte heater_low = 64;
        byte heater_high = 255;
        heater_current = 0;
        valve_open = false;
        
//this is for doing encoder based extruder control
        rpm = 0;
        e_delay = 0;
        error = 0;
        last_extruder_error = 0;
        error_delta = 0;
        e_direction = EXTRUDER_FORWARD;
        
        //default to cool
        set_temperature(target_temperature);
}


byte extruder::wait_till_hot()
{  
  count = 0;
  oldT = get_temperature();
  while (get_temperature() < target_temperature - HALF_DEAD_ZONE)
  {
	manage_all_extruders();
        count++;
        if(count > 20)
        {
            newT = get_temperature();
            if(newT > oldT)
               oldT = newT;
            else
                return 1;
            count = 0;
        }
	delay(1000);
  }
  return 0;
}



void extruder::valve_set(bool open, int millis)
{
        wait_for_temperature();
	valve_open = open;
	digitalWrite(valve_dir_pin, open);
        digitalWrite(valve_en_pin, 1);
        delay(millis);
        digitalWrite(valve_en_pin, 0);
}


void extruder::set_temperature(int temp)
{
	target_temperature = temp;
	max_temperature = (temp*11)/10;

        // If we've turned the heat off, we might as well disable the extrude stepper
        if(target_temperature < 0)
          ex[extruder_in_use]->disableStep(); 
}

/**
*  Samples the temperature and converts it to degrees celsius.
*  Returns degrees celsius.
*/
int extruder::get_temperature()
{
#ifdef USE_THERMISTOR
	int raw = sample_temperature(temp_pin);

	int celsius = 0;
	byte i;

	for (i=1; i<NUMTEMPS; i++)
	{
		if (temptable[i][0] > raw)
		{
			celsius  = temptable[i-1][1] + 
				(raw - temptable[i-1][0]) * 
				(temptable[i][1] - temptable[i-1][1]) /
				(temptable[i][0] - temptable[i-1][0]);

			break;
		}
	}

        // Overflow: Set to last value in the table
        if (i == NUMTEMPS) celsius = temptable[i-1][1];
        // Clamp to byte
        if (celsius > 255) celsius = 255; 
        else if (celsius < 0) celsius = 0; 

	return celsius;
#else
  return ( 5.0 * sample_temperature(temp_pin) * 100.0) / 1024.0;
#endif
}



/*
* This function gives us an averaged sample of the analog temperature pin.
*/
int extruder::sample_temperature(byte pin)
{
	int raw = 0;
	
	//read in a certain number of samples
	for (byte i=0; i<TEMPERATURE_SAMPLES; i++)
		raw += analogRead(pin);
		
	//average the samples
	raw = raw/TEMPERATURE_SAMPLES;

	//send it back.
	return raw;
}


#if TEMP_PID
int extruder::temp_update(int dt)
{
  int output;
  int error;
  float pTerm, iTerm, dTerm;
  
  if (temp_control_enabled) {
    error = target_temperature - current_temperature;
    
    pTerm = temp_pGain * error;
    
    temp_iState += error;
    temp_iState = constrain(temp_iState, temp_iState_min, temp_iState_max);
    iTerm = temp_iGain * temp_iState;
    
    dTerm = temp_dGain * (current_temperature - temp_dState);
    temp_dState = current_temperature;
    
    output = pTerm + iTerm - dTerm;
    output = constrain(output, 0, 255);
  } else {
    output = 0;
  }
  return output;
}
 
void extruder::temp_pid_update_windup()
{
  temp_iState_min = -TEMP_PID_INTEGRAL_DRIVE_MAX/temp_iGain;
  temp_iState_max = TEMP_PID_INTEGRAL_DRIVE_MAX/temp_iGain;
}

#else

int extruder::temp_update(int dt)
{
  int output;
  
  if (temp_control_enabled) {
    //put the heater into high mode if we're not at our target.
    if (current_temperature < target_temperature)
      output = heater_high;
    //put the heater on low if we're at our target.
    else if (current_temperature < max_temperature)
      output = heater_low;
    //turn the heater off if we're above our max.
    else
      output = 0;
  } else {
    output = 0;
  }
  return output;
}
#endif /* TEMP_PID */


/*void extruder::manage()
{
 //int output = random(255);
// analogWrite(12,128);
 // 
 //digitalWrite(12,(output > 64)?HIGH:LOW);
 //Serial.print("!");
 //delay(200);
}
*/
/*!
Manages motor and heater based on measured temperature:
o If temp is too low, don't start the motor
o Adjust the heater power to keep the temperature at the target
*/
// NEW
void extruder::manage()
{
  int output, dt;
  unsigned long time;

  //make sure we know what our temp is.
  current_temperature = get_temperature();
    
  // ignoring millis rollover for now
  time = millis();
  dt = time - temp_prev_time;

  if (dt > TEMP_UPDATE_INTERVAL)
  {
    temp_prev_time = time;
    output = temp_update(dt);
    //digitalWrite(DEBUG_PIN, (output > 0)?HIGH:LOW);
//    analogWrite(12, output);
//    delay(200);
    digitalWrite(heater_pin, (output > 128)?HIGH:LOW);
    softPWMduty = output;
//    softPWM(); // deze moet gewoon aan of uit...
  }
}


/*!
  Manages extruder functions to keep temps, speeds etc
  at the set levels.  Should be called only by manage_all_extruders(),
  which should be called in all non-trivial loops.
  o If temp is too low, don't start the motor
  o Adjust the heater power to keep the temperature at the target
 */
// OLD
/*
void extruder::manage()
{
	//make sure we know what our temp is.
	int current_celsius = get_temperature();
        int newheat = 0;
  
        //put the heater into high mode if we're not at our target.
        if (current_celsius < target_celsius)
                newheat = 255;
        //put the heater on low if we're at our target.
        else if (current_celsius < max_celsius)
                newheat = 64;
        
        // Only update heat if it changed
        if (heater_current != newheat) {
                heater_current = newheat;
//                analogWrite(heater_pin, newheat); // STandard 
                analogWrite(12, newheat); // STandard 
//                digitalWrite(heater_pin, heater_current);//ERIK
        }
}

*/


// NOT USED


