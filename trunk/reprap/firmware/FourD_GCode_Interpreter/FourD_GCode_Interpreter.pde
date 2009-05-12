// Yep, this is actually -*- c++ -*-

// Sanguino G-code Interpreter
// Arduino v1.0 by Mike Ellery - initial software (mellery@gmail.com)
// v1.1 by Zach Hoeken - cleaned up and did lots of tweaks (hoeken@gmail.com)
// v1.2 by Chris Meighan - cleanup / G2&G3 support (cmeighan@gmail.com)
// v1.3 by Zach Hoeken - added thermocouple support and multi-sample temp readings. (hoeken@gmail.com)
// Sanguino v1.4 by Adrian Bowyer - added the Sanguino; extensive mods... (a.bowyer@bath.ac.uk)
// Sanguino v1.5 by Adrian Bowyer - implemented 4D Bressenham XYZ+ stepper control... (a.bowyer@bath.ac.uk)

#include <ctype.h>
#include <HardwareSerial.h>
#include "WProgram.h"
#include "parameters.h"
#include "pins.h"
#include "extruder.h"
#include "vectors.h"
#include "cartesian_dda.h"

// Maintain a list of extruders...
byte extruder_in_use = 0;
extruder* ex[EXTRUDER_COUNT];

// ...creating static instances of them here
extruder ex0(EXTRUDER_0_MOTOR_DIR_PIN, EXTRUDER_0_MOTOR_SPEED_PIN , EXTRUDER_0_HEATER_PIN,
            EXTRUDER_0_FAN_PIN,  EXTRUDER_0_TEMPERATURE_PIN, EXTRUDER_0_VALVE_DIR_PIN,
            EXTRUDER_0_VALVE_ENABLE_PIN, EXTRUDER_0_STEP_ENABLE_PIN);

// This is our RepRap machine; this class handles all movement.
cartesian_dda cdda;


// Our interrupt function

SIGNAL(SIG_OUTPUT_COMPARE1A)
{
  ex[extruder_in_use]->interrupt();
}

void setup()
{
  extruder_in_use = 0;
  ex[extruder_in_use] = &ex0;
  Serial.begin(19200);
  Serial.println("start");
  cdda.set_extruder(ex[extruder_in_use]);
  init_process_string();

}

void loop()
{
	manage_all_extruders();
        get_and_do_command();        
}
