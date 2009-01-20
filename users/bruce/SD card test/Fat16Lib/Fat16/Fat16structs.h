/* Arduino FAT16 Library
 * Copyright (C) 2008 by William Greiman
 *  
 * This file is part of the Arduino FAT16 Library
 *  
 * This Library is free software: you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published by 
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This Library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 
 * You should have received a copy of the GNU General Public License
 * along with the Arduino Fat16 Library.  If not, see
 * <http://www.gnu.org/licenses/>.
 */
/**
 * \file
 * FAT data structures
 */    
#ifndef Fat16structs_h
#define Fat16structs_h
/*
 * mostly from Microsoft document fatgen103.doc
 * http://www.microsoft.com/whdc/system/platform/firmware/fatgen.mspx
 */
/**
 * \struct partitionTable
 * \brief MBR partition table entry
 *  
 * A partiton table entry for a MBR formatted storage device.
 * The MBR partiton table has four entries. 
 */ 
struct partitionTable {
          /**
           * Boot Indicator . Indicates whether the volume is the active 
           * partition.  Legal values include: 0X00. Do not use for booting. 
           * 0X80 Active partition.
           */           
  uint8_t  boot;
          /**
            * Head part of Cylinder-head-sector address of the first block in 
            * the partition. Legal values are 0-255. Only used in old PC BIOS.
            */            
  uint8_t  beginHead; 
          /**
           * Sector part of Cylinder-head-sector address of the first block in
           * the partition. Legal values are 1-63. Only used in old PC BIOS.
           */           
  unsigned beginSector : 6;
           /** High bits cylinder for first block in partition. */
  unsigned beginCylinderHigh : 2;
          /**
           * Combine beginCylinderLow with beginCylinderHigh. Legal values 
           * are 0-1023.  Only used in old PC BIOS.
           */           
  uint8_t  beginCylinderLow;
          /**
           * Partition type. See defines that begin with PART_TYPE_ for
           * some Microsoft partition types.
           */           
  uint8_t  type;
          /**
           * head part of cylinder-head-sector address of the last sector in the 
            * partition.  Legal values are 0-255. Only used in old PC BIOS.
            */            
  uint8_t  endHead;
          /**
           * Sector part of cylinder-head-sector address of the last sector in 
           * the partition.  Legal values are 1-63. Only used in old PC BIOS.
           */           
  unsigned endSector : 6;
           /** High bits of end cylinder */
  unsigned endCylinderHigh : 2;    
          /**
           * Combine endCylinderLow with endCylinderHigh. Legal values 
           * are 0-1023.  Only used in old PC BIOS.
           */           
  uint8_t  endCylinderLow;             
           /** Logical block address of the first block in the partition. */
  uint32_t firstSector;
           /** Length of the partition, in blocks. */
  uint32_t totalSectors;
};
/** Type name for partitionTable */
typedef struct partitionTable part_t;

        /** Boot indicator for active bootable partition. */
#define PART_BOOT_ACTIVE       0X80
        /** Boot indicator for non-bootable partition */
#define PART_BOOT_NON_BOOTABLE 0X00
      /**
        * FAT12 primary partition or logical drive 
        * (fewer than 32,680 sectors in the volume)
        */        
#define PART_TYPE_FAT12     0x01
        /** FAT16 partition or logical drive (32,680–65,535 sectors or 16 MB–33 MB) */
#define PART_TYPE_DOSFAT16  0x04
        /** Extended partition */
#define PART_TYPE_EXTENDED  0x05
        /** BIGDOS FAT16 partition or logical drive (33 MB–4 GB) */
#define PART_TYPE_FAT16     0x06
        /** Installable File System (NTFS partition or logical drive) */
#define PART_TYPE_NTFS      0x07
        /** FAT32 partition or logical drive */
#define PART_TYPE_FAT32     0x0B
        /** FAT32 partition or logical drive using BIOS INT 13h extensions */
#define PART_TYPE_FAT32LBA  0x0C
        /** BIGDOS FAT16 partition or logical drive using BIOS INT 13h extensions */
#define PART_TYPE_FAT16LBA  0x0E
        /** Extended partition using BIOS INT 13h extensions */
#define PART_TYPE_EXTDOSLBA 0x0F
/**
 * \struct masterBootRecord
 *  
 * \brief Master Boot Record
 *  
 * The first block of a storage device that is formatted with a MBR.
 */
struct masterBootRecord {
           /** Code Area for master boot program. */
  uint8_t  codeArea[440];
           /** Optional WindowsNT disk signature. May contain more boot code. */
  uint32_t diskSignature;
           /** Usually zero but may be more boot code. */
  uint16_t usuallyZero;
           /** Partition tables. */
  part_t   part[4];
           /** First MBR signature byte. Must be 0X55 */
  uint8_t  mbrSig0;
           /** Second MBR signature byte. Must be 0XAA */
  uint8_t  mbrSig1;
};
/** Type name for masterBootRecord */
typedef struct masterBootRecord mbr_t;
/**
 * \struct biosPramBlock
 *  
 * \brief Structure that defines a FAT16 volume.
 * 
 *  See FAT boot sector for entire block. 
 */
struct biosPramBlock{
          /**
           * Count of bytes per sector. This value may take on only the 
           * following values: 512, 1024, 2048 or 4096
           */            
  uint16_t bytesPerSector;      
          /**
           * Number of sectors per allocation unit. This value must be a 
           * power of 2 that is greater than 0. The legal values are 
           * 1, 2, 4, 8, 16, 32, 64, and 128. 
           */           
  uint8_t  sectorsPerCluster;   
          /** 
           * Number of sectors before the first FAT.  
           * This value must not be zero. 
           */
  uint16_t reservedSectorCount; 
          /** The count of FAT data structures on the volume. This field should 
           *  always contain the value 2 for any FAT volume of any type. 
           */           
  uint8_t  fatCount;            
          /**
          * For FAT12 and FAT16 volumes, this field contains the count of 
          * 32-byte directory entries in the root directory. For FAT32 volumes, 
          * this field must be set to 0. For FAT12 and FAT16 volumes, this 
          * value should always specify a count that when multiplied by 32 
          * results in a multiple of bytesPerSector.  FAT16 volumes should
          * use the value 512.
          */          
  uint16_t rootDirEntryCount;
          /**
           * This field is the old 16-bit total count of sectors on the volume. 
           * This count includes the count of all sectors in all four regions 
           * of the volume. This field can be 0; if it is 0, then totalSectors32 
           * must be non-zero.  For FAT32 volumes, this field must be 0. For 
           * FAT12 and FAT16 volumes, this field contains the sector count, and 
           * totalSectors32 is 0 if the total sector count fits
           * (is less than 0x10000).
           */           
  uint16_t totalSectors16;      
          /** 
           * This dates back to the old MS-DOS 1.x media determination and is 
           * no longer usually used for anything.  0xF8 is the standard value 
           * for fixed (non-removable) media. For removable media, 0xF0 is
           * frequently used. Legal values are 0xF0 or 0xF8-0xFF.
           */           
  uint8_t  mediaType;           
          /** 
           * This field is the FAT12/FAT16 16-bit count of sectors occupied by 
           * ONE FAT. On FAT32 volumes this field must be 0, and sectorsPerFat32 
           * contains the FAT size count.
           */           
  uint16_t sectorsPerFat16;
           /** Sectors per track for interrupt 0x13. Not used otherwise. */
  uint16_t sectorsPerTrtack;
           /** Number of heads for interrupt 0x13.  Not used otherwise. */
  uint16_t headCount;
          /** 
           * Count of hidden sectors preceding the partition that contains this 
           * FAT volume. This field is generally only relevant for media 
           *  visible on interrupt 0x13.
           */           
  uint32_t hidddenSectors;
          /** 
           * This field is the new 32-bit total count of sectors on the volume. 
           * This count includes the count of all sectors in all four regions 
           * of the volume.  This field can be 0; if it is 0, then 
           * totalSectors16 must be non-zero. 
           */           
  uint32_t totalSectors32;
};

/** Type name for biosParmBlock */
typedef struct biosPramBlock bpb_t;
/*
 * Some derived values
 * firstFatSector = reservedSectorCount
 * rootDirSectors = (32*rootEntryCount + bytesPerSector - 1)/bytesPerSector
 * firstDataSector = reservedSectorCount + (fatCount * fatSize) + rootDirSectors
 * dataSectorCount = totalSectors - firstDataSector
 * clusterCount = dataSectorCount/sectorsPerCluster
 * for cluster number N
 * firstSectorOfCluster = (N  - 2)*sectorsPerCluster + firstDataCluster
 */ 
/**
 * \struct fat16BootSector
 * \brief Boot Sector of a FAT16 volume
 */
struct fat16BootSector {
           /** X86 jmp to boot program */
  uint8_t  jmpToBootCode[3];  
           /** informational only - don't depend on it */
  char     oemName[8];          
           /** BIOS Pramameter Block */
  bpb_t    bpb;                
           /** for int0x13 use value 0X80 for hard drive */
  uint8_t  driveNumber;         
           /**used by Windows NT - should be zero for FAT16 */
  uint8_t  reserved1;           
           /** 0X29 if next three fields are vaild */
  uint8_t  bootSignature;    
           /** usually generated by combining date and time */
  uint32_t volumeSerialNumber;
           /** should match volume label in root dir */
  char     volumeLabel[11];     
           /** informational only - don't depend on it */
  char     fileSystemType[8];   
           /** X86 boot code */
  uint8_t  bootCode[448];   
           /** must be 0X55 */
  uint8_t  bootSectorSig0;      
           /** must be 0XAA */
  uint8_t  bootSectorSig1;
};

/** Type name for fat16BootSector */
typedef struct fat16BootSector fbs_t;

        /** Value for byte 254 of boot block */
#define BOOTSIG0        0X55
        /** value for byte 255 of boot block */
#define BOOTSIG1        0XAA
/**
 * \struct directoryEntry
 * \brief FAT short directory entry
 * 
 * Short means short 8.3 name, not the entry size.
 */
struct directoryEntry {
           /**
            * Short 8.3 name.
            * The first eight bytes contain the file name with blank fill.
            * The last three bytes contain the file extension with blank fill.
            */
  uint8_t  name[11];   
          /** Entry attributes.
           *        
           * The upper two bits of the attribute byte are reserved and should 
           * always be set to 0 when a file is created and never modified or 
           * looked at after that.  See defines that begin with DIR_ATT_. 
           */
  uint8_t  attributes;
          /**
           * Reserved for use by Windows NT. Set value to 0 when a file is 
           * created and never modify or look at it after that.
           */   
  uint8_t  reservedNT;
          /**
           * The granularity of the seconds part of creationTime is 2 seconds 
           * so this field is a count of tenths of a second and its valid 
           * value range is 0-199 inclusive.
           */            
  uint8_t  creationTimeTenths;
           /** Time file was created. */
  uint16_t creationTime;
           /** Date file was created. */
  uint16_t creationDate;
          /**
           * Last access date. Note that there is no last access time, only 
           * a date.  This is the date of last read or write. In the case of 
           * a write, this should be set to the same date as lastWriteDate.
           */            
  uint16_t lastAccessDate;
          /**
           * High word of this entry’s first cluster number (always 0 for a 
           * FAT12 or FAT16 volume).
           */            
  uint16_t firstClusterHigh;
           /** Time of last write. File creation is considered a write. */
  uint16_t lastWriteTime;
           /** Date of last write. File creation is considered a write. */
  uint16_t lastWriteDate;
           /** Low word of this entry’s first cluster number. */
  uint16_t firstClusterLow;
           /** 32-bit unsigned holding this file’s size in bytes. */
  uint32_t fileSize;
};
        /** Type name for directoryEntry */
typedef struct directoryEntry dir_t;
        /** escape for name[0] = 0XE5 */
#define DIR_NAME_0XE5          0X05 
        /** name[0] value for entry that is free after being "deleted" */
#define DIR_NAME_DELETED       0XE5
        /** name[0] value for entry that is free and no allocated entries follow */
#define DIR_NAME_FREE          0X00 
        /** file is read-only */
#define DIR_ATT_READ_ONLY      0X01
        /** File should hidden in directory listings */
#define DIR_ATT_HIDDEN         0X02
        /** Entry is for a system file */
#define DIR_ATT_SYSTEM         0X04
        /** Directory entry contains the volume label */
#define DIR_ATT_VOLUME_ID      0X08
        /** Entry is for a directory */
#define DIR_ATT_DIRECTORY      0X10
       /** Old DOS archive bit for backup support */
#define DIR_ATT_ARCHIVE        0X20
       /** Test value for long name entry.  Test is 
           d->attributes & DIR_ATT_LONG_NAME_MASK) == DIR_ATT_LONG_NAME. */
#define DIR_ATT_LONG_NAME      0X0F 
        /** Test mask for long name entry */
#define DIR_ATT_LONG_NAME_MASK 0X3F 
        /** cluster alue to test for end of chain */
#define FAT_LAST_USED          0XFFEF
        /** cluster value used to mark end of chain in FAT */
#define FAT_EOC                0XFFFF  
#endif //Fat16structs_h
