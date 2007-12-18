
//
// Various processing commands.
//
void setup_extruder_snap_v2();
void process_thermoplast_extruder_snap_commands_v2();

//
// Version information
//
#define VERSION_MAJOR 2
#define VERSION_MINOR 0

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
#define CMD_PRESCALER     51
#define CMD_SETVREF       52
#define CMD_SETTEMPSCALER 53
#define CMD_GETDEBUGINFO  54
#define CMD_GETTEMPINFO   55

extern ThermoplastExtruder extruder;