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
#include <avr/pgmspace.h>
#include "Fat16Config.h"
#include "Fat16.h"

static uint8_t make83Name(char *str, uint8_t *name);

// block device driver
BlockDevice *Fat16::rawDev_ = 0;        //class for block read and write
// volume info
uint8_t  Fat16::volumeInitialized_ = 0; //true if FAT16 volume is valid
uint8_t  Fat16::fatCount_;              //number of file allocation tables
uint8_t  Fat16::blocksPerCluster_;      //must be power of 2
uint16_t Fat16::rootDirEntryCount_;     //should be 512 for FAT16
uint16_t Fat16::blocksPerFat_;          //number of blocks in one FAT
uint16_t Fat16::clusterCount_;          //total clusters in volume
uint32_t Fat16::fatStartBlock_;         //start of first FAT
uint32_t Fat16::rootDirStartBlock_;     //start of root dir
uint32_t Fat16::dataStartBlock_;        //start of data clusters

//raw block cache
uint32_t Fat16::cacheBlockNumber_ = 0XFFFFFFFF; //init to invalid block number
cache_t  Fat16::cacheBuffer_;       //512 byte cache for BlockDevice
uint8_t  Fat16::cacheDirty_ = 0;    //cacheFlush() will write block if true
// form 8.3 name for directory entry
uint8_t make83Name(char *str, uint8_t *name)
{
  uint8_t c;
  uint8_t n = 7;
  uint8_t i = 0;
  //blank fill name and extension
  while (i < 11)name[i++] = ' ';
  i = 0;
  while ((c = *str++) != '\0') {
    if (c == '.') {
      if (n == 10) return 0;// only one dot allowed
      n = 10;
      i = 8;
    }
    else {
#if FAT16_SAVE_RAM
      // using PSTR gives incorrect warning in C++ files for Arduino V12
      // illegal FAT16 characters
      char b, *p = (char *)PSTR("|<>^+=?/[];,*\"\\");
      while ((b = pgm_read_byte(p++))) if (b == c) return 0;
#else //FAT16_SAVE_RAM
      // illegal FAT16 characters
      const char *p = "|<>^+=?/[];,*\"\\";     
      while (*p) if (*p++ == c) return 0;
#endif //FAT16_SAVE_RAM
      // check length and only allow ASCII printable characters
      if (i > n || c < 0X21 || c > 0X7E)return 0;
      //only upper case allowed in 8.3 names - convert lower to upper
      name[i++] = c < 'a' || c > 'z' ?  c : c + ('A' - 'a');
    }
  }
  //must have a file name, extension optional
  if (name[0] == ' ') return 0;
  return 1;
}

#if FAT16_WRITE_SUPPORT
uint8_t Fat16::addCluster(void)
{
  fat_t *f;
  //start search after last cluster of file or at cluster two in FAT
  fat_t freeCluster = writeCluster_ != 0 ? writeCluster_ : 1;
  for (uint16_t i = 0; ; i++) {
    // return no free clusters
    if (i >= clusterCount_) return 0;
    // Fat has clusterCount + 2 entries
    if (freeCluster > clusterCount_) freeCluster = 1;
    freeCluster++;
    if (!(f = cacheFatEntry(freeCluster))) return 0;
    if (*f == 0) break;
  }
  if (writeCluster_ == 0) {
    // first cluster of file so link to directory entry
    dir_t *d = cacheDirEntry(dirEntryIndex_, CACHE_FOR_WRITE);
    if (!d) return 0;
    d->firstClusterLow = freeCluster;
    firstCluster_ = freeCluster;
  }
  //link freeCluster to chain and mark it as allocated in each FAT
  for (uint8_t i = 0; i < fatCount_; i++) {
    if (writeCluster_ != 0) {
      // link cluster to chain
      if (!(f = cacheFatEntry(writeCluster_, CACHE_FOR_WRITE, i))) return 0;
      *f = freeCluster;
    }
    // mark cluster allocated 
    if (!(f = cacheFatEntry(freeCluster, CACHE_FOR_WRITE, i))) return 0;
    *f = FAT_EOC;
  }
  writeCluster_ = freeCluster;
  return 1;
}
#endif //FAT16_WRITE_SUPPORT
uint8_t Fat16::cacheDataBlock(fat_t cluster, uint8_t blockOfCluster, uint8_t action)
{
  uint32_t lba = dataStartBlock_ + (cluster - 2)*blocksPerCluster_ + blockOfCluster;
  return cacheRawBlock(lba, action);
}

dir_t *Fat16::cacheDirEntry(uint16_t index, uint8_t action)
{
  if (index >= rootDirEntryCount_) return 0;  
  if (!cacheRawBlock(rootDirStartBlock_ + (index >> 4), action)) return 0;
  return &cacheBuffer_.dir[index & 0XF]; 
}

fat_t *Fat16::cacheFatEntry(fat_t cluster, uint8_t action, uint8_t table)
{
  if (cluster > (clusterCount_ + 1)) return 0;  
  uint32_t lba = fatStartBlock_ + (cluster >> 8) + table*blocksPerFat_ ;
  if (!cacheRawBlock(lba, action)) return 0;
  return &cacheBuffer_.fat[cluster & 0XFF];
}
uint8_t Fat16::cacheFlush(void)
{
  if (cacheDirty_) {
#if FAT16_WRITE_SUPPORT 
    if (!rawDev_->writeBlock(cacheBlockNumber_, cacheBuffer_.data)) return 0;
    cacheDirty_ = 0;
#else //FAT16_WRITE_SUPPORT
    //error if dirty with no write support
    return 0;
#endif //FAT16_WRITE_SUPPORT
  }
  return 1;
}

uint8_t Fat16::cacheRawBlock(uint32_t blockNumber, uint8_t action)
{
  if (action == CACHE_ZERO_BLOCK) {
    if (!cacheFlush()) return 0;
    for (uint16_t i = 0; i < sizeof(cacheBuffer_); i++) {
      cacheBuffer_.data[i] = 0;
    }
    cacheBlockNumber_ = blockNumber;
  }
  else if (cacheBlockNumber_ != blockNumber) {
    if (!cacheFlush()) return 0;
    if (!rawDev_->readBlock(blockNumber, cacheBuffer_.data)) return 0;
    cacheBlockNumber_ = blockNumber;
  }
  cacheDirty_ |= action;
  return 1;
}
/**
 *  Closes a file and forces cached data and directory information
 *  to be written to the storage device.
 *
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.
 * Reasons for failure include no file is open or an I/O error. 
 */  
uint8_t Fat16::close(void)
{
#if FAT16_WRITE_SUPPORT
  if (!sync())return 0;
#else //FAT16_WRITE_SUPPORT
  if (!isOpen()) return 0;
#endif //FAT16_WRITE_SUPPORT
  attributes_ = 0;
  return 1;
}
#if FAT16_WRITE_SUPPORT
/**
 * Create and open a new file.
 * 
 * \note This function only creates files in the root directory and
 * only supports short DOS 8.3 names. See open() for more information.
 * 
 * \param[in] fileName a valid DOS 8.3 file name.
 * 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.
 * Reasons for failure include \a fileName contains
 * an invalid DOS 8.3 file name, the FAT volume has not been initialized,
 * a file is already open, the file already exists, the root
 * directory is full or an I/O error. 
 *
 */  
uint8_t Fat16::create(char *fileName)
{
  uint8_t name[11];
  uint16_t index = 0;
  if (isOpen())return 0;
  //error if bad file name
  if (!make83Name(fileName, name)) return 0;
  //error if name exists
  if (findDirEntry(index, name)) return 0;
  index = 0;
  //find unused directory entry
  uint8_t *p = (uint8_t *)findDirEntry(index, 0);
  //error if directory full
  if(!p) return 0;
  //insure created directory entry will be written to storage device
  cacheSetDirty();
  //initialize as empty file
  for (uint8_t i = 0; i < sizeof(dir_t); i++) {
    p[i] = i < sizeof(name) ? name[i] : 0;
  }
  // open entry
  return open(index);
}
#endif //FAT16_WRITE_SUPPORT
//
dir_t *Fat16::findDirEntry(uint16_t &entry, uint8_t *name, uint8_t skip)
{
  if(!volumeInitialized_) return 0;
  uint16_t index = entry;
  dir_t *d;
  for(; ; index++) {
    if (index >= rootDirEntryCount_) return 0;
    if(!(d = cacheDirEntry(index))) return 0;    
    if (name == 0) {
      // done if unused entry
      if (d->name[0] == DIR_NAME_FREE || d->name[0] == DIR_NAME_DELETED) break;      
    }
    else {
      // done if beyond last used entry
      if (d->name[0] == DIR_NAME_FREE) return 0;
      // skip deleted entry
      if (d->name[0] == DIR_NAME_DELETED) continue;
      // skip long names
      if ((d->attributes & DIR_ATT_LONG_NAME_MASK) == DIR_ATT_LONG_NAME) continue;
      // skip if attribute match
      if (d->attributes & skip) continue;
      // done if no name
      if (name[0] == '\0') break;
      //check for match of name and extension
      uint8_t i;
      for (i = 10; d->name[i] == name[i] && i > 0; i--);
      if(i == 0)break;  
    }
  }
  entry = index;
  return d;
}
/**
 *  Initialize a FAT16 volume.
 *  
 * \param[in] dev The BlockDevice where the volume is located.
 *
 * \param[in] part The partition to be used.  Legal values for \a part are
 * 1-4 to use the corresponding partition on a device formatted with 
 * a MBR, Master Boot Record, or zero if the device is formatted as
 * a super floppy with the FAT boot sector in block zero.
 *  
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.  reasons for
 * failure include not finding a valid FAT16 file system in the
 * specified partition, a call to init() after a volume has
 * been successful initialized or an I/O error.
 *
 */  
uint8_t Fat16::init(BlockDevice &dev, uint8_t part)
{
 //error if volume already open or invalid partition
  if (volumeInitialized_ || part > 4) return 0;
  rawDev_ = &dev;
  uint32_t volumeStartBlock = 0;
  // if part == 0 assume super floppy with FAT16 boot sector in block zero
  // if part > 0 assume mbr volume with partition table 
  if (part) {
    if (!cacheRawBlock(volumeStartBlock)) return 0;
    volumeStartBlock = cacheBuffer_.mbr.part[part - 1].firstSector;
  }
  if (!cacheRawBlock(volumeStartBlock)) return 0;
  //check boot block signature
  if (cacheBuffer_.data[510] != BOOTSIG0 ||
      cacheBuffer_.data[511] != BOOTSIG1) return 0;
  bpb_t *bpb = &cacheBuffer_.fbs.bpb;
  fatCount_ = bpb->fatCount;
  blocksPerCluster_ = bpb->sectorsPerCluster;
  blocksPerFat_ = bpb->sectorsPerFat16;
  rootDirEntryCount_ = bpb->rootDirEntryCount;
  fatStartBlock_ = volumeStartBlock + bpb->reservedSectorCount;
  rootDirStartBlock_ = fatStartBlock_ + bpb->fatCount*bpb->sectorsPerFat16;
  dataStartBlock_ = rootDirStartBlock_ + ((32*bpb->rootDirEntryCount + 511)/512);
  uint32_t totalBlocks = bpb->totalSectors16 ? 
                               bpb->totalSectors16 : bpb->totalSectors32;
  clusterCount_ = (totalBlocks - (dataStartBlock_ - volumeStartBlock))
                  /bpb->sectorsPerCluster;
  //verify valid FAT16 volume
  if (bpb->bytesPerSector != 512      //only allow 512 byte blocks
     || bpb->sectorsPerFat16 == 0     //zero for FAT32
     || clusterCount_ < 4085          //FAT12 if true
     || totalBlocks > 0X800000        //Max size for FAT16 volume
     || bpb->reservedSectorCount == 0 //invalid volume
     || bpb->fatCount == 0            //invalid volume
     || bpb->sectorsPerFat16 < (clusterCount_ >> 8) //invalid volume
     || bpb->sectorsPerCluster == 0   //invalid volume
     || bpb->sectorsPerCluster & (bpb->sectorsPerCluster - 1)) {//power of 2 test
    //not a usable FAT16 bpb
    return 0;
  }
  volumeInitialized_ = 1;
  return 1;
}
/**
 * Open a file for read and write by file name.  Two file positions are
 * maintained.  The write position is at the end of the file.  Data is
 * appended to the file. The read position starts at the beginning of the file.
 * 
 *\note The file must be in the root directory and must have a DOS
 * 8.3 name. 
 * 
 * \param[in] fileName A valid 8.3 DOS name for a file in the root directory.
 * 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.
 * Reasons for failure include the FAT volume has not been initialized,
 * a file is already open, \a fileName is invalid, the file does not
 * exist or it is a directory.  
 */  
uint8_t Fat16::open(char *fileName)
{
  uint8_t name[11];
  // error if invalid name
  if (!make83Name(fileName, name)) return 0;
  // start search at start of root directory
  uint16_t index = 0;
  // error if name not found
  if(!findDirEntry(index, name)) return 0;
  // open found entry
  return open(index);
}
/**
 * Open a file for read and write by file index.  Two file positions are
 * maintained.  The write position is at the end of the file.  Data is
 * appended to the file. The read position starts at the beginning of the file.
 * 
 * \param[in] index The root directory index of the file to be opened.  See \link
 *  Fat16::readDir() readDir()\endlink.
 * 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.
 * Reasons for failure include the FAT volume has not been initialized,
 * a file is already open, \a index is invalid or is not the index of a
 * file.  
 */    
uint8_t Fat16::open(uint16_t index)
{
  if (isOpen() || !volumeInitialized_ )return 0;
  dir_t *d = cacheDirEntry(index);
  // if bad file index or I/O error
  if (!d) return 0;
  // error if unused entry
  if (d->name[0] == DIR_NAME_FREE || d->name[0] == DIR_NAME_DELETED) return 0;
  //error if long name, volume label or subdirectory
  if ((d->attributes & (DIR_ATT_VOLUME_ID | DIR_ATT_DIRECTORY)) != 0) return 0; 
  attributes_ = d->attributes & ATTR_DIR_MASK; 
  firstCluster_ = d->firstClusterLow;
  fileSize_ = d->fileSize; 
#if FAT16_READ_SUPPORT
  readCluster_ = 0;
  readPosition_ = 0;
#endif //FAT16_READ_SUPPORT
#if FAT16_WRITE_SUPPORT
  if (fileSize_ == 0) {
    writeCluster_ = 0;
  }
  else {
    // find cluster for end of file
    writeCluster_ = firstCluster_;
    //assumes 512 byte blocks
    uint16_t n = fileSize_/(blocksPerCluster_ << 9);
    while (n-- > 0) {
      writeCluster_ = nextCluster(writeCluster_);
      // return error if bad cluster chain
      if (writeCluster_ < 2 || isEOC(writeCluster_)) return 0;
    }
  }
  #endif //FAT16_WRITE_SUPPORT
  // set file open
  attributes_ |= ATTR_IS_OPEN;
  dirEntryIndex_ = index;
  #if FAT16_WRITE_SUPPORT
  return sync();
  #else //FAT16_WRITE_SUPPORT
  return 1;
  #endif //FAT16_WRITE_SUPPORT
}
//get next cluster in chain
fat_t Fat16::nextCluster(fat_t cluster)
{
  fat_t *f;
  if (!(f = cacheFatEntry(cluster))) return 0;
  return *f;
}
#if FAT16_READ_SUPPORT
/**
 * Read the next byte from a file.
 *  
 * \return For success read returns the next byte in the file as an int.
 * If an error occurs or end of file is reached -1 is returned.
 */ 
int16_t Fat16::read(void)
{
  uint8_t b;
  return read(&b, 1) == 1 ? b : -1;
}
/**
 * Read data from a file at starting at the current read position.
 * 
 * \param[out] dst Pointer to the location that will receive the data.
 * 
 * \param[in] count Maximum number of bytes to read.
 * 
 * \return For success read returns the number of bytes read.
 * A value less than \a count, including zero, may be returned
 * if end of file is reached. 
 * If an error occurs, read returns -1.  Possible errors include
 * read called before a file has been opened, corrupt file system
 * or I/O error.
 */ 
int16_t Fat16::read(uint8_t *dst, uint16_t count)
{
  if (!isOpen()) return -1;
  // don't read beyond end of file
  if (readPosition_ + count > fileSize_) count = fileSize_ - readPosition_;
  uint16_t nToRead = count;
  while (nToRead > 0) {
    uint8_t blkOfCluster = blockOfCluster(readPosition_);
    uint16_t blockOffset = cacheDataOffset(readPosition_);
    if (blkOfCluster == 0 && blockOffset == 0) {
      // start next cluster
      readCluster_ = readCluster_ ? nextCluster(readCluster_) : firstCluster_;
      // return error if bad cluster chain
      if (readCluster_ < 2 || isEOC(readCluster_)) return -1;
    }
    if (!cacheDataBlock(readCluster_, blkOfCluster)) return -1;
    // max number of byte available in block
    uint16_t n = 512 - blockOffset;
    //lesser of available and amount to read
    if(n > nToRead) n = nToRead;
    uint8_t *src = cacheBuffer_.data + blockOffset;
    uint8_t *end = src + n;
    while (src != end) *dst++ = *src++;
    nToRead -= n;
    readPosition_ += n;
  }
  return count; 
}
#endif //FAT16_READ_SUPPORT
#if FAT16_SEEK_SUPPORT & FAT16_READ_SUPPORT
/**
 * Sets the file's read position.
 *
 * \param[in] pos The new read position in bytes from the beginning of the file.
 * 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.   
 */

uint8_t Fat16::seek(uint32_t pos)
{
  // error if file not open or seek past end of file
  if (!isOpen() || pos > fileSize_) return 0;
  if (pos == 0) {
    //set position to start of file
    readCluster_ = 0;
  }
  else {
    // find cluster for new read position
    fat_t tmpCluster = firstCluster_;
    uint16_t n = pos/(blocksPerCluster_ << 9);
    while (n-- > 0) {
      tmpCluster = nextCluster(tmpCluster);
      // return error if bad cluster chain
      if (tmpCluster < 2 || isEOC(tmpCluster)) return 0;
    }
    readCluster_ = tmpCluster;
  }
  readPosition_ = pos;
  return 1;
}
#endif //FAT16_SEEK_SUPPORT & FAT16_READ_SUPPORT

#if FAT16_WRITE_SUPPORT
/**
 *  The sync() call causes all modified data and directory fields
 *  to be written to the storage device.
 *
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.
 * Reasons for failure include a call to sync() before a file has been
 * opened or an I/O error.   
 */  
uint8_t Fat16::sync(void)
{
  dir_t *d;
  if (!isOpen()) return 0;
  if (attributes_ & ATTR_FILE_SIZE_DIRTY) {
    // update file size
    if(!(d = cacheDirEntry(dirEntryIndex_, CACHE_FOR_WRITE))) return 0;
    d->fileSize = fileSize_;
    attributes_ &= ~ATTR_FILE_SIZE_DIRTY;
  }
  return cacheFlush();
}
  /**
 * Append one byte to a file.  This function is called by Arduino's Print class.
 *
 * \note The byte is moved to the cache but may not be written to the
 * storage device until sync() is called.
 *
 * \param[in] b The byte to be written. 
 */ 
void Fat16::write(uint8_t b)
{
  write(&b, 1);
}
/**
 * Write data at the end of an open file.
 * 
 * \note Data is moved to the cache but may not be written to the
 * storage device until sync() is called.   
 * 
 * \param[in] src Pointer to the location of the data to be written.
 * 
 * \param[in] count Number of bytes to write.
 * 
 * \return For success write() returns the number of bytes written, always
 * \a count.  If an error occurs, write() returns -1.  Possible errors
 * include write() is called before a file has been opened, write is called
 * for a read-only file, device is full, a corrupt file system or an I/O error. 
 *
 */   
int16_t Fat16::write(uint8_t *src, uint16_t count)
{
  if (!isOpen()) return -1;
  //error if file is read only
  if (attributes_ & DIR_ATT_READ_ONLY) return -1;
  uint16_t nToWrite = count;
  while (nToWrite > 0) {
    uint8_t blkOfCluster = blockOfCluster(fileSize_);
    uint16_t blockOffset = cacheDataOffset(fileSize_);
    if (blkOfCluster == 0 && blockOffset == 0) {
      //start of new cluster
      if (writeCluster_ == 0) {
        if (firstCluster_ == 0) {
          // allocate first cluster of file
          if (!addCluster()) return -1;
        }
        else {
          // only happens if empty file has allocated clusters
          writeCluster_ = firstCluster_;
        }
      }
      else {
        uint16_t next = nextCluster(writeCluster_);
        if (isEOC(next)) {
          // add cluster if at end of chain
          if (!addCluster()) return -1;        
        }
        else {
          // error in cluster chain
          if(next < 2) return -1;
          // only happens if file has extra allocated clusters
          writeCluster_ = next;
        }
      }
    }
    // just zero cache if start of new block otherwise read block into cache
    uint8_t action = blockOffset == 0 ? CACHE_ZERO_BLOCK : CACHE_FOR_WRITE;
    if (!cacheDataBlock(writeCluster_, blkOfCluster, action)) return -1;
    // max space in block
    uint16_t n = 512 - blockOffset;
    // lesser of space and amount to write
    if(n > nToWrite) n = nToWrite;
    uint8_t *dst = cacheBuffer_.data + blockOffset;
    uint8_t *end = dst + n;
    while (dst != end) *dst++ = *src++;
    nToWrite -= n;
    // update fileSize and insure sync will update dir entry
    fileSize_ += n;
    attributes_ |= ATTR_FILE_SIZE_DIRTY;
  }
  return count - nToWrite;
}
#endif //FAT16_WRITE_SUPPORT
