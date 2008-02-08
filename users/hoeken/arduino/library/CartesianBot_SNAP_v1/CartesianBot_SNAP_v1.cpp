#include "CartesianBot_SNAP_v1.h"
#include <avr/interrupt.h>

/**********************************
*  Global variable instantiations
**********************************/

byte x_notify = 255;
byte y_notify = 255;
byte z_notify = 255;

byte x_sync_mode = sync_none;
byte y_sync_mode = sync_none;

ISR(SIG_OUTPUT_COMPARE1A)
{
	if (bot.mode == MODE_DDA)
	{
		if (bot.y.can_step)
			bot.y.ddaStep(bot.max_delta);

		if (bot.x.can_step)
			bot.x.ddaStep(bot.max_delta);
	}
	else if (bot.mode == MODE_SEEK)
	{
		if (bot.x.can_step)
			bot.x.doStep();

		if (bot.y.can_step)
			bot.y.doStep();

		if (bot.z.can_step)
			bot.z.doStep();
	}
	else if (bot.mode == MODE_HOMERESET)
	{
		if (bot.x.function == func_homereset && !bot.x.atMin())
				bot.x.stepper.pulse();

		if (bot.y.function == func_homereset && !bot.y.atMin())
				bot.y.stepper.pulse();

		if (bot.z.function == func_homereset && !bot.z.atMin())
				bot.z.stepper.pulse();
	}
	else if (bot.mode == MODE_FIND_MIN)
	{
		if (bot.x.function == func_findmin)
		{
			if (!bot.x.atMin())
				bot.x.stepper.pulse();
		}

		if (bot.y.function == func_findmin)
		{
			if (!bot.y.atMin())
				bot.y.stepper.pulse();
		}

		if (bot.z.function == func_findmin)
		{
			if (!bot.z.atMin())
				bot.z.stepper.pulse();
		}
	}
	else if (bot.mode == MODE_FIND_MAX)
	{
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
	}
}

void setup_cartesian_bot_snap_v1()
{
	bot.setupTimerInterrupt();
	
	snap.addDevice(X_ADDRESS);
	snap.addDevice(Y_ADDRESS);
	snap.addDevice(Z_ADDRESS);
	
	//snapDebug(X_ADDRESS, (long)0);
}

void cartesian_bot_snap_v1_loop()
{
	if (bot.mode == MODE_DDA)
	{
		if (bot.atTarget())
		{
			if (x_notify != 255)
				notifyDDA(x_notify, X_ADDRESS, (unsigned int)bot.x.getPosition());
			if (y_notify != 255)
				notifyDDA(y_notify, Y_ADDRESS, (unsigned int)bot.y.getPosition());

			bot.stop();
		}
	}
	else if (bot.mode == MODE_SEEK)
	{
		if (bot.x.atTarget() && x_notify != 255)
			notifySeek(x_notify, X_ADDRESS, (int)bot.x.getPosition());

		if (bot.y.atTarget() && y_notify != 255)
			notifySeek(y_notify, Y_ADDRESS, (int)bot.y.getPosition());

		if (bot.z.atTarget() && z_notify != 255)
			notifySeek(z_notify, Z_ADDRESS, (int)bot.z.getPosition());

		if (bot.atTarget())
			bot.stop();
	}
	else if (bot.mode == MODE_HOMERESET)
	{
		if (bot.x.function == func_homereset && bot.x.atMin())
		{
			bot.x.setPosition(0);
			bot.x.function = func_idle;
			bot.x.stepper.setDirection(RS_FORWARD);
			bot.stop();

			if (x_notify != 255)
				notifyHomeReset(x_notify, X_ADDRESS);
		}

		if (bot.y.function == func_homereset && bot.y.atMin())
		{
			bot.y.setPosition(0);
			bot.y.function = func_idle;
			bot.y.stepper.setDirection(RS_FORWARD);
			bot.stop();

			if (y_notify != 255)
				notifyHomeReset(y_notify, Y_ADDRESS);	
		}

		if (bot.z.function == func_homereset && bot.z.atMin())
		{
			bot.z.setPosition(0);
			bot.z.function = func_idle;
			bot.z.stepper.setDirection(RS_FORWARD);
			bot.stop();

			if (z_notify != 255)
				notifyHomeReset(z_notify, Z_ADDRESS);
		}
	}
	else if (bot.mode == MODE_FIND_MIN)
	{
		if (bot.x.function == func_findmin)
		{
			if (bot.x.atMin())
			{
				bot.x.setPosition(0);
				bot.x.stepper.setDirection(RS_FORWARD);
				bot.x.function = func_findmax;
				bot.mode = MODE_FIND_MAX;
			}
		}

		if (bot.y.function == func_findmin)
		{
			if (bot.y.atMin())
			{
				bot.y.setPosition(0);
				bot.y.stepper.setDirection(RS_FORWARD);
				bot.y.function = func_findmax;
				bot.mode = MODE_FIND_MAX;
			}
		}

		if (bot.z.function == func_findmin)
		{
			if (bot.z.atMin())
			{
				bot.z.setPosition(0);
				bot.z.stepper.setDirection(RS_FORWARD);
				bot.z.function = func_findmax;
				bot.mode = MODE_FIND_MAX;
			}
		}
	}
	else if (bot.mode == MODE_FIND_MAX)
	{
		if (bot.x.function == func_findmax)
		{
			//are we there yet?
			if (bot.x.atMax())
			{
				bot.x.setMax(bot.x.getPosition());
				bot.x.function = func_idle;
				bot.stop();

				if (x_notify != 255)
					notifyCalibrate(x_notify, X_ADDRESS, bot.x.getMax());
			}
		}

		if (bot.y.function == func_findmax)
		{
			//are we there yet?
			if (bot.y.atMax())
			{
				bot.y.setMax(bot.y.getPosition());
				bot.y.function = func_idle;
				bot.stop();

				if (x_notify != 255)
					notifyCalibrate(x_notify, X_ADDRESS, bot.y.getMax());
			}
		}

		if (bot.z.function == func_findmax)
		{
			//are we there yet?
			if (bot.z.atMax())
			{
				bot.z.setMax(bot.z.getPosition());
				bot.z.function = func_idle;
				bot.stop();

				if (x_notify != 255)
					notifyCalibrate(x_notify, X_ADDRESS, bot.z.getMax());
			}
		}
	}
}

void process_cartesian_bot_snap_commands_v1()
{
	byte cmd = snap.getByte(0);
	byte dest = snap.getDestination();
	unsigned int position = 0;

	switch (cmd)
	{
		case CMD_VERSION:
			snap.sendReply();
			snap.sendDataByte(CMD_VERSION);  // Response type 0
			snap.sendDataByte(VERSION_MAJOR);
			snap.sendDataByte(VERSION_MINOR);
			snap.endMessage();
		break;

		case CMD_FORWARD:
			//okay, set our speed.
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.x.stepper.setDirection(RS_FORWARD);
				bot.x.function = func_forward;
				bot.setTimer(bot.x.stepper.getSpeed());
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.y.stepper.setDirection(RS_FORWARD);
				bot.y.function = func_forward;
				bot.setTimer(bot.y.stepper.getSpeed());
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.z.stepper.setDirection(RS_FORWARD);
				bot.z.function = func_forward;
				bot.setTimer(bot.z.stepper.getSpeed());
			}
		break;

		case CMD_REVERSE:
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.x.stepper.setDirection(RS_REVERSE);
				bot.x.function = func_reverse;
				bot.setTimer(bot.x.stepper.getSpeed());
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.y.stepper.setDirection(RS_REVERSE);
				bot.y.function = func_reverse;
				bot.setTimer(bot.y.stepper.getSpeed());
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.z.stepper.setDirection(RS_REVERSE);
				bot.z.function = func_reverse;
				bot.setTimer(bot.z.stepper.getSpeed());
			}
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
				position = bot.x.getPosition();
			else if (dest == Y_ADDRESS)
				position = bot.y.getPosition();
			else if (dest == Z_ADDRESS)
				position = bot.z.getPosition();

			snap.sendReply();
			snap.sendDataByte(CMD_GETPOS);
			snap.sendDataInt(position);
			snap.endMessage();
		break;

		case CMD_SEEK:
			// Goto position
			position = snap.getInt(2);

			//okay, set our speed.
			if (dest == X_ADDRESS)
			{
				bot.x.setTarget(position);
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.x.stepper.getSpeed());
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.setTarget(position);
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.getSpeed());
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.setTarget(position);
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.getSpeed());
			}

			//start our seek.
			bot.startSeek();
	    break;

		case CMD_FREE:
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.disable();
				bot.x.function = func_idle;
			}
			if (dest == Y_ADDRESS)
			{
				bot.y.stepper.disable();
				bot.y.function = func_idle;
			}
			if (dest == Z_ADDRESS)
			{
				bot.z.stepper.disable();
				bot.z.function = func_idle;
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
			//stop other stuff.
			bot.stop();
		
			// Request calibration (search at given speed)
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.x.stepper.getSpeed());
				bot.x.function = func_findmin;
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.getSpeed());
				bot.y.function = func_findmin;
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.getSpeed());
				bot.z.function = func_findmin;
			}
			
			//start our calibration.
			bot.startCalibration();
		break;

		case CMD_GETRANGE:
			if (dest == X_ADDRESS)
				position = bot.x.getMax();
			else if (dest == Y_ADDRESS)
				position = bot.y.getMax();
			else
				position = bot.z.getMax();

			//tell the host.
			snap.sendReply();
			snap.sendDataByte(CMD_GETPOS);
			snap.sendDataInt(position);
			snap.endMessage();
		break;

		case CMD_DDA:
			unsigned long target;

			//stop the bot.
			bot.stop();
			
			//get our coords.
			position = snap.getInt(2);
			target = snap.getInt(4);
			
			//which axis is leading?
			if (dest == X_ADDRESS)
			{
				bot.x.setTarget(position);
				
				//we can figure out the target based on the sync mode
				if (y_sync_mode == sync_inc)
					bot.y.setTarget(bot.y.getPosition() + target);
				else if (y_sync_mode == sync_dec)
					bot.y.setTarget(bot.y.getPosition() - target);
				else
					bot.y.setTarget(bot.y.getPosition());
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.setTarget(position);

				//we can figure out the target based on the sync mode
				if (x_sync_mode == sync_inc)
					bot.x.setTarget(bot.x.getPosition() + target);
				else if (x_sync_mode == sync_dec)
					bot.x.setTarget(bot.x.getPosition() - target);
				else
					bot.x.setTarget(bot.x.getPosition());
			}

			//set z's target to itself.
			bot.z.setTarget(bot.z.getPosition());
			
			//set our speed.
			bot.x.stepper.setRPM(snap.getByte(1));
			bot.setTimer(bot.x.stepper.getSpeed());

			//init our DDA stuff!
			bot.calculateDDA();

			//snapDebug(dest, snap.getByte(1));
			//snapDebug(X_ADDRESS, bot.x.getDelta());
			//snapDebug(Y_ADDRESS, bot.y.getDelta());
			//snapDebug(Z_ADDRESS, (long)1);

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
			snap.sendReply();
			snap.sendDataByte(CMD_GETSENSOR);
			// Dummy values to satisfy PIC emulation
			snap.sendDataInt(0);
			snap.endMessage();
		break;

		case CMD_HOMERESET:
			bot.stop();
		
			if (dest == X_ADDRESS)
			{
				//configure our axis
				bot.x.stepper.setDirection(RS_REVERSE);
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.x.stepper.getSpeed());

				//tell our axis to go home.
				bot.x.function = func_homereset;
			}
			else if (dest == Y_ADDRESS)
			{
				//configure our axis
				bot.y.stepper.setDirection(RS_REVERSE);
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.getSpeed());

				//tell our axis to go home.
				bot.y.function = func_homereset;
			}
			else if (dest == Z_ADDRESS)
			{
				//configure our axis
				bot.z.stepper.setDirection(RS_REVERSE);
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.getSpeed());

				//tell our axis to go home.
				bot.z.function = func_homereset;
			}
			
			//starts our home reset mode.
			bot.startHomeReset();

		break;
		
		case CMD_DEVICE_TYPE:
			snap.sendReply();
			snap.sendDataByte(CMD_DEVICE_TYPE);
			snap.sendDataByte(DEVICE_TYPE);
			snap.endMessage();
		break;
	}

	snap.releaseLock();
	bot.enableTimerInterrupt();
}

void notifyHomeReset(byte to, byte from)
{
	snap.startMessage(from);
	snap.sendMessage(to);
	snap.sendDataByte(CMD_HOMERESET);
	snap.endMessage();
}

void notifyCalibrate(byte to, byte from, unsigned int position)
{
	snap.startMessage(from);
	snap.sendMessage(to);
	snap.sendDataByte(CMD_CALIBRATE);
	snap.sendDataInt(position);
	snap.endMessage();	
}

void notifySeek(byte to, byte from, unsigned int position)
{
	snap.startMessage(from);
	snap.sendMessage(to);
	snap.sendDataByte(CMD_SEEK);
	snap.sendDataInt(position);
	snap.endMessage();
}

void notifyDDA(byte to, byte from, unsigned int position)
{
	snap.startMessage(from);
	snap.sendMessage(to);
	snap.sendDataByte(CMD_DDA);
	snap.sendDataInt(position);
	snap.endMessage();
}

void snapDebug(byte from, long debug)
{
	snap.startMessage(from);
	snap.sendMessage(0);
	snap.sendDataLong(debug);
	snap.endMessage();
}
