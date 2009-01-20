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
#include "spiBus.h"
#include "WConstants.h"

void spiInit(void)
{
  pinMode(SS, OUTPUT);
  spiSSHigh();
  pinMode(MOSI, OUTPUT);
  pinMode(SCK, OUTPUT);
  //Enable SPI, Master, clock rate f_osc/128
  SPCR = (1 << SPE) | (1 << MSTR) | (1 << SPR1) | (1 << SPR0);
}
//set speed to f_OSC/2
void spiMaxSpeed(void)
{
  SPCR &= ~((1 << SPR1) | (1 << SPR0)); // f_OSC/4 
  SPSR |= (1 << SPI2X); // Doubled Clock Frequency: f_OSC/2 
}
//clock byte in
uint8_t spiRec(void)
{
  SPDR = 0xff;
  while(!(SPSR & (1 << SPIF)));
  return SPDR;
}
//clock byte out
void spiSend(uint8_t b)
{
  SPDR = b;
  while(!(SPSR & (1 << SPIF)));
}
//set Slave Select HIGH
void spiSSHigh(void)
{
  digitalWrite(SS, HIGH);
}
//set Slave Select LOW
void spiSSLow(void)
{
  digitalWrite(SS, LOW);
}