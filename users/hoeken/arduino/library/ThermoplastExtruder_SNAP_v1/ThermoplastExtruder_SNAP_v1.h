#ifndef THERMOPLAST_EXTRUDER_SNAP_V2_H
#define THERMOPLAST_EXTRUDER_SNAP_V2_H

//our include files.
#include <ThermoplastExtruder.h>
#include <SNAP.h>

//
// Various processing commands.
//
void setup_extruder_snap_v1();
void process_thermoplast_extruder_snap_commands_v1();

//
// Conversion commands
//
int calculateTemperatureForPicTemp(byte picTemp);
byte calculatePicTempForCelsius(int temperature);

//
// constants for temp/pic temp conversion.
//
#define BETA 5000
#define CAPACITOR 0.000001
#define RZ 500000
#define ABSOLUTE_ZERO 273.15

//
// Version information
//
#define VERSION_MAJOR 1
#define VERSION_MINOR 0
#define EXTRUDER_ADDRESS 8

//
// Extruder commands
//
#define CMD_VERSION       0
#define CMD_FORWARD       1
#define CMD_REVERSE       2
#define CMD_SETPOS        3
#define CMD_GETPOS        4
#define CMD_SEEK          5
#define CMD_FREE          6
#define CMD_NOTIFY        7
#define CMD_ISEMPTY       8
#define CMD_SETHEAT       9
#define CMD_GETTEMP       10
#define CMD_SETCOOLER     11
#define CMD_PWMPERIOD     50
#define CMD_PRESCALER     51 //apparently doesnt exist...
#define CMD_SETVREF       52
#define CMD_SETTEMPSCALER 53
#define CMD_GETDEBUGINFO  54 //apparently doesnt exist...
#define CMD_GETTEMPINFO   55 //apparently doesnt exist...

extern ThermoplastExtruder extruder;

#endif
