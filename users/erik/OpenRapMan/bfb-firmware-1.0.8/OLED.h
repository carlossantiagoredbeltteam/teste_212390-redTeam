/**********************************************************************
 ***************************  OLED.h  *********************************
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
#define OLED_Header_VerNo	"RapMan v1.0.8-Erik" //UPDATE VERSION NUMBER HERE (1.0.8)
#define OLED_Auto_Load		"AUTO: Loading.."
#define OLED_ToolSet	   	"TOOL SETUP"
#define OLED_Home			    "HOMING PLEASE WAIT"
#define OLED_Menu_Title0	"MENU"
#define OLED_Menu_0			  "RUN FILE"
#define OLED_Menu_1			  "MANUAL MOVE"
#define OLED_Menu_2			  "TOOL SETUP"
#define OLED_Menu_3			  "HOME TOOL HEAD"
#define OLED_Cursor			  ">"

#define BLANK_SCREEN	0x00
#define DSP_RAPMAN_LOGO		0
#define DSP_BfB_LOGO		1
#define DSP_EXTRUDER_SCREEN	2

extern void OLED_Fill_RAM(unsigned char Data);
extern void OLED_BitMapFill_RAM(unsigned char screen);
extern void OLED_ProgressBar(unsigned char Line, int Value);
extern void OLED_ClearLine(unsigned char Line);
extern void OLED_FastText57(int txtpage, int txtcol, unsigned char* textptr, unsigned char colour);
extern void OLED_Start_Menu(void);
extern void OLED_Auto_Screen(void);
extern void OLED_Manual_Screen(void);
extern void OLED_ToolSetup_Screen(void);
extern void OLED_Home_Screen(void);
extern void OLED_RapManMove_Screen(float X_pos, float Y_pos, float Z_pos, char DoZmove);
extern void OLED_FileEnd_Screen(void);
extern void OLED_SetCursor(int txtpage, int txtcol, unsigned char colour);
extern void OLED_Printing_Screen(void);
extern int  OLED_Init(void);
extern void OLED_Start_Msg(void);

extern void OLED_Extruder_Screen(void);
extern void OLED_UpdatePrintScreen(void);
extern void OLED_UpdateThermistorReading(void);
extern void OLED_UpdateSetTemperature(void);
extern void OLED_UpdateSetRPM(void);
