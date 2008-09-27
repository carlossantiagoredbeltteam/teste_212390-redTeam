#include "WProgram.h"
void init_extruder();
void extruder_set_direction(bool direction);
void extruder_set_speed(byte speed);
void extruder_set_cooler(byte speed);
void extruder_set_temperature(int temp);
int extruder_get_temperature();
int extruder_read_thermistor();
int extruder_read_thermocouple();
int extruder_sample_temperature(byte pin);
void extruder_manage_temperature();
void init_process_string();
int parse_string(struct GcodeParser * gc, char instruction[], int size);
void process_string(char instruction[], int size);
int scan_float(char *str, float *valp, unsigned int *seen, unsigned int flag);
int scan_int(char *str, int *valp, unsigned int *seen, unsigned int flag);
void init_steppers();
void dda_move(long micro_delay);
bool can_step(byte min_pin, byte max_pin, long current, long target, byte direction);
void do_step(byte step_pin);
bool read_switch(byte pin);
long to_steps(float steps_per_unit, float units);
void set_target(float x, float y, float z);
void set_position(float x, float y, float z);
void calculate_deltas();
long calculate_feedrate_delay(float feedrate);
long getMaxSpeed();
void enable_steppers();
void disable_steppers();
#include "HardwareSerial.h"
// Arduino G-code Interpreter
// v1.0 by Mike Ellery - initial software (mellery@gmail.com)
// v1.1 by Zach Hoeken - cleaned up and did lots of tweaks (hoeken@gmail.com)
// v1.2 by Chris Meighan - cleanup / G2&G3 support (cmeighan@gmail.com)
// v1.3 by Zach Hoeken - added thermocouple support and multi-sample temp readings. (hoeken@gmail.com)
//our command string
#define COMMAND_SIZE 128
char word[COMMAND_SIZE];
byte serial_count;
int no_data = 0;
long idle_time;
boolean comment = false;
boolean bytes_received = false;

void setup()
{
	//Do startup stuff here
	Serial.begin(19200);
	Serial.println("start");
	
	//other initialization.
	init_process_string();
	init_steppers();
	init_extruder();
}

void loop()
{
	char c;

	//keep it hot!
	extruder_manage_temperature();

	//read in characters if we got them.
	if (Serial.available() > 0)
	{
		c = Serial.read();
		no_data = 0;

		//newlines are ends of commands.
		if (c != '\n')
		{
			// Start of comment - ignore any bytes received from now on
			if (c == '(')
				comment = true;
				
			// If we're not in comment mode, add it to our array.
			if (!comment)
			{
				word[serial_count] = c;
				serial_count++;
			}
			if (c == ')')
			comment = false; // End of comment - start listening again
		}

		bytes_received = true;
	}
	//mark no data if nothing heard for 10 milliseconds
	else
	{
		if ((millis() - idle_time) >= 100)
		{
			no_data++;
			idle_time = millis();
		}
	}

	//if theres a pause or we got a real command, do it
	if (bytes_received && (c == '\n' || no_data ))
	{
		//process our command!
		process_string(word, serial_count);

		//clear command.
		init_process_string();
	}

	//no data?  turn off steppers
	if (no_data > 10 )
		disable_steppers();
}


// define the parameters of our machine.
#define X_STEPS_PER_INCH 203.133
#define X_STEPS_PER_MM   7.99735
#define X_MOTOR_STEPS    400

#define Y_STEPS_PER_INCH 203.133
#define Y_STEPS_PER_MM   7.99735
#define Y_MOTOR_STEPS    400

#define Z_STEPS_PER_INCH 8128.0
#define Z_STEPS_PER_MM   320.0
#define Z_MOTOR_STEPS    400

//our maximum feedrates
#define FAST_XY_FEEDRATE 1000.0
#define FAST_Z_FEEDRATE  50.0

// Units in curve section
#define CURVE_SECTION_INCHES 0.019685
#define CURVE_SECTION_MM 0.5

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define SENSORS_INVERTING 0

// How many temperature samples to take.  each sample takes about 100 usecs.
#define TEMPERATURE_SAMPLES 5

/****************************************************************************************
* digital i/o pin assignment
*
* this uses the undocumented feature of Arduino - pins 14-19 correspond to analog 0-5
****************************************************************************************/

//cartesian bot pins
#define X_STEP_PIN 2
#define X_DIR_PIN 3
#define X_MIN_PIN 4
#define X_MAX_PIN 9
#define X_ENABLE_PIN 15

#define Y_STEP_PIN 10
#define Y_DIR_PIN 7
#define Y_MIN_PIN 8
#define Y_MAX_PIN 13
#define Y_ENABLE_PIN 15

#define Z_STEP_PIN 19
#define Z_DIR_PIN 18
#define Z_MIN_PIN 17
#define Z_MAX_PIN 16
#define Z_ENABLE_PIN 15

//extruder pins
#define EXTRUDER_MOTOR_SPEED_PIN   11
#define EXTRUDER_MOTOR_DIR_PIN     12
#define EXTRUDER_HEATER_PIN        6
#define EXTRUDER_FAN_PIN           5
#define EXTRUDER_THERMISTOR_PIN    0  //a -1 disables thermistor readings
#define EXTRUDER_THERMOCOUPLE_PIN  -1 //a -1 disables thermocouple readings

//
// Start of temperature lookup table
//
// Thermistor lookup table for RepRap Temperature Sensor Boards (http://make.rrrf.org/ts)
// Made with createTemperatureLookup.py (http://svn.reprap.org/trunk/reprap/firmware/Arduino/utilities/createTemperatureLookup.py)
// ./createTemperatureLookup.py --r0=100000 --t0=25 --r1=0 --r2=4700 --beta=4066 --max-adc=1023
// r0: 100000
// t0: 25
// r1: 0
// r2: 4700
// beta: 4066
// max adc: 1023
#define NUMTEMPS 20
short temptable[NUMTEMPS][2] = {
   {1, 841},
   {54, 255},
   {107, 209},
   {160, 184},
   {213, 166},
   {266, 153},
   {319, 142},
   {372, 132},
   {425, 124},
   {478, 116},
   {531, 108},
   {584, 101},
   {637, 93},
   {690, 86},
   {743, 78},
   {796, 70},
   {849, 61},
   {902, 50},
   {955, 34},
   {1008, 3}
};
//
// End of temperature lookup table
//

#define EXTRUDER_FORWARD true
#define EXTRUDER_REVERSE false

//these our the default values for the extruder.
int extruder_speed = 128;
int extruder_target_celsius = 0;
int extruder_max_celsius = 0;
byte extruder_heater_low = 64;
byte extruder_heater_high = 255;

//this is for doing encoder based extruder control
int extruder_rpm = 0;
long extruder_delay = 0;
int extruder_error = 0;
int last_extruder_error = 0;
int extruder_error_delta = 0;
bool extruder_direction = EXTRUDER_FORWARD;

void init_extruder()
{
	//default to room temp.
	extruder_set_temperature(21);
	
	//setup our pins
	pinMode(EXTRUDER_MOTOR_DIR_PIN, OUTPUT);
	pinMode(EXTRUDER_MOTOR_SPEED_PIN, OUTPUT);
	pinMode(EXTRUDER_HEATER_PIN, OUTPUT);
	pinMode(EXTRUDER_FAN_PIN, OUTPUT);
	
	//initialize values
	digitalWrite(EXTRUDER_MOTOR_DIR_PIN, EXTRUDER_FORWARD);
	analogWrite(EXTRUDER_FAN_PIN, 0);
	analogWrite(EXTRUDER_HEATER_PIN, 0);
	analogWrite(EXTRUDER_MOTOR_SPEED_PIN, 0);
}

void extruder_set_direction(bool direction)
{
	extruder_direction = direction;
	digitalWrite(EXTRUDER_MOTOR_DIR_PIN, direction);
}

void extruder_set_speed(byte speed)
{
	analogWrite(EXTRUDER_MOTOR_SPEED_PIN, speed);
}

void extruder_set_cooler(byte speed)
{
	analogWrite(EXTRUDER_FAN_PIN, speed);
}

void extruder_set_temperature(int temp)
{
	extruder_target_celsius = temp;
	extruder_max_celsius = (int)((float)temp * 1.1);
}

/**
*  Samples the temperature and converts it to degrees celsius.
*  Returns degrees celsius.
*/
int extruder_get_temperature()
{
	if (EXTRUDER_THERMISTOR_PIN > -1)
		return extruder_read_thermistor();
	else if (EXTRUDER_THERMOCOUPLE_PIN > -1)
		return extruder_read_thermocouple();
}

/*
* This function gives us the temperature from the thermistor in Celsius
*/
int extruder_read_thermistor()
{
	int raw = extruder_sample_temperature(EXTRUDER_THERMISTOR_PIN);

	int celsius = 0;
	byte i;

	for (i=1; i<NUMTEMPS; i++)
	{
		if (temptable[i][0] > raw)
		{
			celsius  = temptable[i-1][1] + 
				(raw - temptable[i-1][0]) * 
				(temptable[i][1] - temptable[i-1][1]) /
				(temptable[i][0] - temptable[i-1][0]);

			if (celsius > 255)
				celsius = 255; 

			break;
		}
	}

	// Overflow: We just clamp to 0 degrees celsius
	if (i == NUMTEMPS)
		celsius = 0;

	return celsius;
}

/*
* This function gives us the temperature from the thermocouple in Celsius
*/
int extruder_read_thermocouple()
{
	return ( 5.0 * extruder_sample_temperature(EXTRUDER_THERMOCOUPLE_PIN) * 100.0) / 1024.0;
}

/*
* This function gives us an averaged sample of the analog temperature pin.
*/
int extruder_sample_temperature(byte pin)
{
	int raw = 0;
	
	//read in a certain number of samples
	for (byte i=0; i<TEMPERATURE_SAMPLES; i++)
		raw += analogRead(pin);
		
	//average the samples
	raw = raw/TEMPERATURE_SAMPLES;

	//send it back.
	return raw;
}

/*!
  Manages motor and heater based on measured temperature:
  o If temp is too low, don't start the motor
  o Adjust the heater power to keep the temperature at the target
 */
void extruder_manage_temperature()
{
	//make sure we know what our temp is.
	int current_celsius = extruder_get_temperature();

	//put the heater into high mode if we're not at our target.
	if (current_celsius < extruder_target_celsius)
		analogWrite(EXTRUDER_HEATER_PIN, extruder_heater_high);
	//put the heater on low if we're at our target.
	else if (current_celsius < extruder_max_celsius)
		analogWrite(EXTRUDER_HEATER_PIN, extruder_heater_low);
	//turn the heater off if we're above our max.
	else
		analogWrite(EXTRUDER_HEATER_PIN, 0);
}


// our point structure to make things nice.
struct LongPoint
{
	long x;
	long y;
	long z;
};

struct FloatPoint
{
	float x;
	float y;
	float z;
};

/* gcode line parse results */
struct GcodeParser
{
    unsigned int seen;
    int G;
    int M;
    float P;
    float X;
    float Y;
    float Z;
    float I;
    float J;
    float F;
    float S;
    float R;
    float Q;
};

FloatPoint current_units;
FloatPoint target_units;
FloatPoint delta_units;

FloatPoint current_steps;
FloatPoint target_steps;
FloatPoint delta_steps;

boolean abs_mode = false; //0 = incremental; 1 = absolute

//default to mm for units
float x_units = X_STEPS_PER_MM;
float y_units = Y_STEPS_PER_MM;
float z_units = Z_STEPS_PER_MM;
float curve_section = CURVE_SECTION_MM;

//our direction vars
byte x_direction = 1;
byte y_direction = 1;
byte z_direction = 1;

int scan_int(char *str, int *valp);
int scan_float(char *str, float *valp);

//init our string processing
void init_process_string()
{
	//init our command
	for (byte i=0; i<COMMAND_SIZE; i++)
		word[i] = 0;
	serial_count = 0;
	bytes_received = false;

	idle_time = millis();
}

//our feedrate variables.
float feedrate = 0.0;
long feedrate_micros = 0;

/* keep track of the last G code - this is the command mode to use
 * if there is no command in the current string 
 */
int last_gcode_g = -1;

/* bit-flags for commands and parameters */
#define GCODE_G	(1<<0)
#define GCODE_M	(1<<1)
#define GCODE_P	(1<<2)
#define GCODE_X	(1<<3)
#define GCODE_Y	(1<<4)
#define GCODE_Z	(1<<5)
#define GCODE_I	(1<<6)
#define GCODE_J	(1<<7)
#define GCODE_K	(1<<8)
#define GCODE_F	(1<<9)
#define GCODE_S	(1<<10)
#define GCODE_Q	(1<<11)
#define GCODE_R	(1<<12)

#define TYPE_INT 1
#define TYPE_FLOAT 2

/* macros to save typing and bugs in the parser function */
#define PARSE_INT(ch, instr, str, str_size, len, val, seen, flag) \
	case ch: \
		len = scan_int(str, &val, &seen, flag); \
		break;

#define PARSE_FLOAT(ch, instr, str, str_size, len, val, seen, flag) \
	case ch: \
		len = scan_float(str, &val, &seen, flag); \
		break;

int parse_string(struct GcodeParser * gc, char instruction[], int size)
{
	int ind;
	int len;	/* length of parameter argument */

	gc->seen = 0;

	len=0;
	/* scan the string for commands and parameters, recording the arguments for each,
	 * and setting the seen flag for each that is seen
	 */
	for (ind=0; ind<size; ind += (1+len))
	{
		len = 0;
		switch (instruction[ind])
		{
			PARSE_INT('G', instruction, &instruction[ind+1], size-ind, len, gc->G, gc->seen, GCODE_G);
			PARSE_INT('M', instruction, &instruction[ind+1], size-ind, len, gc->M, gc->seen, GCODE_M);
			PARSE_FLOAT('P', instruction, &instruction[ind+1], size-ind, len, gc->P, gc->seen, GCODE_P);
			PARSE_FLOAT('X', instruction, &instruction[ind+1], size-ind, len, gc->X, gc->seen, GCODE_X);
			PARSE_FLOAT('Y', instruction, &instruction[ind+1], size-ind, len, gc->Y, gc->seen, GCODE_Y);
			PARSE_FLOAT('Z', instruction, &instruction[ind+1], size-ind, len, gc->Z, gc->seen, GCODE_Z);
			PARSE_FLOAT('I', instruction, &instruction[ind+1], size-ind, len, gc->I, gc->seen, GCODE_I);
			PARSE_FLOAT('J', instruction, &instruction[ind+1], size-ind, len, gc->J, gc->seen, GCODE_J);
			PARSE_FLOAT('F', instruction, &instruction[ind+1], size-ind, len, gc->F, gc->seen, GCODE_F);
			PARSE_FLOAT('R', instruction, &instruction[ind+1], size-ind, len, gc->R, gc->seen, GCODE_R);
			PARSE_FLOAT('Q', instruction, &instruction[ind+1], size-ind, len, gc->Q, gc->seen, GCODE_Q);
			break;
		}
	}
}


//Read the string and execute instructions
void process_string(char instruction[], int size)
{

	GcodeParser gc;	/* string parse result */

	//the character / means delete block... used for comments and stuff.
	if (instruction[0] == '/')
	{
		Serial.println("ok");
		return;
	}

	//init baby!
	FloatPoint fp;
	fp.x = 0.0;
	fp.y = 0.0;
	fp.z = 0.0;

	//get all our parameters!
	parse_string(&gc, instruction, size);

	/* if no command was seen, but parameters were, then use the last G code as 
	 * the current command
	 */
	if ((!gc.seen & (GCODE_G | GCODE_M)) && 
	    ((gc.seen != 0) &&
		(last_gcode_g >= 0))
	)
	{
		/* yes - so use the previous command with the new parameters */
		gc.G = last_gcode_g;
		gc.seen |= GCODE_G;
	}

	//did we get a gcode?
	if (gc.seen & GCODE_G)
	{
		last_gcode_g = gc.G;	/* remember this for future instructions */
		fp = current_units;
		if (abs_mode)
		{
			if (gc.seen & GCODE_X)
				fp.x = gc.X;
			if (gc.seen & GCODE_Y)
				fp.y = gc.Y;
			if (gc.seen & GCODE_Z)
				fp.z = gc.Z;
		}
		else
		{
			if (gc.seen & GCODE_X)
				fp.x += gc.X;
			if (gc.seen & GCODE_Y)
				fp.y += gc.Y;
			if (gc.seen & GCODE_Z)
				fp.z += gc.Z;
		}

		// Get feedrate if supplied
		if ( gc.seen & GCODE_F )
			feedrate = gc.F;

		//do something!
		switch (gc.G)
		{
			//Rapid Positioning
			//Linear Interpolation
			//these are basically the same thing.
			case 0:
			case 1:
				//set our target.
				set_target(fp.x, fp.y, fp.z);

				// Use currently set feedrate if doing a G1
				if (gc.G == 1)
					feedrate_micros = calculate_feedrate_delay(feedrate);
				// Use our max for G0
				else
					feedrate_micros = getMaxSpeed();

				//finally move.
				dda_move(feedrate_micros);
				break;

			//Clockwise arc
			case 2:
			//Counterclockwise arc
			case 3:
			{
				FloatPoint cent;

				// Centre coordinates are always relative
				if (gc.seen & GCODE_I) cent.x = current_units.x + gc.I;
				else cent.x = current_units.x;
				if (gc.seen & GCODE_J) cent.y = current_units.y + gc.J;

				float angleA, angleB, angle, radius, length, aX, aY, bX, bY;

				aX = (current_units.x - cent.x);
				aY = (current_units.y - cent.y);
				bX = (fp.x - cent.x);
				bY = (fp.y - cent.y);

				// Clockwise
				if (gc.G == 2)
				{
					angleA = atan2(bY, bX);
					angleB = atan2(aY, aX);
				}
				// Counterclockwise
				else
				{
					angleA = atan2(aY, aX);
					angleB = atan2(bY, bX);
				}

				// Make sure angleB is always greater than angleA
				// and if not add 2PI so that it is (this also takes
				// care of the special case of angleA == angleB,
				// ie we want a complete circle)
				if (angleB <= angleA)
					angleB += 2 * M_PI;
				angle = angleB - angleA;

				radius = sqrt(aX * aX + aY * aY);
				length = radius * angle;
				int steps, s, step;

				// Maximum of either 2.4 times the angle in radians or the length of the curve divided by the constant specified in _init.pde
				steps = (int) ceil(max(angle * 2.4, length / curve_section));

				FloatPoint newPoint;
				float arc_start_z = current_units.z;
				for (s = 1; s <= steps; s++)
				{
					step = (gc.G == 3) ? s : steps - s; // Work backwards for CW
					newPoint.x = cent.x + radius * cos(angleA + angle
							* ((float) step / steps));
					newPoint.y = cent.y + radius * sin(angleA + angle
							* ((float) step / steps));
					set_target(newPoint.x, newPoint.y, arc_start_z + (fp.z
							- arc_start_z) * s / steps);

					// Need to calculate rate for each section of curve
					if (feedrate > 0)
						feedrate_micros = calculate_feedrate_delay(feedrate);
					else
						feedrate_micros = getMaxSpeed();

					// Make step
					dda_move(feedrate_micros);
				}
			}
			break;

			
			case 4: //Dwell
				delay((int)(gc.P * 1000));
				break;

				//Inches for Units
			case 20:
				x_units = X_STEPS_PER_INCH;
				y_units = Y_STEPS_PER_INCH;
				z_units = Z_STEPS_PER_INCH;
				curve_section = CURVE_SECTION_INCHES;

				calculate_deltas();
				break;

				//mm for Units
			case 21:
				x_units = X_STEPS_PER_MM;
				y_units = Y_STEPS_PER_MM;
				z_units = Z_STEPS_PER_MM;
				curve_section = CURVE_SECTION_MM;

				calculate_deltas();
				break;

				//go home.
			case 28:
				set_target(0.0, 0.0, 0.0);
				dda_move(getMaxSpeed());
				break;

				//go home via an intermediate point.
			case 30:
				//set our target.
				set_target(fp.x, fp.y, fp.z);

				//go there.
				dda_move(getMaxSpeed());

				//go home.
				set_target(0.0, 0.0, 0.0);
				dda_move(getMaxSpeed());
				break;

			// Drilling canned cycles
			case 81: // Without dwell
			case 82: // With dwell
			case 83: // Peck drilling
			{
				float retract = gc.R;
				
				if (!abs_mode)
					retract += current_units.z;

				// Retract to R position if Z is currently below this
				if (current_units.z < retract)
				{
					set_target(current_units.x, current_units.y, retract);
					dda_move(getMaxSpeed());
				}

				// Move to start XY
				set_target(fp.x, fp.y, current_units.z);
				dda_move(getMaxSpeed());

				// Do the actual drilling
				float target_z = retract;
				float delta_z;

				// For G83 move in increments specified by Q code, otherwise do in one pass
				if (gc.G == 83)
					delta_z = gc.Q;
				else
					delta_z = retract - fp.z;

				do {
					// Move rapidly to bottom of hole drilled so far (target Z if starting hole)
					set_target(fp.x, fp.y, target_z);
					dda_move(getMaxSpeed());

					// Move with controlled feed rate by delta z (or to bottom of hole if less)
					target_z -= delta_z;
					if (target_z < fp.z)
						target_z = fp.z;
					set_target(fp.x, fp.y, target_z);
					if (feedrate > 0)
						feedrate_micros = calculate_feedrate_delay(feedrate);
					else
						feedrate_micros = getMaxSpeed();
					dda_move(feedrate_micros);

					// Dwell if doing a G82
					if (gc.G == 82)
						delay((int)(gc.P * 1000));

					// Retract
					set_target(fp.x, fp.y, retract);
					dda_move(getMaxSpeed());
				} while (target_z > fp.z);
			}
			break;

			
			case 90: //Absolute Positioning
				abs_mode = true;
				break;

			
			case 91: //Incremental Positioning
				abs_mode = false;
				break;

			
			case 92: //Set as home
				set_position(0.0, 0.0, 0.0);
				break;

				/*
				 //Inverse Time Feed Mode
				 case 93:

				 break;  //TODO: add this

				 //Feed per Minute Mode
				 case 94:

				 break;  //TODO: add this
				 */

			default:
				Serial.print("huh? G");
				Serial.println(gc.G, DEC);
		}
	}

	//find us an m code.
	if (gc.seen & GCODE_M)
	{
		switch (gc.M)
		{
			//TODO: this is a bug because search_string returns 0.  gotta fix that.
			case 0:
				true;
				break;
				/*
				 case 0:
				 //todo: stop program
				 break;

				 case 1:
				 //todo: optional stop
				 break;

				 case 2:
				 //todo: program end
				 break;
				 */
				//turn extruder on, forward
			case 101:
				extruder_set_direction(1);
				extruder_set_speed(extruder_speed);
				break;

				//turn extruder on, reverse
			case 102:
				extruder_set_direction(0);
				extruder_set_speed(extruder_speed);
				break;

				//turn extruder off
			case 103:
				extruder_set_speed(0);
				break;

				//custom code for temperature control
			case 104:
				if (gc.seen & GCODE_S)
				{
					extruder_set_temperature((int)gc.S);

					//warmup if we're too cold.
					while (extruder_get_temperature() < extruder_target_celsius)
					{
						extruder_manage_temperature();
						Serial.print("T:");
						Serial.println(extruder_get_temperature());
						delay(1000);
					}
				}
				break;

				//custom code for temperature reading
			case 105:
				Serial.print("T:");
				Serial.println(extruder_get_temperature());
				break;

				//turn fan on
			case 106:
				extruder_set_cooler(255);
				break;

				//turn fan off
			case 107:
				extruder_set_cooler(0);
				break;

				//set max extruder speed, 0-255 PWM
			case 108:
				if (gc.seen & GCODE_S)
					extruder_speed = (int)gc.S;
				break;

			default:
				Serial.print("Huh? M");
				Serial.println(gc.M, DEC);
		}
	}

	//tell our host we're done
	Serial.println("ok");
}

int scan_float(char *str, float *valp, unsigned int *seen, unsigned int flag)
{
	float res;
	int len;
	char *end;

	res = (float)strtod(str, &end);
	len = end - str;

	if (len > 0)
	{
		*valp = res;
		*seen |= flag;
	}
	else
		*valp = 0;

	return len;	/* length of number */
}

int scan_int(char *str, int *valp, unsigned int *seen, unsigned int flag)
{
	int res;
	int len;
	char *end;

	res = (int)strtol(str, &end, 10);
	len = end - str;

	if (len > 0)
	{
		*valp = res;
		*seen |= flag;
	}
	else
		*valp = 0;

	return len;	/* length of number */
}


//init our variables
long max_delta;
long x_counter;
long y_counter;
long z_counter;
bool x_can_step;
bool y_can_step;
bool z_can_step;
int milli_delay;

void init_steppers()
{
	//turn them off to start.
	disable_steppers();
	
	//init our points.
	current_units.x = 0.0;
	current_units.y = 0.0;
	current_units.z = 0.0;
	target_units.x = 0.0;
	target_units.y = 0.0;
	target_units.z = 0.0;
	
	pinMode(X_STEP_PIN, OUTPUT);
	pinMode(X_DIR_PIN, OUTPUT);
	pinMode(X_ENABLE_PIN, OUTPUT);
	pinMode(X_MIN_PIN, INPUT);
	pinMode(X_MAX_PIN, INPUT);
	
	pinMode(Y_STEP_PIN, OUTPUT);
	pinMode(Y_DIR_PIN, OUTPUT);
	pinMode(Y_ENABLE_PIN, OUTPUT);
	pinMode(Y_MIN_PIN, INPUT);
	pinMode(Y_MAX_PIN, INPUT);
	
	pinMode(Z_STEP_PIN, OUTPUT);
	pinMode(Z_DIR_PIN, OUTPUT);
	pinMode(Z_ENABLE_PIN, OUTPUT);
	pinMode(Z_MIN_PIN, INPUT);
	pinMode(Z_MAX_PIN, INPUT);
	
	//figure our stuff.
	calculate_deltas();
}

void dda_move(long micro_delay)
{
	//turn on steppers to start moving =)
	enable_steppers();
	
	//figure out our deltas
	max_delta = max(delta_steps.x, delta_steps.y);
	max_delta = max(delta_steps.z, max_delta);

	//init stuff.
	long x_counter = -max_delta/2;
	long y_counter = -max_delta/2;
	long z_counter = -max_delta/2;
	
	//our step flags
	bool x_can_step = 0;
	bool y_can_step = 0;
	bool z_can_step = 0;
	
	//how long do we delay for?
	if (micro_delay >= 16383)
		milli_delay = micro_delay / 1000;
	else
		milli_delay = 0;

	//do our DDA line!
	do
	{
		x_can_step = can_step(X_MIN_PIN, X_MAX_PIN, current_steps.x, target_steps.x, x_direction);
		y_can_step = can_step(Y_MIN_PIN, Y_MAX_PIN, current_steps.y, target_steps.y, y_direction);
		z_can_step = can_step(Z_MIN_PIN, Z_MAX_PIN, current_steps.z, target_steps.z, z_direction);

		if (x_can_step)
		{
			x_counter += delta_steps.x;
			
			if (x_counter > 0)
			{
				do_step(X_STEP_PIN);
				x_counter -= max_delta;
				
				if (x_direction)
					current_steps.x++;
				else
					current_steps.x--;
			}
		}

		if (y_can_step)
		{
			y_counter += delta_steps.y;
			
			if (y_counter > 0)
			{
				do_step(Y_STEP_PIN);
				y_counter -= max_delta;

				if (y_direction)
					current_steps.y++;
				else
					current_steps.y--;
			}
		}
		
		if (z_can_step)
		{
			z_counter += delta_steps.z;
			
			if (z_counter > 0)
			{
				do_step(Z_STEP_PIN);
				z_counter -= max_delta;
				
				if (z_direction)
					current_steps.z++;
				else
					current_steps.z--;
			}
		}
		
		//keep it hot =)
		extruder_manage_temperature();
				
		//wait for next step.
		if (milli_delay > 0)
			delay(milli_delay);			
		else
			delayMicroseconds(micro_delay);
	}
	while (x_can_step || y_can_step || z_can_step);
	
	//set our points to be the same
	current_units.x = target_units.x;
	current_units.y = target_units.y;
	current_units.z = target_units.z;
	calculate_deltas();
}

bool can_step(byte min_pin, byte max_pin, long current, long target, byte direction)
{
	//stop us if we're on target
	if (target == current)
		return false;
	//stop us if we're at home and still going 
	else if (read_switch(min_pin) && !direction)
		return false;
	//stop us if we're at max and still going
	else if (read_switch(max_pin) && direction)
		return false;

	//default to being able to step
	return true;
}

void do_step(byte step_pin)
{
	digitalWrite(step_pin, HIGH);
	delayMicroseconds(5);
	digitalWrite(step_pin, LOW);
}

bool read_switch(byte pin)
{
	//dual read as crude debounce
	#if SENSORS_INVERTING == 1
		return !digitalRead(pin) && !digitalRead(pin);
	#else
		return digitalRead(pin) && digitalRead(pin);
	#endif
}

long to_steps(float steps_per_unit, float units)
{
	return steps_per_unit * units;
}

void set_target(float x, float y, float z)
{
	target_units.x = x;
	target_units.y = y;
	target_units.z = z;
	
	calculate_deltas();
}

void set_position(float x, float y, float z)
{
	current_units.x = x;
	current_units.y = y;
	current_units.z = z;
	
	calculate_deltas();
}

void calculate_deltas()
{
	//figure our deltas.
	delta_units.x = abs(target_units.x - current_units.x);
	delta_units.y = abs(target_units.y - current_units.y);
	delta_units.z = abs(target_units.z - current_units.z);
				
	//set our steps current, target, and delta
	current_steps.x = to_steps(x_units, current_units.x);
	current_steps.y = to_steps(y_units, current_units.y);
	current_steps.z = to_steps(z_units, current_units.z);

	target_steps.x = to_steps(x_units, target_units.x);
	target_steps.y = to_steps(y_units, target_units.y);
	target_steps.z = to_steps(z_units, target_units.z);

	delta_steps.x = abs(target_steps.x - current_steps.x);
	delta_steps.y = abs(target_steps.y - current_steps.y);
	delta_steps.z = abs(target_steps.z - current_steps.z);
	
	//what is our direction
	x_direction = (target_units.x >= current_units.x);
	y_direction = (target_units.y >= current_units.y);
	z_direction = (target_units.z >= current_units.z);

	//set our direction pins as well
	digitalWrite(X_DIR_PIN, x_direction);
	digitalWrite(Y_DIR_PIN, y_direction);
	digitalWrite(Z_DIR_PIN, z_direction);
}


long calculate_feedrate_delay(float feedrate)
{
	//how long is our line length?
	float distance = sqrt(delta_units.x*delta_units.x + delta_units.y*delta_units.y + delta_units.z*delta_units.z);
	long master_steps = 0;
	
	//find the dominant axis.
	if (delta_steps.x > delta_steps.y)
	{
		if (delta_steps.z > delta_steps.x)
			master_steps = delta_steps.z;
		else
			master_steps = delta_steps.x;
	}
	else
	{
		if (delta_steps.z > delta_steps.y)
			master_steps = delta_steps.z;
		else
			master_steps = delta_steps.y;
	}

	//calculate delay between steps in microseconds.  this is sort of tricky, but not too bad.
	//the formula has been condensed to save space.  here it is in english:
	// distance / feedrate * 60000000.0 = move duration in microseconds
	// move duration / master_steps = time between steps for master axis.

	return ((distance * 60000000.0) / feedrate) / master_steps;	
}

long getMaxSpeed()
{
	if (delta_steps.z > 0)
		return calculate_feedrate_delay(FAST_Z_FEEDRATE);
	else
		return calculate_feedrate_delay(FAST_XY_FEEDRATE);
}

void enable_steppers()
{
	// Enable steppers only for axes which are moving
	// taking account of the fact that some or all axes
	// may share an enable line (check using macros at
	// compile time to avoid needless code)
	if ( target_units.x == current_units.x
		#if X_ENABLE_PIN == Y_ENABLE_PIN
		     && target_units.y == current_units.y
		#endif
		#if X_ENABLE_PIN == Z_ENABLE_PIN
		     && target_units.z == current_units.z
		#endif
	)
		digitalWrite(X_ENABLE_PIN, LOW);
	else
		digitalWrite(X_ENABLE_PIN, HIGH);
	if ( target_units.y == current_units.y
		#if Y_ENABLE_PIN == X_ENABLE_PIN
		     && target_units.x == current_units.x
		#endif
		#if Y_ENABLE_PIN == Z_ENABLE_PIN
		     && target_units.z == current_units.z
		#endif
	)
		digitalWrite(Y_ENABLE_PIN, LOW);
	else
		digitalWrite(Y_ENABLE_PIN, HIGH);
	if ( target_units.z == current_units.z
		#if Z_ENABLE_PIN == X_ENABLE_PIN
			&& target_units.x == current_units.x
		#endif
		#if Z_ENABLE_PIN == Y_ENABLE_PIN
			&& target_units.y == current_units.y
		#endif
	)
		digitalWrite(Z_ENABLE_PIN, LOW);
	else
		digitalWrite(Z_ENABLE_PIN, HIGH);
}

void disable_steppers()
{
	//disable our steppers
	digitalWrite(X_ENABLE_PIN, LOW);
	digitalWrite(Y_ENABLE_PIN, LOW);
	digitalWrite(Z_ENABLE_PIN, LOW);
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

