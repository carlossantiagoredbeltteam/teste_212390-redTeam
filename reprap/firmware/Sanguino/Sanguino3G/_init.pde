// define the parameters of our machine.

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// H21LOB sensors *are* inverting (AKA: Opto Endstop v2.1)
#define SENSORS_INVERTING 1

#define REPRAP_MOTHERBOARD_VERSION_1_0
//#define REPRAP_MOTHERBOARD_VERSION_1_1

/****************************************************************************************
* digital i/o pin assignment
****************************************************************************************/

//the pin assigment may change from motherboard to motherboard.


//these are the pins for the v1.0 Motherboard.
#ifdef REPRAP_MOTHERBOARD_VERSION_1_0

//x axis pins
#define X_STEP_PIN 7
#define X_DIR_PIN 8
#define X_MIN_PIN 14
#define X_MAX_PIN 17
#define X_ENABLE_PIN 18

//y axis pins
#define Y_STEP_PIN 9
#define Y_DIR_PIN 10
#define Y_MIN_PIN 15
#define Y_MAX_PIN 17
#define Y_ENABLE_PIN 18

//z axis pins
#define Z_STEP_PIN 12
#define Z_DIR_PIN 13
#define Z_MIN_PIN 16
#define Z_MAX_PIN 17
#define Z_ENABLE_PIN 18

#endif

//these are the pins for the v1.1 Motherboard.
#ifdef REPRAP_MOTHERBOARD_VERSION_1_1

//x axis pins
#define X_STEP_PIN 7
#define X_DIR_PIN 8
#define X_MIN_PIN 14
#define X_MAX_PIN 17
#define X_ENABLE_PIN 18

//y axis pins
#define Y_STEP_PIN 9
#define Y_DIR_PIN 10
#define Y_MIN_PIN 15
#define Y_MAX_PIN 17
#define Y_ENABLE_PIN 18

//z axis pins
#define Z_STEP_PIN 12
#define Z_DIR_PIN 13
#define Z_MIN_PIN 16
#define Z_MAX_PIN 17
#define Z_ENABLE_PIN 18

#endif

