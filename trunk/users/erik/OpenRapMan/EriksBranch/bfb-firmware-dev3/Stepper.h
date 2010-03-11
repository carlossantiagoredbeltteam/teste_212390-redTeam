/**********************************************************************
 ***************************  Stepper.h  ******************************
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
 * Erik de Bruijn				 	11/03/2010	Local changes for Eriks Darwin cartesian bot
 ***********************************************************************/

#define SHOW_POSITIONS	1
#define HIDE_POSITIONS	0

//General Defines

extern int GX_On;
extern int GY_On;
extern int GZ_On;
extern int GI_On;
extern int GJ_On;

extern float GX;
extern float GY;
extern float GZ;
extern float GI_Val;
extern float GJ_Val;
extern int F_Code;
extern int M_Code;

extern char ExtruderStatus; 
int Feed_Rate; 

#define INPUT	1
#define OUTPUT	0

//18T MXL Pulley 1/16 Stepping for X & Y Axis
#define StepsPer_mm			61.302// Changed by ERIK. This was: 87.575  // 1/16 Stepping
#define StepsPer_Inch		100 // 1/16 Stepping
#define  FeedFactor 		57094

//M8 x 1.25 thread
//200 steps per rev 3200 at 1/16 stepping x 1/1.25 = 2560
#define ZStepsPer_mm             2560

//  Axis definitions
#define X_Step		PORTDbits.RD2	//Digital
#define X_Dir		PORTDbits.RD7	//Digital
#define X_Disable	PORTDbits.RD3	//Digital

#define Y_Step		PORTDbits.RD8 	//Digital
#define Y_Dir		PORTDbits.RD9	//Digital
#define Y_Disable	PORTDbits.RD10	//Digital

#define Z_Step		PORTBbits.RB8	//Analog
#define Z_Dir		PORTBbits.RB9	//Analog
#define Z_Disable	PORTBbits.RB13	//Analog

#define SB_SIZE     			512   // Step buffer size

//Flag setup for interrupts
#define _T4IE		IEC0bits.T4IE
#define _T4IF		IFS0bits.T4IF

#define SAFE_FEED_RATE			2000
#define RAPID_MOVE_FEED_RATE 	950 //ERIK was: 750 //was500	
#define Z_FEED_RATE				1200 //ERIK was: 750
#define GO_TO_REST_RATE			800

#define X_REST_ABS_MM		130 // ERIK: have a look at this!!
#define Y_REST_ABS_MM		-100
#define Z_REST_ABS_MM		0

int G_CodeRapidXYMove;
int G_CodeRapidZMove;
int S_F_Code; //Stepper F code

/****************************************************************/
/*                     Functions                                */
/****************************************************************/
//External Functions
extern void Stepper_InitIO(void);
extern void Stepper_LoadNewValues(int Feed_Code, int Machine_Code);
extern void Stepper_CalcSteps(int Units, char G2_G3);
extern void	OriginOffset(void);
extern void ResetOrigin(void);
extern void Manual_Mode(char ShowPos);
extern int RapMan_Home(void);	
extern void GoToRest();
extern void Stepper_Run3DLine(void);
extern void Axis_Stepper_Motors(int on_off);
