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
#ifndef BlockDevice_h
#define BlockDevice_h
#include <stdint.h>
/**
 * \class BlockDevice
 *  
 * \brief BlockDevice is the base class for devices supported by Fat16.
 */  
class BlockDevice {
public:
/**
 * Read a 512 byte block from a storage device.
 *  
 * \param[in] blockNumber Logical block to be read.
 * \param[out] dst Pointer to the location that will receive the data. 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.      
 */   
  virtual uint8_t readBlock(uint32_t blockNumber, uint8_t *dst);
/**
 * Write a 512 byte block to a storage device.
 *  
 * \param[in] blockNumber Logical block to be written.
 * \param[in] src Pointer to the location of the data to be written. 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.      
 */   
  virtual uint8_t writeBlock(uint32_t blockNumber, uint8_t *src);
};
#endif //BlockDevice_h
