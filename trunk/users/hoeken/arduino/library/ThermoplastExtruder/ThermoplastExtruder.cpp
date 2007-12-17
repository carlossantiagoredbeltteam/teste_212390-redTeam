#include "WConstants.h"
#include "ThermoplastExtruder.h"

#define NUMTEMPS  22
short temptable[NUMTEMPS][2] = {
// { adc ,  temp }
	{ 1 ,  608 } ,
	{ 60 ,  176 } ,
	{ 70 ,  166 } ,
	{ 80 ,  157 } ,
	{ 90 ,  150 } ,
	{ 100 ,  143 } ,
	{ 110 ,  137 } ,
	{ 120 ,  131 } ,
	{ 130 ,  125 } ,
	{ 140 ,  120 } ,
	{ 150 ,  115 } ,
	{ 160 ,  110 } ,
	{ 170 ,  105 } ,
	{ 180 ,  100 } ,
	{ 190 ,  95 } ,
	{ 200 ,  91 } ,
	{ 210 ,  86 } ,
	{ 220 ,  81 } ,
	{ 230 ,  75 } ,
	{ 240 ,  70 } ,
	{ 250 ,  64 } ,
	{ 300 ,  4 }
};

/*!
	motor_dir_pin must be a digital output.
	motor_pwm_pin and heater_pin must be PWM capable outputs.
	thermistor_pin must be an analog input.
*/
ThermoplastExtruder::ThermoplastExtruder(byte motor_dir_pin, byte motor_pwm_pin, byte heater_pin, byte thermistor_pin)
{
	this->motor_dir_pin = motor_dir_pin;
	this->motor_pwm_pin = motor_pwm_pin;
	this->heater_pin = heater_pin;
	this->thermistor_pin = thermistor_pin;

	pinMode(this->motor_dir_pin, OUTPUT);
	pinMode(this->motor_pwm_pin, OUTPUT);
	pinMode(this->heater_pin, OUTPUT);

	this->readTemperature();
	this->setSpeed(0);
	this->setDirection(true);
	this->setTargetTemperature(0);
	this->setHeater(0);
}

/*!
  Sets the motor speed from 0-255 (0 is off).
*/
void ThermoplastExtruder::setSpeed(byte speed)
{
	this->motor_pwm = speed;
	analogWrite(this->motor_pwm_pin, this->motor_pwm);
}

/*!
  Sets the motor direction (true = forward, false = backward)
*/
void ThermoplastExtruder::setDirection(bool dir)
{
	this->motor_dir = dir;
	digitalWrite(this->motor_dir_pin, this->motor_dir);
}

void ThermoplastExtruder::setTargetTemperature(int target)
{
	this->target_celsius = target;
}

void ThermoplastExtruder::setHeater(byte heat)
{
	this->heater_pwm = heat;
}

byte ThermoplastExtruder::getHeater()
{
	return this->heater_pwm;
}

byte ThermoplastExtruder::getSpeed()
{
	return this->motor_pwm;
}

bool ThermoplastExtruder::getDirection()
{
	return motor_dir;
}

int ThermoplastExtruder::getTemperature()
{
	return this->current_celsius;
}

int ThermoplastExtruder::getTemperatureInFahrenheit()
{
	return (((this->current_celsius * 9) / 5) + 32);
}

int ThermoplastExtruder::getTargetTemperature()
{
	return target_celsius;
}

/**
*  Samples the temperature and converts it to degrees celsius.
*  Returns degrees celsius.
*/
int ThermoplastExtruder::readTemperature()
{
	this->raw_temperature = this->getRawTemperature();
	this->current_celsius = this->calculateTemperatureFromRaw(this->raw_temperature);
	
	return this->current_celsius;
}

/**
*  Samples the temperature and converts it to degrees celsius.
*  Returns degrees celsius.
*/
int ThermoplastExtruder::calculateTemperatureFromRaw(int raw)
{
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
			
			if (celsius > 255)
				celsius = 255; 

			break;
		}
	}

	// Overflow: We just clamp to 0 degrees celsius
	if (i == NUMTEMPS)
		celsius = 0;
		
	return celsius;
}

/*!
  Manages motor and heater based on measured temperature:
  o If temp is too low, don't start the motor
  o Adjust the heater power to keep the temperature at the target
 */
void ThermoplastExtruder::manageTemperature()
{
	//make sure we know what our temp is.
	this->readTemperature();
	
	// Stop the motor and start the heater if temp is too low
	if (current_celsius < target_celsius)
	{
		analogWrite(motor_pwm_pin, 0);
		analogWrite(heater_pin, heater_pwm);
	}
	// Start the motor again and stop the heater if temp is high enough
	else
	{
		analogWrite(motor_pwm_pin, motor_pwm);
		analogWrite(heater_pin, 0);
	}
}

/*!
  Raw temperature reading
 */
int ThermoplastExtruder::getRawTemperature()
{
	return analogRead(thermistor_pin);
}
