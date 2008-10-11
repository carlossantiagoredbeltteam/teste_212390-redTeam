#include "WProgram.h"
#include "HardwareSerial.h"
char* fp="12.345";
char* end;
float res=-1.123;

void setup()
{
  	Serial.begin(19200);
        Serial.println("start");
        // Uncomment next line to cause crash...
	res = (float)strtod(fp, &end);
        Serial.print(((int)(res*1000 + 0.5))/1000);
        Serial.print(".");
        Serial.println(((int)abs(res*1000 + 0.5))%1000);
}

void loop()
{
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

