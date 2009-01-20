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
#include <stdint.h>
#include "Fat16Config.h"
#include "SdCard.h"
#include "spiBus.h"
#include "sdInfo.h"

#define CMD0     0X00      //GO_IDLE_STATE - init card spi mode if CS low
#define CMD9     0X09      //SEND_CSD
#define CMD16    0X10      //SET_BLKLEN
#define CMD17    0X11      //READ_BLOCK
#define CMD24    0X18      //WRITE_BLOCK
#define CMD55    0X37      //APP_CMD - escape for application specific command
#define ACMD41   0X29      //SD_SEND_OP_COMD
//
#define R1_READY_STATE 0
#define R1_IDLE_STATE  1
//start data token for read or write
#define DATA_START_BLOCK      0XFE
//data response tokens for write block
#define DATA_RES_MASK         0X1F
#define DATA_RES_ACCEPTED     0X05
#define DATA_RES_CRC_ERROR    0X0B
#define DATA_RES_WRITE_ERROR  0X0D

static uint8_t cardCommand(uint8_t cmd, uint32_t arg)
{
  uint8_t r1;
  // some cards need extra clocks after transaction to go to ready state
  // easiest to put extra clocks before next transaction
  spiRec();
  spiSend(cmd | 0x40);
  for (int8_t s = 24; s >= 0; s -= 8) spiSend(arg >> s);
  spiSend(cmd == CMD0 ? 0x95 : 0XFF);//must send valid CRC for CMD0
  //wait for not busy
  for (uint8_t retry = 0; (r1 = spiRec()) == 0xFF && retry != 0XFF; retry++);
  return r1;
}

static uint8_t readTransfer(uint8_t *dst, uint16_t count)
{
  //wait for start of data
  for (uint16_t retry = 0; spiRec() != DATA_START_BLOCK; retry++) {
    if (retry == 0XFFFF) {
      spiSSHigh();
      return 0;
    }
  }
  //transfer data
  for (uint16_t i = 0; i < count; i++) {
    dst[i] = spiRec();
  }
  spiRec();//first CRC byte
  spiRec();//second CRC byte
  spiSSHigh();
  return 1;
  }
//
#if SD_CARD_SIZE_SUPPORT
/**
 * Determine the size of a standard SD flash memory card
 * \return The number of 512 byte data blocks in the card
 */ 
uint32_t SdCard::cardSize(void)
{
  csd_t csd;
  spiSSLow();
  if (cardCommand(CMD9, 0)) {
    spiSSHigh();
    return 0;
  }
  if (!readTransfer((uint8_t *)&csd, sizeof(csd))) return 0;
  uint8_t read_bl_len = csd.read_bl_len;
  uint16_t c_size = (csd.c_size_high << 10) | (csd.c_size_mid << 2) | csd.c_size_low;
  uint8_t c_size_mult = (csd.c_size_mult_high << 1) | csd.c_size_mult_low;
  return (uint32_t)(c_size+1) << (c_size_mult + read_bl_len - 7);
}
#endif //SD_CARD_SIZE_SUPPORT
/**
 * Initialize a SD flash memory card.
 * 
* \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure. 
 *
 */  
uint8_t SdCard::init(void)
{
  spiInit();
  //must supply min of 74 clock cycles with CS high.
  for (uint8_t i = 0; i < 10; i++) spiSend(0XFF);
  spiSSLow();
  uint8_t r = cardCommand(CMD0, 0);
  for (uint16_t retry = 0; r != R1_IDLE_STATE; retry++){
    if (retry == 0XFFFF) {
      spiSSHigh();
      return 0;
    }
    r = spiRec();
  }
  for (uint16_t retry = 0; ; retry++) {
    cardCommand(CMD55, 0);
    if (cardCommand(ACMD41, 0) == R1_READY_STATE)break;
    if (retry == 1000) {
      spiSSHigh();
      return 0;
    }
  }
  //use max SPI frequency
  spiMaxSpeed();
  //set block length to 512 (not required? default is 512)
  r =  cardCommand(CMD16, 512) ? 0 : 1;
  spiSSHigh();
  return r;
return 1;
}
/**
 * Reads a 512 byte block from a storage device.
 *  
 * \param[in] blockNumber Logical block to be read.
 * \param[out] dst Pointer to the location that will receive the data. 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.      
 */
uint8_t SdCard::readBlock(uint32_t blockNumber, uint8_t *dst)
{
  spiSSLow();
  if (cardCommand(CMD17, blockNumber << 9)) {
    spiSSHigh();
    return 0;
  }
  return readTransfer(dst, 512);
}
/**
 * Writes a 512 byte block to a storage device.
 *  
 * \param[in] blockNumber Logical block to be written.
 * \param[in] src Pointer to the location of the data to be written. 
 * \return The value one, true, is returned for success and
 * the value zero, false, is returned for failure.      
 */   
uint8_t SdCard::writeBlock(uint32_t blockNumber, uint8_t *src)
{
#if FAT16_WRITE_SUPPORT
  uint32_t address = blockNumber << 9;
#if SD_PROTECT_BLOCK_ZERO
  //don't allow write to first block
  if (address == 0) return 0;
#endif //SD_PROTECT_BLOCK_ZERO
  spiSSLow();
  if (cardCommand(CMD24, address)) {
    spiSSHigh();
    return 0;
  }
  spiSend(DATA_START_BLOCK);
  //transfer block
  for (uint16_t i = 0; i < 512; i++) {
    spiSend(src[i]);
  }
  spiSend(0xff);// dummy crc
  spiSend(0xff);// dummy crc
  uint8_t r1 = spiRec();
  if ((r1 & DATA_RES_MASK) != DATA_RES_ACCEPTED) return 0;
  // wait for card to complete write programming
  for (uint16_t retry = 0; spiRec() != 0XFF ; retry++) {
    if (retry == 0XFFFF) {
      spiSSHigh();
      return 0;
    }
  }
  spiSSHigh();
  return 1;
#else //FAT16_WRITE_SUPPORT
  return 0;
#endif // FAT16_WRITE_SUPPORT
}
#if SD_CARD_READ_REG_SUPPORT
uint8_t SdCard::readReg(uint8_t cmd, uint8_t *dst, uint16_t count)
{
  spiSSLow();
  if (cardCommand(cmd, 0)) {
    spiSSHigh();
    return 0;
  }
  return readTransfer(dst, count);
}
#endif//SD_CARD_READ_REG_SUPPORT
