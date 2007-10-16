
int pwm_a = 9;
int pwm_b = 10;
int pwm_c = 11;
int i;

void setup()
{
	pinMode(9, OUTPUT);
	pinMode(10, OUTPUT);
	pinMode(11, OUTPUT);	

	Serial.begin(9600);
}

void loop()
{
	//
	//fade all channels up and down.
	//
	Serial.println("Fading all pwm channels up to max.");
	for (i=0; i<=255; i++)
	{
		analogWrite(pwm_a, i);
		analogWrite(pwm_b, i);
		analogWrite(pwm_c, i);
	
		delay(100);
	}
	Serial.println("All pwm channels at max, fading down.");
	for (i=255; i>=0; i--)
	{
		analogWrite(pwm_a, i);
		analogWrite(pwm_b, i);
		analogWrite(pwm_c, i);

		delay(100);	
	}
	Serial.println("All pwm channels at zero.");
	
	//
	//only channel A now
	//
	Serial.println("Fading pwm channel A to max.");
	for (i=0; i<=255; i++)
	{
		analogWrite(pwm_a, i);
		delay(100);
	}
	Serial.println("pwm channel A at max, fading down.");
	for (i=255; i>=0; i--)
	{
		analogWrite(pwm_a, i);
		delay(100);	
	}
	Serial.println("pwm channel A at 0.");

	//
	//only channel B now
	//
	Serial.println("Fading pwm channel B to max.");
	for (i=0; i<=255; i++)
	{
		analogWrite(pwm_b, i);
		delay(100);
	}
	Serial.println("pwm channel B at max, fading down.");
	for (i=255; i>=0; i--)
	{
		analogWrite(pwm_b, i);
		delay(100);	
	}
	Serial.println("pwm channel B at 0.");


	//
	//only channel C now
	//
	Serial.println("Fading pwm channel C to max.");
	for (i=0; i<=255; i++)
	{
		analogWrite(pwm_c, i);
		delay(100);
	}
	Serial.println("pwm channel C at max, fading down.");
	for (i=255; i>=0; i--)
	{
		analogWrite(pwm_c, i);
		delay(100);	
	}
	Serial.println("pwm channel C at 0.");

}