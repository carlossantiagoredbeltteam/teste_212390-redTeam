/*
 * Sketch to read and print the file
 * "PRINT00.TXT" created by printExample.pde or
 * "WRITE00.TXT" created by writeExample.pde
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
  Serial.println("type any character to start");
  while (!Serial.available());
  
  // initialize the SD card
  if (!card.init()) error("card.init");
  
  // initialize a FAT16 volume
  // try partition one
  if (!Fat16::init(card, 1)) {
    // try super floppy format
    if (!Fat16::init(card, 0)) error("Fat16.init");
  }
  
  // open a file
  if (!file.open("PRINT00.TXT")) {
    // try the other file
    if (!file.open("WRITE00.TXT")) error("file.open");
  }
  
  // copy file to serial port
  uint16_t n;
  uint8_t buf[7];
  while ((n = file.read(buf, sizeof(buf))) > 0) {
    for (uint8_t i = 0; i < n; i++) Serial.print(buf[i]);
  }
  /* easier way
  uint16_t c;
  while ((c = file.read()) >= 0) Serial.print((char)c);
  */
}

void loop(void) {}
