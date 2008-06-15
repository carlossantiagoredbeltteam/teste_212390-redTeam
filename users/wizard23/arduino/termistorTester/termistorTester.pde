

#define NUMTEMPS 32
short temptable[NUMTEMPS][2] = {
   {210, -10},
   {224, 0},
   {238, 10},
   {252, 20},
   {266, 30},
   {281, 40},
   {296, 50},
   {310, 60},
   {325, 70},
   {339, 80},
   {354, 90},
   {368, 100},
   {383, 110},
   {397, 120},
   {411, 130},
   {425, 140},
   {439, 150},
   {452, 160},
   {465, 170},
   {478, 180},
   {491, 190},
   {503, 200},
   {516, 210},
   {528, 220},
   {539, 230},
   {551, 240},
   {562, 250},
   {573, 260},
   {583, 270},
   {593, 280},
   {602, 290},
   {610, 300},
};


int dir_pin_a = 8;
int speed_pin_a = 9;






int calculateTemperatureFromRaw(int raw)
{
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

void setup()
{
  
  pinMode(dir_pin_a, OUTPUT);
  pinMode(speed_pin_a, OUTPUT);
  digitalWrite(dir_pin_a, HIGH);
  
  // setting up tempsensor
    pinMode(14, OUTPUT);
  digitalWrite(14, HIGH);
  pinMode(16, OUTPUT);
  digitalWrite(16, LOW);
  
  Serial.begin(9600);
  Serial.println("Extruder Tester ready to extrude!"
  );

}

int cnt = 0;
int dcSpeed = 150;

void loop()
{
  cnt++;
  
 if (cnt % 200 == 0) {
   int val = analogRead(1);
   int celsius =  calculateTemperatureFromRaw(val);
   Serial.println(celsius);
   if (celsius > 150)
     Serial.println("ALERT");
 }
 
 int val = Serial.read();
 
 if (val == 'b')
 {
   Serial.println("Motor BACKWARD");
   digitalWrite(dir_pin_a, LOW);
 }
 
 if (val == 'f')
 {
   Serial.println("Motor FORWARD");
   digitalWrite(dir_pin_a, HIGH);
 }
 
 if (val == '+')
 {
   dcSpeed+=10;
   Serial.print("speed: ");
   Serial.println(dcSpeed);
 }
 
 if (val == '-')
 {
   dcSpeed-=10;
   Serial.print("speed: ");
   Serial.println(dcSpeed);
 }
 
 if (val == 'm')
 {
   Serial.print("speed: ");
   Serial.println(dcSpeed);
   Serial.println("2 sec");
   analogWrite(speed_pin_a, dcSpeed);
   delay(1000);
   analogWrite(speed_pin_a, 0);
 }
 
 if (val == 'x')
 {
   Serial.print("speed: ");
   Serial.println(dcSpeed);
   Serial.println("Motor ON");
   analogWrite(speed_pin_a, dcSpeed);
 }
 
 if (val == ' ')
 {
   Serial.println("Motor OFF");
   analogWrite(speed_pin_a, 0);
 }
 delay(3);
}
