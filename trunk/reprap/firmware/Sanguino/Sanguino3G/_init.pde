/****************************************************************************************
* Here's where you define the overall electronics setup for your machine.
****************************************************************************************/

//
// CHOOSE WHICH MOTHERBOARD YOU'RE USING:
//
#define REPRAP_MOTHERBOARD_VERSION_1_0
//#define REPRAP_MOTHERBOARD_VERSION_1_1

//
// CHOOSE WHICH FAMILY OF STEPPER DRIVER YOU'RE USING:
//
//#define STEPPER_DRIVER_VERSION_1_X
#define STEPPER_DRIVER_VERSION_2_X

//
// CHOOSE WHICH FAMILY OF OPTO ENDSTOP YOU'RE USING:
//
//#define OPTO_ENDSTOP_1_X
#define OPTO_ENDSTOP_2_X


/****************************************************************************************
* Sanguino Pin Assignment
****************************************************************************************/

//these are the pins for the v1.0 Motherboard.
#ifdef REPRAP_MOTHERBOARD_VERSION_1_0

//x axis pins
#define X_STEP_PIN 		15
#define X_DIR_PIN 		18
#define X_ENABLE_PIN	19
#define X_MIN_PIN		20
#define X_MAX_PIN		21

//y axis pins
#define Y_STEP_PIN		23
#define Y_DIR_PIN		22
#define Y_ENABLE_PIN	19
#define Y_MIN_PIN		25
#define Y_MAX_PIN		26

//z axis pins
#define Z_STEP_PIN		29
#define Z_DIR_PIN		30
#define Z_ENABLE_PIN	31
#define Z_MIN_PIN		2
#define Z_MAX_PIN		1

//our pin for debugging.
#define DEBUG_PIN		0

//various SPI select pins
#define SPI_SELECT_1	?
#define SPI_SELECT_2	?
#define SPI_SELECT_3	?

//our SD card pins
#define SD_CARD_SELECT	?
#define SD_CARD_WRITE	?
#define SD_CARD_DETECT	?

//our RS485 pins
#define RS485_TX_ENABLE	?
#define RS485_RX_ENABLE	?

#endif

//these are the pins for the v1.1 Motherboard.
#ifdef REPRAP_MOTHERBOARD_VERSION_1_1

//x axis pins
#define X_STEP_PIN		15
#define X_DIR_PIN		18
#define X_ENABLE_PIN	19
#define X_MIN_PIN		20
#define X_MAX_PIN		21

//y axis pins
#define Y_STEP_PIN		23
#define Y_DIR_PIN		22
#define Y_ENABLE_PIN	24
#define Y_MIN_PIN		25
#define Y_MAX_PIN		26

//z axis pins
#define Z_STEP_PIN		27
#define Z_DIR_PIN		28
#define Z_ENABLE_PIN	29
#define Z_MIN_PIN		30
#define Z_MAX_PIN		31

//our pin for debugging.
#define DEBUG_PIN		0

//various SPI select pins
#define SPI_SELECT_1	1
#define SPI_SELECT_2	3
#define SPI_SELECT_3	14

//our SD card pins
#define SD_CARD_SELECT	4
#define SD_CARD_WRITE	2
#define SD_CARD_DETECT	3

//our RS485 pins
#define RS485_TX_ENABLE	12
#define RS485_RX_ENABLE	13

#endif

/****************************************************************************************
* Stepper Driver Behaviour Definition
****************************************************************************************/

#ifdef STEPPER_DRIVER_VERSION_1_X
#define STEPPER_ENABLE	1
#define STEPPER_DISABLE	0
#endif

#ifdef STEPPER_DRIVER_VERSION_2_X
#define STEPPER_ENABLE	0
#define STEPPER_DISABLE	1
#endif

/****************************************************************************************
* Opto Endstop Behaviour Definition
****************************************************************************************/

#ifdef OPTO_ENDSTOP_1_X
#define SENSORS_INVERTING 0
#endif

#ifdef OPTO_ENDSTOP_2_X
#define SENSORS_INVERTING 1
#endif
