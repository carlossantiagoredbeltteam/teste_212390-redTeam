

#include "i2clcd.h"
#include <Wire.h>   // REQUIRED                                                   Used for the I2C Communications
#include <string.h> //needed for strlen()


//*******************************************************************************************************************
//								                                   VARIABLE INITS
//*******************************************************************************************************************

byte LCDCONT    = 0;        // REQUIRED
byte button = 0;            // REQUIRED
int  i  =0;                 // REQUIRED
int  g_num_lines = screen_lines;   // this is the number of lines your screen has
int buttonPress    =0;
int count  = 0;


//*******************************************************************************************************************
//								                         Functions and Subroutines
//*******************************************************************************************************************


//*******************************************************************************************************************
// REQUIRED								                                 I2C TX RX
//*******************************************************************************************************************
void I2C_TX(byte device, byte regadd, byte tx_data)                              // Transmit I2C Data
{
  Wire.beginTransmission(device);
  Wire.send(regadd); 
  Wire.send(tx_data); 
  Wire.endTransmission();
}

void I2C_RX(byte devicerx, byte regaddrx)                                       // Receive I2C Data
{
  Wire.beginTransmission(devicerx);
  Wire.send(regaddrx); 
  Wire.endTransmission();
  Wire.requestFrom(int(devicerx), 1);   

  byte c = 0;
  if(Wire.available())
  {
    byte c = Wire.receive();             
    button = c >>3;
  }
}

//*******************************************************************************************************************
// REQUIRED								                                  LCD INIT
//*******************************************************************************************************************

void LCDinit()
{
  // Only used with port expander
  LCDCONT = RS_pin | E_pin;
  I2C_TX(MCP23017,GPIOB,LCDCONT);

  delay(50);
  LCDcommandWrite(B00110000);                 // Standard Hitachi initialization for 8-bit mode form sepc sheets
  delay(60);
  LCDcommandWrite(B00110000);    
  delay(60);
  LCDcommandWrite(B00110000);      
  delay(60);
  LCDcommandWrite(B00111000);      
  delay(60);
  LCDcommandWrite(B00001000);        
  delay(60);
  LCDcommandWrite(CMD_CLR);          
  delay(60);
  LCDcommandWrite(B00000110); 	
  delay(60);
  LCDcommandWrite(B0001100);        	
  delay(60);
}

//*******************************************************************************************************************
// REQUIRED								                         PORTEXPANDER INIT
//*******************************************************************************************************************
void portexpanderinit()
{
  // --- Set I/O Direction
  I2C_TX(MCP23017,IODIRB,B11111000);
  I2C_TX(MCP23017,IODIRA,B00000000);
  //  --- Set I/O Polarity
  I2C_TX(MCP23017,IPOLA,B00000000);
  I2C_TX(MCP23017,IPOLB,B11111000);
  //  --- Set ALL Bits of GPIOA
  I2C_TX(MCP23017,GPIOA,B00000000);
  // --- Set Weak Pull-Up on Bits 7 of GPIOB
  I2C_TX(MCP23017,GPPUB,B11111000);
  // --- Set Default on Bits 7 of GPIOB
  I2C_TX(MCP23017,DEFVALB,B00000000);
  // --- Set Use Default on Bits 7 of GPIOB
  I2C_TX(MCP23017,INTCONB,B10000000);
  // --- Set IOC on Bits 7 of GPIOB
  I2C_TX(MCP23017,GPINTENB,B10011000);
  // --- Set active low of int pin
  I2C_TX(MCP23017,IOCON,B00110000);
}

//*******************************************************************************************************************
// REQUIRED								                       LCD WRITE / COMMAND
//*******************************************************************************************************************

// this is the LCD command used to send a command to the lcd screen 
void LCDcommandWrite(byte cmdlcd)
{
  LCDCONT =0;                            // was bcf RS_pin
  I2C_TX(MCP23017,GPIOB,LCDCONT);
  LCDprint(cmdlcd);
  delay(20);
}

// this is the LCD print command used to print to the screen this will print where the cursor is at 

void LCDprint(byte lcdChar)
{
  I2C_TX(MCP23017,GPIOA,lcdChar);
  LCDCONT = LCDCONT | E_pin;              // If RS is set then it stays set
  delay(2);
  I2C_TX(MCP23017,GPIOB,LCDCONT);
  LCDCONT = RS_pin;
  I2C_TX(MCP23017,GPIOB,LCDCONT);
}

//this is the LCD clear command

void LCDclear()
{
  LCDcommandWrite(CMD_CLR);
  delay(1);
}


//this is to set the cursor to the home position
void LCDhome()
{
  LCDcommandWrite(CMD_HOME);
}

//scroll whole display to left
void LCDleftscroll(int num_chars, int delay_time)
{
  for (int i=0; i<num_chars; i++) {
    LCDcommandWrite(CMD_LEFT);
    delay(delay_time);
  }
}
// this is to move the cursor to a specific location before printing to LCD
void LCDcursorTO(int line_num, int x)
{
  //first put cursor home 
  LCDcommandWrite(CMD_HOME);
  //if we are on a 1-line display, set line_num to 1st line, regardless of given 
  if (g_num_lines==1)
  {line_num=1;
  }
  
  //offset  40 Char in if secound line requested
  if (line_num == 2)
  {
    x +=40;
  }
  
  //advance the cursor to the right according to position. (second line starts at position 40).
  for (int i=0; i<x; i++)
  {
    LCDcommandWrite(0x14);
  }
}

//this is the printIn command this will print a line and you do not need to add how long the line is

void LCDprintIn(char msg[])
{
  for (i=0;i < strlen(msg);i++)
  {
    LCDprint(msg[i]);
  }
}
  

