#include "CartesianBot_SNAP_v1.h"
#include <avr/interrupt.h>
#include "HardwareSerial.h"

/**********************************
*  Global variable instantiations
**********************************/

//who do we notify? 255 = nobody
byte x_notify = 255;
byte y_notify = 255;
byte z_notify = 255;

//what is our sync mode?
byte x_sync_mode = sync_none;
byte y_sync_mode = sync_none;

//our mode holder.
byte bot_mode = MODE_PAUSE;
byte x_mode = MODE_PAUSE;
byte y_mode = MODE_PAUSE;
byte z_mode = MODE_PAUSE;

//our setup function. intialize stuff.
void setup_cartesian_bot_snap_v1()
{
	snap.addDevice(X_ADDRESS);
	snap.addDevice(Y_ADDRESS);
	snap.addDevice(Z_ADDRESS);
}

//our interrupt handler.  do stepping signals.
SIGNAL(SIG_OUTPUT_COMPARE1A)
{
	if (bot_mode == MODE_DDA)
	{
		if (bot.x.can_step)
			bot.x.ddaStep(bot.max_delta);

		if (bot.y.can_step)
			bot.y.ddaStep(bot.max_delta);
	}
	else if (bot_mode == MODE_HOMERESET)
	{
		if (x_mode == MODE_HOMERESET && !bot.x.atMin())
				bot.x.stepper.pulse();

		if (y_mode == MODE_HOMERESET && !bot.y.atMin())
				bot.y.stepper.pulse();

		if (z_mode == MODE_HOMERESET && !bot.z.atMin())
				bot.z.stepper.pulse();
	}
	else if (bot_mode == MODE_SEEK)
	{
		if (bot.x.can_step)
			bot.x.doStep();

		if (bot.y.can_step)
			bot.y.doStep();

		if (bot.z.can_step)
			bot.z.doStep();
	}
	else if (bot_mode == MODE_FIND_MIN)
	{
		if (x_mode == MODE_FIND_MIN)
		{
			if (!bot.x.atMin())
				bot.x.stepper.pulse();
		}

		if (y_mode == MODE_FIND_MIN)
		{
			if (!bot.y.atMin())
				bot.y.stepper.pulse();
		}

		if (z_mode == MODE_FIND_MIN)
		{
			if (!bot.z.atMin())
				bot.z.stepper.pulse();
		}
	}
	else if (bot_mode == MODE_FIND_MAX)
	{
		if (x_mode == MODE_FIND_MAX)
		{
			//do a step if we're not there yet.
			if (!bot.x.atMax())
				bot.x.stepper.pulse();
		}

		if (y_mode == MODE_FIND_MAX)
		{
			//do a step if we're not there yet.
			if (!bot.y.atMax())
				bot.y.stepper.pulse();
		}

		if (z_mode == MODE_FIND_MAX)
		{
			//do a step if we're not there yet.
			if (!bot.z.atMax())
				bot.z.stepper.pulse();
		}
	}
	else // okay, disable our interrupt!
	{
		bot_mode = MODE_PAUSE;
		bot.disableTimerInterrupt();
	}
}

//our loop guy, check statuses of stuff.
void cartesian_bot_snap_v1_loop()
{
	//first, lookup our state info!
	bot.readState();
	
	if (bot_mode == MODE_DDA)
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
				x_mode = MODE_PAUSE;
				bot.x.setPosition(0);
				bot.x.setTarget(0);

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
			if (!bot.x.can_step)
			{
				x_mode = MODE_PAUSE;

				if (x_notify != 255)
					notifySeek(x_notify, X_ADDRESS, (int)bot.x.current);
			}
		}
		
		if (y_mode == MODE_SEEK)
		{
			if (bot.y.can_step)
			{
				y_mode = MODE_PAUSE;
			
				if (y_notify != 255)
					notifySeek(y_notify, Y_ADDRESS, (int)bot.y.current);
			}
		}
		
		if (z_mode == MODE_SEEK)
		{
			if (bot.z.can_step)
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
	else if (bot_mode == MODE_FIND_MIN)
	{
		if (x_mode == MODE_FIND_MIN)
		{
			if (bot.x.atMin())
			{
				bot.x.setPosition(0);
				bot.x.stepper.setDirection(RS_FORWARD);
				x_mode = MODE_FIND_MAX;
				bot_mode = MODE_FIND_MAX;
			}
		}

		if (y_mode == MODE_FIND_MIN)
		{
			if (bot.y.atMin())
			{
				bot.y.setPosition(0);
				bot.y.stepper.setDirection(RS_FORWARD);
				y_mode = MODE_FIND_MAX;
				bot_mode = MODE_FIND_MAX;
			}
		}

		if (z_mode == MODE_FIND_MIN)
		{
			if (bot.z.atMin())
			{
				bot.z.setPosition(0);
				bot.z.stepper.setDirection(RS_FORWARD);
				z_mode = MODE_FIND_MAX;
				bot_mode = MODE_FIND_MAX;
			}
		}
	}
	else if (bot_mode == MODE_FIND_MAX)
	{
		if (x_mode == MODE_FIND_MAX)
		{
			//are we there yet?
			if (bot.x.atMax())
			{
				bot.x.max = bot.x.current;
				x_mode = MODE_PAUSE;
				bot_mode = MODE_PAUSE;
				bot.disableTimerInterrupt();

				if (x_notify != 255)
					notifyCalibrate(x_notify, X_ADDRESS, bot.x.max);
			}
		}

		if (y_mode == MODE_FIND_MAX)
		{
			//are we there yet?
			if (bot.y.atMax())
			{
				bot.y.max = bot.y.current;
				z_mode = MODE_PAUSE;
				bot_mode = MODE_PAUSE;
				bot.disableTimerInterrupt();

				if (y_notify != 255)
					notifyCalibrate(y_notify, Y_ADDRESS, bot.y.max);
			}
		}

		if (z_mode == MODE_FIND_MAX)
		{
			//are we there yet?
			if (bot.z.atMax())
			{
				bot.z.max = bot.z.current;
				z_mode = MODE_PAUSE;
				bot_mode = MODE_PAUSE;
				bot.disableTimerInterrupt();

				if (z_notify != 255)
					notifyCalibrate(z_notify, Z_ADDRESS, bot.z.max);
			}
		}
	}
	/*
	//not enough room for the move modes.
	else if (bot_mode == MODE_MOVE)
	{
		if (x_mode == MODE_FORWARD || x_mode == MODE_REVERSE)
			bot.x.stepper.pulse();

		if (y_mode == MODE_FORWARD || y_mode == MODE_REVERSE)
			bot.y.stepper.pulse();

		if (z_mode == MODE_FORWARD || z_mode == MODE_REVERSE)
			bot.z.stepper.pulse();
	}
	*/
	//else its in MODE_PAUSE... dont do anything.
}

//our command processor.  parse any SNAP commands.
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
			//not enough room for this mode.
			//okay, set our speed.
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.x.stepper.setDirection(RS_FORWARD);
				x_mode = MODE_FORWARD;
				bot.setTimer(bot.x.stepper.step_delay);
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.y.stepper.setDirection(RS_FORWARD);
				y_mode = MODE_FORWARD;
				bot.setTimer(bot.y.stepper.step_delay);
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.z.stepper.setDirection(RS_FORWARD);
				z_mode = MODE_FORWARD;
				bot.setTimer(bot.z.stepper.step_delay);
			}
			
			//start our seek.
			bot_mode = MODE_MOVE;
			bot.enableTimerInterrupt();
			*/
		break;

		case CMD_REVERSE:
			/*
			//not enough room for this mode.
			if (dest == X_ADDRESS)
			{
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.x.stepper.setDirection(RS_REVERSE);
				x_mode = MODE_REVERSE;
				bot.setTimer(bot.x.stepper.step_delay);
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.y.stepper.setDirection(RS_REVERSE);
				y_mode = MODE_REVERSE;
				bot.setTimer(bot.y.stepper.step_delay);
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.z.stepper.setDirection(RS_REVERSE);
				z_mode = MODE_REVERSE;
				bot.setTimer(bot.z.stepper.step_delay);
			}
			
			//start our seek.
			bot_mode = MODE_MOVE;
			bot.enableTimerInterrupt();
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

			//okay, set our speed.
			if (dest == X_ADDRESS)
			{
				x_mode = MODE_SEEK;
				bot.x.setTarget(position);
				bot.x.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.x.stepper.step_delay);
			}
			else if (dest == Y_ADDRESS)
			{
				y_mode = MODE_SEEK;
				bot.y.setTarget(position);
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.step_delay);
			}
			else if (dest == Z_ADDRESS)
			{
				z_mode = MODE_SEEK;
				bot.z.setTarget(position);
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.step_delay);
			}

			//get everything current.
			bot.readState();
			
			//start our seek.
			bot_mode = MODE_SEEK;
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
				x_mode = MODE_FIND_MIN;
			}
			else if (dest == Y_ADDRESS)
			{
				bot.y.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.y.stepper.step_delay);
				y_mode = MODE_FIND_MIN;
			}
			else if (dest == Z_ADDRESS)
			{
				bot.z.stepper.setRPM(snap.getByte(1));
				bot.setTimer(bot.z.stepper.step_delay);
				z_mode = MODE_FIND_MIN;
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
				z_mode = MODE_HOMERESET;
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
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_HOMERESET);
	snap.sendMessage();
}

void notifyCalibrate(byte to, byte from, int position)
{
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_CALIBRATE);
	snap.sendDataInt(position);
	snap.sendMessage();	
}

void notifySeek(byte to, byte from, int position)
{
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_SEEK);
	snap.sendDataInt(position);
	snap.sendMessage();
}

void notifyDDA(byte to, byte from, int position)
{
	snap.startMessage(to, from);
	snap.sendDataByte(CMD_DDA);
	snap.sendDataInt(position);
	snap.sendMessage();
}
