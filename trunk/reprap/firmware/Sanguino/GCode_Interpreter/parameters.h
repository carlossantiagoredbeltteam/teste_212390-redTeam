// define the parameters of our machine.
#define X_STEPS_PER_INCH 203.133
#define X_STEPS_PER_MM   7.99735
#define X_MOTOR_STEPS    400

#define Y_STEPS_PER_INCH 203.133
#define Y_STEPS_PER_MM   7.99735
#define Y_MOTOR_STEPS    400

#define Z_STEPS_PER_INCH 8128.0
#define Z_STEPS_PER_MM   320.0
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

// How many temperature samples to take.  each sample takes about 100 usecs.
#define TEMPERATURE_SAMPLES 3
