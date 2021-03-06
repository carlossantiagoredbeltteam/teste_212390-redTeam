#ifndef THERMISTORTABLE_100K_H_
#define THERMISTORTABLE_100K_H_

// "RS 100k thermistor" Rs Part: 528-8592; "EPCOS NTC G540" B57540G0104J
// ./createTemperatureLookup.py --r0=100000 --t0=25 --r1=0 --r2=4700 --beta=4036 --max-adc=1023
// r0: 100000
// t0: 25
// r1: 0
// r2: 4700
// beta: 4036
// max adc: 1023

#define NUMTEMPS 20
short temptable[NUMTEMPS][2] = {
   {1, 864},
   {54, 258},
   {107, 211},
   {160, 185},
   {213, 168},
   {266, 154},
   {319, 143},
   {372, 133},
   {425, 125},
   {478, 116},
   {531, 109},
   {584, 101},
   {637, 94},
   {690, 87},
   {743, 79},
   {796, 70},
   {849, 61},
   {902, 50},
   {955, 34},
   {1008, 2}
};


// Thermistor lookup table for RepRap Temperature Sensor Boards (http://make.rrrf.org/ts)
// See this page:  
// http://dev.www.reprap.org/bin/view/Main/Thermistor
// for details of what goes in this table.
// Made with createTemperatureLookup.py (http://svn.reprap.org/trunk/reprap/firmware/Arduino/utilities/createTemperatureLookup.py)
// ./createTemperatureLookup.py --r0=100000 --t0=25 --r1=0 --r2=4700 --beta=4066 --max-adc=1023
// r0: 100000
// t0: 25
// r1: 0
//// r2: 4700
//// beta: 4066
//// max adc: 1023
//
//#define NUMTEMPS 20
//short temptable[NUMTEMPS][2] = {
//   {1, 864},
//   {54, 258},
//   {107, 211},
//   {160, 185},
//   {213, 168},
//   {266, 154},
//   {319, 143},
//   {372, 133},
//   {425, 125},
//   {478, 116},
//   {531, 109},
//   {584, 101},
//   {637, 94},
//   {690, 87},
//   {743, 79},
//   {796, 70},
//   {849, 61},
//   {902, 50},
//   {955, 34},
//   {1008, 2}
//};


#endif

