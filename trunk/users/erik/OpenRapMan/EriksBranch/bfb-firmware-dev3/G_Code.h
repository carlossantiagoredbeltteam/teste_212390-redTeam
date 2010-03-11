/**********************************************************************
 ***************************  G_Code.h  *******************************
 **********************************************************************
 * 
 * Company:         Bits From Bytes Ltd
 *
 * Software License Agreement
 *
 * Copyright (C) 2009 Bits From Bytes Ltd.  All rights reserved.
 *
 * Bits From Bytes Ltd licenses to you the right to use, modify, 
 * copy, and distribute this software under the 
 * Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported
 * licence (see 
 * CreativeCommons-by-nc-sa-3.0-summary.pdf which is a copy of the 
 * text at http://creativecommons.org/licenses/by-nc-sa/3.0/ for a 
 * summary and CreativeCommons-by-nc-sa-3.0.pdf which is a copy of the 
 * text at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
 * for the full legal text).
 * 
 * You should refer to the license agreement (Bits From Bytes Ltd Software 
 * Licence.pdf) accompanying this Software for additional information 
 * regarding your rights and obligations.
 *
 * THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT 
 * WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT 
 * LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A 
 * PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL 
 * BITS FROM BYTES LTD BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT
 * OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, COST OF 
 * PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS 
 * BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE 
 * THEREOF), ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER 
 * SIMILAR COSTS, WHETHER ASSERTED ON THE BASIS OF CONTRACT, TORT 
 * (INCLUDING NEGLIGENCE), BREACH OF WARRANTY, OR OTHERWISE.
 *
 *
 * Author(s)                   		Date    	Comment
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Tony Fletcher (& Ian Adkins) 	16/11/2009	Initial Release
 ***********************************************************************/

//List of G-Codes.
//See G_Code.c for list of the ones implemented
/*
RS274NGC G-CODE PROGRAMMING 

G and M Code Modal Groups
group 1 = {G0, G1, G2, G3, G80, G81, G82, G83, G84, G85, G86, G87, G88, G89} - motion  
group 2 = {G17, G18, G19} - plane selection  
group 3 = {G90, G91} - distance mode  
group 5 = {G93, G94} - spindle speed mode  
group 6 = {G20, G21} - units  
group 7 = {G40, G41, G42} - cutter diameter compensation  
group 8 = {G43, G49} - tool length offset  
group 10 = {G98, G99} - return mode in canned cycles  
group12 = {G54, G55, G56, G57, G58, G59, G59.1, G59.2, G59.3} coordinate system selection

group 2 = {M26, M27} - axis clamping  
group 4 = {M0, M1, M2, M30, M60} - stopping  
group 6 = {M6} - tool change  
group 7 = {M3, M4, M5} - spindle turning  
group 8 = {M7, M8, M9} - coolant  
group 9 = {M48, M49} - feed and speed override bypass


Words acceptable to the interpreter
No D	Tool radius compensation number
Yes F	Feedrate
Yes G	General function see list below
No H	Tool length offset
No I	X-axis offset for arcs
No J	Y-axis offset for arcs
No K	Z-axis offset for arcs
No L	Number of repetitions in canned cycles
Yes M	Miscellanious function
No N	Line Number
Yes P	Dwell time in G4 and canned cycles
No Q	Feed increment in G83 canned cycle
	Key used with G10
No R	arc radius
Yes S	canned cycle plane
No T	Tool selection
Yes X	X-axis of machine
Yes Y	Y-axis of machine
Yes Z	Z-axis of machine
*/

/*
Yes G00	rapid positioning  
Yes G01	linear interpolation  
No G02	circular/helical interpolation (clockwise)  
No G03	circular/helical interpolation (c-clockwise)  
Yes G04	dwell  
Yes G10 coordinate system origin setting  
No G17 xy plane selection  
No G18 xz plane selection  
No G19 yz plane selection  
Yes G20 inch system selection  
Yes G21 millimeter system selection  
No G40 cancel cutter diameter compensation  
No G41 start cutter diameter compensation left  
No G42 start cutter diameter compensation right  
No G43 tool length offset (plus)  
No G49 cancel tool length offset  
No G53 motion in machine coordinate system  
G54 use preset work coordinate system 1  
G55 use preset work coordinate system 2  
G56 use preset work coordinate system 3  
G57 use preset work coordinate system 4
G58 use preset work coordinate system 5  
G59 use preset work coordinate system 6  
G59.1 use preset work coordinate system 7  
G59.2 use preset work coordinate system 8  
G59.3 use preset work coordinate system 9  
G80 cancel motion mode (includes canned)  
G81 drilling canned cycle  
G82 drilling with dwell canned cycle  
G83 chip-breaking drilling canned cycle  
G84 right hand tapping canned cycle  
G85 boring, no dwell, feed out canned cycle  
G86 boring, spindle stop, rapid out canned  
G87 back boring canned cycle  
G88 boring, spindle stop, manual out canned  
G89 boring, dwell, feed out canned cycle  
Yes G90 absolute distance mode  
Yes G91 incremental distance mode  
Yes G92 offset coordinate systems  
G92.2 cancel offset coordinate systems  
G93 inverse time feed mode  
G94 feed per minute mode  
G98 initial level return in canned cycles

M0 program stop  
M1 optional program stop  
M2 program end  
M3 turn spindle clockwise  
M4 turn spindle counterclockwise  
M5 stop spindle turning  
M6 tool change  
M7 mist coolant on
M8 flood coolant on  
M9 mist and flood coolant off  
M26 enable automatic b-axis clamping  
M27 disable automatic b-axis clamping  
M30 program end, pallet shuttle, and reset  
M48 enable speed and feed overrides  
M49 disable speed and feed overrides  
M60 pallet shuttle and program stop

RepRap special codes
GCode generated by March 29,2007 Skeinforge 
M100 P210 Set extruder speed to 210.0 
M103 Turn extruder off. 
M101 Turn extruder on.
M104 P145.0  Set temperature to 145.0 C. 
M105  Custom code for temperature reading. 
M106 Turn fan on.
M107 Turn fan off. 
M108 P0.8  Set extrusion diameter to 0.8 mm. 
**********************
BFB codes
**********************
M220 Turn off AUX
M221 Turn on AUX
M222 Set speed of fast XY moves
M223 Set speed of fast Z moves
M224
M225
**********************
*/

extern char ToolType;   	//1 Pen, 2 Extruder1 , 3 Extruder2, 4 Not Defined, 5 Router, 0 No Tool fitted
extern long SetTemperature;	//value for extruder
extern int temperature_OK;
extern int RPM_Setting;		//value for extruder
extern int SBR, SBW;		//Buffer pointers

extern int Ex_Reverse;
extern int Reverse_Steps;
extern int Prime_Steps;

char Change_M104;
char FeedRate_ManualChange;
char FastMoveMotorEnable;//Flag to switch motor on/off during fast move


/*****************************************************************************/
/*                             External Functions                            */
/*****************************************************************************/
extern void G_CodeRun(char GC_L, int iGC_N, char GC_1L, float fGC_1, char GC_2L,
             float fGC_2, char GC_3L, float fGC_3, char GC_4L,float fGC_4);

extern void M_Code_M104(void); //enable external tremperature control
