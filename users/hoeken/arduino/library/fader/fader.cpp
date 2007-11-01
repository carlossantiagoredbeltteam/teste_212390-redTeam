
#include "WConstants.h"
#include "Fader.h"

void fadeUp(int pin, int delayTime)
{
	fadeTo(pin, 0, 255, delayTime);
}

void fadeDown(int pin, int delayTime)
{
	fadeTo(pin, 255, 0, delayTime);
}

void fadeTo(int pin, int start, int stop, int delayTime)
{
	int i;
	
	//do some error checking to make sure its within bounds
	start = max(start, 0);
	start = min(start, 255);
	stop = max(stop, 0);
	stop = min(stop, 255);
	
	//okay, fade up!
	if (start < stop)
	{
		for (i=start; i<=stop; i++)
		{
			analogWrite(pin, i);
			delay(delayTime);
		}
	}
	//nope, fade down!
	else if (stop < start)
	{
		for (i=start; i>=stop; i--)
		{
			analogWrite(pin, i);
			delay(delayTime);
		}
	}
	//otherwise, they're equal and we just fall through.
}
