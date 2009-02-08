/* -*- mode: c++; c-basic-offset: 8; indent-tabs-mode: t -*- */

// Arduino G-code Interpreter
// v1.0 by Mike Ellery - initial software (mellery@gmail.com)
// v1.1 by Zach Hoeken - cleaned up and did lots of tweaks (hoeken@gmail.com)
// v1.2 by Chris Meighan - cleanup / G2&G3 support (cmeighan@gmail.com)
// v1.3 by Zach Hoeken - added thermocouple support and multi-sample temp readings. (hoeken@gmail.com)
// vX.X by Marius Kintel - refactored a bit to save space and clarify code (kintel@sim.no)
#include <HardwareSerial.h>

#include "_init.h"
AxisConfig axes[3] = {
	{X_STEP_PIN, X_DIR_PIN, X_MIN_PIN, X_MAX_PIN, X_ENABLE_PIN, INVERT_X_DIR, REFERENCE_X_DIR, ENDSTOP_X_MIN_ENABLED, ENDSTOP_X_MAX_ENABLED, X_STEPS_PER_INCH, X_STEPS_PER_MM, X_MOTOR_STEPS},
	{Y_STEP_PIN, Y_DIR_PIN, Y_MIN_PIN, Y_MAX_PIN, Y_ENABLE_PIN, INVERT_Y_DIR, REFERENCE_Y_DIR, ENDSTOP_Y_MIN_ENABLED, ENDSTOP_Y_MAX_ENABLED, Y_STEPS_PER_INCH, Y_STEPS_PER_MM, Y_MOTOR_STEPS},
	{Z_STEP_PIN, Z_DIR_PIN, Z_MIN_PIN, Z_MAX_PIN, Z_ENABLE_PIN, INVERT_Z_DIR, REFERENCE_Z_DIR, ENDSTOP_Z_MIN_ENABLED, ENDSTOP_Z_MAX_ENABLED, Z_STEPS_PER_INCH, Z_STEPS_PER_MM, Z_MOTOR_STEPS}
};

#include "RepRapSDCard.h"

//our command string
#define COMMAND_SIZE 128
char cmdbuffer[COMMAND_SIZE];
byte serial_count;
int no_data = 0;
long old_idle_time;
long idle_time;
int delta;
boolean comment = false;
boolean bytes_received = false;
bool use_sd_card = false;
RepRapSDCard sdcard;
fat_file_struct *file;
bool eof = false;

uint8_t init_sd_card()
{
  if (!sdcard.init_card())
  {
    if (!sdcard.isAvailable())
    {
      Serial.println("No card present"); 
      return 1;
    }
    else
    {
      Serial.println("Card init failed"); 
      return 2;
    }
  }
  else if (!sdcard.open_partition())
  {
    Serial.println("No partition"); 
    return 3;
  }
  else if (!sdcard.open_filesys())
  {
    Serial.println("Can't open filesys"); 
    return 4;
  }
  else if (!sdcard.open_dir("/"))
  {
    Serial.println("Can't open /");
    return 5;
  }
//   else if (sdcard.isLocked())
//   {
//     Serial.println("Card is locked");
//     return 6;
//   }
  return 0;
}

void setup()
{
	//Do startup stuff here
	Serial.begin(115200);
	Serial.println("start");
	
	//other initialization.
	init_steppers();
	init_extruder();
	clear_process_string();

	// Open first file, validate contents
	// Decide whether to read from serial or SD-card; print debug to serial
	if (init_sd_card() == 0) {
                struct fat_dir_entry_struct dir_entry;
		while (fat_read_dir(sdcard.cwd, &dir_entry)) {
			if (dir_entry.attributes & 
			    (FAT_ATTRIB_DIR |
			     FAT_ATTRIB_SYSTEM |
			     FAT_ATTRIB_HIDDEN |
			     FAT_ATTRIB_VOLUME)) {
				continue;
			}
			Serial.print("First file: ");
			Serial.print(dir_entry.attributes, HEX);
			Serial.print(" ");
			Serial.println(dir_entry.long_name);
			file = fat_open_file(sdcard.filesystem, &dir_entry);
			if (!file) {
				Serial.println("Unable to open file.");
			}
			else {
				use_sd_card = true;
			}
			break;
                }
	}
}

void clear_process_string()
{
	//init our command buffer
	for (uint8_t i=0; i<COMMAND_SIZE; i++) cmdbuffer[i] = 0;
	serial_count = 0;
	bytes_received = false;

	idle_time = millis();
}

int input_available()
{
	if (use_sd_card) {
		if (!eof) return 1;
	}
	else {
		return Serial.available();
	}
}

uint8_t input_read()
{
	if (use_sd_card) {
		uint8_t c;
		intptr_t ret = fat_read_file(file, &c, 1);
		if (ret == 0) {
			eof = true;
			c = '\n';
		}
		if (ret == -1) {
			Serial.println("Read error.");
			eof = true;
			c = '\n';
		}
		return c;
	}
	else {
		return Serial.read();
	}
}

void loop()
{
	char c;

	extruder_manage_temperature();  //keep it hot!

	//read in characters if we got them.
	if (input_available() > 0)
	{
		c = input_read();
		
		// Reset no_data timer
		no_data = 0;
		idle_time = millis();
		
		if (c == '\r') {
			Serial.println("debug: linefeed ?!");
		}
		else
		//  commands end with newlines
		if (c != '\n')
		{
			// Start of comment - ignore any bytes received from now on
			if (c == '(') comment = true;
			
			// If we're not in comment mode, add it to our array.
			if (!comment)
			{
				cmdbuffer[serial_count] = c;
				serial_count++;
			}
			
			if (c == ')') comment = false; // End of comment - start listening again
		}
		
		bytes_received = true;
	}
	else
	{
		// mark no_data if nothing heard for 100 milliseconds
		delta = millis() - idle_time;
		if (delta >= 100)
// 		if ((millis() - idle_time) >= 100)
		{	
			no_data++;
			old_idle_time = idle_time;
			idle_time = millis();
		}
	}

	// if there's a pause or we got a real command, do it
	if (bytes_received && (c == '\n' || no_data))
	{
		if (no_data)
		{
			Serial.print("NODATA(");
			Serial.print(no_data);
			Serial.print(" ");
			Serial.print((long)millis());
			Serial.print(" ");
			Serial.print(old_idle_time);
			Serial.print(" ");
			Serial.print(idle_time);
			Serial.print(" ");
			Serial.print(delta);
			Serial.print("): ");
			Serial.println(cmdbuffer);
		}
#if (DEBUG == 1)
 		else
 		{
 			Serial.print("debug: ");
 			Serial.println(cmdbuffer);
 		}
#endif

		//process our command!
		process_string(cmdbuffer, serial_count);

		//clear command.
		clear_process_string();
	}

	//no data for > 1 sec -> turn off steppers
	if (no_data > 10)
		disable_steppers();
}
