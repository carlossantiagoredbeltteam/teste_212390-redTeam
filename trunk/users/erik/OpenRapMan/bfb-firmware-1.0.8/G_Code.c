/**********************************************************************
 ***************************  G_Code.c  *******************************
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

#include "G_Code.h"
#include "Stepper.h"	
#include "Extruder.h"

#define FastFeed				960	 
#define SlowFeed				240 		

//Internal
void G_Code_G0(void);
void G_Code_G1(void);
void G_Code_G2(void);
void G_Code_G3(void);
void G_Code_G4(void);
//void G_Code_G10(void);
void G_Code_G20(void);
void G_Code_G21(void);
void G_Code_G28(void);	//Go Home. 
void G_Code_G90(void);	//Absolute Positioning 
void G_Code_G91(void);	//Incremental Positioning
void G_Code_G92(void);  //Set current as home 

void M_Code_M101(void); //M101 Turn extruder on.
void M_Code_M103(void); //M103 Turn extruder off.
//see header for M104 external 
//void M_Code_M104(void); //M104 S145.0  Set temperature to 145.0 C. 
void M_Code_M106(void); //M106 Turn fan on.
void M_Code_M107(void); //Turn fan off. 
void M_Code_M108(void); //M108 S210 Set extruder speed to 21.0RPM
//*********************
//BFB codes
void M_Code_M220(void);	//Turn off AUX
void M_Code_M221(void);	//Turn on  AUX
void M_Code_M222(void); //M122 S500 Set speed of fast XY moves
void M_Code_M223(void); //M123 S500 Set speed of fast Z moves
						//500fast - 2000slow
void M_Code_M224(void);	//Enable extruder motor during fast move
void M_Code_M225(void);	//Disable extruder motor during fast move
void M_Code_M226(void); //Issue a Pause command from G-Code	
void M_Code_M227(void);	//Enable Extruder Reverse S=Reverse time in ms P=Prime time in ms
void M_Code_M228(void);	//Disable Extruder Reverse
//*********************

//Glaobal variables
int F_Code = 0; //copy of code numbers that are being worked on
int G_Code;
int M_Code;
int Inch_mm = 0;



float GX; //copy of Axis data being worked on
float GY;
float GZ;
float GI_Val;
float GJ_Val;
float GP_Val;
float GS_Val; 

int GX_On = 0;
int GY_On = 0;
int GZ_On = 0;
int GI_On = 0;
int GJ_On = 0;

//TODO here:
//Code in some data validation checks
//const char LetterCode[18]={"DFGHIJKLMNPQRSTXYZ"};
//const int GNumberCode[39]={
//0,1,2,3,4,10,17,18,19,20,
//21,40,41,42,43,49,53,45,55,56,
//57,58,59,80,81,82,83,84,85,86,
//87,88,89,90,91,92,93,94,98
//};
//const int MNumberCode[]={
//0,1,2,3,4,5,6,7,8,9,26,27,30,48,49,60};
/********************************************************/
void G_CodeRun(char GC_L, int iGC_N, char GC_1L, float fGC_1, char GC_2L,
	         float fGC_2, char GC_3L, float fGC_3, char GC_4L,float fGC_4)
{
extern char EOF_Flag;	
//Going into this function we do not know where the axis data
//appears in the line. The following sorts axis Data and stores
//in local globals. It then issues function calls to run the code

	while (SBR!= SBW)
	{
		if ((EOF_Flag == 1)&&(SBW+1 == SBR))
		{//at end of file and one entry in buffer, let it go
			SBW = SBR;
		}
	};

	GX = 0;
	if (GC_1L==0x58) GX=fGC_1; //checks for char "X"
	if (GC_2L==0x58) GX=fGC_2;
	if (GC_3L==0x58) GX=fGC_3;
	if (GC_4L==0x58) GX=fGC_4;
	if ((GC_1L==0x58)|(GC_2L==0x58)|(GC_3L==0x58)|(GC_4L==0x58))
	{
		GX_On=1;
	}
	else
		GX_On=0;
		
	GY = 0;
	if (GC_1L==0x59) GY=fGC_1; //checks for char "Y"
	if (GC_2L==0x59) GY=fGC_2;
	if (GC_3L==0x59) GY=fGC_3;
	if (GC_4L==0x59) GY=fGC_4;
	if ((GC_1L==0x59)|(GC_2L==0x59)|(GC_3L==0x59)|(GC_4L==0x59))
	{
		GY_On=1;
	}
	else
		GY_On=0;
		
	GZ = 0;
	if (GC_1L==0x5A) GZ=fGC_1; //checks for char "Z"
	if (GC_2L==0x5A) GZ=fGC_2;
	if (GC_3L==0x5A) GZ=fGC_3;
	if (GC_4L==0x5A) GZ=fGC_4;
	if ((GC_1L==0x5A)|(GC_2L==0x5A)|(GC_3L==0x5A)|(GC_4L==0x5A))
	{
		GZ_On = 1;
	}
	else
		GZ_On = 0;
		
	GI_Val = 0;
	if (GC_1L==0x49) GI_Val=fGC_1; //checks for char "I"
	if (GC_2L==0x49) GI_Val=fGC_2;
	if (GC_3L==0x49) GI_Val=fGC_3;
	if (GC_4L==0x49) GI_Val=fGC_4;
	if ((GC_1L==0x49)|(GC_2L==0x49)|(GC_3L==0x49)|(GC_4L==0x49))
	{
		GI_On = 1;
	}
	else
		GI_On = 0;
	GJ_Val = 0;
	if (GC_1L==0x4A) GJ_Val=fGC_1; //checks for char "J"
	if (GC_2L==0x4A) GJ_Val=fGC_2;
	if (GC_3L==0x4A) GJ_Val=fGC_3;
	if (GC_4L==0x4A) GJ_Val=fGC_4;
	if ((GC_1L==0x4A)|(GC_2L==0x4A)|(GC_3L==0x4A)|(GC_4L==0x4A))
	{
		GJ_On = 1;
	}
	else
		GJ_On = 0;
		
	//F_Code = 0;//F_Code persistes until its reset by Gcode
	if (GC_1L==0x46) F_Code=fGC_1; //checks for char "F"
	if (GC_2L==0x46) F_Code=fGC_2;
	if (GC_3L==0x46) F_Code=fGC_3;
	if (GC_4L==0x46) F_Code=fGC_4;

	GP_Val = 0;
	if (GC_1L==0x50) GP_Val=fGC_1; //checks for char "P"
	if (GC_2L==0x50) GP_Val=fGC_2;
	if (GC_3L==0x50) GP_Val=fGC_3;
	if (GC_4L==0x50) GP_Val=fGC_4;

	GS_Val = 0;
	if (GC_1L==0x53) GS_Val=fGC_1; //checks for char "S"
	if (GC_2L==0x53) GS_Val=fGC_2;
	if (GC_3L==0x53) GS_Val=fGC_3;
	if (GC_4L==0x53) GS_Val=fGC_4;
/*
	while (SBR!= SBW)
	{
		if ((EOF_Flag == 1)&&(SBW+1 == SBR))
		{//at end of file and one entry in buffer, let it go
			SBW = SBR;
		}
	};
*/	
	switch(GC_L)
	{
		case 0x47:  //G Code
			G_Code=iGC_N;
			if (G_Code==0) 	G_Code_G0();
			if (G_Code==1)	G_Code_G1();
			if (G_Code==2)	G_Code_G2();
			if (G_Code==3)	G_Code_G3();
			if (G_Code==4)	G_Code_G4();
			//if (G_Code==10) G_Code_G10();//?
			if (G_Code==20)	G_Code_G20(); //Set Units Inches
			if (G_Code==21)	G_Code_G21(); //Set Units Metric
			if (G_Code==28)	G_Code_G28(); //Go Home.
			if (G_Code==90)	G_Code_G90(); //Absolute Positioning 
			if (G_Code==91)	G_Code_G91(); //Incremental Positioning 
			if (G_Code==92)	G_Code_G92(); //Set current as home 
			break;
		case 0x4D:	//M Code
			M_Code = iGC_N;	//Sets M code
			G_Code=0, F_Code=0;
				 
			if (M_Code == 101) M_Code_M101();	//M101 Turn extruder on.
			if (M_Code == 103) M_Code_M103();	//M103 Turn extruder off.
			if (M_Code == 104) M_Code_M104();	//M104 Set temperature to S???
			if (M_Code == 106) M_Code_M106();	//M106 Turn fan on
			if (M_Code == 107) M_Code_M107();	//M107 Turn fan off.
			if (M_Code == 108) M_Code_M108();	//M108 S210 Set extruder speed to 21.0RPM
			if (M_Code == 220) M_Code_M220();	//Turn AUX off
			if (M_Code == 221) M_Code_M221();	//Turn AUX On
			if (M_Code == 222) M_Code_M222();	//Set speed of fast XY moves
			if (M_Code == 223) M_Code_M223();	//Set speed of fast Z moves
			if (M_Code == 224) M_Code_M224();	//Enable extruder motor during fast move
			if (M_Code == 225) M_Code_M225();	//Disable extruder motor during fast move
			if (M_Code == 226) M_Code_M226();	//Issue a Pause command from G-Code	
			if (M_Code == 227) M_Code_M227();	//Enable reverse extruder during extruder off
			if (M_Code == 228) M_Code_M228();	//Disable reverse extruder during extruder off
			break;
	}//Switch
}
/********************************************************/
//    G Code Functions to be added here.
//    Please use same format and annotate.
/********************************************************/
void G_Code_G0(void)
{ //G00	rapid positioning 
//Tool coordinates are set as Globals.
// Sets variables and calls functions to execute the code

	//if (M_Code == 0) M_Code = StopSpindle; 	//if not set, make default
	if (F_Code == 0) F_Code = FastFeed; 		//if not set, make default
	//Load values into Stepper control
	Stepper_LoadNewValues(F_Code, M_Code);
	if (ToolType == 1)	ExtruderStatus = 1; //Switch to set normal feed rate
	Stepper_CalcSteps(Inch_mm,0x00);
	Stepper_Run3DLine(); 
}
/********************************************************/
void G_Code_G1(void)
{ //G01	linear interpolation
//Tool coordinates are set as Globals.
//Sets variables and calls functions to execute the code
extern int ManualChange;

	//if (M_Code == 0) M_Code = StopSpindle; 	//if not set, make default
	if (F_Code == 0) F_Code = SlowFeed; 		//if not set, make slowest feed rate
	if (FeedRate_ManualChange)
	{
		F_Code += ManualChange;
	}

	//Load values into Stepper control
	Stepper_LoadNewValues(F_Code, M_Code);
	if (ToolType == 1)	ExtruderStatus = 1; //Switch to set normal feed rate
	Stepper_CalcSteps(Inch_mm,0x00);
	Stepper_Run3DLine(); //Linear machining
}
/********************************************************/
void G_Code_G2(void)
{ //G02	circular interpolation (clockwise)  
//The tool is already at the start position for this instruction
// X,Y coordinates following G2 are the end position of the tool.
// I	X-axis offset to centre
// J	Y-axis offset to centre

	//if (M_Code == 0) M_Code = StopSpindle; 	//if not set, make default
	if (F_Code == 0) F_Code = SlowFeed; 		//if not set, make slowest feed rate
	Stepper_LoadNewValues(F_Code, M_Code);
	Stepper_CalcSteps(Inch_mm, 0x01);
//	Stepper_RunArcLine(2); //run as G2
}
/********************************************************/
void G_Code_G3(void)
{ //G03	circular interpolation (c-clockwise)  
//The tool is already at the start position for this instruction
// X,Y coordinates following G3 are the end position of the tool.
// I	X-axis offset to centre
// J	Y-axis offset to centre

	//if (M_Code == 0) M_Code = StopSpindle; 	//if not set, make default
	if (F_Code == 0) F_Code = SlowFeed; 		//if not set, make slowest feed rate
	Stepper_LoadNewValues(F_Code, M_Code);
	Stepper_CalcSteps(Inch_mm,0x01);
//	Stepper_RunArcLine(3); //run as G3
}
/********************************************************/
void G_Code_G4(void)
{ //G4 Dwell time
//P   Dwell time in seconds
int delay = 0;
//TODO HERE: Time needs sorting out, values here are incorrect
//ms function not scaled correctly and is running at 1/5th speed
	if (GP_Val != 0)
	{
		delay = (int)GP_Val*200;
		delay_ms(delay);
	}
}
/********************************************************/
//void G_Code_G10(void)
//{ //G10 Coordinate system origin

//}
/********************************************************/
void G_Code_G20(void)
{ //G20 Set Units Inches
	Inch_mm = 20; 
}
/********************************************************/
void G_Code_G21(void)
{ //G21 Set Units Metric mm (This is the machine default setting)
	Inch_mm = 21;
}
/********************************************************/
void G_Code_G28(void)	
{//Go Home.TODO HERE
//	if(!RapMan_Home())
//	{
		//home error
//	}	 	
}
/********************************************************/
void G_Code_G90(void)	
{//Absolute Positioning relative to machine home
	ResetOrigin();
}
/********************************************************/
void G_Code_G91(void)	
{//Incremental Positioning, X5 moves +5 units regardless of where the tool is
	//TODO HERE
}
/********************************************************/
void G_Code_G92(void) 
{//Set new origin point
	//G92 X10 Y20 Z0 sets the new origin to these coordinates
	G_Code_G0(); 	//Go to new origin
	OriginOffset(); //Set new origin
}

/********************************************************/
//    M Code Functions to be added here.
//    Please use same format and annotate.
/********************************************************/
void M_Code_M101(void)
{	//"101" Extruder on
	//Switch to flag any special functions required when Extruder is ON
	if (ToolType == 2) //2 is EXTRUDER
	{
		ExtruderStatus = 1; 
	}
}
/********************************************************/
void M_Code_M103(void)
{	//"103" Extruder off
	//Switch to flag any special functions required when Extruder is OFF
	if (ToolType == 2) //2 is EXTRUDER
	{
		ExtruderStatus = 0;
	}
}
/********************************************************/
void M_Code_M104(void)
{	//M104 S145.0  Set temperature to 145.0 C
extern X_Rest_mm;
extern Y_Rest_mm;
extern Z_Rest_mm;

	if (ToolType == 2) //2 is EXTRUDER
	{
		OLED_ClearLine(4);
		OLED_ClearLine(5);
		OLED_ClearLine(6);
		OLED_FastText57(5, 0, "TEMPERATURE CHANGE",0);
	
		temperature_OK = FALSE; //assume temperature is false to start with
		Change_M104 = 1;	//Flag to indicate the temperature change is generated
						//by this G-Code instruction
	
		if (GS_Val != 0)SetTemperature = GS_Val;
		GoToRest();
		Extruder_Status(On); //enables the temperature interrupt
		do
		{
	 		OLED_UpdateThermistorReading();
	 		OLED_UpdateSetTemperature();
	 		OLED_UpdateSetRPM();
		}
		while(temperature_OK == FALSE && SetTemperature != 0);
		Change_M104 = 0; //Reset flag for normal temperature control
		//Delayms(1000);
		OLED_ClearLine(5);		//Clear msg
	}
}
/********************************************************/
void M_Code_M106(void)
{	// M106 Turn fan on.
extern char EnableFanControl; //Set if Fan is to be active
	EnableFanControl=TRUE;
	FAN = On;
}
/********************************************************/
void M_Code_M107(void)
{	// M107 Turn fan off.
extern char EnableFanControl; //Set if Fan is to be active
	EnableFanControl=FALSE;
	FAN = OFF;
}
/********************************************************/
void M_Code_M108(void)
{	//M108 S210 Set extruder speed to 21.0 RPM
	if (ToolType == 2)
	{
		if (GS_Val > 0)	RPM_Setting = GS_Val;
		Control_Stepper_Motor();
		RPM_Change  = 1;//flag to indicate change in value
	}
}
/********************************************************/
void M_Code_M220(void)
{	//M220 Aux OFF
	AUX = OFF;
}
/********************************************************/
void M_Code_M221(void)
{	//M220 Aux ON
	AUX = On;
}
/********************************************************/
void M_Code_M222(void)
{	//M222 S500 Set fast XY move to 500    Fast
	if (ToolType == 2)
	{
		if (GS_Val > 0) G_CodeRapidXYMove = GS_Val;
	}
}
/********************************************************/
void M_Code_M223(void)
{	//M223 S500 Set fast Z move to 500    Fast
	if (ToolType == 2)
	{
		if (GS_Val > 0) G_CodeRapidZMove = GS_Val;
	}
}
/********************************************************/
void M_Code_M224(void)	//Enable extruder motor during fast move
{
	FastMoveMotorEnable = TRUE;
}
/********************************************************/
void M_Code_M225(void)	//Disable extruder motor during fast move
{//Defailt setting
	FastMoveMotorEnable = FALSE;
}
/********************************************************/
void M_Code_M226(void) //Issue a Pause command from G-Code	
{
extern float Save3_X, Save3_Y; //defined in Stepper.c
extern char EOF_Flag; //defined in RapMan.h

	while (SBR!= SBW) //let buffer empty then continue
	{
		if ((EOF_Flag == 1)&&(SBW+1 == SBR))
		{//at end of file and one entry in buffer, let it go
			SBW = SBR;
		}
	};
	Pause_Print();
	while(!Manual_Select); //wait for key up
	RapMan_MoveTo(Save3_X,Save3_Y,0,0);	//move back to print.
}
/********************************************************/	
void M_Code_M227(void)
{	//M228 Enable Extruder reverse during extruder off
	//P=reverse time in ms S=prime time in ms P would 
	//normally be longer than S

	if (ToolType == 2)
	{
		Ex_Reverse = TRUE;
		if (GS_Val > 0)	Reverse_Steps = ceil(GS_Val);
		if (GP_Val > 0) Prime_Steps = ceil(GP_Val);
	}
}
/********************************************************/
void M_Code_M228(void)
{	//M228 Disable Extruder reverse during extruder off
	if (ToolType == 2)
	{
		Ex_Reverse = FALSE;
	}
}
/********************************************************/
