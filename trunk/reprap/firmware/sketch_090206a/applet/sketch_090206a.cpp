#include "WProgram.h"
#define stepPin 4
#define dirPin 5
#define enablePin 6

void setup()
{
  Serial.begin(9600);
  Serial.println("Starting stepper exerciser.");

  pinMode(stepPin, OUTPUT);
  pinMode(dirPin, OUTPUT);
  pinMode(enablePin, OUTPUT);
  
  digitalWrite(dirPin, HIGH);
  digitalWrite(stepPin, LOW);
  digitalWrite(enablePin, LOW);
}

void loop()
{
    int i, j;
    
    for (i=4000; i>=2000; i-=150)
    {
      Serial.print("Speed: ");
      Serial.println(i);
      
      for (j=0; j<2000; j++)
      {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(2);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(i);
      }

      delay(500);
      Serial.println("Switching directions.");
      digitalWrite(dirPin, !digitalRead(dirPin));

      for (j=0; j<2000; j++)
      {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(2);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(i);
      }

      delay(1000);
      Serial.println("Switching directions."); 
      digitalWrite(dirPin, !digitalRead(dirPin));
  }
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

