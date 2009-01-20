/*
 * Write Example
 *
 * This sketch creates a new file and writes 100 lines to the file.
 */

#include "Fat16.h"
#include "SdCard.h"

#include "WProgram.h"
void error(char *str);
void setup(void);
void loop(void);
SdCard card;
Fat16 file;

void error(char *str)
{
  Serial.print("error: ");
  Serial.println(str);
  while(1);
}
/*
 * Write CR LF to a file
 */
void writeCRLF(Fat16 &f)
{
  f.write((uint8_t *)"\r\n", 2);
}
/*
 * Write an unsigned number to a file
 */
void writeNumber(Fat16 &f, uint32_t n)
{
  uint8_t buf[10];
  uint8_t i = 0;
  do {
    i++;
    buf[sizeof(buf) - i] = n%10 + '0';
    n /= 10;
  } while (n);
  f.write(&buf[sizeof(buf) - i], i);
}
/*
 * Write a string to a file
 */
void writeString(Fat16 &f, char *str)
{
  uint8_t n;
  for (n = 0; str[n]; n++);
  f.write((uint8_t *)str, n);
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
  char name[] = "WRITE00.TXT";
  for (uint8_t i = 0; i < 100; i++) {
    name[5] = i/10 + '0';
    name[6] = i%10 + '0';
    if (file.create(name)) break;
  }
  if (!file.isOpen()) error ("file.create");
  Serial.print("Writing to: ");
  Serial.println(name);
  
  // write 100 line to file
  for (uint8_t i = 0; i < 100; i++) {
    writeString(file, "line ");
    writeNumber(file, i);
    writeString(file, " millis = ");
    writeNumber(file, millis());
    writeCRLF(file);
  }
  // close file and force write of all data to the SD card
  file.close();
  Serial.println("Done");
}

void loop(void) {}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

