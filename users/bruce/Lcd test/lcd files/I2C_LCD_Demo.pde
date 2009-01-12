

#include "i2c_lcd.h"
#include <Wire.h>   // REQUIRED                                                   Used for the I2C Communications



//*******************************************************************************************************************
//								                                   VARIABLE INITS
//*******************************************************************************************************************

byte LCDCONT    = 0;        // REQUIRED
byte button = 0;            // REQUIRED
int  i  =0;                 // REQUIRED

int buttonPress    =0;
int count  = 0;



//*******************************************************************************************************************
// REQUIRED								                                    SET-UP 
//*******************************************************************************************************************

void setup()
{
  Wire.begin();                                                        // join i2c bus (address optional for master)
  portexpanderinit();
  delay(200);
  lcdinit();
  delay(500);
  LCDcmd(ClrLCD);
  Serial.begin(9600);    // Only used for debugging - not required
 }



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

void lcdinit()
{
  // Only used with port expander
  LCDCONT = RS_pin | E_pin;
  I2C_TX(MCP23017,GPIOB,LCDCONT);

  delay(50);
  LCDcmd(B00110000);                 // Standard Hitachi initialization for 8-bit mode form sepc sheets
  delay(60);
  LCDcmd(B00110000);    
  delay(60);
  LCDcmd(B00110000);      
  delay(60);
  LCDcmd(B00111000);      
  delay(60);
  LCDcmd(B00001000);        
  delay(60);
  LCDcmd(ClrLCD);          
  delay(60);
  LCDcmd(B00000110); 	
  delay(60);
  LCDcmd(B0001100);        	
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
void LCDcmd(byte cmdlcd)
{
  LCDCONT =0;                            // was bcf RS_pin
  I2C_TX(MCP23017,GPIOB,LCDCONT);
  LCDwr(cmdlcd);
  delay(20);
}

void LCDwr(byte lcdChar)
{
  I2C_TX(MCP23017,GPIOA,lcdChar);
  LCDCONT = LCDCONT | E_pin;              // If RS is set then it stays set
  delay(2);
  I2C_TX(MCP23017,GPIOB,LCDCONT);
  LCDCONT = RS_pin;
  I2C_TX(MCP23017,GPIOB,LCDCONT);
}


