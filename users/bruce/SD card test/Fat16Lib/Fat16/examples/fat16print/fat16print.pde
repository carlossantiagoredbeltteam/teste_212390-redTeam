/*
 * Print Example
 *
 * This sketch shows how to use the Arduino V12 Print class with Fat16
 */
#include "Fat16.h"
#include "SdCard.h"

SdCard card;
Fat16 file;

void error(char *str)
{
  Serial.print("error: ");
  Serial.println(str);
  while(1);
}

void setup(void)
{
  Serial.begin(9600);
  Serial.println();
  Serial.println("Type any character to start");
  while (!Serial.available());
  
  // initialize the SD card
  if (!card.init()) error("card.init");
  
  // initialize a FAT16 volume
  // Assume MBR volume and try partition one
  if (!Fat16::init(card, 1)) {
    // try super floppy
    if (!Fat16::init(card, 0)) error("Fat16::init");
  }
  // create a new file
  char name[] = "PRINT00.TXT";
  for (uint8_t i = 0; i < 100; i++) {
    name[5] = i/10 + '0';
    name[6] = i%10 + '0';
    if (file.create(name)) break;
  }
  if (!file.isOpen()) error ("file.create");
  Serial.print("Printing to: ");
  Serial.println(name);
  
  // print 100 line to file
  for (uint8_t i = 0; i < 100; i++) {
    file.print("line ");
    file.print(i, DEC);
    file.print(" millis = ");
    file.println(millis());
  }
  // force write of all data to the SD card
  file.sync();
  Serial.println("Done");
}
void loop(void){}
