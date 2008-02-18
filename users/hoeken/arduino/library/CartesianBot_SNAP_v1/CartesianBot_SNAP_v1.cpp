#include "CartesianBot_SNAP_v1.h"
#include <avr/interrupt.h>
#include "HardwareSerial.h"

/**********************************
*  Global variable instantiations
**********************************/

byte x_notify = 255;
byte y_notify = 255;
byte z_notify = 255;

byte x_sync_mode = sync_none;
byte y_sync_mode = sync_none;

//our mode holder.
byte bot_mode = MODE_PAUSE;
byte x_mode = MODE_PAUSE;
byte y_mode = MODE_PAUSE;
byte z_mode = MODE_PAUSE;

SIGNAL(SIG_OUTPUT_COMPARE1A)
{
	if (bot_mode == MODE_PAUSE)
		bot.disableTimerInterrupt();
	else if (bot_mode == MODE_DDA)
		interruptDDA();
	else if (bot_mode == MODE_HOMERESET)
		interruptHomeReset();
	else if (bot_mode == MODE_SEEK)
		interruptSeek();
/*
	else if (bot_mode == MODE_FIND_MIN)
		true; //interruptFindMin();
	else if (bot_mode == MODE_FIND_MAX)
		true; //interruptFindMax();
*/
	else
	{
		bot.mode = MODE_PAUSE;
		bot.disableTimerInterrupt();
	}
}

void interruptDDA()
{
	/*
	snap.debug();
	Serial.print("x");
	Serial.println(bot.x.counter);

	snap.debug();
	Serial.print("y");
	Serial.println(bot.y.counter);

	snap.debug();
	Serial.print("m");
	Serial.println(bot.max_delta);
	*/

//	snap.debug();
//	Serial.println("s");

	if (bot.y.can_step)
		bot.y.ddaStep(bot.max_delta);

//	snap.debug();
//	Serial.println("m");

	if (bot.x.can_step)
		bot.x.ddaStep(bot.max_delta);

//	snap.debug();
//	Serial.println("f");
}

void interruptHomeReset()
{
//	snap.debug();
//	Serial.println("h");

	if (x_mode == MODE_HOMERESET && !bot.x.atMin())
			bot.x.stepper.pulse();

	if (y_mode == MODE_HOMERESET && !bot.y.atMin())
			bot.y.stepper.pulse();

	if (z_mode == MODE_HOMERESET && !bot.z.atMin())
			bot.z.stepper.pulse();
}

void interruptSeek()
{
	if (bot.x.can_step)
		bot.x.doStep();

	if (bot.y.can_step)
		bot.y.doStep();
	
	if (bot.z.can_step)
		bot.z.doStep();
}

void interruptFindMin()
{
	/*
	if (bot.x.function == func_findmin)
	{
		if (!digitalRead(bot.x.min_pin))
			bot.x.stepper.pulse();
	}

	if (bot.y.function == func_findmin)
	{
		if (!digitalRead(bot.y.min_pin))
			bot.y.stepper.pulse();
	}

	if (bot.z.function == func_findmin)
	{
		if (!digitalRead(bot.z.min_pin))
			bot.z.stepper.pulse();
	}
	*/
}

void interruptFindMax()
{
/*
	if (bot.x.function == func_findmax)
	{
		//do a step if we're not there yet.
		if (!bot.x.atMax())
			bot.x.doStep();
	}
	
	if (bot.y.function == func_findmax)
	{
		//do a step if we're not there yet.
		if (!bot.y.atMax())
			bot.y.doStep();
	}
	
	if (bot.z.function == func_findmax)
	{
		//do a step if we're not there yet.
		if (!bot.z.atMax())
			bot.z.doStep();
	}
*/
}


void setup_cartesian_bot_snap_v1()
{
	bot.setupTimerInterrupt();
	bot.disableTimerInterrupt();
	
	snap.addDevice(X_ADDRESS);
	snap.addDevice(Y_ADDRESS);
	snap.addDevice(Z_ADDRESS);
}

void cartesian_bot_snap_v1_loop()
{	
	if (bot_mode == MODE_PAUSE)
	{
		x_mode = MODE_PAUSE;
		y_mode = MODE_PAUSE;
		z_mode = MODE_PAUSE;
		
		return;
	}
	else if (bot_mode == MODE_DDA)
	{
		if (bot.atTarget())
		{
			//stop us.
			bot_mode = MODE_PAUSE;
			x_mode = MODE_PAUSE;
			y_mode = MODE_PAUSE;
			z_mode = MODE_PAUSE;
			bot.disableTimerInterrupt();

			if (x_notify != 255)
				notifyDDA(x_notify, X_ADDRESS, bot.x.current);
			if (y_notify != 255)
				notifyDDA(y_notify, Y_ADDRESS, bot.y.current);
		}
	}
	else if (bot_mode == MODE_HOMERESET)
	{
		if (x_mode == MODE_HOMERESET)
		{
			if (bot.x.atMin())
			{
				snap.debug();
				Serial.println("x home.");
				
				x_mode = MODE_PAUSE;
				bot.x.setPosition(0);
				bot.x.setTarget(0);
				bot.x.stepper.setDirection(RS_FORWARD);

				if (x_notify != 255)
					notifyHomeReset(x_notify, X_ADDRESS);
			}
		}

		if (y_mode == MODE_HOMERESET)
		{
			if (bot.y.atMin())
			{
				y_mode = MODE_PAUSE;
				bot.y.setPosition(0);
				bot.y.setTarget(0);
				bot.y.stepper.setDirection(RS_FORWARD);

				if (y_notify != 255)
					notifyHomeReset(y_notify, Y_ADDRESS);	
			}
		}
		
		if (z_mode == MODE_HOMERESET)
		{
			if (bot.z.atMin())
			{
				z_mode = MODE_PAUSE;
				bot.z.setPosition(0);
				bot.z.setTarget(0);
				bot.z.stepper.setDirection(RS_FORWARD);

				if (z_notify != 255)
					notifyHomeReset(z_notify, Z_ADDRESS);
			}
		}
		
		if (x_mode == MODE_PAUSE && y_mode == MODE_PAUSE && z_mode == MODE_PAUSE)
		{
			bot_mode = MODE_PAUSE;
			bot.disableTimerInterrupt();
		}
	}
	else if (bot_mode == MODE_SEEK)
	{
		if (x_mode == MODE_SEEK)
		{
			if (bot.x.current == bot.x.target)
			{
				x_mode = MODE_PAUSE;

				if (x_notify != 255)
					notifySeek(x_notify, X_ADDRESS, (int)bot.x.current);
			}
		}
		
		if (y_mode == MODE_SEEK)
		{
			if (bot.y.current == bot.y.target)
			{
				y_mode = MODE_PAUSE;
			
				if (y_notify != 255)
					notifySeek(y_notify, Y_ADDRESS, (int)bot.y.current);
			}
		}
		
		if (z_mode == MODE_SEEK)
		{
			if (bot.z.current == bot.z.target)
			{
				z_mode = MODE_PAUSE;
			
				if (z_notify != 255)
					notifySeek(z_notify, Z_ADDRESS, (int)bot.z.current);
			}	
		}
		
		if (x_mode == MODE_PAUSE && y_mode == MODE_PAUSE && z_mode == MODE_PAUSE)
		{
			bot_mode = MODE_PAUSE;
			bot.disableTimerInterrupt();
		}
	}
	
	/*
	else if (bot_mode == MODE_FIND_MIN)
	{
		if (bot.x.function == func_findmin)
		{
			if (digitalRead(bot.x.min_pin)
			{
				bot.x.setPosition(0);
				bot.x.stepper.setDirection(RS_FORWARD);
				bot.x.function = func_findmax;
				bot_mode = MODE_FIND_MAX;
			}
		}

		if (bot.y.function == func_findmin)
		{
			if (digitalRead(bot.y.min_pin)
			{
				bot.y.setPosition(0);
				bot.y.stepper.setDirection(RS_FORWARD);
				bot.y.function = func_findmax;
				bot_mode = MODE_FIND_MAX;
			}
		}

		if (bot.z.function == func_findmin)
		{
			if (digitalRead(bot.z.min_pin)
			{
				bot.z.setPosition(0);
				bot.z.stepper.setDirection(RS_FORWARD);
				bot.z.function = func_findmax;
				bot_mode = MODE_FIND_MAX;
			}
		}
	}
	else if (bot_mode == MODE_FIND_MAX)
	{
		if (bot.x.function == func_findmax)
		{
			//are we there yet?
			if (bot.x.atMax())
			{
				bot.x.setMax(bot.x.current);
				bot.x.function = func_idle;
				bot.disableTimerInterrupt();

				if (x_notify != 255)
					notifyCalibrate(x_notify, X_ADDRESS, bot.x.max);
			}
		}

		if (bot.y.function == func_findmax)
		{
			//are we there yet?
			if (bot.y.atMax())
			{
				bot.y.setMax(bot.y.current);
				bot.y.function = func_idle;
				bot.disableTimerInterrupt();

				if (x_notify != 255)
					notifyCalibrate(x_notify, X_ADDRESS, bot.y.max);
			}
		}

		if (bot.z.function == func_findmax)
		{
			//are we there yet?
			if (bot.z.atMax())
			{
				bot.z.setMax(bot.z.current);
				bot.z.function = func_idle;
				bot.disableTimerInterrupt();

				if (x_notify != 255)
					notifyCalibrate(x_notify, X_ADDRESS, bot.z.max);
			}
		}
	}
	*/
}

void process_cartesian_bot_snap_commands_v1()
{
	byte cmd = snap.getByte(0);
	byte dest = snap.getDestination();
	int position = 0;

	switch (cmd)
	{
		case CMD_VERSION:
			snap.startMessage(0, dest);
			snap.sendDataByte(CMD_VERSION);  // Response type 0
			snap.sendDataByte(VERSION_MAJOR);
			snap.sendDataByte(VERSION_MINOR);
			snap.sendMessage();
		break;

		case CMD_FORWARD:
			/*
			//okay, set our speed.
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.x.stepper.setDirection(RS_FORWARD);
				bot.x.function = func_forward;
				bot.setTimer(bot.x.stepper.step_delay);
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.y.stepper.setDirection(RS_FORWARD);
				bot.y.function = func_forward;
				bot.setTimer(bot.y.stepper.step_delay);
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.z.stepper.setDirection(RS_FORWARD);
				bot.z.function = func_forward;
				bot.setTimer(bot.z.stepper.step_delay);
			}
			*/
		break;

		case CMD_REVERSE:
			/*
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.x.stepper.setDirection(RS_REVERSE);
				bot.x.function = func_reverse;
				bot.setTimer(bot.x.stepper.step_delay);
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.y.stepper.setDirection(RS_REVERSE);
				bot.y.function = func_reverse;
				bot.setTimer(bot.y.stepper.step_delay);
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.z.stepper.setDirection(RS_REVERSE);
				bot.z.function = func_reverse;
				bot.setTimer(bot.z.stepper.step_delay);
			}
			*/
		break;

		case CMD_SETPOS:
			position = snap.getInt(1);
			
			if (dest == X_ADDRESS)
			{
				bot.x.setPosition(position);
				bot.x.setTarget(position);
			}
			else if (dest == Y_ADDRESS) 
			{
				bot.y.setPosition(position);
				bot.y.setTarget(position);
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.setPosition(position);
				bot.z.setTarget(position);
			}
		break;

		case CMD_GETPOS:
			if (dest == X_ADDRESS)
				position = bot.x.current;
			else if (dest == Y_ADDRESS)
				position = bot.y.current;
			else if (dest == Z_ADDRESS)
				position = bot.z.current;

			snap.startMessage(0, dest);
			snap.sendDataByte(CMD_GETPOS);
			snap.sendDataInt(position);
			snap.sendMessage();
		break;

		case CMD_SEEK:
			// Goto position
			position = snap.getInt(2);

			snap.debug();
			Serial.println("seekstart");

			//okay, set our speed.
			if (dest == X_ADDRESS)
			{
				x_mode = MODE_SEEK;
				bot.x.setTarget(position);
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.x.stepper.step_delay);
				
				snap.debug();
				Serial.print("xdelay");
				Serial.println(bot.x.stepper.step_delay);
			}
			else if (dest == Y_ADDRESS)
			{
				y_mode = MODE_SEEK;
				bot.y.setTarget(position);
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.step_delay);
				
				snap.debug();
				Serial.print("ydelay");
				Serial.println(bot.y.stepper.step_delay);
			}
			else if (dest == Z_ADDRESS)
			{
				z_mode = MODE_SEEK;
				bot.z.setTarget(position);
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.step_delay);
				
				snap.debug();
				Serial.print("zdelay");
				Serial.println(bot.z.stepper.step_delay);
			}

			//get everything current.
			bot.readState();
			
			//start our seek.
			bot_mode = MODE_SEEK;
			
			snap.debug();
			Serial.println("seekend");
			bot.enableTimerInterrupt();
			
	    break;

		case CMD_FREE:
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.disable();
				x_mode = MODE_PAUSE;
			}
			if (dest == Y_ADDRESS)
			{
				bot.y.stepper.disable();
				y_mode = MODE_PAUSE;
			}
			if (dest == Z_ADDRESS)
			{
				bot.z.stepper.disable();
				z_mode = MODE_PAUSE;
			}
		break;

		case CMD_NOTIFY:
			// Parameter is receiver of notification, or 255 if notification should be turned off
			if (dest == X_ADDRESS)
				x_notify = snap.getByte(1);
			if (dest == Y_ADDRESS)
				y_notify = snap.getByte(1);
			if (dest == Z_ADDRESS)
				z_notify = snap.getByte(1);
		break;

		case CMD_SYNC:
			// Set sync mode.. used to determine which direction to move slave stepper
			if (dest == X_ADDRESS)
				x_sync_mode = snap.getByte(1);
			if (dest == Y_ADDRESS)
				y_sync_mode = snap.getByte(1);
		break;

		case CMD_CALIBRATE:
			// Request calibration (search at given speed)
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.x.stepper.step_delay);
				//bot.x.function = func_findmin;
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.step_delay);
				//bot.y.function = func_findmin;
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.step_delay);
				//bot.z.function = func_findmin;
			}
			
			//start our calibration.
			bot_mode = MODE_FIND_MIN;		
			bot.enableTimerInterrupt();
		break;

		case CMD_GETRANGE:
			if (dest == X_ADDRESS)
				position = bot.x.max;
			else if (dest == Y_ADDRESS)
				position = bot.y.max;
			else
				position = bot.z.max;

			//tell the host.
			snap.startMessage(0, dest);
			snap.sendDataByte(CMD_GETPOS);
			snap.sendDataInt(position);
			snap.sendMessage();
		break;

		case CMD_DDA:
			int target;

			//get our coords.
			position = snap.getInt(2);
			target = snap.getInt(4);
			
			//which axis is leading?
			if (dest == X_ADDRESS)
			{
				bot.x.setTarget(position);
				
				//we can figure out the target based on the sync mode
				if (y_sync_mode == sync_inc)
					bot.y.setTarget(bot.y.current + target);
				else if (y_sync_mode == sync_dec)
					bot.y.setTarget(bot.y.current - target);
				else
					bot.y.setTarget(bot.y.current);
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.setTarget(position);

				//we can figure out the target based on the sync mode
				if (x_sync_mode == sync_inc)
					bot.x.setTarget(bot.x.current + target);
				else if (x_sync_mode == sync_dec)
					bot.x.setTarget(bot.x.current - target);
				else
					bot.x.setTarget(bot.x.current);
			}

			//debug our stuff.
			/*
			snap.debug();
			Serial.print("x");
			Serial.print(bot.x.current);
			Serial.print(":");
			Serial.print(bot.x.target);
			Serial.print('\n');

			snap.debug();
			Serial.print("y");
			Serial.print(bot.y.current);
			Serial.print(":");
			Serial.print(bot.y.target);
			Serial.print('\n');
			*/

			//set z's target to itself.
			bot.z.setTarget(bot.z.current);
			
			//set our speed.
			bot.x.stepper.setRPM(snap.getByte(1));
			bot.setTimer(bot.x.stepper.step_delay);

			//init our DDA stuff!
			bot.calculateDDA();
			
			//start the dda!
			bot_mode = MODE_DDA;
			x_mode = MODE_DDA;
			y_mode = MODE_DDA;
			z_mode = MODE_DDA;
			bot.enableTimerInterrupt();
			
			/*
			snap.debug();
			Serial.print("x");
			Serial.println(bot.x.delta);

			snap.debug();
			Serial.print("y");
			Serial.println(bot.y.delta);

			snap.debug();
			Serial.print("m");
			Serial.println(bot.max_delta);
			*/
						
		break;

		case CMD_FORWARD1:
			if (dest == X_ADDRESS)
				bot.x.forward1();
			else if (dest == Y_ADDRESS)
				bot.y.forward1();
			else if (dest == Z_ADDRESS)
				bot.z.forward1();
		break;

		case CMD_BACKWARD1:
			if (dest == X_ADDRESS)
				bot.x.reverse1();
			else if (dest == Y_ADDRESS)
				bot.y.reverse1();
			else if (dest == Z_ADDRESS)
				bot.z.reverse1();
		break;

		case CMD_SETPOWER:
			//doesnt matter because power is handled by the stepper driver board!
		break;

		case CMD_GETSENSOR:
			snap.startMessage(0, dest);
			snap.sendDataByte(CMD_GETSENSOR);
			// Dummy values to satisfy PIC emulation
			snap.sendDataInt(0);
			snap.sendMessage();
		break;

		case CMD_HOMERESET:

			if (dest == X_ADDRESS)
			{
				//configure our axis
				bot.x.stepper.setDirection(RS_REVERSE);
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.x.stepper.step_delay);

				//tell our axis to go home.
				x_mode = MODE_HOMERESET;
			}
			else if (dest == Y_ADDRESS)
			{
				//configure our axis
				bot.y.stepper.setDirection(RS_REVERSE);
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.step_delay);

				//tell our axis to go home.
				y_mode = MODE_HOMERESET;
			}
			else if (dest == Z_ADDRESS)
			{
				//configure our axis
				bot.z.stepper.setDirection(RS_REVERSE);
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.step_delay);

				//tell our axis to go home.
				z_mode = func_homereset;
			}

			//starts our home reset mode.
			bot_mode = MODE_HOMERESET;
			bot.enableTimerInterrupt();
		break;
		
		case CMD_DEVICE_TYPE:
			snap.startMessage(0, dest);
			snap.sendDataByte(CMD_DEVICE_TYPE);
			snap.sendDataByte(DEVICE_TYPE);
			snap.sendMessage();
		break;
	}
}

void notifyHomeReset(byte to, byte from)
{
	snap.debug();
	Serial.println("notifyhome");
	
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_HOMERESET);
	snap.sendMessage();
}

void notifyCalibrate(byte to, byte from, int position)
{
	snap.debug();
	Serial.println("notifycali");
	
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_CALIBRATE);
	snap.sendDataInt(position);
	snap.sendMessage();	
}

void notifySeek(byte to, byte from, int position)
{
	snap.debug();
	Serial.println("notifyseek");
	
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_SEEK);
	snap.sendDataInt(position);
	snap.sendMessage();
}

void notifyDDA(byte to, byte from, int position)
{
	snap.debug();
	Serial.println("notifydda");
	
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_DDA);
	snap.sendDataInt(position);
	snap.sendMessage();
}
