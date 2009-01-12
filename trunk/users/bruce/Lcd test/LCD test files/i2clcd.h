

#ifndef I2CLCD_H_
#define I2CLCD_H_


//*******************************************************************************************************************
// REQUIRED							                                Define Statements 
//*******************************************************************************************************************

// Port Expander
#define		MCP23017	B00100000	//MCP23017 I2C Address was B01000000
//                                    xxx <- These are the I2C address bits

#define		IOCON		0x0A		// MCP23017 Config Reg.

#define		IODIRA		0x00		// MCP23017 address of I/O direction
#define		IODIRB		0x01		// MCP23017 1=input

#define		IPOLA		0x02		// MCP23017 address of I/O Polarity
#define		IPOLB		0x03		// MCP23017 1= Inverted

#define		GPIOA		0x12		// MCP23017 address of GP Value
#define		GPIOB		0x13		// MCP23017 address of GP Value

#define		GPINTENA	0x04		// MCP23017 IOC Enable
#define		GPINTENB	0x05		// MCP23017 IOC Enable

#define		INTCONA		0x08		// MCP23017 Interrupt Cont 
#define		INTCONB		0x09		// MCP23017 1= compair to DEFVAL(A or B) 0= change

#define		DEFVALA		0x06		// MCP23017 IOC Default value
#define		DEFVALB		0x07		// MCP23017 if INTCONA set then INT. if diff. 

#define		GPPUA		0x0C		// MCP23017 Weak Pull-Ups
#define		GPPUB		0x0D		// MCP23017 1= Pulled HIgh via internal 100k

// LCD
#define		CMD_CLR		0x01		// clear the LCD
#define		CMD_HOME	0x02		// move cursor to home position
#define		CrsrLf		0x10		// move cursor left
#define		CrsrRt		0x14		// move cursor right
#define		CMD_LEFT	0x18		// shift displayed chars left
#define		CMD_RIGHT	0x1C		// shift displayed chars right
#define		DDRam		0x80		// Display Data RAM control
#define		ddram2		0xC0		// 9th position of display (not in next 

#define		RS_pin		B00000100
#define		RW_pin		B00000010
#define		E_pin		B00000001

#define         screen_lines    2               // this is the amount of lines the LCD screen has 


#endif
