// This  is -*- c++ -*-, no kidding
// define the parameters of our machine.
#define X_STEPS_PER_INCH 5080
#define X_STEPS_PER_MM   200
#define X_MOTOR_STEPS    200

#define Y_STEPS_PER_INCH 5080
#define Y_STEPS_PER_MM   200
#define Y_MOTOR_STEPS    200

#define Z_STEPS_PER_INCH 1219
#define Z_STEPS_PER_MM   48
#define Z_MOTOR_STEPS    48

//our maximum feedrates
#define FAST_XY_FEEDRATE 1000.0
#define FAST_Z_FEEDRATE  50.0

// Units in curve section
#define CURVE_SECTION_INCHES 0.019685
#define CURVE_SECTION_MM 0.5

// Set to one if endstop outputs are inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define ENDSTOPS_INVERTING 0
// Optionally disable max endstops to save pins or wiring
#define ENDSTOPS_MIN_ENABLED 1
#define ENDSTOPS_MAX_ENABLED 0

// How many temperature samples to take.  each sample takes about 100 usecs.
#define TEMPERATURE_SAMPLES 5

/****************************************************************************************
 * digital i/o pin assignment
 *  
 * this uses the undocumented feature of Arduino - pins 14-19 correspond to analog 0-5
 ****************************************************************************************/

//cartesian bot pins
#define X_STEP_PIN 2
#define X_DIR_PIN 3
#define X_MIN_PIN 4
#define X_MAX_PIN 9
#define X_ENABLE_PIN 15

#define Y_STEP_PIN 10
#define Y_DIR_PIN 7
#define Y_MIN_PIN 8
#define Y_MAX_PIN 13
#define Y_ENABLE_PIN 15

#define Z_STEP_PIN 19
#define Z_DIR_PIN 18
#define Z_MIN_PIN 17
#define Z_MAX_PIN 16
#define Z_ENABLE_PIN 15

//extruder pins
#define EXTRUDER_MOTOR_SPEED_PIN   9
#define EXTRUDER_MOTOR_DIR_PIN     12
#define EXTRUDER_HEATER_PIN        6
#define EXTRUDER_FAN_PIN           5
#define EXTRUDER_THERMISTOR_PIN    0  //NB! analog pin, -1 disables thermistor readings
#define EXTRUDER_THERMOCOUPLE_PIN  -1 //NB! analog pin, -1 disables thermocouple readings
