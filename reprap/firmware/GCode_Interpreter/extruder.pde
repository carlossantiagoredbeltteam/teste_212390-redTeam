
#include "parameters.h"
#include "pins.h"
#include "ThermistorTable.h"
#include "extruder.h" 

void manage_all_extruders()
{
    for(byte i = 0; i < EXTRUDER_COUNT; i++)
       ex[i]->manage();
}
   
extruder::extruder(byte md_pin, byte ms_pin, byte h_pin, byte f_pin, byte t_pin, byte vd_pin, byte ve_pin)
{
         motor_dir_pin = md_pin;
         motor_speed_pin = ms_pin;
         heater_pin = h_pin;
         fan_pin = f_pin;
         temp_pin = t_pin;
         valve_dir_pin = vd_pin;
         valve_en_pin = ve_pin;
         
	//setup our pins
	pinMode(motor_dir_pin, OUTPUT);
	pinMode(motor_speed_pin, OUTPUT);
	pinMode(heater_pin, OUTPUT);
	pinMode(fan_pin, OUTPUT);
	pinMode(temp_pin, INPUT);
	pinMode(valve_dir_pin, OUTPUT); 
        pinMode(valve_en_pin, OUTPUT);

	//initialize values
	digitalWrite(motor_dir_pin, EXTRUDER_FORWARD);
	analogWrite(fan_pin, 0);
	analogWrite(heater_pin, 0);
	analogWrite(motor_speed_pin, 0);
	digitalWrite(valve_dir_pin, false);
	digitalWrite(valve_en_pin, 0);

        //these our the default values for the extruder.
        e_speed = 128;
        target_celsius = 17;
        max_celsius = 0;
        heater_low = 64;
        heater_high = 255;
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
        set_temperature(target_celsius);
}

byte extruder::wait_till_hot()
{  
  count = 0;
  oldT = get_temperature();
  while (get_temperature() < target_celsius - HALF_DEAD_ZONE)
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

/*
byte extruder::wait_till_cool()
{  
  count = 0;
  oldT = get_temperature();
  while (get_temperature() > target_celsius + HALF_DEAD_ZONE)
  {
	manage_all_extruders();
        count++;
        if(count > 20)
        {
            newT = get_temperature();
            if(newT < oldT)
               oldT = newT;
            else
                return 1;
            count = 0;
        }
	delay(1000);
  }
  return 0;
}
*/

void extruder::temperature_error()
{
      Serial.print("E: ");
      Serial.println(get_temperature());  
}

//warmup if we're too cold; cool down if we're too hot
void extruder::wait_for_temperature()
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

void extruder::valve_set(bool open, int millis)
{
        wait_for_temperature();
	valve_open = open;
	digitalWrite(valve_dir_pin, open);
        digitalWrite(valve_en_pin, 1);
        delay(millis);
        digitalWrite(valve_en_pin, 0);
}


void extruder::set_direction(bool dir)
{
	e_direction = dir;
	digitalWrite(motor_dir_pin, e_direction);
}

void extruder::set_speed(byte sp)
{
    e_speed = sp;
    if(e_speed > 0)
          wait_for_temperature();
    analogWrite(motor_speed_pin, e_speed);
}

void extruder::set_cooler(byte sp)
{
	analogWrite(fan_pin, sp);
}

void extruder::set_temperature(int temp)
{
	target_celsius = temp;
	max_celsius = (temp*11)/10;
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

/*!
  Manages extruder functions to keep temps, speeds etc
  at the set levels.  Should be called only by manage_all_extruders(),
  which should be called in all non-trivial loops.
  o If temp is too low, don't start the motor
  o Adjust the heater power to keep the temperature at the target
 */
void extruder::manage()
{
	//make sure we know what our temp is.
	int current_celsius = get_temperature();
        byte newheat = 0;
  
        //put the heater into high mode if we're not at our target.
        if (current_celsius < target_celsius)
                newheat = heater_high;
        //put the heater on low if we're at our target.
        else if (current_celsius < max_celsius)
                newheat = heater_low;
        
        // Only update heat if it changed
        if (heater_current != newheat) {
                heater_current = newheat;
                analogWrite(heater_pin, heater_current);
        }
}

#ifdef TEST_MACHINE

bool heat_on;

void extruder::heater_test()
{
  int t = get_temperature();
  if(t < 50 && !heat_on)
  {
    Serial.println("\n *** Turning heater on.\n");
    heat_on = true;
    analogWrite(heater_pin, heater_high);
  }

  if(t > 100 && heat_on)
  {
    Serial.println("\n *** Turning heater off.\n");
    heat_on = false;
    analogWrite(heater_pin, 0);
  } 
 
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.print(" deg C. The heater is ");
  if(heat_on)
    Serial.println("on.");
  else
    Serial.println("off.");
  
  delay(2000);  
}

void extruder::drive_test()
{
    Serial.println("Turning the extruder motor on forwards for 5 seconds.");
    set_direction(true);
    set_speed(200);
    delay(5000);
    set_speed(0);
    Serial.println("Pausing for 2 seconds.");
    delay(2000);  
    Serial.println("Turning the extruder motor on backwards for 5 seconds.");
    set_direction(false);
    set_speed(200);
    delay(5000);
    set_speed(0);    
    Serial.println("Pausing for 2 seconds.");
    delay(2000);
}

void extruder::valve_test()
{
    Serial.println("Opening the valve.");
    valve_set(true, 500);
    Serial.println("Pausing for 2 seconds.");
    delay(2000);  
    Serial.println("Closing the valve.");
    valve_set(false, 500);
    Serial.println("Pausing for 2 seconds.");
    delay(2000);  
}

void extruder::fan_test()
{
    Serial.println("Fan on.");
    set_cooler(255);
    Serial.println("Pausing for 2 seconds.");
    delay(2000);  
    Serial.println("Fan off.");
    set_cooler(0);
    Serial.println("Pausing for 2 seconds.");
    delay(2000);  
}



#endif
