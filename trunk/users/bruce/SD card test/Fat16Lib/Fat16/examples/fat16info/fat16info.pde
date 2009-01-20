/*
 * cardInfo.pde
 */

#include <avr/pgmspace.h>
#include "Fat16.h"
#include "SdCard.h"

SdCard card;
Fat16 file;
/*
 * print PROGMEM string
 */
 void printProgStr(const char *str)
{
  uint8_t b;
  while((b = pgm_read_byte(str++)))Serial.print(b);
}
/*
 * print PROGMEM string and CR LF
 */
void printProgStrln(const char *str)
{
  printProgStr(str);
  Serial.println();
}
// macros to use PSTR
#define progPrint(str) printProgStr(PSTR(str))
#define progPrintln(str) printProgStrln(PSTR(str))
/*
 * print partition info
 */
uint8_t partitionInfo(void)
{
  mbr_t *mbr = (mbr_t *)Fat16::dbgCacheBlock(0);
  if (mbr == 0) {
    progPrintln("partitionInfo: cacheBlock(0) failed");
    return 0;
  }
  uint8_t good = 0;
  for (uint8_t i = 0; i < 4; i++) {
    if ((mbr->part[i].boot & 0X7F) != 0 ||
        (mbr->part[i].firstSector == 0 && mbr->part[i].totalSectors != 0)) {
          return 0;
    }
    if (mbr->part[i].firstSector != 0 && mbr->part[i].totalSectors != 0) {
      good = 1;
    }
  }
  if (!good) return 0;
  progPrintln("Partition  Table:");
  progPrintln("part,boot,start,size");
  for (uint8_t i = 0; i < 4; i++) {
    Serial.print(i+1);
    progPrint(",0X");
    Serial.print(mbr->part[i].boot, HEX);
    Serial.print(',');
    Serial.print(mbr->part[i].firstSector);
    Serial.print(',');
    Serial.println(mbr->part[i].totalSectors);
  }
  Serial.println();
  return 1;
}
/*
 * print info for FAT volume
 */
uint8_t volumeInfo(uint8_t part)
{
  uint8_t volumeType = 0;
  if (part > 4) {
    progPrintln("volumeInfo: invalid partition number");
    return 0;
  }
  mbr_t *mbr = (mbr_t *)Fat16::dbgCacheBlock(0);
  if (mbr == 0) {
    progPrintln("volumeInfo: cacheBlock(0) failed");
    return 0;
  }
  bpb_t *bpb = &(((fbs_t *)mbr)->bpb);
  if (part != 0) {
    if ((mbr->part[part-1].boot & 0X7F) !=0  ||
      mbr->part[part-1].totalSectors < 100 ||
      mbr->part[part-1].firstSector == 0) {
        return 0;
     }
     fbs_t *fbs = (fbs_t *)Fat16::dbgCacheBlock(mbr->part[part-1].firstSector);
     if (fbs == 0) {
       progPrintln("volumeInfo cacheBlock(fat boot sector) failed");
       return 0;
     }
     if (fbs->bootSectorSig0 != 0X55 || fbs->bootSectorSig1 != 0XAA) {
       progPrintln("Bad FAT boot sector signature for partition: ");
       Serial.println(part, DEC);
       return 0;
     } 
     bpb = &fbs->bpb;
  }
  if (bpb->bytesPerSector != 512 ||
      bpb->fatCount == 0 ||
      bpb->reservedSectorCount == 0 ||
      bpb->sectorsPerCluster == 0 ||
      (bpb->sectorsPerCluster & (bpb->sectorsPerCluster - 1)) != 0) {
        // not valid FAT volume
        return 0;
  }
  uint32_t totalBlocks = bpb->totalSectors16 ? bpb->totalSectors16 : bpb->totalSectors32;
  uint32_t fatSize = bpb->sectorsPerFat16;
  if (fatSize == 0) {
    // first entry of FAT32 structure is FatSize32
    // don't ask why this works
    fatSize = *(&bpb->totalSectors32 + 1);
  }
  uint16_t rootDirSectors = (32*bpb->rootDirEntryCount + 511)/512;
  uint32_t firstDataSector = bpb->reservedSectorCount + 
                                 bpb->fatCount*fatSize + rootDirSectors;
  uint32_t dataBlockCount = totalBlocks - firstDataSector;
  uint32_t clusterCount = dataBlockCount/bpb->sectorsPerCluster;
  if (part) {
    progPrint("FAT Volume info for MBR partition: ");
    Serial.println(part, DEC);
  }
  else {
    progPrintln("FAT Volume is super floppy format");
  }
  if (clusterCount < 4085) {
    volumeType = 12;
  }
  else if (clusterCount < 65525) {
    volumeType = 16;
  }
  else {
    volumeType = 32;
  }
  progPrint("Volume is FAT");
  Serial.println(volumeType, DEC);
  progPrint("clusterSize: ");
  Serial.println(bpb->sectorsPerCluster, DEC);
  progPrint("clusterCount: ");
  Serial.println(clusterCount);  
  progPrint("fatCount: ");
  Serial.println(bpb->fatCount, DEC);
  progPrint("fatSize: ");
  Serial.println(fatSize);
  progPrint("totalBlocks: ");
  Serial.println(totalBlocks);
  Serial.println();
  return volumeType;
}
void setup()
{
  int8_t part = -1;
  Serial.begin(9600);
  Serial.println();
  if (!card.init()) {
    progPrintln("card.init failed");
    progPrintln("May be SDHC card");
    while(1);
  }
  uint32_t size = card.cardSize();
  progPrint("Card Size(blocks): ");
  Serial.println(size);
  if (size < 1000 || size > 5000000) {
    progPrint("Quitting, bad size");
    while(1);
  }  
  Serial.println();
  Fat16::dbgSetDev(card);
  if (partitionInfo()) {
    for (uint8_t i = 1; i < 5; i++) {
      if (volumeInfo(i) == 16) part = i;
    }
  }
  else {
    progPrintln("Card is not MBR trying super floppy");
    if (volumeInfo(0) == 16) part = 0;
  }
  if (part >= 0) {
    if (!Fat16::init(card, part)) {
      progPrintln("Can't init volume");
      while(1);
    }
    uint16_t index = 0;
    dir_t *d;
    progPrintln("Root Directory:");
    progPrintln("name,ext,attr,size");
    uint8_t nd = 0;
    while ((d = Fat16::readDir(index)) && nd++ < 20) {
      for (uint8_t i = 0; i < 11; i++) {
        if (i == 8)Serial.print(' ');
        Serial.print((char)d->name[i]);
      }
      Serial.print(' ');
      Serial.print(d->attributes, HEX);
      Serial.print(' ');
      Serial.println(d->fileSize);
      index++;
    }
  }
  else {
    progPrintln("FAT16 volume not found");
  }
}

void loop()
{
}
