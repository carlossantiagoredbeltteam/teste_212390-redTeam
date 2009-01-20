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
#ifndef Fat16_h
#define Fat16_h
#include "BlockDevice.h"
#include "Print.h"
#include "Fat16structs.h"
#include "Fat16Config.h"
/**
 * \typedef fat_t
 *
 * \brief Type fot FAT entry
 */
typedef uint16_t fat_t;
/**
 * \union cache_t
 *  
 * \brief Cache buffer data type
 *
 */  
union cache_t {
          /** Used to access cached file data blocks. */
  uint8_t data[512];
          /** Used to access cached FAT entries. */
  fat_t   fat[256];
          /** Used to access cached directory entries. */
  dir_t   dir[16];
          /** Used to access a cached MasterBoot Record. */
  mbr_t   mbr;
          /** Used to access to a cached FAT16 boot sector. */
  fbs_t   fbs;       
};

/** \class Fat16
 * \brief Fat16 implements a minimal Arduino FAT16 Library
 *  
 * Fat16 does not support subdirectories or long file names. 
 */ 
#if FAT16_WRITE_SUPPORT && FAT16_PRINT_SUPPORT
class Fat16 : public Print {
#else // FAT16_WRITE_SUPPORT
class Fat16 {
#endif //FAT16_WRITE_SUPPORT
  // Device
  static BlockDevice *rawDev_;
  // Volume info
  static uint8_t  volumeInitialized_;  //true if volume has been initialized
  static uint8_t  fatCount_;           //number of FATs
  static uint8_t  blocksPerCluster_;   //must be power of 2, max cluster size 32K
  static uint16_t rootDirEntryCount_;  //should be 512 for FAT16
  static uint16_t blocksPerFat_;       //number of blocks in one FAT
  static uint16_t clusterCount_;       //total clusters in volume
  static uint32_t fatStartBlock_;      //start of first FAT
  static uint32_t rootDirStartBlock_;  //start of root dir
  static uint32_t dataStartBlock_;     //start of data clusters

#define CACHE_FOR_READ   0              //cache a block for read
#define CACHE_FOR_WRITE  1              //cache a block and set dirty for the block
#define CACHE_ZERO_BLOCK 2              //zero the cache and set dirty fot the block

  //block cache
  static cache_t cacheBuffer_;           //512 byte cache for storage device blocks
  static uint32_t cacheBlockNumber_;     //Logical number of block in the cache
  static uint8_t cacheDirty_;            //cacheFlush() will write block if true

  // File info
  
#define ATTR_DIR_MASK        0X3F  //attributes from directory entry
#define ATTR_FILE_SIZE_DIRTY 0X40  //sync of directory entery file size required
#define ATTR_IS_OPEN         0X80  //file open 

  uint8_t attributes_;       //see above ATTR defines
  int16_t dirEntryIndex_;    //index of directory entry for open file
  fat_t firstCluster_;       //first cluster of file
  uint32_t fileSize_;        //fileSize
#if FAT16_READ_SUPPORT
  fat_t readCluster_;        //cluster for read position
  uint32_t readPosition_;    //byte offset for next read
#endif //FAT16_READ_SUPPORT
#if FAT16_WRITE_SUPPORT
  fat_t writeCluster_;       //cluster for write position at end of file
#endif//FAT16_WRITE_SUPPORT
  //private functions for cache
  static uint8_t blockOfCluster(uint32_t position) {
    // depends on blocks per cluster being power of two
    return ((position)>> 9) & (blocksPerCluster_ - 1);}
  static uint16_t cacheDataOffset(uint32_t position) {return position & 0X1FF;}
  static uint8_t cacheDataBlock(fat_t cluster, 
                                uint8_t blockOfCluster, uint8_t action = 0);
  static dir_t *cacheDirEntry(uint16_t index, uint8_t action = 0);
  static fat_t *cacheFatEntry(fat_t cluster, uint8_t action = 0, uint8_t table = 0);
  static uint8_t cacheRawBlock(uint32_t blockNumber, uint8_t action = 0);
  static uint8_t cacheFlush(void);
  static void cacheSetDirty(void) {cacheDirty_ |= CACHE_FOR_WRITE;}
  static uint8_t cacheZeroBlock(uint32_t blockNumber);
  //find and cache a directory entery
  static dir_t *findDirEntry(uint16_t &entry, uint8_t *name,
                             uint8_t skip = DIR_ATT_VOLUME_ID);
  //get next cluster in chain
  static fat_t nextCluster(fat_t cluster);
  //end of chain test
  static uint8_t isEOC(fat_t cluster) {return cluster >= 0XFFF8;}
  //allocate a cluster to a file
  uint8_t addCluster(void);
  /*
   * Public functions
   */
  public:
  //create with file closed
  Fat16(void) : attributes_(0) {}
  static uint8_t init(BlockDevice &dev, uint8_t part);
//  static dir_t *readDir(uint16_t &index, uint8_t skip = DIR_ATT_DIRECTORY);
/**
 *  Read the next short, 8.3, directory entry into the cache buffer.
 *
 *  Unused entries and entries for long names are skipped.
 *
 *  The directory entry must not be modified since the cached block
 *  containing the entry may be written back to the storage device.
 *
 * \param[in,out] entry The search starts at \a entry and \a entry is
 * updated with the root directory index of the found directory entry.
 * If the entry is a file, it may be opened by calling
 * \link Fat16::open(uint16_t) open(entry)\endlink.
 *
 * \param[in] skip Skip entries that have these attributes. If \a skip
 * is not specified, the default is to skip the volume label and directories.
 *
 * \return A pointer to a dir_t structure for the found directory entry,
 * or NULL if an error occurs or the end of the root directory is reached.
 * On success, \a entry is set to the index of the found directory entry.
 */
  static dir_t *readDir(uint16_t &entry,
                    uint8_t skip = (DIR_ATT_VOLUME_ID | DIR_ATT_DIRECTORY)) {
                        return findDirEntry(entry, (uint8_t *)"", skip);}
  /**
   * \return The number of entries in the root directory.
   */     
  static uint16_t rootDirEntryCount(void) {
    return rootDirEntryCount_;}
  //file access functions
  uint8_t close(void);
  uint8_t create(char *fileName);
  /**
   * \return The file's size in bytes.
   * This is also the write position for the file.
   */ 
  uint32_t fileSize(void) {return fileSize_;}
  /**
   * Checks the file's open/closed status for this instance of Fat16. 
   * \return The value true if a file is open otherwise false;
   */     
  uint8_t isOpen(void) {return (attributes_ & ATTR_IS_OPEN) != 0;}
  uint8_t open(char *fileName);
  uint8_t open(uint16_t entry);
#if FAT16_READ_SUPPORT
  int16_t read(void);
  int16_t read(uint8_t *dst, uint16_t count);
  /**
   * \return The read position in bytes.
   */
  uint32_t readPos(void) {return readPosition_;}
  uint8_t seek(uint32_t pos);
#endif //FAT16_READ_SUPPORT  
#if FAT16_WRITE_SUPPORT
  uint8_t sync(void);
  void write(uint8_t b);
  int16_t write(uint8_t *src, uint16_t count);
#endif //FAT16_WRITE_SUPPORT
#if FAT16_DEBUG_SUPPORT
  /** For debug only.  Do not use in applications. */
  static void dbgSetDev(BlockDevice &dev) {rawDev_ = &dev;}
  /** For debug only.  Do not use in applications. */
  static uint8_t *dbgCacheBlock(uint32_t blockNumber) {
    return cacheRawBlock(blockNumber) ? cacheBuffer_.data : 0; }
  /** For debug only.  Do not use in applications. */
  static dir_t *dbgCacheDir(uint16_t index) {
    return cacheDirEntry(index);}
  /** For debug only.  Do not use in applications. */
  static uint16_t *dbgCacheFat(uint16_t cluster) {
    return cacheFatEntry(cluster);}
#endif //FAT16_DEBUG_SUPPORT
};
#endif//Fat16_h
