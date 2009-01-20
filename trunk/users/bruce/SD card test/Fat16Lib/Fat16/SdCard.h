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
#ifndef SdCard_h
#define SdCard_h
#include "BlockDevice.h"
/**
 * \class SdCard
 * \brief Hardware access class for SD flash cards
 *  
 * Supports raw access to a standard SD flash memory card.  
 *
 */  
class SdCard : public  BlockDevice {
uint8_t readReg(uint8_t cmd, uint8_t *dst, uint16_t count);
public:
  uint32_t cardSize(void);
  uint8_t init(void);
  uint8_t readBlock(uint32_t block, uint8_t *dst);
  uint8_t writeBlock(uint32_t block, uint8_t *src);
  //debug functions
#if SD_CARD_READ_REG_SUPPORT
  void dmpCID(void);
  void dmpCSD(void);
#endif //SD_CARD_READ_REG_SUPPORT
};
#endif //SdCard_h