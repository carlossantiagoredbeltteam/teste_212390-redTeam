/**********************************************************************
 ***************************  Stepper.c  ******************************
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

#include <plib.h>  //required for interrupt handlers
#include <stdio.h>
#include <stdlib.h>
#include <p32xxxx.h>
#include <math.h>
#include <inttypes.h>
#include "Stepper.h"
#include "Enviroment.h" //to import button defs
#include "Extruder.h"
#include "OLED.h"

#define X_LEFT		1
#define X_RIGHT		0
#define Z_DOWN		1
#define Z_UP		0
#define Y_FORWARD	1
#define Y_BACK		0

#define VERY_SLOW_MOVE		60000		//Sets the speed of the start speed in manual move mode
#define HOME_SPEED_X_Y		1000
#define HOME_SPEED_X_Y_SET	60000
#define HOME_SPEED_Z		500
#define HOME_SPEED_Z_SET	5000

#define	PRESSED 	0
#define NOT_PRESSED 1

#define X_HOME_MM			-135
#define Y_HOME_MM			100
#define Z_HOME_MM			0

//Internal Functions
int f_to_ul(float fNumber); //float to unsigned long
signed int f_to_sl(float fNumber); //float to signed long
void Bresenham_3D_Line(signed int x1, signed int y1, signed int z1,signed int x2, signed int y2, signed int z2);
void AddToStepBuffer(unsigned char SData, char xs, char ys);
void Stepper_SaveValues(void);

//Module Globals

int S_M_Code; //Stepper M code

int xyrate = 0;	    	//Used when x and y steps occur together
int ZFeed_Rate  = 0;	//always do rapid z move

float Delta_X;	//Used to hold movement data
float Delta_Y;
float Delta_Z;

float Save_X = 0;	//Last used coordinate saved here.
float Save_Y = 0;
float Save_Z = 0;
float Save2_X = 0;	//2nd to Last used coordinate saved here.
float Save2_Y = 0;
float Save2_Z = 0;
float Save3_X = 0;	//3nd to Last used coordinate saved here.
float Save3_Y = 0;
float Save3_Z = 0;

//Step value coordinates 
float X_Steps,Y_Steps,Z_Steps; 			//Float value of steps
signed long lX_Steps,lY_Steps,lZ_Steps;	//Long integer values of steps
signed long lSaveSteps_X, lSaveSteps_Y, lSaveSteps_Z;
signed long lHomeStepsX, lHomeStepsY, lHomeStepsZ; //Stores the machine home coordinates
PRIVATE signed int	OffsetSteps_X;//Stores the number of steps offset from absolute coordinate 
PRIVATE signed int	OffsetSteps_Y;
PRIVATE signed int	OffsetSteps_Z;

//Globals for the step circular buffer
unsigned char SBuf;	//Step buffer Flag
int SBR, SBW;	//Buffer pointers
// circular buffer
int SCB[ SB_SIZE]; //Step circular buffer
// Buffer status
volatile int SBReady;
int SBCode; //Byte from buffer Only used in stepper Interrupt
unsigned char BufferEmpty = 1; //Flags Buffer empty = 1

int StepRPM_Setting = 30, PR4_Setting = 65535, StepperInt_Cycle = 0, ManualStepperInt_Cycle = 0;//, Direction = CCW;

int Set_X_Dir, Set_Y_Dir, Set_Z_Dir;
char moveX = 0, moveY = 0, moveZ = 0;
int Manual_Mode_Set = !TRUE;
int FirstPass = TRUE;

//Functions
/******************************************************************/
void Manual_Mode(char ShowPos)
{
//ShowPos show position on OLED = 1 or not = 0
unsigned char AsciiString[9]; 
float Xmm=0,Ymm=0,Zmm=0;

	while (SBR!=SBW); 				//wait for step buffer to empty
	mT4IntEnable(!TRUE);			//Disable T4 step buffer interrput
	Feed_Rate = VERY_SLOW_MOVE;		//Set speed to slow
	moveX = !TRUE;					//Turn off all steppers
	moveY = !TRUE;
	moveZ = !TRUE;
	Axis_Stepper_Motors(On);
	OLED_Manual_Screen();
	
	while(!XPlusRight_Btn); 				//Wait for menu selection key to be released
	while(Manual_Select == NOT_PRESSED){
		Manual_Mode_Set = TRUE;
	
		if(Feed_Rate>1000)Feed_Rate -=75;	//Ramping of the move speed
		if(Feed_Rate>100)Feed_Rate -=5;	//the longer the button is 
		if(Feed_Rate<400) Feed_Rate = 400;	//pressed
		
		//Set direction & move
		if (!XPlusRight_Btn) { Set_X_Dir = X_RIGHT; moveX =TRUE;}
		if (!XMinusLeft_Btn) { Set_X_Dir = X_LEFT; moveX =TRUE;}
		if (XPlusRight_Btn && XMinusLeft_Btn) moveX = !TRUE;
		if (!YPlusTop_Btn)   { Set_Y_Dir = Y_BACK; moveY =TRUE;}
		if (!YMinusBot_Btn)  { Set_Y_Dir = Y_FORWARD; moveY =TRUE;}
		if (YPlusTop_Btn && YMinusBot_Btn) moveY = !TRUE;
		if (!ZPlus_up_Btn)   { Set_Z_Dir = Z_UP; moveZ =TRUE;}
		if (!ZMinus_down_Btn){ Set_Z_Dir = Z_DOWN; moveZ =TRUE;}
		if (ZPlus_up_Btn && ZMinus_down_Btn) moveZ = !TRUE;
		if (!moveX && !moveY && !moveZ) Feed_Rate = VERY_SLOW_MOVE;	//Re-set move speed
			
		//Report current position to OLED. 
		if(ShowPos){
			Xmm = (float)lSaveSteps_X / StepsPer_mm;
			sprintf(AsciiString, "%6.2f",Xmm);		// Converts number to text
			OLED_FastText57(4, 64, AsciiString,0);    // Write the new number	
			Ymm = (float)lSaveSteps_Y / StepsPer_mm;   
			sprintf(AsciiString, "%6.2f",Ymm);	    // Converts number to text
			OLED_FastText57(5, 64, AsciiString,0);    // Write the new number	
			Zmm = (float)lSaveSteps_Z / ZStepsPer_mm;   
			sprintf(AsciiString, "%6.2f",Zmm);		// Converts number to text
			OLED_FastText57(6, 64, AsciiString,0);    // Write the new number	
		}
	}
	Manual_Mode_Set = !TRUE;
	mT4IntEnable(!TRUE);				//Disable T4 step buffer interrput
}//ManualMode

/******************************************************************/
void Axis_Stepper_Motors(int on_off)
{
	if(on_off == On){
		X_Disable = !TRUE; 		//to enable X axis
		Y_Disable = !TRUE; 		//to enable Y axis
		Z_Disable = !TRUE; 		//to enable Z axis
		mT4IntEnable(TRUE);		//Turn on interrupts
	}
	else{
		X_Disable = TRUE; 		//to disable X axis
		Y_Disable = TRUE; 		//to disable Y axis
		Z_Disable = TRUE; 		//to disable Z axis
		mT4IntEnable(!TRUE);	//Turn off interrupts
	}	
}		
/******************************************************************/
/******************************************************************/

int RapMan_Home(void)
{
int i;
	OLED_Home_Screen();
	
	moveX = !TRUE;					//Turn off all steppers
	moveY = !TRUE;
	moveZ = !TRUE;
	Stepper_InitIO();
	Axis_Stepper_Motors(On);
	Manual_Mode_Set = TRUE;
	
	// Manual homing function by Erik de Bruijn
	while(!XPlusRight_Btn); // loop until button is released
	
	OLED_FastText57(3, 0, "PRESS > FOR MANUAL",0);
	int init_manual_home;
	init_manual_home = 0;
	for(i=0;i<2000000;i++)
	{
	if(!XPlusRight_Btn)
	  { 
	    init_manual_home = 1;
	    OLED_FastText57(3, 0, "HOMING MANUALLY   ",0);
	    for(i=0;i<2000000;i++);
	  }
	}
	if(init_manual_home == 1)
	{
	  Manual_Mode('1');
	  OLED_FastText57(3, 0, "HOME COMPLETE",0);
	  while(!Manual_Select); // loop until button is released
	  return TRUE;
	}
	// End of manual homing code.

	Feed_Rate = HOME_SPEED_Z;		//Move tool down to prevent crash
	OLED_FastText57(3, 0, "Z DOWN     ",0);
	Set_Z_Dir = Z_DOWN;
	moveZ = TRUE;
	for(i=0;i<200000;i++);
	moveZ = !TRUE;
	
	OLED_FastText57(3, 0, "Y FORWARD  ",0);
	Feed_Rate = HOME_SPEED_X_Y;		//Move tool forward to prevent crash
	Set_Y_Dir = Y_FORWARD;
	moveY = TRUE;
	for(i=0;i<60000;i++);
	moveY = !TRUE;
	
	OLED_FastText57(3, 0, "HOME X    ",0);	//Display operation
	Feed_Rate = HOME_SPEED_X_Y;				//Set homing speed
	while(!X_HomeSwitch && Manual_Select){	//Keep homing until the switch is pressed
		Set_X_Dir = X_LEFT;					//Direction of home		
		while(!X_HomeSwitch && Manual_Select)moveX = TRUE;	
		moveX = !TRUE;
		for(i=0;i<20000;i++);				//Wait to allow de-bounce of switch/ noise
	}
	moveX=TRUE;								//Move a little more to ensure full switch
	for(i=0;i<10000;i++);
	moveX = !TRUE;
	
	Feed_Rate = HOME_SPEED_X_Y_SET;			//At slow speed pull away from switch
	while(X_HomeSwitch && Manual_Select){	//to get accurate switch point
		Set_X_Dir = X_RIGHT;
		while(X_HomeSwitch && Manual_Select)moveX = TRUE;
		moveX = !TRUE;
		for(i=0;i<2000;i++);				//Wait to allow de-bounce of switch/ noise
		lSaveSteps_X = X_HOME_MM * StepsPer_mm;	//*************HOME X
		lHomeStepsX = lSaveSteps_X;
	}
	
	OLED_FastText57(3, 0, "HOME Y    ",0);
	Feed_Rate = HOME_SPEED_X_Y;
	while(!Y_HomeSwitch && Manual_Select){		
		Set_Y_Dir = Y_BACK;
		while(!Y_HomeSwitch && Manual_Select)moveY = TRUE;
		moveY = !TRUE;
		for(i=0;i<20000;i++);
	}	
	moveY=TRUE;
	for(i=0;i<10000;i++);
	moveY = !TRUE;
	
	Feed_Rate = HOME_SPEED_X_Y_SET;
	while(Y_HomeSwitch && Manual_Select){	
		Set_Y_Dir = Y_FORWARD;
		while(Y_HomeSwitch && Manual_Select)moveY = TRUE;
		moveY = !TRUE;
		for(i=0;i<2000;i++);
		lSaveSteps_Y = Y_HOME_MM * StepsPer_mm;//*************HOME Y
		lHomeStepsY = lSaveSteps_Y;
	}		
	
	OLED_FastText57(3, 0, "HOME Z    ",0);
	Feed_Rate = HOME_SPEED_Z;
	while(!Z_HomeSwitch && Manual_Select){	
		Set_Z_Dir = Z_UP;
		while(!Z_HomeSwitch && Manual_Select)moveZ = TRUE;
		moveZ = !TRUE;
		for(i=0;i<2000;i++);	
	}
	moveZ=TRUE;
	for(i=0;i<10000;i++);
	moveZ = !TRUE;
	
	Feed_Rate = HOME_SPEED_Z_SET;
	while(Z_HomeSwitch && Manual_Select){	
		Set_Z_Dir = Z_DOWN;
		while(Z_HomeSwitch && Manual_Select)moveZ = TRUE;
		moveZ = !TRUE;
		for(i=0;i<2000;i++);
		lSaveSteps_Z = Z_HOME_MM;//*************HOME Z
		lHomeStepsZ = lSaveSteps_Z;
	}
	Manual_Mode_Set = !TRUE;
	mT4IntEnable(!TRUE);
	if(!Manual_Select)
	{
		OLED_FastText57(3, 0, "HOME ABORTED",0);
		for(i=0;i<2000000;i++);
		return !TRUE;
	}
	else
	{
		OLED_FastText57(3, 0, "HOME COMPLETE",0);
		for(i=0;i<2000000;i++);
		return TRUE;
	}	
}//Rap_Man_Home

//******************************************************************
void GoToRest(void)
{
//Variables required for Run3DLine	
//Values set from last move: lSaveSteps_X,lSaveSteps_Y,lSaveSteps_Z
//Values set here: lX_Steps,lY_Steps,lZ_Steps

extern float X_Rest_mm,Y_Rest_mm,Z_Rest_mm;

	GX_On=1; //Enable axis for move
	GY_On=1;
	GZ_On=0; //To stop any Z move
	Feed_Rate = GO_TO_REST_RATE; //set speed
	
	X_Steps = X_Rest_mm * StepsPer_mm;//Convert mm coordinate to steps
	Y_Steps = Y_Rest_mm * StepsPer_mm;
	//Z_Steps = Z_Rest_mm * ZStepsPer_mm;//Uncomment for Z move
			
	lX_Steps= f_to_sl(X_Steps);	//Convert to integer steps
	lY_Steps= f_to_sl(Y_Steps);	//float to signed long.	
	//lZ_Steps= f_to_sl(Z_Steps);//Uncomment for Z move
	
	mT4IntEnable(TRUE);
	
	Stepper_Run3DLine();//Run line and reset all values
	
	GX_On=0; 
	GY_On=0;
	//GZ_On=0;//Uncomment for Z move
	Delayms(250);
	
}//GoToRest

//******************************************************************
//		STEPPER INTERRUPT
//******************************************************************
void __ISR( _TIMER_4_VECTOR, ipl2) T4Interrupt( void)
{
//XYZ-Axis step timer
//SBCode is 32bit containing step and direction for xyz and speed data
//SBCode Bits 7 XDir, 6 X, 5 YDir, 4 Y, 3 ZDir, 2 Z, 1 & 0 Not used
int mask;
unsigned char bit_pos = 0;
unsigned char xs,ys;

if(Manual_Mode_Set){
	switch(ManualStepperInt_Cycle)
	{
		case 0:	//set Direction
		{
			X_Dir = Set_X_Dir;
			Y_Dir = Set_Y_Dir;
			Z_Dir = Set_Z_Dir;
			PR4 = 5;
			ManualStepperInt_Cycle = 1;
			break;
		}
			
		case 1:
		{
			if(moveX){
				X_Step = 1;
				if(!Set_X_Dir) lSaveSteps_X += 1;
				else lSaveSteps_X -= 1;
			}
			else X_Step = 0;
			if(moveY){
				Y_Step = 1;
				if(!Set_Y_Dir) lSaveSteps_Y += 1;
				else lSaveSteps_Y -= 1;
			}
			else Y_Step = 0;
			if(moveZ){
				Z_Step = 1;
				if(! Set_Z_Dir) lSaveSteps_Z += 1;
				else lSaveSteps_Z -= 1;
			}
			else Z_Step = 0;
		   					
			PR4 = 10;	//Set the on Time
			ManualStepperInt_Cycle = 2;
			break;
		}
			
		case 2:
		{
			PR4 = Feed_Rate;
			X_Step = 0; Y_Step = 0; Z_Step = 0;	
			ManualStepperInt_Cycle = 0;
			break;
		}
	}
	TMR4 = 0;
	mT4ClearIntFlag();
}		
else
{	
	switch(StepperInt_Cycle)
	{
		case 0:	//Read in new code and set Direction
			if(!SBReady&&(SBR!=SBW))
			{ //ready and the buffer is not empty
				SBCode =  SCB[ SBR];  //Read buffer
				SCB[ SBR] = 0x00;    //once read, set to zero 
				SBR++;  
				SBR %= SB_SIZE;
    			SBReady = 1;    //Step byte consumed - ready to take another byte
 			
 				mask = 0x08000000;
 				bit_pos = 3;
				do // Unpack the code into axis Step and Dir
				{	
  					if ( SBCode & mask )
   					{
	   					switch(bit_pos)
		   				{
		   				//set 1's in code
		   					case 3: Z_Dir  = 1; break;
		   					case 5: Y_Dir  = 1; break;
		   					case 7: X_Dir  = 1; break;
		   				}	
   					}
   					else
	   				{
	   					switch(bit_pos)
		   				{
		   				//set 0's in code
		   					case 3: Z_Dir  = 0; break;
		   					case 5: Y_Dir  = 0; break;
		   					case 7: X_Dir  = 0; break;
		   				}	
	   				}	
   					bit_pos += 2;
   					mask <<= 2;
 				}  
   			 	while (mask !=0);
			}		
			PR4 = 5;
			StepperInt_Cycle = 1;
			break;
						
		case 1:
			if (SBReady)
			{
				mask = 0x04000000;
 				bit_pos = 2;
				do // Unpack the code into axis Step and Dir
				{	
  					if ( SBCode & mask )
   					{
	   					switch(bit_pos)
		   				{
		   				//set 1's in code
		   					case 2: Z_Step = 1; break;
		   					case 4: Y_Step = 1; ys = 1; break;
		   					case 6: X_Step = 1; xs = 1; break;
		   				}	
   					}
   					else
	   				{
	   					switch(bit_pos)
		   				{
		   				//set 0's in code
		   					case 2: Z_Step = 0; break;
		   					case 4: Y_Step = 0; ys=0; break;
		   					case 6: X_Step = 0; xs=0; break;
		   				}	
	   				}	
   					bit_pos += 2;
   					mask <<= 2;
 				}  
   			 	while (mask !=0);
			}
			PR4 = 10;	//Set the on Time
			StepperInt_Cycle = 2;
			break;
				
		case 2:
			if (SBReady)
			{
				mask = 0xFFFF; //to return the bottom two bytes
				PR4_Setting = SBCode & mask;
				PR4 = PR4_Setting;	//Set the off time
			}
			else
				PR4 = 5000;
			
			X_Step = 0; Y_Step = 0; Z_Step = 0;	//turn off step pulse
			StepperInt_Cycle = 0;
			SBReady = 0;//code taken from buffer
			SBCode = 0;
			break;	
	}

	TMR4 = 0;
	mT4ClearIntFlag();
	}		
}//T4Interrupt
//******************************************************************
void Stepper_InitIO (void)
{
	// Setup timers
	//Timer 1
	T1CON = 0x8030;	//Set up timer 1 Fosc/2, prescaled 1:256 
	
	DDPCONbits.JTAGEN = 0; //To release port A pins from use by JTAG port
	
	//Set Tris for Stepper
	//X
	 AD1PCFGbits.PCFG8 = 1;   //AtoD port cfg AN8/B8
	 TRISBbits.TRISB8    = OUTPUT;	//Step
	 AD1PCFGbits.PCFG9 = 1;   //AtoD port cfg AN9/B9
	 TRISBbits.TRISB9    = OUTPUT;	//Dir
	 AD1PCFGbits.PCFG13 = 1;   //AtoD port cfg AN13/B13
	 TRISBbits.TRISB13    = OUTPUT;	//Enable
	 TRISDbits.TRISD4    = INPUT;	//X_HomeSwitch
	//Y
	 TRISDbits.TRISD8    = OUTPUT;	//Step
	 TRISDbits.TRISD9    = OUTPUT;	//Dir
	 TRISDbits.TRISD10    = OUTPUT;	//Enable
	 TRISCbits.TRISC13     = INPUT;	//Y_HomeSwitch
	 
	//Z
	 TRISDbits.TRISD2     = OUTPUT;	//Step
	 TRISDbits.TRISD7    = OUTPUT;	//Dir
	 TRISDbits.TRISD3     = OUTPUT;	//Enable
	 TRISCbits.TRISC14     = INPUT;	//Z_HomeSwitch
	 
	X_Disable = TRUE; 		
	Y_Disable = TRUE; 		
	Z_Disable = TRUE; 		
	
	//Timer 4 is used to time the stepper motor steps
	//PB clk = 8MHz Post scaler = 2 to 1 tick every 25nS	
	T4CON = 0x0;			//Clear timer setting register
	T4CONSET = 0x0010;		//Set PS to 2
	TMR4 = 0;				//Reset clock
	PR4 = 500;				//Initialise PR4 value (when T4 matches PR4 it interrupts)
	mT4SetIntPriority(7);	//Set T4 interrupt to top priority
	INTEnableSystemMultiVectoredInt();//Set T4 to vectored i.e. Fast
	mT4ClearIntFlag();		//Clear interrupt flag
	T4CONSET = 0x8000;		//Turn on T4
	mT4IntEnable(!TRUE);	//Disable T4 interrputs
	
	// init the circular buffer pointers
	 SBR = 0;
	 SBW = 0;
	 // Init Rapid moves
	 G_CodeRapidXYMove=0;
	 G_CodeRapidZMove=0;
	 
}//InitStepper
//****************************************************************
void Stepper_LoadNewValues(int Feed_Code, int Machine_Code)
{
int PBspeed;
extern int GoToRestSpeed;
extern char FastMoveMotorEnable;//Flag to switch motor on/off during fast move

	S_F_Code = Feed_Code;
	S_M_Code = Machine_Code;
	
	//Set the feed Rate
	//From Enrique's code Feed rate comes in as mm/s
	//Old code may come in as mm/min
	//if (Feed_Code > 50)
	//{ //assume its mm/min
		Feed_Code /= 60; //to give mm/sec
	//}
	
	//PB clk = 80/8 = 10MHz PS is 2:1
	//Timer is 5MHz 
	//defined above FeedFactor 57094 = 5000000 / 87.575 StepsPer_mm
	
	if (Feed_Code !=0)
	{
		Feed_Rate = (int)FeedFactor / Feed_Code;
	}
	else Feed_Rate = SAFE_FEED_RATE;

	if (G_CodeRapidZMove > 0) ZFeed_Rate = G_CodeRapidZMove; // if it gets a value from G_Code use it
	else ZFeed_Rate  = Z_FEED_RATE;	//always do rapid z move
	
	xyrate = Feed_Rate * 1.414; //Multiply by root2 for 45Degree step
	

	//Extruder OFF Feed Rate
	//Realistic range for Extruder off 250(Very fast) - 7136{Slow)
	if (ExtruderStatus == 0) 
	{
		if (G_CodeRapidXYMove > 0) Feed_Rate = G_CodeRapidXYMove;
		else Feed_Rate = RAPID_MOVE_FEED_RATE; //extruder off fast speed
	
		if (FastMoveMotorEnable == FALSE) //flag set by G-Code
		//default is motor On ie TRUE
		{
			if (FirstPass == TRUE)Extruder_Reverse();
			
			EXTRUDER_DISABLE = TRUE; //Turn off motor
			FirstPass = FALSE;
		}
	}
	else 
	{
		if (FirstPass == FALSE)Extruder_Prime();
		FirstPass = TRUE;
	}
										
	if (GoToRestSpeed)//Flag set and reset in the RapMan_Rest function
	{
		if (G_CodeRapidXYMove > 0) 
		{//if it gets a value from the G_Code
			Feed_Rate = G_CodeRapidXYMove;
			xyrate = G_CodeRapidXYMove;
		}
		else 
		{// Use default
			Feed_Rate = RAPID_MOVE_FEED_RATE;
			xyrate = RAPID_MOVE_FEED_RATE;
		}
		EXTRUDER_DISABLE = TRUE; //Turn off motor
	}

}//Stepper_LoadNewValues
//****************************************************************
void Stepper_CalcSteps(int Units, char G2_G3)
{
//Number of steps on each Axis
	switch (Units)
	{
		case 20:	//Inches
			X_Steps =  GX * StepsPer_Inch;//numbers here are not rounded
			Y_Steps =  GY * StepsPer_Inch;//up or down!
			Z_Steps =  GZ * StepsPer_Inch;
			
			lX_Steps= f_to_sl(X_Steps);	//Float to long function at bottom of this 
			lY_Steps= f_to_sl(Y_Steps);	//section.	
			lZ_Steps= f_to_sl(Z_Steps);
			break;

		case 21:	//Metric
		default:	//Default metric
			X_Steps = GX * StepsPer_mm;
			Y_Steps = GY * StepsPer_mm;
			Z_Steps = GZ * ZStepsPer_mm;
			
			lX_Steps= f_to_sl(X_Steps);	//Float to long function at bottom of this 
			lY_Steps= f_to_sl(Y_Steps);	//section.	
			lZ_Steps= f_to_sl(Z_Steps);
			break;
	}//switch
}
//****************************************************************
void OriginOffset(void)
{
extern float X_Rest_mm,Y_Rest_mm,Z_Rest_mm;
float OffsetX_mm,OffsetY_mm,OffsetZ_mm;

	OffsetSteps_X = lHomeStepsX - lSaveSteps_X;
	OffsetSteps_Y = lHomeStepsY - lSaveSteps_Y;
	OffsetSteps_Z = lHomeStepsZ - lSaveSteps_Z;
	
	//SAVE offset to EEPROM here?
	
	//reset saved values to new origin
	lSaveSteps_X = 0; //zero only if the machine is at new 0,0
	lSaveSteps_Y = 0;
	lSaveSteps_Z = 0;
	
	OffsetX_mm = OffsetSteps_X / StepsPer_mm;
	OffsetY_mm = OffsetSteps_Y / StepsPer_mm;
	OffsetZ_mm = OffsetSteps_Z / ZStepsPer_mm;
	
	X_Rest_mm = X_REST_ABS_MM - X_HOME_MM + OffsetX_mm;
	Y_Rest_mm = Y_REST_ABS_MM - Y_HOME_MM + OffsetY_mm;
	Z_Rest_mm = Z_REST_ABS_MM - Z_HOME_MM + OffsetZ_mm;	
					
}//OriginOffset
//****************************************************************
void ResetOrigin(void)
{
extern float X_Rest_mm,Y_Rest_mm,Z_Rest_mm;

	//restore offset from EEPROM?
		
	if (lSaveSteps_X != lHomeStepsX)	lSaveSteps_X = lHomeStepsX - OffsetSteps_X + lSaveSteps_X;
	if (lSaveSteps_Y != lHomeStepsY)	lSaveSteps_Y = lHomeStepsY - OffsetSteps_Y + lSaveSteps_Y;
	if (lSaveSteps_Z != lHomeStepsZ)	lSaveSteps_Z = lHomeStepsZ - OffsetSteps_Z + lSaveSteps_Z;
	
	X_Rest_mm = X_REST_ABS_MM;
	Y_Rest_mm = Y_REST_ABS_MM;
	Z_Rest_mm = Z_REST_ABS_MM;	
				
}//ResetOrigin

//****************************************************************
void Stepper_Run3DLine()
{	
//all the variables in the following are available a global or local
	Bresenham_3D_Line(lX_Steps,lY_Steps,lZ_Steps,lSaveSteps_X,lSaveSteps_Y,lSaveSteps_Z);
	Stepper_SaveValues();
	
}//Stepper_Run3DLine

//****************************************************************
void Bresenham_3D_Line(signed int x1, signed int y1, signed int z1, 
						signed int x2, signed int y2, signed int z2)
{

int MajorAxis = 0;
signed int incX = 1, incY = 1, incZ = 1;
signed long DeltaX = x2-x1;
signed long DeltaY = y2-y1;
signed long DeltaZ = z2-z1;
signed long TwoDeltaX = DeltaX + DeltaX;
signed long TwoDeltaY = DeltaY + DeltaY;
signed long TwoDeltaZ = DeltaZ + DeltaZ;
int currentX = x1;
int currentY = y1;
int currentZ = z1;
int ErrorX = 0, ErrorY = 0, ErrorZ = 0;
int moveX = 0, moveY = 0, moveZ = 0;

//StepData Bits 7 XDir, 6 X, 5 YDir, 4 Y, 3 ZDir, 2 Z, 1 & 0 Not used
unsigned char StepData = 0;

	if (!GX_On)
	{	//checks to see if the code mentions X
		DeltaX = 0;	//if not mentioned then no change
		TwoDeltaX=0;
	}
	if (!GY_On)
	{
		DeltaY = 0;
		TwoDeltaY=0;
	}
	if (!GZ_On)
	{
		DeltaZ = 0;
		TwoDeltaZ=0;
	}

	//if there is no delta, current step coord is same as saved value
	if (DeltaX == 0)
	{
		x1=x2;
		lX_Steps=lSaveSteps_X;
		GX = Save_X;
	}
	if (DeltaY == 0)
	{
		y1=y2;
		lY_Steps=lSaveSteps_Y;
		GY = Save_Y;
	}
	if (DeltaZ == 0)
	{
		z1=z2;
		lZ_Steps=lSaveSteps_Z;
		GZ = Save_Z;
	}

	if (DeltaX < 0)
	{
		X_Dir = 0;		//Set X Direction based on sign of Delta value
		StepData = StepData & ~0x80; //set bit 7 off
		incX = -1;		
		DeltaX = -DeltaX;
		TwoDeltaX = -TwoDeltaX;
	}
	else 
		{
			X_Dir = 1;
			StepData |= 0x80; //set bit 7 on
		}
		
	if (DeltaY < 0)
	{
		Y_Dir = 0;		//Set Y Direction based on sign of Delta value
		StepData = StepData & ~0x20; //set bit 5 off
		incY = -1;
		DeltaY = -DeltaY;
		TwoDeltaY = -TwoDeltaY;
	}
	else
		{
			Y_Dir = 1;
			StepData |= 0x20; //set bit 5 on
		}
		
	if (DeltaZ < 0)
	{
		Z_Dir = 1;		//Set Z Direction based on sign of Delta value
		StepData |= 0x08; //set bit 3 on
		incZ = -1;			
		DeltaZ = -DeltaZ;	
		TwoDeltaZ = -TwoDeltaZ;
	}
	else
		{
			Z_Dir = 0;
			StepData = StepData & ~0x08; //set bit 3 off	
		}
		
	if ((DeltaX == 0)&(DeltaY == 0))
 	{
		// if its only a z change then go fast
		if (DeltaZ != 0) Feed_Rate = ZFeed_Rate;
	}

	if ((DeltaZ >= DeltaX)&(DeltaZ >= DeltaY))(MajorAxis = 1);
	if ((DeltaX >= DeltaZ)&(DeltaX >= DeltaY))(MajorAxis = 2);	
	if ((DeltaY >= DeltaX)&(DeltaY >= DeltaZ))(MajorAxis = 3);
	
	if ((DeltaX ==0)&(DeltaY==0)&(DeltaZ==0)) MajorAxis = 0; 	

	//if (MajorAxis == 0)
	//{
		//error trap if required
		//if MajorAxis is 0 then it drops out of this code with no action
	//}

//case 1
	if (MajorAxis == 1)// = Z
	{
		do
		{
			currentZ += incZ;
			ErrorX += TwoDeltaX;
			ErrorY += TwoDeltaY;

			if (ErrorX > DeltaZ)
			{
				currentX += incX;
				ErrorX -= TwoDeltaZ;
				moveX = 1;
				StepData |= 0x40; //x set bit 6 on
			}
			if (ErrorY > DeltaZ)
			{
				currentY += incY;
				ErrorY -= TwoDeltaZ;
				moveY = 1;
				StepData |= 0x10; //y set bit 5 on
			}
						
			StepData |= 0x04; //z set bit 2 on
			AddToStepBuffer(StepData,moveX,moveY); //add step data to cuircular buffer
			moveX = 0, moveY = 0, moveZ = 0;
			StepData = StepData & ~0x54; //set bit 6,4,2 (x,y,z) off
			
		}
		while(currentZ != z2);
		
	}//if

//case 2
	if (MajorAxis == 2)// = X
	{
		do
		{
			currentX += incX;
			ErrorZ += TwoDeltaZ;
			ErrorY += TwoDeltaY;

			if (ErrorZ > DeltaX)
			{
				currentZ += incZ;
				ErrorZ -= TwoDeltaX;
				moveZ = 1;
				StepData |= 0x04; //z set bit 2 on
			}
			if (ErrorY > DeltaX)
			{
				currentY += incY;
				ErrorY -= TwoDeltaX;
				moveY = 1;
				StepData |= 0x10; //y set bit 5 on
			}
			
			StepData |= 0x40; //x set bit 6 on	
			AddToStepBuffer(StepData,moveX,moveY); //add step data to cuircular buffer
			moveX = 0, moveY = 0, moveZ = 0;
			StepData = StepData & ~0x54; //set bit 6,4,2 (x,y,z) off
			
		}
		while(currentX != x2);
	}//if

//case 3
	if (MajorAxis == 3)// = Y
	{
		if (currentY != y2)
		{
			do
			{
				currentY += incY;
				ErrorX += TwoDeltaX;
				ErrorZ += TwoDeltaZ;

				if (ErrorX > DeltaY)
				{
					currentX += incX;
					ErrorX -= TwoDeltaY;
					moveX = 1;
					StepData |= 0x40; //x set bit 6 on	
				}
				if (ErrorZ > DeltaY)
				{
					currentZ += incZ;
					ErrorZ -= TwoDeltaY;
					moveZ = 1;
					StepData |= 0x04; //z set bit 2 on
				}
				
				StepData |= 0x10; //y set bit 5 on
				AddToStepBuffer(StepData,moveX,moveY); //add step data to circular buffer
				moveX = 0, moveY = 0; moveZ = 0;
				StepData = StepData & ~0x54; //set bit 6,4,2 (x,y,z) off
			
			}
			while(currentY != y2);
		}//if
	}//if
}//Bresenham_3D_Line

//*************************************************************
void Stepper_SaveValues()
{
//Tidy up after Gcode instruction.
//Save current dimension and step coordinates 

	lSaveSteps_X = lX_Steps;
	lSaveSteps_Y = lY_Steps;
	lSaveSteps_Z = lZ_Steps;
	
	Save3_X = Save2_X;
	Save3_Y = Save2_Y;
	Save3_Z = Save2_Z;

	Save2_X = Save_X;
	Save2_Y = Save_Y;
	Save2_Z = Save_Z;
	
	Save_X = GX;
	Save_Y = GY;
	Save_Z = GZ;
	
//Reset globals
	Delta_X=0; Delta_Y=0; Delta_Z=0;
	X_Steps=0; Y_Steps=0; Z_Steps=0; 
	lX_Steps=0;lY_Steps=0;lZ_Steps=0;
	
}//Stepper_SaveValues

//*************************************************************
int f_to_ul(float fNumber)
{
//Function returns a rounded unsigned long value for fNumber

double IntNumber, Fraction;
int TempNum;

	Fraction = modf(fNumber, &IntNumber);//split float into Int and fraction
	TempNum = (int)IntNumber;
	
	if (Fraction >= 0.5)
	{
		TempNum += 1;
		return TempNum;
	}
	else
		return TempNum;
		
}//f_to_ul

//****************************************************************
signed int f_to_sl(float fNumber)
{
//Function returns a rounded signed long value for fNumber

double IntNumber, Fraction;
signed int TempNum;

	Fraction=modf(fNumber,&IntNumber);//split float into Int and fraction
	TempNum = (signed int)IntNumber;
	
	if (Fraction >= 0.5)
	{
		TempNum += 1;	
	}
	if (Fraction <= -0.5)
	{
		TempNum -= 1;
	}

	return TempNum;
	
}//f_to_sl

//****************************************************************
void AddToStepBuffer(unsigned char SData, char xs, char ys)
{
int BufferCode = 0;
int addmask;
	
	BufferCode = SData; //shift in 8Bit step data
	BufferCode <<= 24;  
  
    if (xs && ys)		//if we have a step in x and y
	{					//at the same time, the move is at 45deg
	    addmask = xyrate; 	//therefore swap in the slower feed rate
	}
	else
		{
			addmask = Feed_Rate;
		}
	BufferCode |= addmask; //add in the feed rate
	
	//ready to add new data so now wait if buffer is full
    while ( (SBW+1)%SB_SIZE == SBR);
   
    SCB[ SBW] = BufferCode; //write in the buffer
	SBW++;                  //increment ptr  	
    SBW %= SB_SIZE;         //wrap around if required
    
}//AddToStepBuffer
/*****************************************************************/
