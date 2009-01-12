#include <Wire.h>
#include "i2c_lcd.h"


void setup()
{
  Serial.begin(19200);
  Wire.begin();                   //this is to start the initilize the lcd screen                                     
         portexpanderinit();
         delay(200);
         LCDinit();
         delay(500);
         LCDclear(); 
         LCDprint("start"[5]);
}

void loop()
{
  if (Serial.available()) {
    LCDprint(Serial.read());
  }
}
