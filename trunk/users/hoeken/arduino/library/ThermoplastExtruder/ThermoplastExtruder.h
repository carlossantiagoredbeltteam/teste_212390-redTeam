/*
	ThermoplastExtruder.h - RepRap Thermoplastic Extruder library for Arduino - Version 0.1

	This library is used to read, control, and handle a thermoplastic extruder.

	History:
	* Created intial library (0.1) by Zach Smith.
	* Initial rework (0.2) by Marius Kintel <kintel@sim.no>

*/

#ifndef THERMOPLASTEXTRUDER_H
#define THERMOPLASTEXTRUDER_H

class ThermoplastExtruder
{
	public:
		ThermoplastExtruder(byte motor_dir_pin, byte motor_pwm_pin, byte heater_pin, byte thermistor_pin);

		// various setters methods:
		void setSpeed(byte speed);
		void setDirection(bool dir);
		void setTargetTemperature(int targettemp);
		void setHeater(byte heat);

		//get various info things.
		byte getSpeed();
		bool getDirection();
		int getTargetTemperature();
		int getTemperature();
		int getTemperatureInFahrenheit();
		int getRawTemperature();
		int calculateTemperatureFromRaw(int raw);

		byte getHeater();

		//manage the extruder
		int readTemperature();
		void manageTemperature();



	private:

		//pin numbers:
		byte motor_pwm_pin;		// motor PWM pin
		byte motor_dir_pin;		// motor direction pin
		byte heater_pin;		// heater PWM pin
		byte thermistor_pin;	// thermistor analog input pin

		//extruder variables
		bool motor_dir;			// Motor direction (true = forward, false = backward)
		byte motor_pwm;			// Speed in PWM, 0-255
		byte heater_pwm;		// Heater PWM, 0-255
		int target_celsius;		// Our target temperature
		int current_celsius;	// Our current temperature
		int raw_temperature;	// our raw temperature reading.
};

#endif
