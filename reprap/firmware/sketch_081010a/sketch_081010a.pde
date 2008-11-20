#include <HardwareSerial.h>

char c;
long count;

void setup()
{
  	Serial.begin(19200);
        Serial.println("Type a character: ");
        while(!Serial.available());
        c = Serial.read();
}

void loop()
{
  Serial.println(count);
  count++;
  delay(1000);
}
