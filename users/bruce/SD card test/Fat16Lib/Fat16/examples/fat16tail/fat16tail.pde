/*
 * Sketch to read and print the tail of files created
 * by printExample.pde and writeExample.pde
 */
//#include <string.h>
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
    // try super floppy
    if (!Fat16::init(card, 0)) error("Fat16.init");
  }
}
uint16_t index = 0;
dir_t *dir = 0;
/*
 * Print tail of all Fat16 example files
 */
void loop(void)
{
  // advance index if not first time
  if (dir) index++;
  // read next directory entry into the cache
  if (!(dir = Fat16::readDir(index))) {
    Serial.println("End of Directory");
    while(1);
  }
  // check for file name "PRINT*.TXT" or "WRITE*.TXT"
  // first 8 bytes are blank filled name
  if (strncmp((char *)dir->name, "WRITE", 5) &&
      strncmp((char *)dir->name, "PRINT", 5)) return;
  // last three bytes are blank filled extension
  if (strncmp((char *)&dir->name[8], "TXT", 3)) return;
  
  // print file name message
  Serial.print("Tail of: ");
  for(uint8_t i = 0; i < 8 && dir->name[i] != ' '; i++) Serial.print(dir->name[i]);
  Serial.println(".TXT");
  
  // open file by index - easier to use than open by name.
  // cache will no longer contain the directory entry after open call
  if (!file.open(index)) error("file.open");
  
  // position to tail of file
  if (file.fileSize() > 100) {
    if (!file.seek(file.fileSize() - 100)) error("file.seek");
  }
  int16_t c;
  // find end of line  
  while ((c = file.read()) >= 0 && c != '\n');
  
  // print rest of file
  while ((c = file.read()) >= 0) Serial.print((char)c);
  file.close();
  Serial.println();
}
