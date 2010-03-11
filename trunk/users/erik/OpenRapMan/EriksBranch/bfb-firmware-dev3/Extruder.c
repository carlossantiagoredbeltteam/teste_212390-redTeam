/**********************************************************************
 ***************************  Extruder.c  *****************************
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
 * Erik de Bruijn					11/03/2010  Less limiting of the mininum extrusion rate!
 ***********************************************************************/
#include "Extruder.h"
#include "Stepper.h"
#include "Enviroment.h"
#include "G_Code.h"
#include "OLED.h"
#include <plib.h>  //required for interrupt handlers
#include "stdlib.h"

#define INPUT	1
#define OUTPUT	0
#define	PRESSED 	0
#define NOT_PRESSED 1

//default values for extruder reverse and prime steps
#define STEPS_TO_REVERSE  	1000
#define STEPS_TO_PRIME		1000
#define Z_HOP_STEPS			500

//Variables
int Thermistor_Failure_Counter = 0;
int ADC_reading = 0;

volatile int StepReady;
//long Reverse_ms = 50;
//long Prime_ms = 25;
int SampleCountThermistor = 0;
long AveSamplesThermistor = 0;
long LowValue,HighValue,Range;
float Fraction;
long DataVal,TempVal;
long raw_temperature;
float temperature1;
//char mode;
int HeaterON = 0;		//Heater Flag
int temperature_OK = FALSE;	//Motor flag
short update_temp = FALSE;
long SetTemperature = 0; //Value set from control board
int RPM_Setting = 400;

int PR3_Setting = 65525, Step_Cycle = 0, Direction = CCW;
int RPM_Setting_Old = 0;
int New_Data = FALSE;
int UART_Counter = 0;
char Message[20];

int Reverse_Steps;
int Prime_Steps;
int Reverse_Step_Count;
int Prime_Step_Count;

int Temperature_Cycle = 0;
extern int Operation_Mode;
extern char FastMoveMotorEnable;//Flag to switch motor on/off during fast move

//Thermistor 204GT  200K Ohms at ambient 600 ohm ref resister, 5V
const long Therm_Table[31] = {
1024,1023,1022,1020,1018,1015,1010,1004,995,984, 	//0-90
969,950,927,899,865,827,784,737,687,635,  		 	//100-190
583,531,480,433,388,346,309,275,244,217,		 	//200-290
193};												//300



/***********************************************************/
//                     Functions
/***********************************************************/
//low priority interrupt for running the temperature control loop
void __ISR( _TIMER_2_VECTOR,ipl4) T2InterruptHandler(void)
{
	switch(Temperature_Cycle)
	{
		case 0: //maintains the ave. raw temp reading
			ADC_reading = Read_Analog(THERMISTOR_ADC);

			if (ADC_reading > 0) 
			{
     			AveSamplesThermistor += ADC_reading;
				++SampleCountThermistor;	
				if (SampleCountThermistor > 9)
				{
					raw_temperature = AveSamplesThermistor/10;
					SampleCountThermistor = 0;
					AveSamplesThermistor = 0;
					Temperature_Cycle = 1;
					break;
				}
			}
			Temperature_Cycle = 0;
			break;			
		case 1: //returns the temperature in DegC from raw_temperature
			temperature1 = Thermistor_LookUp(raw_temperature);
			Temperature_Cycle = 2;
			break;	
		case 2: //changes settings
			Control_Temperature();
			Temperature_Cycle = 0;
			if(HEATER)Thermistor_Failure_Counter++;
			else Thermistor_Failure_Counter = 0;
			
			if (!RPM_Change)
			{
				if (!XPlusRight_Btn){RPM_Change  = 1;RPM_Setting += 1;}//ERIK: was 10
				if (!XMinusLeft_Btn){RPM_Change  = 1;RPM_Setting -=1;}//ERIK: was 10
			}
			if (!Temp_Change)
			{
				if (!YPlusTop_Btn)  {Temp_Change = 1;SetTemperature++;}
				if (!YMinusBot_Btn) {Temp_Change = 1;SetTemperature--;}
			}
			break;	
	}
	TMR2 = 0;				//Reset clock
	mT2ClearIntFlag();
	
}//ISR Timer2

/***********************************************************/
//Stepper Interrupt Control 
void __ISR( _TIMER_3_VECTOR,ipl7) T3InterruptHandler(void)
{
	switch(Step_Cycle){
 		case 0:
 			if (!StepReady)
 			{
 				if (Reverse_Step_Count>0)--Reverse_Step_Count; //decrement step count
 				if (Prime_Step_Count>0)--Prime_Step_Count;
 				StepReady = 1; 	 //Step taken from count	
 			}
 			EXTRUDER_DIR = Direction;
 			PR3 = 5;
 			Step_Cycle = 1;
 			
 			break;			
		case 1:
			if (StepReady)
			{
				EXTRUDER_STEP = On; //Step pin high
			}
			PR3 = 10;
			Step_Cycle = 2;
			break;	
		case 2:
			if (StepReady)
			{
				EXTRUDER_STEP = OFF; //step pin low
			}
			PR3 = PR3_Setting;
			Step_Cycle = 0;
			StepReady = 0; //Step complete
			break;	
	}
	TMR3 = 0;
	mT3ClearIntFlag();
	
}//ISR Timer3

/***********************************************************/
void Control_Stepper_Motor(void)	
{
	RPM_Setting_Old = RPM_Setting;
		
	if (RPM_Setting < 2) RPM_Setting = 2; //Limit minimum to 1.5 RPM // ERIK: limit 0.2
	if (RPM_Setting > 2000) RPM_Setting = 2000; //Limit maximum to 200 RPM
	PR3_Setting=(PR3_CONSTANT/RPM_Setting)-25;
		
	if(temperature_OK){
		EXTRUDER_DISABLE = FALSE;	//run motor
		if(RPM_Setting <=15)EXTRUDER_DISABLE = TRUE;	//If slower than 1.5RPM turn motor off
	}
	else EXTRUDER_DISABLE = TRUE; 
	
}//Control_Stepper_Motor

/*************************************************/
void Control_Temperature(void)
{  
//Change_M104 flag to alter the heating method
//Change_M104 == 1 temperature is changed by G_Code the new temp 
//must be achieved before it continues
//Change_M104 == 0 is used during printing
extern char Change_M104;
extern char PauseFlag;
	
	if(SetTemperature<0)SetTemperature = 0;
	if(SetTemperature>300)SetTemperature = 300;	
	
	if (PauseFlag == 0)
	{
		if (temperature1 < SetTemperature)HEATER = On;
		else HEATER = OFF;
	}
	else HEATER = OFF;
	
	if (Change_M104 == 0) //Temperature control during print
	{
		if ((temperature1 < SetTemperature-10)||
			(temperature1 > SetTemperature+10)||
			(SetTemperature<100))
		{
			temperature_OK = FALSE; 			//To control motor
			EXTRUDER_DISABLE = TRUE;
		}	
		else temperature_OK = TRUE;
	}
	
	if (Change_M104 == 1) //Temperature change called for by G_Code
	{
		if ((temperature1 < SetTemperature-1)||
			(temperature1 > SetTemperature+1)||
			(SetTemperature<100)||
			(temperature1 == 0))
		{
			temperature_OK = FALSE; 			//To control motor
			EXTRUDER_DISABLE = TRUE;
		}	
		else temperature_OK = TRUE;
	
	}
	
	if (EnableFanControl == TRUE)
	{
		if (temperature1 < SetTemperature-5)	FAN = OFF;	//Fan control
		else FAN = On;
	}
	
	if (temperature1 == -1)Extruder_Status(OFF);//Error condition switch all off	
	if (temperature1 == 999)Extruder_Status(OFF);//Error condition switch all off

}//Control_Temperature

/*************************************************/
float Thermistor_LookUp(long raw_temperature)	
{
float temperature;
int k;

	if (raw_temperature < 28){temperature = 999;return temperature;}	//Value over temp
	if (raw_temperature >= 1023 && Thermistor_Failure_Counter > 50)
			{temperature = -1;return temperature;}//Thermistor failure after 5 bad ave.readings

		for(k=0; k<31; ++k){				// Loop through the Thermistor array
		TempVal = Therm_Table[k];
      	if (raw_temperature > TempVal){
			LowValue = TempVal;
			HighValue = Therm_Table[k-1];
			Range = HighValue - LowValue;	//contains the range
			DataVal = raw_temperature - LowValue;
			Fraction = (float)DataVal/Range;
			Fraction *= 10; //as the range is 10Degrees
			temperature = (float)(k*10) - Fraction;
 			return temperature;
		}
	}
}//Thermistor_LookUp

/*************************************************/
int Read_Analog(int Ch)
{
int i;
	AD1CHSbits.CH0SA = Ch;	    //select analog +ve input
	AD1CON1bits.SAMP = 1;		//start sampling
	for(i=0;i<200;i++);			//delay
	AD1CON1bits.SAMP = 0;
	while (!AD1CON1bits.DONE);	//wait for conversion to complete
 	return ADC1BUF0;			//read the conversion result
 	
}//Read_Analog

/*************************************************/
void Extruder_Status(int on_off)
{
	switch(on_off == On){
	case On:
		EXTRUDER_DISABLE = !TRUE;
		mT2IntEnable(TRUE);			//Enable T2 interrputs Heater
		mT3IntEnable(TRUE);			//Enable T3 interrputs Stepper
		//Delayms(1000);				//Time to get first reading from Thermistor
		Thermistor_Failure_Counter = 0;
		break;
	case OFF:
		HEATER	= OFF;
		EXTRUDER_DISABLE = TRUE;
		mT2IntEnable(!TRUE);		//Disable T2 interrputs Heater
		mT3IntEnable(!TRUE);		//Disable T3 interrputs Stepper
		break;
	case NO_MOTOR:
		EXTRUDER_DISABLE = TRUE;
		mT3IntEnable(!TRUE);
		break;
	}
}//Extruder_Status	
	
/*************************************************/
void InitExtruder(void)
{
	//Initializations
 	TRISEbits.TRISE1     = OUTPUT;	//Step
 	TRISEbits.TRISE2     = OUTPUT;	//Dir
 	TRISEbits.TRISE0     = OUTPUT;	//Enable	
		
	mOSCSetPBDIV(OSC_PB_DIV_8);
	
	//Timer 2 is used to run the temperature control
	//PB clk = 8MHz Post scaler = 2 to 1 tick every 25uS	
	T2CON = 0x0;			//256 PS setting register
	T2CONSET = 0x0070;		//Set PS to 2
	TMR2 = 0;				//Reset clock
	PR2 = 500;				//Initialise PR2 value (when T2 matches PR2 it interrupts)
	mT2SetIntPriority(4);	//Set T2 interrupt to LOW priority
	mT2ClearIntFlag();		//Clear interrupt flag
	T2CONSET = 0x8000;		//Turn on T2
	mT2IntEnable(!TRUE);	//Enable T2 interrputs
	
	//Timer 3 is used to time the stepper motor steps
	//PB clk = 8MHz Post scaler = 2 to 1 tick every 25uS	
	T3CON = 0x0;			//Clear timer setting register
	T3CONSET = 0x0010;		//Set PS to 2
	TMR3 = 0;				//Reset clock
	PR3 = 5000;//500;		//Initialise PR3 value (when T3 matches PR3 it interrupts)
	mT3SetIntPriority(7);	//Set T3 interrupt to top priority
	INTEnableSystemMultiVectoredInt();//Set T3 to vectored i.e. Fast
	mT3ClearIntFlag();		//Clear interrupt flag
	T3CONSET = 0x8000;		//Turn on T3
	
	mT3IntEnable(!TRUE);		//Enable T3 interrputs
	EXTRUDER_DISABLE = TRUE;	//Disable Stepper
	EnableFanControl = FALSE;	//Default - Disable fan
	FastMoveMotorEnable = FALSE; //Default - set extruder motor off
	
}//InitExtruder

/***********************************************************/
void Manual_Extruder( void )    
{
int i=0;
	OLED_Fill_RAM(BLANK_SCREEN);
	while(!XPlusRight_Btn); 				//Wait for menu selection key to be released
	RPM_Setting = 0;
	SetTemperature = 0;
	OLED_Extruder_Screen();
	Extruder_Status(On);
	while (Manual_Select == NOT_PRESSED){
		Control_Stepper_Motor();
		i++;
		if(i>1000)
		{
			OLED_Extruder_Screen();
			if (!XPlusRight_Btn)RPM_Setting +=1;//Erik: was 10
			if (!XMinusLeft_Btn)RPM_Setting -=1;//Erik: was 10
			if (!YPlusTop_Btn)	SetTemperature++;
			if (!YMinusBot_Btn)	SetTemperature--;
			i=0;
		}
	}
	Extruder_Status(OFF);
			
}//Manual_Extruder

/***********************************************************/
// Delay uS 
//Max delay 21,000,000,000 i.e. 2,100 seconds = 35 Minutes
//Calling has overhead of 260nS i.e. delay = 0 takes 260nS
//delay = 1 takes 1.26uS
void delay_us(long delayus)
{
int i_util;

   	for(i_util=0;i_util<delayus*4;i_util++)
	{
		asm("nop");
	 	asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
	}
}//delay_us

/***********************************************************/
// Delay mS
//See delay_us for limits
void delay_ms(long delayms)
{
	delay_us(delayms*1000);
	
}//delay_ms

/***********************************************************/
void Extruder_Reverse(void)
{
//StepData Bits 7 XDir, 6 X, 5 YDir, 4 Y, 3 ZDir, 2 Z, 1 & 0 Not used
//unsigned char StepData = 0; //used for Z hop
//unsigned int Z_Hop;
	
	if((Ex_Reverse)&&(EXTRUDER_DISABLE == !TRUE)) 
	{
		/*
		if (Do_Z_Hop == TRUE) //Gcode switch TODO
		{
			//Z Hop up
			StepData |= 0x08; //Set Z Direction set bit 3 on
			StepData |= 0x04; //z set step bit 2 on
			Feed_Rate  = 750;
			Z_Hop = Z_HOP_STEPS;
			do
			{
				AddToStepBuffer(StepData,0,0); //add step data to circular buffer
				--Z_Hop;
			}
			while (Z_Hop>0);
			Done_Hop_UP = TRUE; Not defined yet
		}
		*/
		
		Direction = CW;
		if (Reverse_Step_Count == 0) //if not set in gCode then use default
		{
			if (Reverse_Steps == 0)	Reverse_Step_Count = STEPS_TO_REVERSE; //Set number of steps to reverse
			else Reverse_Step_Count = Reverse_Steps;	
		}
		
		PR3_Setting=(PR3_CONSTANT/1000)-25; //set up step interrupt
		while (Reverse_Step_Count >0);//wait for number of steps to complete
		Direction = CCW; //reset normal direction
	}
}

/***********************************************************/
void Extruder_Prime(void)
{
//StepData Bits 7 XDir, 6 X, 5 YDir, 4 Y, 3 ZDir, 2 Z, 1 & 0 Not used
//unsigned char StepData = 0; //used for Z hop
//unsigned int Z_Hop;

	if((Ex_Reverse)&&(EXTRUDER_DISABLE == !TRUE))
	{
		/*
		if ((Do_Z_Hop == TRUE)&&(Done_Hop_UP == TRUE)) //GCode switch and there must have been a hop up
		{												//before we hop down.
			//Z Hop down
			StepData = StepData & ~0x08; //Set Z Direction set bit 3 off
			StepData |= 0x04; //z set step bit 2 on
			Feed_Rate  = 750;
			Z_Hop = Z_HOP_STEPS;
			do
			{
				AddToStepBuffer(StepData,0,0); //add step data to circular buffer
				--Z_Hop;
			}
			while (Z_Hop>0);
			Done_Hop_UP = FALSE; Not defined yet
		}
		*/
		Direction = CCW;
		if (Prime_Step_Count == 0)//if not set use default
		{
			if (Prime_Steps == 0) Prime_Step_Count = STEPS_TO_PRIME; //Set number of steps to reverse
			else Prime_Step_Count = Prime_Steps;
		}
		
			PR3_Setting=(PR3_CONSTANT/1000)-25;//was1500
			while (Prime_Step_Count >0);//wait for number of steps to complete
			PR3_Setting=(PR3_CONSTANT/RPM_Setting)-25;
	}
}
/***********************************************************/

