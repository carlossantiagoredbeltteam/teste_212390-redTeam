#ifndef PARAMETERS_H
#define PARAMETERS_H

// Comment the next line out to use the Arduino
#define SANGUINO

// Uncomment the next line to run stand-alone tests on the machine (also see the 
// ends of this, the process_string, the extruder, and the stepper_control tabs).
//#define TEST_MACHINE
// If that works, comment out the next line to test the rest:
#define COMMS_TEST

// define the parameters of our machine.
#define X_STEPS_PER_MM   7.99735
#define X_STEPS_PER_INCH (X_STEPS_PER_MM*25.4)
#define X_MOTOR_STEPS    400

#define Y_STEPS_PER_MM   7.99735
#define Y_STEPS_PER_INCH (Y_STEPS_PER_MM*25.4)
#define Y_MOTOR_STEPS    400

#define Z_STEPS_PER_MM   320
#define Z_STEPS_PER_INCH (Z_STEPS_PER_MM*25.4)
#define Z_MOTOR_STEPS    400

//our maximum feedrates
#define FAST_XY_FEEDRATE 1600.0
#define FAST_Z_FEEDRATE  50.0

// Units in curve section
#define CURVE_SECTION_INCHES 0.019685
#define CURVE_SECTION_MM 0.5

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define SENSORS_INVERTING 0


#endif
