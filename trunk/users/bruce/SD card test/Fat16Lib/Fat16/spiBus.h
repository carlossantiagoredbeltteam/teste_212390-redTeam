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
#ifndef spiBus_h
#define spiBus_h
#include <stdint.h>
#define SS   4
#define MOSI 5
#define MISO 6
#define SCK  7
void spiInit(void);
uint8_t spiRec(void);
void spiSend(uint8_t b);
void spiMaxSpeed(void);
void spiSSHigh(void);
void spiSSLow(void);
#endif //spiBus_h
