#ifndef FEATURES_H
#define FEATURES_H
// Features.   
//Each of these defines relates specifically to a component electronic or hardware function or capability that may or may not exist 
// in your particular machine.
// You should select which of these are used, in your instance, in configuration.h

///#define USE_EXTRUDER_CONTROLLER 1   // 1 means the extruder has its own controller that we talk to via RS485, 0 means it uses the integrated PID logic. 

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


// #define DATA_SOURCE DATA_SOURCE_USB_SERIAL

#define DATA_SOURCE_USB_SERIAL 1
#define DATA_SOURCE_SDCARD 2   // is there an SD card reader present?   
//#define DATA_SOURCE_EEPROM 3   // this is just a theoretical one at this time
  
#endif



