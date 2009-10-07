// Yep, this is actually -*- c++ -*-
void init_extruder()
{
  //reset motor1
  motor1_control = MC_PWM;
  motor1_dir = MC_FORWARD;
  motor1_pwm = 0;
  motor1_target_rpm = 0;
  motor1_current_rpm = 0;
  
  //reset motor2
  motor2_control = MC_PWM;
  motor2_dir = MC_FORWARD;
  motor2_pwm = 0;
  motor2_target_rpm = 0;
  motor2_current_rpm = 0;
	
  //free up 9/10
  servo1.detach();
  servo2.detach();

  //init our PID stuff.
  speed_error = 0;
  iState = 0;
  dState = 0;
  pGain = SPEED_INITIAL_PGAIN;
  iGain = SPEED_INITIAL_IGAIN;
  dGain = SPEED_INITIAL_DGAIN;
	
  //encoder pins are for reading.
  pinMode(ENCODER_A_PIN, INPUT);
  pinMode(ENCODER_B_PIN, INPUT);

  //pullups on our encoder pins
  digitalWrite(ENCODER_A_PIN, HIGH);
  digitalWrite(ENCODER_B_PIN, HIGH);

  //attach our interrupt handler
  attachInterrupt(0, read_quadrature, CHANGE);

  //setup our motor control pins.
  pinMode(MOTOR_1_SPEED_PIN, OUTPUT);
  pinMode(MOTOR_2_SPEED_PIN, OUTPUT);
  pinMode(MOTOR_1_DIR_PIN, OUTPUT);
  pinMode(MOTOR_2_DIR_PIN, OUTPUT);

  //turn them off and forward.
  digitalWrite(MOTOR_1_SPEED_PIN, LOW);
  digitalWrite(MOTOR_2_SPEED_PIN, LOW);
  digitalWrite(MOTOR_1_DIR_PIN, HIGH);
  digitalWrite(MOTOR_2_DIR_PIN, HIGH);

  //setup our various accessory pins.
  pinMode(HEATER_PIN, OUTPUT);
  pinMode(FAN_PIN, OUTPUT);
  pinMode(VALVE_PIN, OUTPUT);

  //turn them all off
  digitalWrite(HEATER_PIN, LOW);
  digitalWrite(FAN_PIN, LOW);
  digitalWrite(VALVE_PIN, LOW);

  //setup our debug pin.
  pinMode(DEBUG_PIN, OUTPUT);
  digitalWrite(DEBUG_PIN, LOW);

  //default to zero.
  set_temperature(0);

  setupTimer1Interrupt();
}

void read_quadrature()
{  
  // found a low-to-high on channel A
  if (digitalRead(ENCODER_A_PIN) == HIGH)
  {   
    // check channel B to see which way
    if (digitalRead(ENCODER_B_PIN) == LOW)
      QUADRATURE_INCREMENT
else
  QUADRATURE_DECREMENT
}
// found a high-to-low on channel A
  else                                        
  {
    // check channel B to see which way
    if (digitalRead(ENCODER_B_PIN) == LOW)
      QUADRATURE_DECREMENT
else
  QUADRATURE_INCREMENT
}
}

void enable_motor_1()
{
  if (motor1_control == MC_PWM)
  {
    //nuke any previous reversals.
    motor1_reversal_state = false;
    
    if (motor1_dir == MC_FORWARD)
      digitalWrite(MOTOR_1_DIR_PIN, HIGH);
    else
      digitalWrite(MOTOR_1_DIR_PIN, LOW);

    analogWrite(MOTOR_1_SPEED_PIN, motor1_pwm);
  }
  else if (motor1_control == MC_ENCODER)
  {
    speed_error = 0;
    disableTimer1Interrupt();
    setTimer1Ticks(motor1_target_rpm);
    enableTimer1Interrupt();
  }
  else if (motor1_control == MC_STEPPER)
  {
    setTimer1Ticks(stepper_ticks);
    enableTimer1Interrupt();
  }
}

void disable_motor_1()
{
  if (motor1_control == MC_PWM)
  {
    analogWrite(MOTOR_1_SPEED_PIN, 0);
    
    if (motor1_dir == MC_FORWARD)
      motor1_reversal_state = true;
  }
  else if (motor1_control == MC_ENCODER)
  {
    speed_error = 0;
    disableTimer1Interrupt();
  }
  else if (motor1_control == MC_STEPPER)
  {
    disableTimer1Interrupt();
    digitalWrite(MOTOR_1_SPEED_PIN, LOW);
    digitalWrite(MOTOR_2_SPEED_PIN, LOW);
  }
}

void reverse_motor_1()
{
  //wait for it to stop.
  if (DELAY_FOR_STOP > 0)
    cancellable_delay(DELAY_FOR_STOP, 0);

  //reverse our motor for a bit.
  if (MOTOR_REVERSE_DURATION > 0 && motor1_reversal_state)
  {
    digitalWrite(MOTOR_1_DIR_PIN, LOW);
    analogWrite(MOTOR_1_SPEED_PIN, motor1_pwm);
    cancellable_delay(MOTOR_REVERSE_DURATION, 1);
  }

  //wait for it to stop.
  if (DELAY_FOR_STOP > 0 && motor1_reversal_state)
    cancellable_delay(DELAY_FOR_STOP, 0);
  
  //forward our motor for a bit.
  if (MOTOR_FORWARD_DURATION > 0 && motor1_reversal_state)
  {
    digitalWrite(MOTOR_1_DIR_PIN, HIGH);
    analogWrite(MOTOR_1_SPEED_PIN, motor1_pwm);
    cancellable_delay(MOTOR_FORWARD_DURATION, 2);
  }
  
  motor1_reversal_count = 0;

  //finally stop it.
  if (motor1_reversal_state)
    analogWrite(MOTOR_1_SPEED_PIN, 0);
  
  //we're done.
  motor1_reversal_state = false;
}

//basically we want to delay unless there is a start command issued.
void cancellable_delay(unsigned int duration, byte state)
{
  if (motor1_reversal_state)
  {
    for (unsigned int i=0; i<duration; i++)
    {
      delay(1);
      
      //keep track of how far we go.
      if (state == 1)
	      motor1_reversal_count++;
      else if (state == 2)
      	motor1_reversal_count--;
      	
      //dont let it go below zero or above our forward duration.
      motor1_reversal_count = max(0, motor1_reversal_count);
      motor1_reversal_count = min(MOTOR_FORWARD_DURATION, motor1_reversal_count);

			//check for packets.
      process_packets();
      
      //did we start up?  break!
      if (!motor1_reversal_state)
        break;
    }    
  }
}

void enable_motor_2()
{
  if (motor2_control == MC_PWM)
  {
    if (motor2_dir == MC_FORWARD)
      digitalWrite(MOTOR_2_DIR_PIN, HIGH);
    else
      digitalWrite(MOTOR_2_DIR_PIN, LOW);

    analogWrite(MOTOR_2_SPEED_PIN, motor2_pwm);
  }
  else if (motor2_control == MC_ENCODER)
  {
    speed_error = 0;
    setTimer1Ticks(motor2_target_rpm/16);
    enableTimer1Interrupt();
  }
}

void disable_motor_2()
{
  if (motor2_control == MC_PWM)
    analogWrite(MOTOR_2_SPEED_PIN, 0);
  else if (motor2_control == MC_ENCODER)
  {
    speed_error = 0;
    disableTimer1Interrupt();
  }
}

void enable_fan()
{
  digitalWrite(FAN_PIN, HIGH);
}

void disable_fan()
{
  digitalWrite(FAN_PIN, LOW);
}

void open_valve()
{
  digitalWrite(VALVE_PIN, HIGH);
}

void close_valve()
{
  digitalWrite(VALVE_PIN, LOW);
}

byte is_tool_ready()
{
  //are we within 5% of the temperature?
  if (current_temperature > (int)(target_temperature * 0.95))
    return 1;
  else
    return 0;
}

void set_temperature(int temp)
{
  target_temperature = temp;
  max_temperature = (int)((float)temp * 1.1);
}

/**
 *  Samples the temperature and converts it to degrees celsius.
 *  Returns degrees celsius.
 */
int get_temperature()
{
#ifdef THERMISTOR_PIN
  return read_thermistor();
#endif
#ifdef THERMOCOUPLE_PIN
  return read_thermocouple();
#endif
}

/*
* This function gives us the temperature from the thermistor in Celsius
 */
#ifdef THERMISTOR_PIN
int read_thermistor()
{
  int raw = sample_temperature(THERMISTOR_PIN);

  int celsius = 0;
  byte i;

  for (i=1; i<NUMTEMPS; i++)
  {
    if (temptable[i][0] > raw)
    {
      celsius  = temptable[i-1][1] + 
        (raw - temptable[i-1][0]) * 
        (temptable[i][1] - temptable[i-1][1]) /
        (temptable[i][0] - temptable[i-1][0]);

      if (celsius > 255)
        celsius = 255; 

      break;
    }
  }

  // Overflow: We just clamp to 0 degrees celsius
  if (i == NUMTEMPS)
    celsius = 0;

  return celsius;
}
#endif

/*
* This function gives us the temperature from the thermocouple in Celsius
 */
#ifdef THERMOCOUPLE_PIN
int read_thermocouple()
{
  return ( 5.0 * sample_temperature(THERMOCOUPLE_PIN) * 100.0) / 1024.0;
}
#endif

/*
* This function gives us an averaged sample of the analog temperature pin.
 */
int sample_temperature(byte pin)
{
  int raw = 0;

  //read in a certain number of samples
  for (byte i=0; i<TEMPERATURE_SAMPLES; i++)
    raw += analogRead(pin);

  //average the samples
  raw = raw/TEMPERATURE_SAMPLES;

  //send it back.
  return raw;
}


/*!
 Manages motor and heater based on measured temperature:
 o If temp is too low, don't start the motor
 o Adjust the heater power to keep the temperature at the target
 */
void manage_temperature()
{
  //make sure we know what our temp is.
  current_temperature = get_temperature();

  //put the heater into high mode if we're not at our target.
  if (current_temperature < target_temperature)
    analogWrite(HEATER_PIN, heater_high);
  //put the heater on low if we're at our target.
  else if (current_temperature < max_temperature)
    analogWrite(HEATER_PIN, heater_low);
  //turn the heater off if we're above our max.
  else
    analogWrite(HEATER_PIN, 0);
}


//this handles the timer interrupt event
void manage_motor1_speed()
{
  // somewhat hacked implementation of a PID algorithm as described at:
  // http://www.embedded.com/2000/0010/0010feat3.htm - PID Without a PhD, Tim Wescott 

  int abs_error = abs(speed_error);
  int pTerm = 0;
  int iTerm = 0;
  int dTerm = 0;
  int speed = 0;

  //hack for extruder not keeping up, overflowing, then shutting off.
  if (speed_error < -5000)
    speed_error = -500;
  if (speed_error > 5000)
    speed_error = 500;

  if (speed_error < 0)
  {
    //calculate our P term
    pTerm = abs_error / pGain;

    //calculate our I term
    iState += abs_error;
    iState = constrain(iState, iMin, iMax);
    iTerm = iState / iGain;

    //calculate our D term
    dTerm = (abs_error - dState) * dGain;
    dState = abs_error;

    //calculate our PWM, within bounds.
    speed = pTerm + iTerm - dTerm;
  }

  //our debug loop checker thingie
  /*
    cnt++;
   if (cnt > 250)
   {
   Serial.print("e:");
   Serial.println(speed_error);
   Serial.print("spd:");
   Serial.println(speed);
   cnt = 0;
   }
   */

  //figure out our real speed and use it.
  motor1_pwm = constrain(speed, MIN_SPEED, MAX_SPEED);

  analogWrite(MOTOR_1_SPEED_PIN, motor1_pwm);
}
