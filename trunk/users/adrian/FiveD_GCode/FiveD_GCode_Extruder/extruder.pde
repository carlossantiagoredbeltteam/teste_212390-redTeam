#include "extruder.h"

extruder::extruder()
{
  pinMode(H1D, OUTPUT);
  pinMode(H1E, OUTPUT);  
  pinMode(H2D, OUTPUT);
  pinMode(H2E, OUTPUT);
  pinMode(OUTPUT_A, OUTPUT);
  pinMode(OUTPUT_B, OUTPUT);
  pinMode(OUTPUT_C, OUTPUT);  
  pinMode(POT, INPUT);
  
  disableStep();
  
  // Change the frequency of Timer 0 so that PWM on pins H1E and H2E goes at
  // a very high frequency (64kHz see: 
  // http://tzechienchu.typepad.com/tc_chus_point/2009/05/changing-pwm-frequency-on-the-arduino-diecimila.html)
  
  TCCR0B &= ~(0x07); 
  TCCR0B |= 1; 
  
  coilPosition = 0;  
  forward = true;
  
  // How much is the pot turned up?
  // Divide it by 4 to spread the valid readings out a bit.
  // This is about right for a 1A 3-ohm/coil stepper.
  
  potValue = analogRead(POT)>>2;
}

void extruder::wait_for_temperature()
{
  
}

void extruder::valve_set(bool open)
{

}

void extruder::set_direction(bool direction)
{
  forward = direction;  
}

void extruder::set_cooler(byte e_speed)
{
  if(e_speed > 20)
    digitalWrite(OUTPUT_B, 1);
  else
    digitalWrite(OUTPUT_B, 0);    
}

void extruder::set_temperature(int temp)
{
  if(temp > 20)
    digitalWrite(OUTPUT_A, 1);
  else
    digitalWrite(OUTPUT_A, 0);  
}

int extruder::get_temperature()
{
  return 99;  
}

void extruder::manage()
{
  
}

void extruder::step()
{
// This increments or decrements coilPosition then writes the appropriate pattern to the output pins.

  if(forward)
    coilPosition++;
  else
    coilPosition--;
  coilPosition &= 7;
  
  // Disable the coils
  
  digitalWrite(H1E, 0);
  digitalWrite(H2E, 0);
  
  // Which of the 8 possible patterns do we want?
  // The commented out setPower(...) lines could
  // be used to run the coils at constant power (with
  // half-stepping not each step is equal).  Just
  // use the value of the argument to setPower(...) to
  // scale the PWM values.
  
  switch(coilPosition) 
  {
  case 7:
    //setPower((stepPower >> 1) + (stepPower >> 3));
    digitalWrite(H1D, 1);    
    digitalWrite(H2D, 1);
    h1Enable = true;
    h2Enable = true;    
    break;
    
  case 6:
    //setPower(stepPower);
    digitalWrite(H1D, 1);    
    digitalWrite(H2D, 1);
    h1Enable = true;
    h2Enable = false;   
    break; 
    
  case 5:
    //setPower((stepPower >> 1) + (stepPower >> 3));
    digitalWrite(H1D, 1);
    digitalWrite(H2D, 0);
    h1Enable = true;
    h2Enable = true; 
    break;
    
  case 4:
    //setPower(stepPower);
    digitalWrite(H1D, 1);
    digitalWrite(H2D, 0);
    h1Enable = false;
    h2Enable = true; 
    break;
    
  case 3:
    //setPower((stepPower >> 1) + (stepPower >> 3));
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 0);
    h1Enable = true;
    h2Enable = true; 
    break; 
    
  case 2:
    //setPower(stepPower);
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 0);
    h1Enable = true;
    h2Enable = false; 
    break;
    
  case 1:
    //setPower((stepPower >> 1) + (stepPower >> 3));
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 1);
    h1Enable = true;
    h2Enable = true; 
    break;
    
  case 0:
    //setPower(stepPower);
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 1);
    h1Enable = false;
    h2Enable = true; 
    break; 
    
  }
  
  // How much is the pot turned up?
  // Divide it by 4 to spread the valid readings out a bit.
  // This is about right for a 1A 3-ohm/coil stepper.
  
  //potValue = analogRead(POT)>>2;
  
  // Send the appropriate PWM values
  
  if(h1Enable)
    analogWrite(H1E, potValue);
  else
    analogWrite(H1E, 0);
    
  if(h2Enable)
    analogWrite(H2E, potValue);
  else
    analogWrite(H2E, 0);
}
 

void extruder::enableStep()
{
// Nothing to do here - step() automatically enables the stepper drivers appropriately.  
}

void extruder::disableStep()
{
    analogWrite(H1E, 0);
    analogWrite(H2E, 0);  
}

char* extruder::processCommand(char command[])
{
  reply[0] = 0;
  switch(command[0])
  {
    case WAIT_T:
      wait_for_temperature();
      break;
      
    case VALVE:
      valve_set(command[1] == '1');
      break;
      
    case DIRECTION:
      set_direction(command[1] == '1');
      break;
      
     case COOL:
       set_cooler(atoi(&command[1]));
       break;
       
     case SET_T:
       set_temperature(atoi(&command[1]));
       break;
       
     case GET_T:
       itoa(get_temperature(), reply, 10);
       break;
        
     case STEP:
       step();
       break;
        
     case ENABLE:
       enableStep();
       break;
        
     case DISABLE:
       disableStep();
       break;
        
     case PING:
       break;
        
     default:
        return 0; // Flag up dud command
    }
   return reply; 
}
