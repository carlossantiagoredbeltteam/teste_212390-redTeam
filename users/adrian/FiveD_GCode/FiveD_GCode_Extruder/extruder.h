#ifndef EXTRUDER_H
#define EXTRUDER_H

#define REPLY_LENGTH 20

#define WAIT_T 'W'        // wait_for_temperature();
#define VALVE 'V'         // valve_set(bool open, int dTime);
#define DIRECTION 'D'     // set_direction(bool direction);
#define COOL 'C'          // set_cooler(byte e_speed);
#define SET_T 'T'         // set_temperature(int temp);
#define GET_T 't'         // get_temperature();
#define STEP 'S'          // step();
#define ENABLE 'E'        // enableStep();
#define DISABLE 'e'       // disableStep();
#define PREAD 'R'         // read the pot voltage
#define SPWM 'M'          // Set the motor PWM
#define PING 'P'          // Just acknowledge

class extruder
{

public:
   extruder();

   char* processCommand(char command[]);
   
   void manage();
  
private:

// We will half-step;  coilPosition will take values between 0 and 7 inclusive

   byte coilPosition;

// This variable stores the value (0..255) of the on-board potentiometer.  This is used 
// to vary the PWM mark-space values in analogWrites() to the enable pins, hence 
// controlling the effective motor current.

   byte pwmValue;
   byte stp;
   int  temp;     // Target temperature in C
   bool h1Enable;
   bool h2Enable;
   bool forward;
   char reply[REPLY_LENGTH];

   void waitForTemperature();
   void valveSet(bool open);
   void setDirection(bool direction);
   void setCooler(byte e_speed);
   void setTemperature(int t);
   int getTemperature();
   void sStep();
   void enableStep();
   void disableStep();
   int potVoltage();
   void setPWM(int p); 
};

#endif

