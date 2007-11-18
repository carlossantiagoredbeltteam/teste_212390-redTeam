
#include "WConstants.h"
#include "ThermoplastExtruder.h"

ThermoplastExtruder::ThermoplastExtruder(int motor_dir_pin, int motor_speed_pin, int heater_pin, int thermistor_pin)
{
	this->motor_dir_pin = motor_dir_pin;
    this->motor_speed_pin = motor_speed_pin;
	this->heater_pin = heater_pin;
    this->thermistor_pin = thermistor_pin;

	pinMode(this->motor_dir_pin, OUTPUT);
	pinMode(this->motor_speed_pin, OUTPUT);
	pinMode(this->heater_pin, OUTPUT);
	
	this->readTemp();
	this->setDirection(1);
	this->setSpeed(0);
	this->setTargetTemp(0);
}

void ThermoplastExtruder::readState()
{
	this->readTemp();
}

void ThermoplastExtruder::setSpeed(byte whatSpeed)
{
	speed = whatSpeed;
	analogWrite(motor_speed_pin, speed);
}

void ThermoplastExtruder::setDirection(bool direction)
{
	this->direction = direction;
	digitalWrite(motor_dir_pin, direction);
}

void ThermoplastExtruder::setTargetTemp(int target)
{
	target_temp = target;
}

byte ThermoplastExtruder::getSpeed()
{
	return speed;
}

bool ThermoplastExtruder::getDirection()
{
	return direction;
}

int ThermoplastExtruder::getTemp()
{
	return current_temp;
}

int ThermoplastExtruder::readTemp()
{
	current_temp = analogRead(thermistor_pin);

	return current_temp;
}

int ThermoplastExtruder::getTargetTemp()
{
	return target_temp;
}

void ThermoplastExtruder::manageTemp()
{
	//turn off our motor if we're not at our target temp yet.
	if (speed && current_temp > (target_temp + 10))
		digitalWrite(motor_speed_pin, 0);
	else if (speed)
		digitalWrite(motor_speed_pin, speed);
		
	this->calculateHeaterPWM();
	analogWrite(heater_pin, heater_pwm);
}

void ThermoplastExtruder::calculateHeaterPWM()
{
	//lower values == hotter temps.
	if (current_temp > target_temp)
		heater_pwm = 255;
	else
		heater_pwm = 0;
}

int ThermoplastExtruder::version()
{
	return 1;
}
