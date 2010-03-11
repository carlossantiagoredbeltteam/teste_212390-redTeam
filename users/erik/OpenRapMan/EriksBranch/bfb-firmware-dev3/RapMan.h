/**********************************************************************
 ***************************  RapMan.h  *******************************
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

//add in below as required
#include "Enviroment.h"
#include "FSIO.h"
#include "Stepper.h"	//Stepper motor functions and defines
#include "G_Code.h"		//G code table
#include "Extruder.h"
#include "stdlib.h"
#include "stdio.h"		//for printf **See note
//To use printf the build options need to show a heap.
//for output printf ONLY the heap can be set to 0
//add to end of compile line --heap=0

#include "OLED.h"

//General Defines
#define	PRESSED 	0
#define NOT_PRESSED 1

//File types
#define INVALID_FILE	0
#define GCO_FILE		1
#define BIN_FILE		2
#define BFB_FILE		3

//Error Conditions
#define TEST			0
#define SEEK_POINT_ERR	1

int PosInFile = 0;	//character count in file
int LineNumber = 0; //Line count in file

int Word_Count=0;
char Inst_Code_Letter;
char Inst_Code[8];
int iInst_Code;
char Dim_1_Letter;
char Dim_1[8];
float fDim_1;
char Dim_2_Letter;
char Dim_2[8];
float fDim_2;
char Dim_3_Letter;
char Dim_3[8];
float fDim_3;
char Dim_4_Letter;
char Dim_4[8];
float fDim_4;

float X_Rest_mm;
float Y_Rest_mm;
float Z_Rest_mm;

char EOF_Flag = 0; //end of file

char ExtruderStatus; 

FSFILE * pointer;

char SaveFileName[12];
int SaveFileSize;
 
FSFILE *FilePointer;

int ItemsRead = 0;

extern int GX_On;
extern int GY_On;
extern int GZ_On;
extern int GI_On;
extern int GJ_On;
extern signed long lX_Steps,lY_Steps,lZ_Steps;
extern int Feed_Rate;

int ManualChange;

char PauseFlag; //Used to prevent heater going on during pause

signed int Ops_mode;

void Setup(void);
char GetTool_ID(void);

//**********************************************************************
// Functions
//**********************************************************************
void RapMan_MoveTo(float X_pos, float Y_pos, float Z_pos, char DoZmove);
void OpenReadSDFile(void);
void GetFileToOpen(void);
int Get_file_Type(void);
void ReadBinData(void);
void ReadData(void);
void GetCodes(void);
void FlushBuffer(void);
extern void ShowBufferFillState(void);
extern void ShowPrintProgress(void);
char RapMan_Mode();
