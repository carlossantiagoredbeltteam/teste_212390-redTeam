#ifndef FEATURES_H
#define FEATURES_H
//-----------------------------------------------------------------------------------------------
// Features:   
//  Each of these defines relates specifically to a component electronic or hardware function or 
//     capability that may or may not exist in your particular machine.
//  You should select which of these are used, in your instance, in configuration.h
//-----------------------------------------------------------------------------------------------

//NONE OF THESE CONSTANTS NEED EVER BE CHANGED IN HERE! 

// (Arduino: 0 - no longer in use)
// Sanguino or RepRap Motherboard with direct drive extruders: 1
// RepRap Motherboard with RS485 extruders: 2
// Arduino Mega: 3
//eg:
//#define MOTHERBOARD  MOTHERBOARD_MENDEL 
//#define MOTHERBOARD_ARDUINO 0
//#define MOTHERBOARD_SANGUINO_DD 1
//#define MOTHERBOARD_REPRAP_RS485 2
//#define MOTHERBOARD_MEGA 3


//eg:
// #define DEFAULTS  MENDEL_DEFAULTS   // setup the pinouts and opts to match a typical Mendel setup with typical wiring, and typical pinouts etc
#define DARWIN_DEFAULTS 1
#define MENDEL_DEFAULTS 2
#define MENDEL_MEGA_DEFAULTS 3
#define MAKERBOT_DEFAULTS 4
#define BATHPROTO_DEFAULTS 5
#define CUSTOM_DEFAULTS 6


///#define EXTRUDER_CONTROLLER EXTRUDER_CONTROLLER_RS485   //  means the extruder has its own controller that we talk to via RS485, 0 means it uses the integrated PID logic. 

  #define EXTRUDER_CONTROLLER_RS485 1     // separate extruder temperature management logic on another CPU.
  #define EXTRUDER_CONTROLLER_INTERNAL 2  // stepper driven extruder on master CPU
  #define EXTRUDER_CONTROLLER_DC 3        // DC extruder like makerbot
  

 //eg: 
//#define CPUTYPE CPUTYPE_SANGUINO  //or MEGA, or ATMEL328 , or ATLEM168 ( describes the core CPU, how many pins, what types, and likely connection/s)

  #define CPUTYPE_ATMEL168 1
  #define CPUTYPE_SANGUINO 2
  #define CPUTYPE_MEGA 3
  #define CPUTYPE_ATMEL328 4
 // #define CPU_EMC2  5 // this is just a theoretical one at this time

  //eg:
//#define POSITIONING_HARDWARE POSITIONING_HARDWARE_MENDEL_STYLE // what style XYZ positioning system do you use?

   #define POSITIONING_HARDWARE_DARWIN_STYLE 1
   #define POSITIONING_HARDWARE_MENDEL_STYLE 2 
   #define POSITIONING_HARDWARE_MAKERBOT_STYLE 3
   #define POSITIONING_HARDWARE_CNC_STYLE 4
  // #define POSITIONING_HARDWARE_MOVINGGANTRY_STYLE 5  // this is just a theoretical one at this time
  // #define CUSTOM 6 // this is just a theoretical one at this time

// eg
//#define MOVEMENT_TYPE MOVEMENT_TYPE_STEP_DIR  // when sending signals to the drivers, what electrical/logical interface will we use? - there are a number of possible different hardware methods for getting directional movement, here we decide which one we want to use normally:  

  #define MOVEMENT_TYPE_STEP_DIR 1      // standard step & direction information, recommended
  #define MOVEMENT_TYPE_GRAY_CODE 2     // also called quadrature stepping, less popular but basically same quality as above
  #define MOVEMENT_TYPE_UNMANAGED_DC 3  //open-ended DC motor using timer or PWM. typically low res, perhaps use for Z axis or Makerbot Extruder , and only if you must. 
  #define MOVEMENT_TYPE_ENCODER_MANAGED_DC 4// closed-loop DC motor who's position is maintained by an opto or magneto encoder generating edges on an external imterrupt line. ?

// eg:
//#define STEPPER_TYPE STEPPER_TYPE_LIN_4118S // only really relevant if STEP_TYPE == 0 or 1

  #define STEPPER_TYPE_LIN_4118S  1  // http://www.reprap.org/wiki/StepperMotor#Lin_Engineering_.2F_4118S-62-07
  #define STEPPER_TYPE_ZAPP_SY42 2
  #define STEPPER_TYPE_NANOTEC_ST57 3
  #define STEPPER_TYPE_OSXMODS17_62 4   //  http://ausxmods.com.au/stepper-motors/62-oz-in-nema-17-stepper-motor


// eg: 
//#define ENDSTOP_OPTO_TYPE  ENDSTOP_OPTO_TYPE_OES2_1 

  #define ENDSTOP_OPTO_TYPE_NORMAL 0
  #define ENDSTOP_OPTO_TYPE_INVERTING 1
  #define ENDSTOP_OPTO_TYPE_OES1_0 ENDSTOP_OPTO_TYPE_NORMAL    //  http://make.rrrf.org/oes-1.0
  #define ENDSTOP_OPTO_TYPE_OES2_1 ENDSTOP_OPTO_TYPE_INVERTING    //  http://reprap.org/wiki/OptoEndstop_2_1   - reprap Opto End Stop circuit revision 2.1  
  #define ENDSTOP_OPTO_TYPE_H21LOI ENDSTOP_OPTO_TYPE_NORMAL
  #define ENDSTOP_OPTO_TYPE_H21LOB ENDSTOP_OPTO_TYPE_INVERTING
  #define ENDSTOP_OPTO_TYPE_YOUR_TYPE ENDSTOP_OPTO_TYPE_INVERTING // if you have a published circuit  
  
  //eg:
  //#define ENABLE_PIN_STATE  ENABLE_PIN_STATE_NORMAL
  
  #define ENABLE_PIN_STATE_NORMAL 0
  #define ENABLE_PIN_STATE_INVERTING 1
// Set to 1 if enable pins are inverting
// For RepRap stepper boards version 1.x the enable pins are *not* inverting.
// For RepRap stepper boards version 2.x and above the enable pins are inverting.
// OLD variable was:
// #define INVERT_ENABLE_PINS 0
  
//eg:
// #define TEMP_SENSOR TEMP_SENSOR_EPCOS_THERMISTOR
  
 #define TEMP_SENSOR_EPCOS540_THERMISTOR   //see: http://reprap.org/wiki/Thermistor
 #define TEMP_SENSOR_EPCOS560_THERMISTOR   //see: http://reprap.org/wiki/Thermistor
 #define TEMP_SENSOR_RRRF100K_THERMISTOR   //see: http://reprap.org/wiki/Thermistor
 #define TEMP_SENSOR_RRRF10K_THERMISTOR   //see: http://reprap.org/wiki/Thermistor
 #define TEMP_SENSOR_RS10K_THERMISTOR   //see: http://reprap.org/wiki/Thermistor
 #define TEMP_SENSOR_AD595_THERMOCOUPLE  // see: http://reprap.org/wiki/Thermocouple_Sensor_1.0
 #define TEMP_SENSOR_MAX6675_THERMOCOUPLE // see: http://reprap.org/wiki/Hacks_to_the_RepRap_Extruder_Controller_v2.2
// #define USE_THERMISTOR // old  definition, replaced by the above. 

// #define DATA_SOURCE DATA_SOURCE_USB_SERIAL

#define DATA_SOURCE_USB_SERIAL 1
#define DATA_SOURCE_SDCARD 2   // is there an SD card reader present?   
//#define DATA_SOURCE_EEPROM 3   // this is just a theoretical one at this time


//eg:
//#define ACCELERATION  ACCELERATION_ON
#define ACCELERATION_ON 1
#define ACCELERATION_OFF 0


//-----------------------------------------------------------------------------------------------
// IMMUTABLE (READONLY) CONSTANTS GO HERE:
//-----------------------------------------------------------------------------------------------
// The width of Henry VIII's thumb (or something).
#define INCHES_TO_MM 25.4 // *RO

// The temperature routines get called each time the main loop
// has gone round this many times
#define SLOW_CLOCK 2000

// The speed at which to talk with the host computer; default is 19200=
#define HOST_BAUD 19200 // *RO

// The number of mm below which distances are insignificant (one tenth the
// resolution of the machine is the default value).
#define SMALL_DISTANCE 0.01 // *RO

// Useful to have its square
#define SMALL_DISTANCE2 (SMALL_DISTANCE*SMALL_DISTANCE) // *RO

//our command string length
#define COMMAND_SIZE 128 // *RO

// Our response string length
#define RESPONSE_SIZE 256 // *RO

// The size of the movement buffer
#define BUFFER_SIZE 4 // *RO

// Number of microseconds between timer interrupts when no movement
// is happening
#define DEFAULT_TICK (long)1000 // *RO

// What delay() value to use when waiting for things to free up in milliseconds
#define WAITING_DELAY 1 // *RO

#endif



