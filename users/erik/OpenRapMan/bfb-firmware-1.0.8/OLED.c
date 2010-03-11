/**********************************************************************
 ***************************  OLED.c  *********************************
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
#include <p32xxxx.h>
#include "OLED.h"
#include "Screens.h"
#include "stepper.h"
#include "extruder.h"

//SPI2 pins for OLED 
#define OLED_CS 		PORTBbits.RB5 //Analog pin
#define DC      		PORTEbits.RE6	//Digital
#define RES     		PORTEbits.RE7	//Digital


extern int RPM_Setting;
extern long SetTemperature;
extern float temperature1;
extern int HeaterON;
extern int LineNumber;
extern char SaveFileName[12];

float ExtrusionRate;
/**************************************************/
/*                Forward Declarations            */
/**************************************************/
int  WriteSPI(int i);
void write_command(unsigned char command);
void write_data(unsigned char data);
void Fill_RAM(unsigned char Data); 

/***********************************************************/ 
void OLED_Printing_Screen(void) //Static Lables only
{
extern int ToolType;
	
	OLED_FastText57(0, 0, OLED_Header_VerNo,0);
	OLED_FastText57(1, 28, SaveFileName,0);
	OLED_FastText57(2, 0, "G-Code Line:",0);    	//Display G Code line number       
	OLED_FastText57(3, 0, "Head Speed:",0);    		//Display Feed Rate
	if (ToolType==2)OLED_FastText57(4, 0, "Ext. Rate:",0); 	//Display Extrusion Rate
	             	
}//OLED_Printing_Screen  
    
/***********************************************************/ 
void OLED_UpdatePrintScreen(void) //Info updated every G_Code line
{
char AsciiString[10];
float data1;
extern int S_F_Code;
extern int ToolType;

	sprintf(AsciiString, "%1u", LineNumber);	//Converts number to text
	OLED_FastText57(2, 90, AsciiString,0);     	//Write the new number
	
	if (S_F_Code > 0 )
	{
		data1 = (float)S_F_Code/60;
		sprintf(AsciiString, "%5.1fmm/s", data1);	//Converts number to text
		OLED_FastText57(3, 75, AsciiString,0);     	//Write the new number
		ExtrusionRate = (float)RPM_Setting*0.056;	//factor is 0.0563814
		sprintf(AsciiString, "%5.1fmm/s", ExtrusionRate);	//Converts number to text
		OLED_FastText57(4, 75, AsciiString,0);     	//Write the new number
	}
	else
		OLED_FastText57(3, 75, "Not Set",0);
	
	
	ShowBufferFillState();						//ln6 Show how full the look ahead buffer is
	ShowPrintProgress();						//ln5 Progress through the file	
	
	if (ToolType==2)//Extruder
	{
		OLED_UpdateThermistorReading();
		if (Temp_Change)OLED_UpdateSetTemperature();  //Update only if changed
		if (RPM_Change)OLED_UpdateSetRPM();			  //Update only if changed
	}
	
}//OLED_UpdatePrintScreen

/***********************************************************/ 
void OLED_Extruder_Screen(void)
{
	OLED_FastText57(0, 0, OLED_Header_VerNo,0);
	OLED_FastText57(1, 0, "Extruder Control",0);
	
	if(HEATER)OLED_FastText57(5, 0, "Heater On ",0);
	else OLED_FastText57(5, 0, "Heater Off",0);
	
	if (temperature1 < 100)
	{
		OLED_FastText57(3, 0, " <100C Motor OFF",0);
	}
	else
		OLED_ClearLine(3);
	
	OLED_UpdateSetTemperature();		
	OLED_UpdateThermistorReading();
	OLED_UpdateSetRPM();
	
}//OLED_Extruder_Screen

/***********************************************************/ 
void OLED_UpdateThermistorReading(void)
{
char AsciiString[10];
int data1;

	if (temperature1 == 999||temperature1 == -1){
		OLED_ClearLine(7);
		if (temperature1 == 999)OLED_FastText57(7, 10,"TEMPERATURE ERROR",0);
		if (temperature1 == -1)OLED_FastText57(7, 10, "THERMISTOR ERROR",0);
		return;
	}	
	
	data1=(int)temperature1;						//Display actual temperature
	sprintf(AsciiString, "%3uC", (int)data1);    	//Converts number to text
	OLED_FastText57(7, 45, AsciiString,0);         	//Write the new number
	if(HEATER)OLED_FastText57(7, 35, "*",0); 		//Heater indication
	else OLED_FastText57(7, 35, " ",0);
	
}//	OLED_UpdateThermistorReading

/***********************************************************/
void OLED_UpdateSetRPM(void)
{
char AsciiString[10];	
int data1;
extern char RPM_Change;  //set if RPM has changed
	
	data1=RPM_Setting/10;							//Display RPM Setting
	sprintf(AsciiString, "%3uRPM", (int)data1);    	//Converts number to text 
	OLED_FastText57(7, 85, AsciiString,0);          //Write the new number
	
	OLED_FastText57(4, 0, "Ext. Rate:",0);    	//Display Extrusion Rate
	ExtrusionRate= (float)RPM_Setting*0.04643;
	sprintf(AsciiString, "%5.1fmm/s", ExtrusionRate);	//Converts number to text
	OLED_FastText57(4, 75, AsciiString,0);     	//Write the new number
	
	RPM_Change = 0;
	
}//OLED_UpdateSetRPM
	
/***********************************************************/
void OLED_UpdateSetTemperature(void)
{
char AsciiString[10];
extern char Temp_Change; //set if Temperature has changed	

	if (SetTemperature <0)SetTemperature = 0;
	sprintf(AsciiString, "%3uC", (int)SetTemperature); //Converts number to text
	OLED_FastText57(7, 0, AsciiString,0);           //Write the new number
	Temp_Change = 0;
	
}//OLED_UpdateSetTemperature

/***********************************************************/	
void OLED_Fill_RAM(unsigned char Data)
{
unsigned char i,j;

	for(i=0;i<8;i++){
        write_command(0xB0+i);
        write_command(0x00);
        write_command(0x10);             
		for(j=0;j<128;j++)write_data(Data);
	}
}//OLED_Fill_RAM
     
/***********************************************************/ 
void OLED_ProgressBar(unsigned char Line, int Value)
{
unsigned char j;

   write_command(0xB0+Line);
   write_command(0x00);
   write_command(0x10);
             
	for(j=0;j<Value;j++)
	{
		write_data(0x18);
	}
	for(j=Value;j<128;j++)
	{
		write_data(0x00);
	}
}//OLEDProgressBar

/***********************************************************/  
void OLED_ClearLine(unsigned char Line)	{
	
unsigned char j;

   write_command(0xB0+Line);
   write_command(0x00);
   write_command(0x10);
             
	for(j=0;j<128;j++)
	{
		write_data(0x00);
	}	
}//OLEDClearLine

/***********************************************************/  
void OLED_BitMapFill_RAM(unsigned char screen)
{
unsigned char i,j;
const unsigned char *screen_ptr;
int offset;

switch(screen)
	{
		case DSP_RAPMAN_LOGO:
		{
			screen_ptr = RAPMAN_LOGO;
			break;
		}
		case DSP_BfB_LOGO:
		{
			screen_ptr = BfB_LOGO;
			break;
		}
		case DSP_EXTRUDER_SCREEN:
		{
			screen_ptr = EXTRUDER_SCREEN;
			break;
		}
	}
 
 for(i=0;i<8;i++)   //loop through 8 pages
 {
  offset = i*128;
  write_command(0xB0+i); //set start of page
  write_command(0x00);
  write_command(0x10);
  
      	for(j=0;j<128;j++) //loop through each col on page
  	{
   		write_data(screen_ptr[offset+j]);
  	}
 }
}//BitMapFill_RAM

/***********************************************************/  
void OLED_FastText57(int txtpage, int txtcol, unsigned char* textptr, unsigned char colour)
{

unsigned char  add, lAddr, hAddr; 
int i, j, k;                       				// Loop counters
unsigned char pixelData[5];                  	// Stores character data
 	
  k = 0;
  add = txtcol;
  lAddr = 0x0F & add;    // Low address
  hAddr = 0x10 | (add >> 4);  // High address
  
  write_command(0xB0 + txtpage); //set start page
  write_command(lAddr);
  write_command(hAddr);
  
   for(i=0; textptr[i] != '\0'; ++i) // Loop through the passed string
   {
      if(textptr[i] < 'S')       // Checks if the letter is in the first text array
         memcpy(pixelData, TEXT[textptr[i]-' '], 5);
      else 
      	if(textptr[i] <= '~')     // Check if the letter is in the second array
		{
      		if (textptr[i]>91)//if ascii char is > [ then realign
       		{
      			memcpy(pixelData, TEXT2[textptr[i]- 84], 5); //1 more than S to realign the lower case letters
       		}
       		else
         	memcpy(pixelData, TEXT2[textptr[i]-'S'], 5);
      	}  
      	else
        memcpy(pixelData, TEXT[0], 5);   // Default to space
 	
      for(j=0; j<5; ++j)         // Loop through character byte data
      {    
	      if (k <128){
		    if (colour == 0)
		    {   
          		write_data(pixelData[j]);
      		} 
      		else
      		{
	      		write_data(~pixelData[j]);	
	      	}   	
          	++k;
       	  }
       	  else{ //text wrap if required
       	  	write_command(0xB0 + txtpage+1);
       	  	write_data(pixelData[j]); 
       	  }	  
      }
      write_data(0x00);
      ++k;
	}
}//OLED_FastText

/***********************************************************/  
void OLED_Start_Menu(void)
{
	OLED_Fill_RAM(BLANK_SCREEN); //clear screen
	OLED_FastText57(0, 10, OLED_Header_VerNo,0);
	OLED_FastText57(1, 20, OLED_Menu_Title0,0);	
	OLED_FastText57(2, 20, OLED_Menu_0,0);	
	OLED_FastText57(3, 20, OLED_Menu_1,0);	
	OLED_FastText57(4, 20, OLED_Menu_2,0);	
	OLED_FastText57(5, 20, OLED_Menu_3,0);
			
}//OLED_Start_Menu

/***********************************************************/  
void OLED_Manual_Screen(void)
{
	OLED_Fill_RAM(BLANK_SCREEN); //clear screen
	OLED_FastText57(0, 10, OLED_Header_VerNo,0);
	OLED_FastText57(1, 0, "MANUAL", 0);
	OLED_FastText57(4, 0, "X_Step:",0);      
	OLED_FastText57(5, 0, "Y_Step:",0);    
	OLED_FastText57(6, 0, "Z_Step:",0); 
	
}//OLED_Manual_Screen

/***********************************************************/  
void OLED_Auto_Screen(void)
{
	OLED_Fill_RAM(BLANK_SCREEN); //clear screen
	OLED_FastText57(0, 10, OLED_Header_VerNo,0);
	OLED_FastText57(1, 20,OLED_Auto_Load,0);
	
}//OLED_Auto_Screen
	
/***********************************************************/ 
 void OLED_ToolSetup_Screen(void)
{
	OLED_ClearLine(1);
	OLED_FastText57(1, 20,OLED_ToolSet,0);
	
}//OLED_ToolSetup_Screen
	
/***********************************************************/  
void OLED_Home_Screen(void)
{
	OLED_Fill_RAM(BLANK_SCREEN); //clear screen	
	OLED_FastText57(1, 0,OLED_Home,0);
	
}//OLED_Home_Screen

/***********************************************************/  
void OLED_RapManMove_Screen(float X_pos, float Y_pos, float Z_pos, char DoZmove)
{
char AsciiString[10];

	OLED_Fill_RAM(BLANK_SCREEN); //clear screen	
	OLED_FastText57(1, 0, "MOVE TO:",0);
	sprintf(AsciiString, "X=%6.2f",X_pos);		// Converts number to text
	OLED_FastText57(3, 0, AsciiString,0);    	// Write the new number	
	sprintf(AsciiString, "Y=%6.2f",Y_pos);	    // Converts number to text
	OLED_FastText57(4, 0, AsciiString,0);    	// Write the new number	
	if (DoZmove)
	{  
		sprintf(AsciiString, "Z=%6.2f",Z_pos);	// Converts number to text
		OLED_FastText57(5, 0, AsciiString,0);   // Write the new number
	}
	else OLED_FastText57(5, 0, "NO Z MOVE",0);
	
}//OLED_Home_Screen

/***********************************************************/  
void OLED_FileEnd_Screen(void)
{
	OLED_Fill_RAM(BLANK_SCREEN);
	OLED_FastText57(0, 0, "Prog.End",0);
	OLED_FastText57(2, 0, "Return to Menu",0);
	OLED_FastText57(4, 0, "<<< Press Esc.",0);
		
}//OLED_FileEnd_Screen

/***********************************************************/  
void OLED_SetCursor(int txtpage, int txtcol, unsigned char colour)
{
	//Cursor
	switch (txtpage)
	{
		case 0: //txtpage 0 reserved for headings
		{
		//	OLED_FastText57(0, txtcol, OLED_Cursor, colour);	
		//	OLED_FastText57(1, txtcol, "  ",0);
		//	OLED_FastText57(2, txtcol, "  ",0);
		//	OLED_FastText57(3, txtcol, "  ",0);
		//	OLED_FastText57(4, txtcol, "  ",0);
		//	OLED_FastText57(5, txtcol, "  ",0);
		//	OLED_FastText57(6, txtcol, "  ",0);
		//	OLED_FastText57(7, txtcol, "  ",0);
			break;
		}
		case 1:
		{
		//	OLED_FastText57(0, txtcol, "  ",0);	
			OLED_FastText57(1, txtcol, OLED_Cursor, colour);
			OLED_FastText57(2, txtcol, "  ",0);
			OLED_FastText57(3, txtcol, "  ",0);
			OLED_FastText57(4, txtcol, "  ",0);
			OLED_FastText57(5, txtcol, "  ",0);
			OLED_FastText57(6, txtcol, "  ",0);
			OLED_FastText57(7, txtcol, "  ",0);
			break;
		}
		case 2:
		{
		//	OLED_FastText57(0, txtcol, "  ",0);	
			OLED_FastText57(1, txtcol, "  ",0);
			OLED_FastText57(2, txtcol, OLED_Cursor, colour);
			OLED_FastText57(3, txtcol, "  ",0);
			OLED_FastText57(4, txtcol, "  ",0);
			OLED_FastText57(5, txtcol, "  ",0);
			OLED_FastText57(6, txtcol, "  ",0);
			OLED_FastText57(7, txtcol, "  ",0);
			break;
		}
		case 3:
		{
		//	OLED_FastText57(0, txtcol, "  ",0);	
			OLED_FastText57(1, txtcol, "  ",0);
			OLED_FastText57(2, txtcol, "  ",0);
			OLED_FastText57(3, txtcol, OLED_Cursor, colour);
			OLED_FastText57(4, txtcol, "  ",0);
			OLED_FastText57(5, txtcol, "  ",0);
			OLED_FastText57(6, txtcol, "  ",0);
			OLED_FastText57(7, txtcol, "  ",0);
			break;
		}
		case 4:
		{
		//	OLED_FastText57(0, txtcol, "  ",0);	
			OLED_FastText57(1, txtcol, "  ",0);
			OLED_FastText57(2, txtcol, "  ",0);
			OLED_FastText57(3, txtcol, "  ",0);
			OLED_FastText57(4, txtcol, OLED_Cursor, colour);
			OLED_FastText57(5, txtcol, "  ",0);
			OLED_FastText57(6, txtcol, "  ",0);
			OLED_FastText57(7, txtcol, "  ",0);
			break;
		}
		case 5:
		{
		//	OLED_FastText57(0, txtcol, "  ",0);	
			OLED_FastText57(1, txtcol, "  ",0);
			OLED_FastText57(2, txtcol, "  ",0);
			OLED_FastText57(3, txtcol, "  ",0);
			OLED_FastText57(4, txtcol, "  ",0);
			OLED_FastText57(5, txtcol, OLED_Cursor, colour);
			OLED_FastText57(6, txtcol, "  ",0);
			OLED_FastText57(7, txtcol, "  ",0);
			break;
		}
		case 6:
		{
		//	OLED_FastText57(0, txtcol, "  ",0);	
			OLED_FastText57(1, txtcol, "  ",0);
			OLED_FastText57(2, txtcol, "  ",0);
			OLED_FastText57(3, txtcol, "  ",0);
			OLED_FastText57(4, txtcol, "  ",0);
			OLED_FastText57(5, txtcol, "  ",0);
			OLED_FastText57(6, txtcol, OLED_Cursor, colour);
			OLED_FastText57(7, txtcol, "  ",0);
			break;
		}
		case 7:
		{
		//	OLED_FastText57(0, txtcol, "  ",0);	
			OLED_FastText57(1, txtcol, "  ",0);
			OLED_FastText57(2, txtcol, "  ",0);
			OLED_FastText57(3, txtcol, "  ",0);
			OLED_FastText57(4, txtcol, "  ",0);
			OLED_FastText57(5, txtcol, "  ",0);
			OLED_FastText57(6, txtcol, "  ",0);
			OLED_FastText57(7, txtcol, OLED_Cursor, colour);
			break;
		}
	}
	
}//OLED_SetCursor

/***********************************************************/
//SCREEN DRIVER
//Col address 0 to 127 is made up of a high and low nibble screen address
//col 1 is lower nibble 1, higher nibble 0
//col 127 is lower nibble = f, higher nibble 7
/***********************************************************/
int WriteSPI(int i)	{

     SPI2BUF = i;
     while( !SPI2STATbits.SPIRBF);
     return SPI2BUF;
     
}//WriteSPI

/***********************************************************/
void write_command(unsigned char command){		
     
     DC = 0;		//When Low send Display command
     OLED_CS = 0;  //OLED chip select
     WriteSPI(command);
     OLED_CS = 1;
     DC =1;	 
      
}//write_command

/***********************************************************/
void write_data(unsigned char data)	{

     DC =1;	
     OLED_CS = 0;
     WriteSPI(data);
     OLED_CS = 1;
	 DC =1;	
	 
}//write_data

/***********************************************************/             
void Fill_RAM(unsigned char Data)
{
unsigned char i,j;
	
	for(i=0;i<8;i++)
	{
        write_command(0xB0+i);
        write_command(0x00);
        write_command(0x10);
             
		for(j=0;j<128;j++)
		{
			write_data(Data);
		}
	} 
}//Fill_RAM

/***********************************************************/
int OLED_Init(void)
{
unsigned int i = 0;

	SPI2CON = 0x8120; //Enable & configure SPI port

    DC = 0;					//When Low D7-D0 is Display command
    OLED_CS = 0;				//Communication with chip only when Low
    RES = 0;					//Reset when pin is low
    for(i=0;i<2000;i++);		//10ms delay
    RES = 1;					//Reset complete		
	for(i=0;i<2000;i++);		//10ms delay
	OLED_CS = 1;

//LCD commands
//panel_128x64
	write_command(0xd5);		//SetDisplayClock(0x10)
	write_command(0x10);
	
	write_command(0xd3);		//SetDisplayOffset(0)
	write_command(0);
	
	write_command(0xa8);		//SetMultiplex(63)
	write_command(63);
	
	write_command(0xd8);		//SetAreaColor(0)
	write_command(0);
	
	write_command(0x40);		//SetStartLine(0)
	
	write_command(0xa0);		//SetSegmentReMap(0)
	
	write_command(0xc8);		//SetCOMScan(8)
	
	write_command(0xda);		//SetCOMHWConfig(0x12)
	write_command(0x12);
	
	write_command(0x81);		//SetContrast(0xff)
	write_command(0xf0);
	
	write_command(0xa4);		//SetEntireDisplay(0)
	
	write_command(0xd9);		//Setprecharge(0xf2)
	write_command(0xf2);
		
	write_command(0xa6);		//SetNormal_Inverse_Display(0xa6 or 0xa7)
	
	write_command(0x26);     	//horizontal scroll setup           
	write_command(0x01);
	write_command(0x00);
	write_command(0x00);
	write_command(0x01);
	
	Fill_RAM(0x00);   			//Clear screen
	for(i=0;i<2000;i++);
	write_command(0xAF);		//display on 
	
}//InitOLED

/***********************************************************/ 
void OLED_Start_Msg(void)
{
	// Start Message  
    OLED_Fill_RAM(BLANK_SCREEN); //Clear screen
    OLED_BitMapFill_RAM(DSP_BfB_LOGO);
    Delayms(200);
    OLED_Fill_RAM(BLANK_SCREEN); //Clear screen
    OLED_BitMapFill_RAM(DSP_RAPMAN_LOGO);
    Delayms(200);
    	
}//OLED_Start_Msg

/***********************************************************/ 


