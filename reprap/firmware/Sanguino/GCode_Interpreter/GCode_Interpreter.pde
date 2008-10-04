// Yep, this is actually -*- c++ -*-

// Arduino G-code Interpreter
// v1.0 by Mike Ellery - initial software (mellery@gmail.com)
// v1.1 by Zach Hoeken - cleaned up and did lots of tweaks (hoeken@gmail.com)
// v1.2 by Chris Meighan - cleanup / G2&G3 support (cmeighan@gmail.com)
// v1.3 by Zach Hoeken - added thermocouple support and multi-sample temp readings. (hoeken@gmail.com)
#include <HardwareSerial.h>

// Uncomment the next line to run stand-alone tests on the machine (also see the 
// ends of the GCode_Interpreter, extruder, and stepper_control code).

//#define TEST_MACHINE

//our command string
#define COMMAND_SIZE 128
char word[COMMAND_SIZE];
byte serial_count;
int no_data = 0;
long idle_time;
boolean comment = false;
boolean bytes_received = false;

void setup()
{
	//Do startup stuff here
	Serial.begin(19200);
	Serial.println("start");
	
	//other initialization.
	init_process_string();
	init_steppers();
	init_extruder();
}

void loop()
{
#ifndef TEST_MACHINE  
	char c;

	//keep it hot!
	extruder_manage_temperature();

	//read in characters if we got them.
	if (Serial.available() > 0)
	{
		c = Serial.read();
		no_data = 0;

		//newlines are ends of commands.
		if (c != '\n')
		{
			// Start of comment - ignore any bytes received from now on
			if (c == '(')
				comment = true;
				
			// If we're not in comment mode, add it to our array.
			if (!comment)
			{
				word[serial_count] = c;
				serial_count++;
			}
			if (c == ')')
			        comment = false; // End of comment - start listening again
		}

		bytes_received = true;
	}
	//mark no data if nothing heard for 100 milliseconds
	else
	{
		if ((millis() - idle_time) >= 100)
		{
			no_data++;
			idle_time = millis();
		}
	}

	//if theres a pause or we got a real command, do it
	if (bytes_received && (c == '\n' || no_data ))
	{
		//process our command!
		process_string(word, serial_count);

		//clear command.
		init_process_string();
	}

	//no data?  turn off steppers
	if (no_data > 10 )
		disable_steppers();
#else

// Run the parts of the machine as a test
// Comment out all but one of these

  // extruder_heater_test();
  // extruder_drive_test();
  // extruder_valve_test();
   X_motor_test();
  // Y_motor_test();
  // Z_motor_test();
    
#endif        
}
