/****************************************************************************************
* Here's where you define the overall electronics setup for your machine.
****************************************************************************************/

//
// CHOOSE WHICH EXTRUDER YOU'RE USING:
//
#define EXTRUDER_CONTROLLER_VERSION_2_0

#define TEMPERATURE_SAMPLES 5
#define SERIAL_SPEED 76800

//the address for commands to listen to
#define RS485_ADDRESS 1
#define PACKET_TIMEOUT 10

/****************************************************************************************
* Here's where you define the speed PID behavior
****************************************************************************************/
//#define INVERT_QUADRATURE
#define MIN_SPEED 50				//minimum PWM speed to use
#define MAX_SPEED 255				//maximum PWM speed to use
#define SPEED_ERROR_MARGIN 10		//our error margin (to prevent constant seeking)
#define SPEED_INITIAL_PGAIN 1		//our proportional gain.
#define SPEED_INITIAL_IGAIN 100		//our integral gain.
#define SPEED_INITIAL_DGAIN 10		//our derivative gain.

/****************************************************************************************
* Sanguino Pin Assignment
****************************************************************************************/

//these are the pins for the v2.0 Extruder Controller
#ifdef EXTRUDER_CONTROLLER_VERSION_2_0

#define ENCODER_A_PIN 2
#define ENCODER_B_PIN 3

#define RX_ENABLE_PIN 4
#define TX_ENABLE_PIN 16

#define MOTOR_1_SPEED_PIN 5
#define MOTOR_1_DIR_PIN 7
#define MOTOR_2_SPEED_PIN 6
#define MOTOR_2_DIR_PIN 8

#define SERVO1_PIN 9
#define SERVO2_PIN 10

#define HEATER_PIN 11
#define FAN_PIN 12
#define VALVE_PIN 15

#define THERMISTOR_PIN 3

#define DEBUG_PIN 13

#endif

//quadrature encoder behavior
#ifdef INVERT_QUADRATURE
#define QUADRATURE_INCREMENT speed_error--;
#define QUADRATURE_DECREMENT speed_error++;
#else
#define QUADRATURE_INCREMENT speed_error++;
#define QUADRATURE_DECREMENT speed_error--;
#endif
