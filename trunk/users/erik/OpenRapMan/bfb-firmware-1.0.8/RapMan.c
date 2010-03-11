/**********************************************************************
 ***************************  RapMan.c  *******************************
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


/***********************************************************
************************Rap_Man*****************************
************************************************************
*
*Notes for G_Code syntax for input file.
*The Progamme has been developed using:
*ACE DXF Converter
*Eagle PCB
*Enrique's Skienforge STL to G_Code
*
*Performance with other converters or G_Code from other
*sources should be checked before running.
*
*Basic File requirement.
*	1) Max line length is 50 characters long.
*	2) Alows Blank lines
*	3) One instruction per line
*	4) G0 feed fast feed
*	   G1 - If no F code is found the default slowest feed
*		rate will be used
*	5) M Codes should be added to the file as required.
*		This should be the only instruction on the line.
*		If more than one Mcode is required, each should be
*		placed on a new line
*	6) The default filenames on the SD-Card are *.bfb or *.gco
*	7) Any line started with a open bracket is ignored
*		as comment
*	8) GCode format is with a space between axis data.

************************************************************
************************Rap_Man*****************************
************************************************************/

#pragma config POSCMOD=XT, FNOSC=PRIPLL, FSOSCEN = OFF
#pragma config FPLLIDIV=DIV_2, FPLLMUL=MUL_20, FPLLODIV=DIV_1 //(8MHz/2)=4 *20=80 /1=80MHz 
#pragma config FWDTEN=OFF, CP=OFF, BWP=OFF

#include <p32xxxx.h>
#include "RapMan.h"
#include "OLED.h"
#include <int.h>

#define NUNBER_OF_MENU_ITEMS	3		//equals number of menu items -1
#define PRINT_OBJECT			0
#define MANUAL_MOVE_HEAD		1
#define TOOL_CONTROL			2
#define SEND_TO_HOME			3
//Tool Head Defines
#define NO_TOOL					0
#define PEN						1
#define EXTRUDER				2
#define EXTRUDER2				3
#define NOT_DEFINED				4
#define ROUTER					5

int Start_Menu(void);
int GetMenuSelection(void);
void Print_Gcode_File(void);
void Pause_Print(void);
void ErrorCondition(int ErrNo);

char CharBuffer[1];
unsigned char LineBuffer[50];

int ADC_readingToolID = 0;
int SampleCountToolID = 0;
long AveSamplesToolID = 0;
int Operation_Mode = 0;

char ToolType = 0;  //1 Pen, 2 Extruder1 , 3 Extruder2
					//4 Not Defined, 5 Router, 0 No Tool fitted
					
int SetTemp = 0;	//value for extruder
int SetRPM = 0;		//value for extruder

int GoToRestSpeed = 0;

//File type switch
int FileType = INVALID_FILE; //init to invalid file type

/***********************************************************
 * Function:        int main(void)
 *
 * PreCondition:    None
 *
 * Input:           None
 *
 * Output:          None
 *
 * Overview:        
 *
 * Note:           Modules:Stepper, Manual, G_Code External
 * functions are prefixed with the module name, internal functions 
 * have no prefix. This does not apply to third party modules like 
 * SPI, FSIO and LCD.
 *  
 ************************************************************/
//*************************************************************
/*
int main( void )
{
//	Setup(); //Configure the IO etc
TRISDbits.TRISD11 	= OUTPUT_PIN;	//FET
//	OLED_Start_Msg();
	while(TRUE) //restart prog
	{
PORTDbits.RD11 = On;
Delayms(200);
PORTDbits.RD11 = OFF;
			
	}	
} // main
*/
int main( void )
{
int Operation_Mode;

	Setup(); //Configure the IO etc
	OLED_Start_Msg();
	while(TRUE) //restart prog
	{
		while(!XPlusRight_Btn);       //wait for key up
		Operation_Mode = Start_Menu();
		switch(Operation_Mode)
		{
			case PRINT_OBJECT: 		Print_Gcode_File(); 				break;
			case MANUAL_MOVE_HEAD:	Manual_Mode(SHOW_POSITIONS); 		break;	//Maunal control of the tool head
			case TOOL_CONTROL:		if (ToolType==2)Manual_Extruder(); 	break;	//Manual control of the extruder
			case SEND_TO_HOME:		RapMan_Home();						break;	//Move to home and reset position
		}				
	}	
} // main

//*************************************************************
void Print_Gcode_File(void)
{
extern float Save3_X, Save3_Y;
	
	PauseFlag == 0; //Initialise flag
	FeedRate_ManualChange = 0;
	
	if(GetTool_ID() != NO_TOOL){
		OLED_Fill_RAM(BLANK_SCREEN); //Clear screen
		OLED_FastText57(0, 10, OLED_Header_VerNo,0);
		while(!XPlusRight_Btn); //wait for key up
		
		while (!MDD_SDSPI_MediaDetect())
		{//Handle no card error
				OLED_FastText57(2, 0, "Insert SD-Card or",0);
				OLED_FastText57(4, 0, "<<ESC TO RESUME",0);
				Delayms(250);
				if(!Manual_Select) return;
		}
		OLED_ClearLine(2); //ensure error msg lines are clear
		OLED_ClearLine(4);	
		
		OpenReadSDFile(); //sets the file name to open
		while(!XPlusRight_Btn); //wait for key up	
		if(!Manual_Select) return;
		if ((FileType == BFB_FILE) || (FileType == GCO_FILE))
		{
			if(!RapMan_Home()) return; //Test home completed normally.
			Operation_Mode = AUTO_MODE;
			OLED_Fill_RAM(BLANK_SCREEN); //Clear screen
			OLED_Printing_Screen(); //Static lables
			
			Stepper_InitIO ();
			Axis_Stepper_Motors(On);
			
			do	{ //MAIN LOOP
				
				if(!Manual_Select){
					Pause_Print();
					while(!Manual_Select);
					while (SBR!= SBW)
					{
						if ((EOF_Flag == 1)&&(SBW+1 == SBR))
						{//at end of file and one entry in buffer, let it go
							SBW = SBR;
						}
					};
					RapMan_MoveTo(Save3_X,Save3_Y,0,0);
				}
				OLED_UpdatePrintScreen();
				
				do{ReadData();}while (LineBuffer[1] == 40); //skip comment lines
				GetCodes();	//Words from the line put into globals
				//Control now passed to the G_Code module
				G_CodeRun(Inst_Code_Letter, iInst_Code, Dim_1_Letter, fDim_1, Dim_2_Letter, fDim_2, Dim_3_Letter, fDim_3, Dim_4_Letter,fDim_4);
				
				FlushBuffer(); //Flush buffer ready for new data
				if (ToolType==2)
				{
					Control_Stepper_Motor();//if the current action is not a fast move
				}
				
				if (!ZPlus_up_Btn){FeedRate_ManualChange = 1;     ManualChange += 10;}
				if (!ZMinus_down_Btn){FeedRate_ManualChange = 1; ManualChange -= 10;}
								
			}//MAIN LOOP
			while ((EOF_Flag !=1)|(ItemsRead != 0)); 	//loop to end of file
		}
		else{
				OLED_Fill_RAM(BLANK_SCREEN);
				OLED_FastText57(2, 0, "Invalid File Type",0);
				OLED_FastText57(3, 0, "Please only use",0);
				OLED_FastText57(4, 0, "*.BFB or *.GCO Files",0);
				while(Manual_Select);
		}		
		Extruder_Status(OFF);						//Disable Stepper
		Axis_Stepper_Motors(OFF);
		pointer = FilePointer; 						//set the file pointer
		FSfclose (pointer);     					//close the file
	
		Setup();
		OLED_FileEnd_Screen();
	
		while(Manual_Select);
	}	
}//Print_Gcode_File	

/************************************************************/
void Pause_Print(void)
{
	while(!Manual_Select); 		//wait for key up
	OLED_ClearLine(4);
	OLED_ClearLine(5);
	OLED_ClearLine(6);
	OLED_FastText57(5, 0, "PAUSE",0);
	
	PauseFlag = 1; //to stop heater going on
	RapMan_MoveTo(X_Rest_mm,Y_Rest_mm,Z_Rest_mm,0); //Move to rest, No Z move
		
	OLED_FastText57(5, 0, "<<ESC TO RESUME",0);

	do
	{
		OLED_UpdateSetTemperature();
		OLED_UpdateThermistorReading(); //monitor temperature during pause
		Delayms(500);
	}
	while(Manual_Select);	//Release from pause
	PauseFlag = 0;
	OLED_ClearLine(5);		//Clear pause msg
	Extruder_Status(On);	//Heater and motor back on	
	M_Code_M104();			//Hold for temp change
	
}//	Pause_Print

/************************************************************/	
void ErrorCondition(int ErrNo)
{
	//Puts the machine in a safe condition if an error is detected
	OLED_ClearLine(2);
	OLED_ClearLine(3);
	OLED_ClearLine(4);
	OLED_ClearLine(5);
	OLED_ClearLine(6);
	OLED_ClearLine(7);
	
	switch(ErrNo)
	{ //Definitions in RapMan.h
		case TEST:
			OLED_FastText57(3, 0, "Error TEST",0);
			if (ToolType == 2 )//Extruder
			{
				Extruder_Status(OFF);
				OLED_FastText57(4, 0, "Extruder OFF",0);
			}
			RapMan_MoveTo(X_Rest_mm,Y_Rest_mm,Z_Rest_mm,0); //Move to rest, No Z move
			EOF_Flag = 1;
			break;
			
		case SEEK_POINT_ERR: //File error
			OLED_FastText57(3, 0, "File Error :seek pt",0);
			if (ToolType == 2 )//Extruder
			{
				Extruder_Status(OFF);
				OLED_FastText57(4, 0, "Extruder OFF",0);
			}
			RapMan_MoveTo(X_Rest_mm,Y_Rest_mm,Z_Rest_mm,0); //Move to rest, No Z move
			EOF_Flag = 1;
			break;
				
		default: //unknown error
			OLED_FastText57(3, 0, "Unknown Error",0);
			break;
	}//switch
	
	do
	{	
		OLED_FastText57(5, 0, " <ESC TO RESUME",0);
		Delayms(150);
		OLED_FastText57(5, 0, "<",0);
		Delayms(150);	
	}
	while(Manual_Select);
	while(!Manual_Select);//wait for keyup
	
}//ErrorCondition

/************************************************************/	
void Setup(void)	
{	

	//OLED setup I/O
	AD1PCFGbits.PCFG5 = 1;   //AtoD port cfg AN5/B5 digital for OLED chip select
	TRISBbits.TRISB5 	= OUTPUT_PIN;	//OLED chip Select
	
	TRISEbits.TRISE6 	= OUTPUT_PIN;	//Display DC
	TRISEbits.TRISE7 	= OUTPUT_PIN;	//Display RES
	//SPI IN OUT and CLK are in Hardware Profile	
	    
    //THERMISTOR
    AD1PCFGbits.PCFG11 = 0;   //AtoD port cfg AN11/B11 Analog
    TRISBbits.TRISB11  	= INPUT_PIN; 	//Thermistor Input
    
    //Tool ID
    AD1PCFGbits.PCFG12 = 0;   //AtoD port cfg AN12/B12 Analog
    TRISBbits.TRISB12  	= INPUT_PIN; 	//Tool ID input
    
    //Fillament switch
    AD1PCFGbits.PCFG0 = 1;   //AtoD port cfg AN0  make digital for switch
    TRISBbits.TRISB0  	= INPUT_PIN; 	//Fillament switch Input
	
	//Push Buttons on Analog pins
	AD1PCFGbits.PCFG2 = 1;   //AtoD port cfg AN2  make digital for btn
	AD1PCFGbits.PCFG3 = 1;   //AtoD port cfg AN3  make digital for btn	
	AD1PCFGbits.PCFG4 = 1;   //AtoD port cfg AN4  make digital for btn	
 	AD1PCFGbits.PCFG15 = 1;  //AtoD port cfg AN15 make digital for btn	
 	
 	//TRIS for buttons
 	TRISBbits.TRISB2 	= INPUT_PIN;	//Button
 	TRISBbits.TRISB3 	= INPUT_PIN;	//Button
 	TRISBbits.TRISB4 	= INPUT_PIN;	//Button
 	TRISBbits.TRISB15 	= INPUT_PIN;	//Button
 	
 	TRISFbits.TRISF4 	= INPUT_PIN;	//Button
 	TRISFbits.TRISF5 	= INPUT_PIN;	//Button
 	TRISGbits.TRISG9 	= INPUT_PIN;	//Button

	//Weak Pullups - Buttons
 	CNPUEbits.CNPUE4=1; 	//B2
 	CNPUEbits.CNPUE5=1; 	//B3
 	CNPUEbits.CNPUE6=1; 	//B4
 	CNPUEbits.CNPUE12=1;	//B15
 	CNPUEbits.CNPUE17=1; 	//F4
 	CNPUEbits.CNPUE18=1; 	//F5
 	CNPUEbits.CNPUE11=1; 	//G9
 	
 	//Limit switches
 	TRISDbits.TRISD4 	= INPUT_PIN;	//switch
	TRISCbits.TRISC13 	= INPUT_PIN;	//switch
	TRISCbits.TRISC14 	= INPUT_PIN;	//switch
	
	//Weak Pullups - Switch
	CNPUEbits.CNPUE13 = 1; 	//X limit D4
	CNPUEbits.CNPUE1  = 1; 	//Y limit C13
	CNPUEbits.CNPUE0  = 1; 	//Z Limit C14
	
	//Setup AtoD
	AD1CON1 = 0x0000; 		//Auto conversion sequence start after sampling
	AD1CON2 = 0;			//use MUXA, AVss and AVdd are used for VRef+/-
	AD1CON3 = 0x1F02;		//Tad =
	AD1CSSL = 0;			//no scanning required
	//Once set up, turn on A to D
	AD1CON1bits.ADON = 1;	//turn on ADC
	
	//Drive all FET's to off state on Start up
	TRISFbits.TRISF0 	= OUTPUT_PIN;	//FET
	HEATER 	= OFF;
	TRISEbits.TRISE5 	= OUTPUT_PIN;	//FET
	FAN  	= OFF;
	TRISDbits.TRISD11 	= OUTPUT_PIN;	//FET
	AUX = OFF; 
 	
	PMCON = 0x00; //disable PMP
 	Stepper_InitIO();
 	InitExtruder();
  	OLED_Init(); 
    INTEnableSystemMultiVectoredInt();	
    
    FeedRate_ManualChange = 0;
    ManualChange = 0 ;//No manual change applied to gcode feed rates
    
    X_Rest_mm = X_REST_ABS_MM;
	Y_Rest_mm = Y_REST_ABS_MM;
	Z_Rest_mm = Z_REST_ABS_MM;	

}//Setup

/************************************************************/
 char GetTool_ID(void)	{
//Any tool attached has an Identification resistor. The voltage drop accross it 
//is the tool ID.
//Descriotion						Resistor	A/D
//976 Ohm resistor for PEN				1K		(90)
//4.7K Ohm resistor for Extruder		4K7		(320)
//9.9K Ohm resistor for Extruder2		10K		(500)
//22K Ohm resistor for Not Defined		22K		(700)
//47K to 100K Ohm resistor for Router	47K to 100K		(840 to 920)
//1M  Ohm resistor for No Tool			1M to open circuit(1010 to 1024)

int Reading = 0;
char type = 0;

	while(Reading == 0){
		ADC_readingToolID = Read_Analog(TOOL_ID);
	    AveSamplesToolID += ADC_readingToolID;
		++SampleCountToolID;	
		if (SampleCountToolID > 3){
			Reading = AveSamplesToolID / 4;
			SampleCountToolID = 0;
			AveSamplesToolID = 0;
		}
	}
	
	if((Reading >= 0)&&(Reading <= 200))    {type = 1;	OLED_FastText57(1, 20, "Tool: Pen",0);}			//Pen
	if((Reading >= 200)&&(Reading <= 400))  {type = 2;	OLED_FastText57(1, 20, "Tool: Extruder",0);}	//Extruder - Primary material
	if((Reading >= 400)&&(Reading <= 600))  {type = 3;	OLED_FastText57(1, 20, "Tool: Extruder2",0);}	//Extruder2 - Fill
	if((Reading >= 600)&&(Reading <= 800))  {type = 4;	OLED_FastText57(1, 20, "Tool: Not Defined",0);}	//Not Defined
	if((Reading >= 800)&&(Reading <= 1000)) {type = 5;	OLED_FastText57(1, 20, "Tool: Router",0);}		//Router
	if(Reading >= 1020) 					{type = 0;	OLED_FastText57(1, 20, "Tool: None",0);}			//No tool fitted
	return type;
	
}//GetTool_ID

/************************************************************/
int Start_Menu(void)
{
int mode = 0;

	ToolType = GetTool_ID();
	OLED_Start_Menu(); //Draw the menu screen
	mode = GetMenuSelection();
	return mode;
	
}//Start_Menu

/************************************************************/
int GetMenuSelection(void)
{
int mode = 0;
	while(XPlusRight_Btn == NOT_PRESSED){		//Run this until a menu item is selected
		delay_ms(5);

		if (YMinusBot_Btn == PRESSED){  		//Move cursor up & down the menu choices
			delay_ms(5);
			while(YMinusBot_Btn == PRESSED);  	//wait for key up
			mode += 1;
			if (mode >NUNBER_OF_MENU_ITEMS) mode = 0;
		}
		if (YPlusTop_Btn == PRESSED){  			//key down
			delay_ms(5);
			while(YPlusTop_Btn == PRESSED);  	//wait for key up
			mode -= 1;
			if (mode <0) mode = NUNBER_OF_MENU_ITEMS;
		}
		switch(mode){									//Move the Cursor on the screen
			case 0: {OLED_SetCursor(2, 0, 1); break;} 	//Print Object 
			case 1:	{OLED_SetCursor(3, 0, 1); break;}	//Manual
			case 2:	{OLED_SetCursor(4, 0, 1); break;}	//Tool Setup
			case 3:	{OLED_SetCursor(5, 0, 1); break;}	//Home	
		}
	}//while
	
	return mode;
	
}//GetMenuSelection

/************************************************************/
void RapMan_MoveTo(float X_pos, float Y_pos, float Z_pos, char DoZmove)	{
	
	//Move to coordinate
	//With Z move (1)
	//Without Z move (0)

	mT4IntEnable(TRUE);
	GoToRestSpeed = 1; //flag to switch in the speed
	
	Inst_Code_Letter = 0x47; //"G"  //G0 to coordeinate
	iInst_Code = 0;
	Dim_1_Letter = 0x58; //"X"
	fDim_1	= X_pos;
	Dim_2_Letter = 0x59; //"Y"
	fDim_2 = Y_pos;
	
	if (DoZmove)
	{
		Dim_3_Letter = 0x5A; //"Z" Z move
		fDim_3 = Z_pos;
	}
	else
	{
		Dim_3_Letter = 0; 	//"Z" No Z move
		fDim_3 = 0;	
	}
	
	Dim_4_Letter = 0x46; //"F"
	fDim_4 = 0; //note, this value is set to the defaut fast.
	
	G_CodeRun(Inst_Code_Letter, iInst_Code, Dim_1_Letter, fDim_1, Dim_2_Letter,
				fDim_2, Dim_3_Letter, fDim_3, Dim_4_Letter,fDim_4);
	
	Inst_Code_Letter = 0; //"G"
	iInst_Code = 0;
	Dim_1_Letter = 0; //"X"
	fDim_1	= 0;
	Dim_2_Letter = 0; //"Y"
	fDim_2 = 0;
	Dim_3_Letter = 0; //"Z"
	fDim_3 = 0;
	Dim_4_Letter = 0; //"F"
	fDim_4 = 0;
	
	GoToRestSpeed = 0; 
	Delayms(250);
	
}//RapMan_MoveTo

/************************************************************/
void OpenReadSDFile(void)
{	
	if (EOF_Flag == 1)
	{ //It may be after restart
		EOF_Flag = 0; 
		FilePointer = 0;
		ItemsRead = 0;
		PosInFile = 0;
		LineNumber = 0;
	}
 	//Initialize the SD/MMC library
   	while (!FSInit());
	GetFileToOpen();	//select file to open and save as global
	if(!Manual_Select) return;
	//File type returned is *.*
	FileType = Get_file_Type();	//file types defined as
							// 1 = .TXT
							// 2 = .BIN
							// 0 = Invalid type

	pointer = FSfopen ( SaveFileName, "r");
	
   	FilePointer = pointer; //save file pointer as global   
   	  
   	if ((pointer == NULL)|(pointer == 0x0000))
	{
 		do
		{//Handle file error
				OLED_FastText57(2, 0, "File Error    ",0);
 				OLED_FastText57(3, 40,"File Not Found",0);
				OLED_FastText57(4, 0, "<<ESC TO RESUME",0);
				Delayms(250);
				if(!Manual_Select) return;
		}
		while(1);
			
   	}  	//file open error
   	
	OLED_FastText57(2, 90, "Open",0);
	
}//OpenReadSDFile

/************************************************************/
void GetFileToOpen(void)	
{
//Searches the SD card root directory for :
//Flies with File attribute set to archive
SearchRec rec;
unsigned char attributes = ATTR_ARCHIVE;
char name[] = "*.*";
int result = 1;
static int FileNumber = 0;
static int FilesOnCard = 0; 
int i =0;
int SkipFindLast = 0;
char AsciiString[10];

do
{
	//Test SD card for valid file type
	result = FindFirst(name,attributes,&rec); //Test for first file
	if (result == 0)
	{//if success
		//FILE COUNT
	 	FilesOnCard = 1;
		do
		{//Loop to end of file table
			result = FindNext(&rec);//check to see if there is another file
			if (result == 0)FilesOnCard++;
		}
		while(result==0);
		if (!SkipFindLast)//find last file only first time through
		{
			//FIND LAST FILE
			result = FindFirst(name,attributes,&rec); //reset to first
			FileNumber = 1;
			for (i=1;i<FilesOnCard;i++)	//loop to last file
			{
				result = FindNext(&rec);
			}
			FileNumber = FilesOnCard;		//set file number to last
			OLED_FastText57(2, 0,rec.filename,0); //show last file
		}
	}
	if (result!=0)
	{//failure
		FilesOnCard=0;
		FileNumber = 0;
 		
 		do
 		{	//Crash with "File Error"
	 		OLED_FastText57(2, 0,"Find First Error",0);
	 		OLED_FastText57(3, 0,"No files on card",0);
	 		OLED_FastText57(5, 0, "Switch OFF/ON",0);
	 		OLED_FastText57(6, 0, "to Reset",0);
			Delayms(250);
 			if(!Manual_Select) return;
 		}
		while(1);				
	}
		
	do
	{
		if (result == 0)
		{
			if (YMinusBot_Btn == 0)
			{   //FIND NEXT FILE
				while (YMinusBot_Btn==0); //wait for key up
				Delayms(30);

				result = FindNext(&rec);//check to see if there is another file
				if (result==0)
				{//success
					if (FileNumber > FilesOnCard)FileNumber = FilesOnCard;
					else
						FileNumber++;
				}
				else
				{
					result = FindFirst(name,attributes,&rec);
					FileNumber = 1;	
				}
				OLED_ClearLine(2);
				OLED_FastText57(2, 0,rec.filename,0);
			}
			
			if (YPlusTop_Btn == 0)
			{   //FIND PREVIOUS FILE
				while (YPlusTop_Btn==0); //wait for key up
				Delayms(30);
				do
				{	//Loop to end of file table
					result = FindNext(&rec);//check to see if there is another file
				}
				while(result==0);
				result = FindFirst(name,attributes,&rec);
				--FileNumber;
				if (FileNumber == 0)//If less than first file show last file
				{
					FileNumber = FilesOnCard;
					SkipFindLast = 1;
				}
				for (i=1;i<FileNumber;i++)
				{
					result = FindNext(&rec);
				}
				OLED_ClearLine(2);
				OLED_FastText57(2, 0,rec.filename,0);
			}
			
			OLED_FastText57(6, 0,"File",0);  
			sprintf(AsciiString, "%3u", FileNumber);    	//Converts number to text
			OLED_FastText57(6, 25,AsciiString,0);         	//Write the new number
			OLED_FastText57(6, 65,"of",0);
			sprintf(AsciiString, "%3u", FilesOnCard);    	//Converts number to text
			OLED_FastText57(6, 90,AsciiString,0);         	//Write the new number		
		}
		if(!Manual_Select) return;
	}
	while ((XPlusRight_Btn == 1)&(result==0)); 
}
while (XPlusRight_Btn == 1); 

//save the selected filename & filesize to global
strcpy(SaveFileName, rec.filename);
SaveFileSize = rec.filesize;

}//GetFileToOpen

/************************************************************/
int Get_file_Type(void)
{
BYTE type;
BYTE f;
//file name is 12 chars long 0-11 4 back from end is index 8
//this is the first possible site of the "."
//then work back in the filename array to find the "."
 	for(f=8; f; --f)
	{ //Flush line Buffer
		if (SaveFileName[f] == 46)
		{ //look for full stop before file extension
			if ((SaveFileName[f+1] == 'G') &		
				(SaveFileName[f+2] == 'C') &		
				(SaveFileName[f+3] == 'O'))			
			{			
				return type  = GCO_FILE; //Set for TXT file type
			}
			
			if ((SaveFileName[f+1] == 'B') &		
				(SaveFileName[f+2] == 'F') &		
				(SaveFileName[f+3] == 'B'))			
			{	
				return type  = BFB_FILE; //Set for BIN file type
			}
			return type = 0;	//Invalid file type
		}
	}
}//Get_file_Type

/************************************************************/
void ReadData(void)
{
unsigned char AsciiString[9]; 
int CharNum=1;
int n=0;

  	//Read into buffer, Num.of bytes, Num.of Items, File handle
  	//FSfread returns the number of items read from the file 
   	EOF_Flag=0;
  	pointer = FilePointer; 	//set the file pointer
  	LineNumber += 1;		//move on line counter	
  	LineBuffer[0] = 0x3E;   //fill with >
	
	//pointer is the file, pos in file, zero offset from file beginning
	if(FSfseek(pointer,PosInFile,0) !=0)
	{ //set file pos to last char & test
		ErrorCondition(SEEK_POINT_ERR);
		EOF_Flag = 1;
  	}
  	
  	if (EOF_Flag == 0)
	{
  		do
	  	{
  			ItemsRead = FSfread (CharBuffer, 1, 1, pointer);
			LineBuffer[CharNum]=CharBuffer[0];
			CharNum++;
						
			if (CharBuffer[0]== 40)
			{ //Open bracket - GCode comment line
				//loop through and discard the data.
				do
				{
					ItemsRead = FSfread (CharBuffer, 1, 1, pointer);
					if (FSfeof (pointer))break;
				}	
				while (CharBuffer[0] !=10); //read line checking for line feed
			}

    		if (FSfeof (pointer)){// Check if this is the end of the file
				FSfclose (pointer);
				EOF_Flag = 1;
				break;
    		}
		}
		while (CharBuffer[0] !=10); 	//while charbuffer is not line feed char.
    	PosInFile=FSftell(pointer); 	//where we are after reading line
  	}//end if
  	
}//ReadData

/********************************************************/
void GetCodes(void)
{
//Runs through the contents of the LineBuffer and splits out the G-code words.
//Note code looks for a space between words, edit if Gcode
//runs words together
//Code words saved as globals for use in other functions

int CharPosLine = 1; //Caracter position in line
int CharPosWord = 0;

	Word_Count = 1; //to get first word
	do
	{		//Search for first character
		if (LineBuffer[1] == 13)
		{//13Carriage return so exit loop
			break;
		}
		
 		if (Word_Count == 1)
		{
 			if (CharPosWord == 0)
			{ //its the letter code
				Inst_Code_Letter = LineBuffer[CharPosLine];
				CharPosLine++; 
			}
			Inst_Code[CharPosWord] = LineBuffer[CharPosLine];
			CharPosWord++;
			if (LineBuffer[CharPosLine] == 32)
			{
				CharPosLine++; //skip space
				CharPosWord=0; //reset
				Word_Count=2;  //spot space at end of word
			}
		}
		if (Word_Count == 2)
		{
			if (CharPosWord == 0)
			{ //its the letter code
				Dim_1_Letter = LineBuffer[CharPosLine];
				CharPosLine++;
			}
			Dim_1[CharPosWord] = LineBuffer[CharPosLine];
			CharPosWord++;
			if (LineBuffer[CharPosLine] == 32)
			{
				CharPosLine++; //skip space
				CharPosWord=0; //reset
				Word_Count=3;  //spot space at end of word
			}
		}
		if (Word_Count == 3)
		{
			if (CharPosWord == 0)
			{ //its the letter code
				Dim_2_Letter=LineBuffer[CharPosLine];
				CharPosLine++;
			}
			Dim_2[CharPosWord]=LineBuffer[CharPosLine];
			CharPosWord++;
			if (LineBuffer[CharPosLine] == 32)
			{
				CharPosLine++;   //skip space
				CharPosWord = 0; //reset
				Word_Count = 4;  //spot space at end of word
			}
		}
		if (Word_Count == 4)
		{
			if (CharPosWord == 0)
			{ //its the letter code
				Dim_3_Letter = LineBuffer[CharPosLine];
				CharPosLine++;
			}
			Dim_3[CharPosWord] = LineBuffer[CharPosLine];
			CharPosWord++;
			if (LineBuffer[CharPosLine] == 32)
			{
				CharPosLine++; //skip space
				CharPosWord=0; //reset
				Word_Count=5;  //spot space at end of word
			}
		}
		if (Word_Count == 5)
		{
			if (CharPosWord == 0)
			{ //its the letter code
				Dim_4_Letter = LineBuffer[CharPosLine];
				CharPosLine++;
			}
			Dim_4[CharPosWord] = LineBuffer[CharPosLine];
			CharPosWord++;
		}
		
		if (LineBuffer[CharPosLine]== 10) break; //to deal with space at end of line
		CharPosLine++;
	}
	while (LineBuffer[CharPosLine]!= 13); //spot end of line

	//recast the data from ascii to integer or float
	iInst_Code = atoi(Inst_Code);
	fDim_1=atof(Dim_1);
	fDim_2=atof(Dim_2);
	fDim_3=atof(Dim_3);
	fDim_4=atof(Dim_4);
	
}//GetCodes

/********************************************************/
void FlushBuffer(void)
{
//Clears out all old data ready for a new line
int f;
	
	//LineBuffer
	for(f=49; f; --f)
	{ //Flush line Buffer
		LineBuffer[f]=0;
	}
	if (f==0) LineBuffer[0]=0; //to clear remaining character
	
	//Inst_Code
	Inst_Code_Letter=0;
	for(f=7; f; --f)
	{ 
		Inst_Code[f]=0;
	}
	if (f==0) Inst_Code[0]=0; //to clear remaining character
		
	//Dim_1	
	Dim_1_Letter=0;
	for(f=7; f; --f)
	{ 
		Dim_1[f]=0;
	}
	if (f==0) Dim_1[0]=0; //to clear remaining character
	
	//Dim_2
	Dim_2_Letter=0;
	for(f=7; f; --f)
	{ 
		Dim_2[f]=0;
	}
	if (f==0) Dim_2[0]=0; //to clear remaining character

	//Dim_3
	Dim_3_Letter=0;
	for(f=7; f; --f)
	{ 
		Dim_3[f]=0;
	}
	if (f==0) Dim_3[0]=0; //to clear remaining character

	//Dim_4
	Dim_4_Letter=0;
	for(f=7; f; --f)
	{ 
		Dim_4[f]=0;
	}
	if (f==0) Dim_4[0]=0; //to clear remaining character

}//FlushBuffer

/********************************************************/
void ShowBufferFillState(void)	{ //Step buffer fill status
	
float FillStat = 0; 
extern int SBR,SBW;

	if (SBW>SBR)
	{
		FillStat = SBW-SBR;
	}
	else
		FillStat = (SB_SIZE - SBR)+SBW;
	  
	FillStat /= SB_SIZE;
	FillStat *= (int) 127;
	  		
	OLED_ProgressBar(6,FillStat); //Bar on line number , Value to show relative to 127
	
}//ShowBufferFillState

/********************************************************/
void ShowPrintProgress(void)
{ 	
float FillStat = 0; 

	FillStat =	(float)PosInFile / SaveFileSize;
	FillStat *= (int) 127;
	if (FillStat >127) FillStat = 127;
	  		
	OLED_ProgressBar(5,FillStat); //Bar on line number , Value to show relative to 127
	
}//ShowPrintProgress

/********************************************************/



