/**********************************************************************
 ***************************  Extruder.h  *****************************
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
//#include <plib.h>  //required for interrupt handlers
#include "GenericTypeDefs.h"
#include "Enviroment.h" 
//#include "stdlib.h"

#define CW					0
#define CCW					1
#define NO_MOTOR			2

#define EXTRUDER_DISABLE	PORTEbits.RE0	//Digital
#define EXTRUDER_STEP		PORTEbits.RE1	//Digital
#define EXTRUDER_DIR		PORTEbits.RE2	//Digital

extern char ExtruderStatus; //M103,M101 flag extruder off and on
extern int Feed_Rate; 

int Ex_Reverse;

//Functions
int Read_Analog(int Ch);
float Thermistor_LookUp(long raw_temperature);
char RPM_Change; //set if RPM has changed
char Temp_Change; //set if Temperature has changed
char EnableFanControl; //Set if Fan is to be active

void Control_Temperature(void);
void InitExtruder(void);
void delay_us(long delayus);
void delay_ms(long delayms);
void Control_Stepper_Motor(void);
void Manual_Extruder(void);
extern void Extruder_Status(int on_off);
extern void Extruder_Reverse(void);
extern void Extruder_Prime(void);

