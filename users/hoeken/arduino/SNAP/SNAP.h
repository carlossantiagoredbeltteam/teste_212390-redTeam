/*
 *
 * RepRap, The Replicating Rapid Prototyper Project
 *
 * http://reprap.org/
 *
 * RepRap is copyright (C) 2005-7 University of Bath, the RepRap
 * researchers (see the project's People webpage), and other contributors.
 *
 * RepRap is free; you can redistribute it and/or modify it under the
 * terms of the GNU Library General Public Licence as published by the
 * Free Software Foundation; either version 2 of the Licence, or (at your
 * option) any later version.
 *
 * RepRap is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
 * Licence for more details.
 *
 * For this purpose the words "software" and "library" in the GNU Library
 * General Public Licence are taken to mean any and all computer programs
 * computer files data results documents and other copyright information
 * available from the RepRap project.
 *
 * You should have received a copy of the GNU Library General Public
 * Licence along with RepRap (in reports, it will be one of the
 * appendices, for example); if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA, or see
 *
 * http://www.gnu.org/
 *
 */

#ifndef SNAP_h
#define SNAP_h

// include types & constants of Wiring core API
#include "WConstants.h"
#include "HardwareSerial.h"

//how many devices we have on this meta device
#ifndef MAX_DEVICE_COUNT
	#define MAX_DEVICE_COUNT 3
#endif

// Transmit buffer size.
#ifndef RX_BUFFER_SIZE
	#define RX_BUFFER_SIZE 16
#endif

// Size of largest possible message.
#ifndef TX_BUFFER_SIZE
	#define TX_BUFFER_SIZE 16
#endif

#define SNAP_SYNC B01010100

enum {
  SNAP_idle = 0x30,
  SNAP_haveSync,
  SNAP_haveHDB2,
  SNAP_haveHDB1,
  SNAP_haveDAB,
  SNAP_readingData,
  SNAP_dataComplete,

  // The *Pass states below represent states where
  // we should just be passing the data on to the next node.
  // This is either because we bailed out, or because the
  // packet wasn't destined for us.
  SNAP_haveHDB2Pass,
  SNAP_haveHDB1Pass,
  SNAP_haveDABPass,
  SNAP_readingDataPass
};

class SNAP {
	public:
		SNAP(void);
		
		void receiveByte(byte b);
		void addDevice(byte b);
		void releaseLock();
		
		void sendReply();
		void sendDataByte(byte c);
		void sendMessage(byte dest);
		void endMessage();
		
		byte packetReady();
		byte getByte(byte index);
		byte getPacketLength();
		byte getDestination();
		byte getSource();

		
	private:
		
		bool hasDevice(byte b);
		void transmit(byte c);
		byte computeCRC(byte c);
		
		byte uartState;		// Current SNAP state machine state
		byte in_hdb1;					// Temporary buffers needed to
		byte in_hdb2;					// pass packets on from various states
		byte packetLength;				// Length of packet being received
		byte destAddress;				// Destination of packet being received
		byte sourceAddress;				// Source of packet being received
		byte receivedSourceAddress;		// Source of packet previously received
		byte crc;						// Incrementally calculated CRC value

		byte rxBufferIndex;				// Current receive buffer index
		byte rxBuffer[RX_BUFFER_SIZE];	// Receive buffer
		
		// This buffer stores the last complete packet body (not the headers
		// as they can be reconstructed).  This is to allow automatic re-sending
		// if a NAK is received.
		byte sendPacket[TX_BUFFER_SIZE];	// Last packet data, for auto resending on a NAK
		byte sendPacketDestination;			// Last packet destination
		byte sendPacketLength;				// Last packet length
		
		// When sending a packet this is set to 0 and incremented for
		// every NAK.  After too many have occurred, the packet is just
		// dropped.
		byte nakCount;

		// General flags:
		// @bug these should be "sbit" rather than "byte" but sdcc is breaking a bit
		byte processingLock;
		byte ackRequested;

		// the address of our internal device sending message
		byte deviceAddresses[MAX_DEVICE_COUNT];
		byte deviceCount;
};

#endif
