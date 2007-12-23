#ifndef CARTESIAN_BOT_SNAP_V1_H
#define CARTESIAN_BOT_SNAP_V1_H

//all our includes.
#include <SNAP.h>
#include <RepStepper.h>
#include <LinearAxis.h>
#include <CartesianBot.h>

//this guy actually processes the v1 SNAP commands.
void setup_cartesian_bot_snap_v1();
void process_cartesian_bot_snap_commands_v1();
void handleInterrupt();

//notification functions to let the host know whats up.
void notifyHomeReset(byte to, byte from);
void notifyCalibrate(byte to, byte from, unsigned int position);
void notifySeek(byte to, byte from, unsigned int position);
void notifyDDA(byte to, byte from, unsigned int position);

extern CartesianBot bot;

//
// Version information
//
#define VERSION_MAJOR 1
#define VERSION_MINOR 0
#define HOST_ADDRESS 0

//
// Linear Axis commands
//
#define CMD_VERSION   0
#define CMD_FORWARD   1
#define CMD_REVERSE   2
#define CMD_SETPOS    3
#define CMD_GETPOS    4
#define CMD_SEEK      5
#define CMD_FREE      6
#define CMD_NOTIFY    7
#define CMD_SYNC      8
#define CMD_CALIBRATE 9
#define CMD_GETRANGE  10
#define CMD_DDA       11
#define CMD_FORWARD1  12
#define CMD_BACKWARD1 13
#define CMD_SETPOWER  14
#define CMD_GETSENSOR 15
#define CMD_HOMERESET 16

//
// Addresses for our linear axes.
//
#define X_ADDRESS 2
#define Y_ADDRESS 3
#define Z_ADDRESS 4

/********************************
*  Global mode declarations
********************************/
enum functions {
	func_idle,
	func_forward,
	func_reverse,
	func_syncwait,   // Waiting for sync prior to seeking
	func_seek,
	func_findmin,    // Calibration, finding minimum
	func_findmax,    // Calibration, finding maximum
	func_ddamaster,
	func_homereset   // Move to min position and reset
};

/********************************
 *  Sync mode declarations
 ********************************/
enum sync_modes {
  sync_none,     // no sync (default)
  sync_seek,     // synchronised seeking
  sync_inc,      // inc motor on each pulse
  sync_dec       // dec motor on each pulse
};

#endif
