#include <ThermoPlastExtruder_SNAP_v2.h>

int currentPos = 0;
byte currentHeat = 0;
byte requestedHeat0 = 0;
byte requestedHeat1 = 0;
byte temperatureLimit0 = 0;
byte temperatureLimit1 = 0;

//this guys sets us up.
void setup_extruder_snap_v2()
{
	snap.addDevice(EXTRUDER_ADDRESS);
}

//this guy actually processes the commands.
void process_thermoplast_extruder_snap_commands_v2()
{
	byte cmd = snap.getByte(0);

	switch (cmd)
	{
		case CMD_VERSION:
			snap.sendReply();
			snap.sendDataByte(CMD_VERSION);
			snap.sendDataByte(VERSION_MINOR);
			snap.sendDataByte(VERSION_MAJOR);
			snap.endMessage();
		break;

		// Extrude speed takes precedence over fan speed
		case CMD_FORWARD:
			extruder.setDirection(1);
			extruder.setSpeed(snap.getByte(1));
		break;

		// seems to do the same as Forward
		case CMD_REVERSE:
			extruder.setDirection(0);
			extruder.setSpeed(snap.getByte(1));
		break;

		case CMD_SETPOS:
			currentPos = snap.getInt(1);
		break;

		case CMD_GETPOS:
			//send some Bogus data so the Host software is happy
			snap.sendReply();
			snap.sendDataByte(CMD_GETPOS); 
			snap.sendDataInt(currentPos);
			snap.endMessage();
		break;

		case CMD_SEEK:
			//debug.println("n/i: seek");
		break;

		case CMD_FREE:
			// Free motor.  There is no torque hold for a DC motor,
			// so all we do is switch off
			extruder.setSpeed(0);
		break;

		case CMD_NOTIFY:
			//debug.println("n/i: notify");
		break;

		case CMD_ISEMPTY:
			// We don't know so we say we're not empty
			snap.sendReply();
			snap.sendDataByte(CMD_ISEMPTY); 
			snap.sendDataByte(0);  
			snap.endMessage();
		break;

		case CMD_SETHEAT:
			requestedHeat0 = snap.getByte(1);
			requestedHeat1 = snap.getByte(2);
			temperatureLimit0 = snap.getByte(3);
			temperatureLimit1 = snap.getByte(4);
			extruder.setTargetTemperature(temperatureLimit1);
			extruder.setHeater(requestedHeat1);

			/*
			debug.print("requestedHeat0: ");
			debug.println(requestedHeat0);
			debug.print("requestedHeat1: ");
			debug.println(requestedHeat1);
			debug.print("temperatureLimit0: ");
			debug.println(temperatureLimit0);
			debug.print("temperatureLimit1: ");
			debug.println(temperatureLimit1);
			*/
		break;

		case CMD_GETTEMP:
			/*
			debug.print("temp: ");
			debug.println(extruder.getTemperature(), DEC);
			debug.print("raw: ");
			debug.println(extruder.getRawTemperature(), DEC);
			*/
			snap.sendReply();
			snap.sendDataByte(CMD_GETTEMP); 
			snap.sendDataByte(extruder.getTemperature());
			snap.sendDataByte(0);
			snap.endMessage();
		break;

		case CMD_SETCOOLER:
			//debug.println("n/i: set cooler");
		break;

		// "Hidden" low level commands
		case CMD_PWMPERIOD:
			//debug.println("n/i: pwm period");
		break;

		case CMD_PRESCALER:
			//debug.println("n/i: prescaler");
		break;

		case CMD_SETVREF:
			//debug.println("n/i: set vref");
		break;

		case CMD_SETTEMPSCALER:
			//debug.println("n/i: set temp scaler");
		break;

		case CMD_GETDEBUGINFO:
			//debug.println("n/i: get debug info");
		break;

		case CMD_GETTEMPINFO:
			snap.sendReply();
			snap.sendDataByte(CMD_GETTEMPINFO); 
			snap.sendDataByte(requestedHeat0);
			snap.sendDataByte(requestedHeat1);
			snap.sendDataByte(temperatureLimit0);
			snap.sendDataByte(temperatureLimit1);
			snap.sendDataByte(extruder.getTemperature());
			snap.sendDataByte(0);
			snap.endMessage();
		break;
	}
	snap.releaseLock();
}
