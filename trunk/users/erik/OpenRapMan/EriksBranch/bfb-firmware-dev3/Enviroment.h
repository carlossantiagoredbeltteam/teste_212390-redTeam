/**********************************************************************
 *************************  Environment.h  ****************************
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

//SPI2 pins for SD card see HardwareProfile
#define OLED_CS             PORTBbits.RB5 //Analog pin
// Description: OLED-SPI Chip Select TRIS bit
#define OLED_CS_TRIS        TRISBbits.TRISB5
#define DC      PORTEbits.RE6	//Digital
#define RES     PORTEbits.RE7	//Digital


//General Defines
#define On					1
#define OFF					0
//#define TRUE				1
//#define FALSE				0

#define CLOCK_SPEED			80000000
#define INPUT_PIN           1
#define OUTPUT_PIN          0

//Stepper Setup
#define EXTRUDER_STEP_PER_REV		3200
#define	PR3_FREQUENCY				5e6		//=80MHz (sysclk) div_8 then div 2 for Pre-Scaler
#define	PR3_CONSTANT			PR3_FREQUENCY*600/EXTRUDER_STEP_PER_REV //Use for 600 RPM * 10 to allow int maths

//Interrupt defines
#define _T3IE					IEC0bits.T3IE
#define _T3IF					IFS0bits.T3IF

//Buttons
#define YPlusTop_Btn			PORTBbits.RB15	//Analog pin
#define YMinusBot_Btn			PORTBbits.RB4  	//Analog pin
#define XPlusRight_Btn			PORTBbits.RB3	//Analog pin
#define XMinusLeft_Btn			PORTBbits.RB2	//Analog pin
#define ZPlus_up_Btn			PORTFbits.RF5	//Digital pin
#define ZMinus_down_Btn			PORTFbits.RF4	//Digital pin
#define Manual_Select			PORTGbits.RG9	//Digital pin

//Axis Limit switches
#define X_HomeSwitch			PORTDbits.RD4	//Digital pin
#define Y_HomeSwitch			PORTCbits.RC13	//Digital pin
#define Z_HomeSwitch			PORTCbits.RC14	//Digital pin

//FETS
#define HEATER				PORTFbits.RF0  //Digital pin
#define FAN					PORTEbits.RE5  //Digital pin
#define AUX					PORTDbits.RD11 //Digital pin

#define FILLAMENT_ERROR		PORTBbits.RB0	//Analog pin

//Analog
#define THERMISTOR_ADC		11		//B11 Thermistor Analog Channel
#define TOOL_ID				12		//B12 TOOL identification resistor

//Display mode defines
#define MANUAL_MOVE		0
#define TEMPERATURE		1
#define RPM				2
#define AUTO_MODE		3

