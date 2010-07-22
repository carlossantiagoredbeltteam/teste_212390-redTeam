#ifndef PARAMETERS_H
#define PARAMETERS_H

// Comment the next line out to use the Arduino
#define SANGUINO

// Set 1s where you have endstops; 0s where you don't
#define ENDSTOPS_MIN_ENABLED 1
#define ENDSTOPS_MAX_ENABLED 0

//our command string length
#define COMMAND_SIZE 128

// The size of the movement buffer

#define BUFFER_SIZE 4

// Number of microseconds between timer interrupts when no movement
// is happening

#define DEFAULT_TICK 1000

// What delay() value to use when waiting for things to free up in milliseconds

#define WAITING_DELAY 1

#define INCHES_TO_MM 25.4

#define MOTHERBOARD_ERIK2
#ifdef MOTHERBOARD_ERIK2
// define the parameters of our machine.
#define X_STEPS_PER_MM   (8*8) //7.99735/// was 8
#define X_STEPS_PER_INCH (X_STEPS_PER_MM*INCHES_TO_MM)
#define X_MOTOR_STEPS    (200*8) //was: 400 half step
#define INVERT_X_DIR 0

#define Y_STEPS_PER_MM   (8*8) //7.99735
#define Y_STEPS_PER_INCH (Y_STEPS_PER_MM*INCHES_TO_MM)
#define Y_MOTOR_STEPS    (200*8) // 1/8
#define INVERT_Y_DIR 0

#define Z_STEPS_PER_MM   160 // 320
#define Z_STEPS_PER_INCH (Z_STEPS_PER_MM*INCHES_TO_MM)
#define Z_MOTOR_STEPS    200
#define INVERT_Z_DIR 0

// For when we have a stepper-driven extruder
// E_STEPS_PER_MM is the number of steps needed to 
// extrude 1mm out of the nozzle.

#define E_STEPS_PER_MM   5.0   // 5mm diameter drive - empirically adjusted
#define E_STEPS_PER_INCH (E_STEPS_PER_MM*INCHES_TO_MM)
#define E_MOTOR_STEPS    800

//our maximum feedrates
#define FAST_XY_FEEDRATE 3000.0 // def: 3000.0
#define FAST_Z_FEEDRATE  90.0// def: 50.0 // was 70

// Data for acceleration calculations
// Comment out the next line to turn accelerations off
//#define ACCELERATION_ON
#define SLOW_XY_FEEDRATE 1000.0 // Speed from which to start accelerating

// Set to 1 if enable pins are inverting
// For RepRap stepper boards version 1.x the enable pins are *not* inverting.
// For RepRap stepper boards version 2.x and above the enable pins are inverting.
#define INVERT_ENABLE_PINS 1

#if INVERT_ENABLE_PINS == 1
#define ENABLE_ON LOW
#else
#define ENABLE_ON HIGH
#endif

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define ENDSTOPS_INVERTING 0

#else
// define the parameters of our machine.
#define X_STEPS_PER_MM   (8*8) //7.99735/// was 8
#define X_STEPS_PER_INCH (X_STEPS_PER_MM*INCHES_TO_MM)
#define X_MOTOR_STEPS    (200*8) //was: 400 half step
#define INVERT_X_DIR 0

#define Y_STEPS_PER_MM   (8*8) //7.99735
#define Y_STEPS_PER_INCH (Y_STEPS_PER_MM*INCHES_TO_MM)
#define Y_MOTOR_STEPS    (200*8) // 1/8
#define INVERT_Y_DIR 0

#define Z_STEPS_PER_MM   160 // 320
#define Z_STEPS_PER_INCH (Z_STEPS_PER_MM*INCHES_TO_MM)
#define Z_MOTOR_STEPS    200
#define INVERT_Z_DIR 0

// For when we have a stepper-driven extruder
// E_STEPS_PER_MM is the number of steps needed to 
// extrude 1mm out of the nozzle.

#define E_STEPS_PER_MM   5.0   // 5mm diameter drive - empirically adjusted
#define E_STEPS_PER_INCH (E_STEPS_PER_MM*INCHES_TO_MM)
#define E_MOTOR_STEPS    800

//our maximum feedrates
#define FAST_XY_FEEDRATE 3000.0 // def: 3000.0
#define FAST_Z_FEEDRATE  90.0// def: 50.0 // was 70

// Data for acceleration calculations
// Comment out the next line to turn accelerations off
//#define ACCELERATION_ON
#define SLOW_XY_FEEDRATE 1000.0 // Speed from which to start accelerating

// Set to 1 if enable pins are inverting
// For RepRap stepper boards version 1.x the enable pins are *not* inverting.
// For RepRap stepper boards version 2.x and above the enable pins are inverting.
#define INVERT_ENABLE_PINS 0

#if INVERT_ENABLE_PINS == 1
#define ENABLE_ON LOW
#else
#define ENABLE_ON HIGH
#endif

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define ENDSTOPS_INVERTING 0

#endif
// end ifndef ERIK2
/****************************************************************************************
 * Define the PID behavior for the heater
 ****************************************************************************************/
/// Set to true to use PID for temperature.
/// false uses the old on-off mechanism.
#define TEMP_PID 1

// How many temperature samples to take for an average.  each sample takes about 100 usecs.
#define TEMPERATURE_SAMPLES 2

/// The interval between heater updates, in milliseconds.
#define TEMP_UPDATE_INTERVAL 50
#define TEMP_PID_INTEGRAL_DRIVE_MAX 110
#define TEMP_PID_PGAIN 5.0
#define TEMP_PID_IGAIN 0.1
#define TEMP_PID_DGAIN 100.0


#endif
