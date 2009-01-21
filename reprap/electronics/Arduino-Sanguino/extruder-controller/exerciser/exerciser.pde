#define QUAD_A_PIN 2
#define QUAD_B_PIN 3

#define RX_ENABLE_PIN 4
#define TX_ENABLE_PIN 16

#define MOTOR_A_SPEED_PIN 5
#define MOTOR_A_DIR_PIN 7

#define MOTOR_B_SPEED_PIN 6
#define MOTOR_B_DIR_PIN 8

#define OUTPUT_A_PIN 15
#define OUTPUT_B_PIN 11
#define OUTPUT_C_PIN 12

#define DEBUG_PIN 13

#define THERMISTOR_PIN 3

void setup()
{
  //init our quadrature encoder pins.
  pinMode(QUAD_A_PIN, INPUT);
  pinMode(QUAD_B_PIN, INPUT);

  //init our RS485 comms pins
  pinMode(RX_ENABLE_PIN, OUTPUT);
  pinMode(TX_ENABLE_PIN, INPUT);

  //get ready to receive data.
  digitalWrite(RX_ENABLE_PIN, HIGH);
  digitalWrite(TX_ENABLE_PIN, LOW);
  
  //init our motor control pins.
  pinMode(MOTOR_A_SPEED_PIN, OUTPUT);
  pinMode(MOTOR_A_DIR_PIN, OUTPUT);
  pinMode(MOTOR_B_SPEED_PIN, OUTPUT);
  pinMode(MOTOR_B_DIR_PIN, OUTPUT);

  //default to an off state.
  analogWrite(MOTOR_A_SPEED_PIN, 0);
  analogWrite(MOTOR_B_SPEED_PIN, 0);
  digitalWrite(MOTOR_A_DIR_PIN, LOW);
  digitalWrite(MOTOR_B_DIR_PIN, LOW);
  
  //init our output control pins.
  pinMode(OUTPUT_A_PIN, OUTPUT);
  pinMode(OUTPUT_B_PIN, OUTPUT); 
  pinMode(OUTPUT_C_PIN, OUTPUT);
  
  //default our output pins to off.
  digitalWrite(OUTPUT_A_PIN, LOW);
  analogWrite(OUTPUT_B_PIN, 0);
  analogWrite(OUTPUT_C_PIN, 0);
}

boolean dir = 1;
boolean blink = 0;

void loop()
{
 digitalWrite(MOTOR_A_DIR_PIN, dir);
 digitalWrite(MOTOR_B_DIR_PIN, !dir);
 
 for (byte i=0; i<255; i++)
 {
    analogWrite(MOTOR_A_SPEED_PIN, i);
    analogWrite(MOTOR_B_SPEED_PIN, 256-i);
    
    digitalWrite(DEBUG_PIN, blink);
    blink = !blink;
    
    delayMicroseconds(19531);
 }
}
