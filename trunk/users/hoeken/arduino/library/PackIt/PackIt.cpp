
#include "PackIt.h"
#include "WConstants.h"

PackIt::PackIt(byte to, byte from)
{
	this->to = to;
	this->from = from;
	this->size = 0;
	this->crc = 0;
}

boolean PackIt::add(byte b)
{
	//do we have room left?
	if (this->size <= MAX_PACKET_SIZE)
	{
		//add it in!
		this->packets[this->size] = b;
		this->size++;
		
		//calculate our crc
		this->crc = this->crc ^ b;
	}
	else
		return false;
}

boolean PackIt::add(boolean b)
{
	if (b)
		return this->add((byte)1);
	else
		return this->add((byte)0);
}

boolean PackIt::add(char c)
{
	return this->add((byte)c);
}

boolean PackIt::add(int i)
{
	byte j, b;
	bool result;
	
	for (j=0; j<4; j++)
	{
		b = i & B11111111;
		result = this->add(b);
		i >>= 8;
	}
	
	return result;
}

boolean PackIt::add(unsigned int i)
{
	return this->add((int)i);
}

boolean PackIt::add(long l)
{
	byte i, b;
	bool result;
	
	for (i=0; i<4; i++)
	{
		b = l & B11111111;
		result = this->add(b);
		l >>= 8;
	}
	
	return result;
}

boolean PackIt::add(unsigned long l)
{
	return this->add((long)l)
}

boolean PackIt::add(float f)
{
	byte i, b;
	bool result;
	
	for (i=0; i<4; i++)
	{
		b = f & B11111111;
		result = this->add(b);
		f >>= 8;
	}
	
	return result;
}

boolean PackIt::add(double d)
{
	byte i, b;
	bool result;
	
	for (i=0; i<8; i++)
	{
		b = d & B11111111;
		result = this->add(b);
		d >>= 8;
	}
	
	return result;
}

void send()
{
	byte i;

	//send our header
	Serial.print(this->to);
	Serial.print(this->from);
	Serial.print(this->crc);
	Serial.print(this->size);

	//send our data!
	for (i=0; i<MAX_PACKET_SIZE; i++)
		Serial.print(this->packets[i]);
}
