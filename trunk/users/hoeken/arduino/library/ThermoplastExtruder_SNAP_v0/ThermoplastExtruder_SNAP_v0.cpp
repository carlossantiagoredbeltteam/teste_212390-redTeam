#include <ThermoPlastExtruder_SNAP_v0.h>

//
// Variables from host software
//
byte vRefFactor = 7;
byte tempScaler = 4;
int currentPos = 0;

//this guys sets us up.
void setup_extruder_snap_v0()
{
	snap.addDevice(EXTRUDER_ADDRESS);

	//init to defaults in java software.
	vRefFactor = 7;
	tempScaler = 4;
	currentPos = 0;
}

//this guy actually processes the commands.
void process_thermoplast_extruder_snap_commands_v0()
{
	byte cmd = snap.getByte(0);

	switch (cmd)
	{
		// tell the host what version we are.
		case CMD_VERSION:
			snap.sendReply();
			snap.sendDataByte(CMD_VERSION);
			snap.sendDataByte(VERSION_MINOR);
			snap.sendDataByte(VERSION_MAJOR);
			snap.endMessage();
		break;

		// move motor forward.
		case CMD_FORWARD:
			extruder.setDirection(1);
			extruder.setSpeed(snap.getByte(1));
		break;

		// move motor backward.
		case CMD_REVERSE:
			extruder.setDirection(0);
			extruder.setSpeed(snap.getByte(1));
		break;

		// dunno what this is supposed to do...
		case CMD_SETPOS:
			currentPos = snap.getInt(1);
		break;

		// dunno what this is supposed to do either...
		case CMD_GETPOS:
			//send some Bogus data so the Host software is happy
			snap.sendReply();
			snap.sendDataByte(CMD_GETPOS); 
			snap.sendDataInt(currentPos);
			snap.endMessage();
		break;

		// we also cant really do this.
		case CMD_SEEK:
			//debug.println("n/i: seek");
		break;

		// Free motor.  There is no torque hold for a DC motor, so all we do is switch off
		case CMD_FREE:
			extruder.setSpeed(0);
		break;

		// this is also a mystery... we cant really do this either.
		case CMD_NOTIFY:
			//debug.println("n/i: notify");
		break;

		// are we out of filament?
		case CMD_ISEMPTY:
			// We don't know so we say we're not empty
			snap.sendReply();
			snap.sendDataByte(CMD_ISEMPTY); 
			snap.sendDataByte(0);  
			snap.endMessage();
		break;

		// set our heater and target information
		case CMD_SETHEAT:
			extruder.heater_low = snap.getByte(1);
			extruder.heater_high = snap.getByte(2);
			extruder.target_celsius = calculatePicTempForCelsius(snap.getByte(3));
			extruder.max_celsius = calculatePicTempForCelsius(snap.getByte(4));
		break;

		// tell the host software how hot we are.
		case CMD_GETTEMP:
			delay(100);
			snap.sendReply();
			snap.sendDataByte(CMD_GETTEMP); 
			snap.sendDataByte(calculatePicTempForCelsius(extruder.getTemperature()));
			snap.sendDataByte(0); //dunno what this is for... its how it is in the old firmware too.
			snap.endMessage();
		break;

		// turn our fan on/off.
		case CMD_SETCOOLER:
			extruder.setCooler(snap.getByte(1));
		break;

		// used for temp conversion.
		case CMD_SETVREF:
			vRefFactor = snap.getByte(1);
		break;

		// used for temp conversion.
		case CMD_SETTEMPSCALER:
			tempScaler = snap.getByte(1);
		break;
		
		case CMD_DEVICE_TYPE:
			snap.sendReply();
			snap.sendDataByte(CMD_DEVICE_TYPE);
			snap.sendDataByte(DEVICE_TYPE);
			snap.endMessage();
		break;

	}
	snap.releaseLock();
}

/***************
* This is code for doing reading conversions since the Arduino does the temp readings via straight analog reads.
***************/

int calculateTemperatureForPicTemp(int picTemp)
{
	int scale = 1 << (tempScaler+1);
	double clock = 4000000.0 / (4.0 * (double)scale);  // hertz		
	double vRef = 0.25 * 5.0 + 5.0 * vRefFactor / 32.0;  // volts
	double T = (double)picTemp / clock; // seconds
	double resistance =	-T / (log(1 - vRef / 5.0) * CAPACITOR);  // ohms

	return (int)((1.0 / (1.0 / ABSOLUTE_ZERO + log(resistance/RZ) / BETA)) - ABSOLUTE_ZERO);
}

/**
* Calculates an expected PIC Temperature expected for a
* given resistance 
* @param resistance
* @return
*/
int calculatePicTempForCelsius(int temperature)
{
	double resistance = RZ * exp(BETA * (1/((double)temperature + ABSOLUTE_ZERO) - 1/ABSOLUTE_ZERO));
	int scale = 1 << (tempScaler+1);
	double clock = 4000000.0 / (4.0 * (double)scale);  // hertz		
	double vRef = 0.25 * 5.0 + 5.0 * vRefFactor / 32.0;  // volts
	double T = -resistance * (log(1 - vRef / 5.0) * CAPACITOR);

	return (int)(T * clock);
}
