This is a .PDE files for Arduino/sanguino for controlling an HD74800-compatible 
LCD in I2c mode using the Reprap LCD controler board.
Tested on Arduino 0011 Alpha.

Installation
--------------------------------------------------------------------------------

To install this file, just place this entire folder and point to it with the arduino
envoriment

file list

readme.txt //that is this readme file explaining how to use the I2c lcd files
i2clcd.h   //this is the hex file that contains the settings for the I2c files
i2c_lcd.pde  // this is the file that contains the commands that are available 
to control the LCD
lcd_test.pde  // this is a simple test program to test the function of your LCD 
and board it uses the serial port and will show what is typed into the keyboard onto
the LCD screen it uses 19200 baud


Commands
--------------------------------------------------------------------------------
here is a list of available commands that you can use and a little bit of how to use them

LCDprint  this is the command to print it would be used as follows LCDprint("start"[5]); with the 5 being the number of charitors

LCDprintIn  this command will print but you will not have to call out the amount of Charitors

LCDclear  this command will clear the LCD display

LCDinit  this command will initilize the display

portexpanderinit  this command will initilize the I2c LCD board

LCDcommandWrite  this command is used to send a command to the LCD 

LCDhome  this command will sed the cursor to the home postion

LCDleftscroll  this command will scroll the display to the left

LCDcursorTo  this command will position the cursor to the position that is called out

LCDcheckbutton   this command is used to scan for a button press it is displayed with a command buttonPress


Using
--------------------------------------------------------------------------------

to use these files you will need to first initilize the board and then the display

use in your "void setup()"     command

Wire.begin();                   //this is to start the initilize the lcd screen                                     
         portexpanderinit();  //this will initilize the board 
         delay(200);
         LCDinit();           // this will initilize the lcd screen 
         delay(500);
         LCDclear();          // this is a clear lcd command   not needed just done to clear the display 
         LCDprint("start"[5]);  // this is a simple test it prints start  This is also not needed
         
         
         
then when you want to print you just add in your code 

LCDprintIn("this what you would want to print");

         
more instructions to follow