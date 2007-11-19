

#include "SNAP.h"
#include "WConstants.h"

SNAP::SNAP(void)
{
	packetState = SNAP_idle;
	processingLock = false;
	deviceCount = 0;
	serialStatus = 0;
	crc = 0;
}

void SNAP::receiveError()
{
	byte i;

	if (serialStatus & msgAbortedBit == 0)
	{
		//wipe the corrupt-message out of the receive-buffers of the nodes
		for (i=0; i<8; i++)
		{
			//if we are sending too much for the transmit-buffer, it is discarded
			this->transmit(0);
		}
	}
	
	//clear all bits except msgAbortedBit;
	serialStatus = serialStatus & msgAbortedBit;
	
	packetState = SNAP_idle;
}

void SNAP::receiveByte(byte c)
{
	if (serialStatus & serialErrorBit)
	{
		this->receiveError();
		return;
	}
  
	switch(packetState)
	{
		case SNAP_idle:
		    // In the idle state, we wait for a sync byte.  If none is
		    // received, we remain in this state.
		    if (c == SNAP_SYNC)
			{
		      packetState = SNAP_haveSync;
		      serialStatus &= ~msgAbortedBit; //clear
		    }
			break;

		case SNAP_haveSync:
			// In this state we are waiting for header definition bytes. First
			// HDB2.  We currently insist that all packets meet our expected
			// format which is 1 byte destination address, 1 byte source
			// address, and no protocol specific bytes.  The ACK/NAK bits may
			// be anything.
			in_hdb2 = c;
			if ((c & B11111100) != B01010000)
			{
				// Unsupported header.  Drop it an reset
				serialStatus |= serialErrorBit;  //set serialError
				serialStatus |= wrongByteErrorBit; 
				this->receiveError();
			}
			else
			{
				// All is well
				if ((c & B00000011) == B00000001)
					serialStatus |= ackRequestedBit;  //set ackRequested-Bit
				else
					serialStatus &= ~ackRequestedBit; //clear

				crc = 0;
				this->computeCRC(c);

				packetState = SNAP_haveHDB2;
			}
			break;

		case SNAP_haveHDB2:
			// For HDB1, we insist on high bits are 0011 and low bits are the length 
			//   of the payload.
			in_hdb1 = c;
			if ((c & B11110000) != B00110000)
			{
				serialStatus |= serialErrorBit;  //set serialError
				serialStatus |= wrongByteErrorBit; 
				this->receiveError();
			}
			else
			{
				packetLength = c & 0x0f;
				if (packetLength > RX_BUFFER_SIZE)
					packetLength = RX_BUFFER_SIZE;
				
				this->computeCRC(c);
				
				packetState = SNAP_haveHDB1;
			}
			break;

		case SNAP_haveHDB1:
			// We should be reading the destination address now
			if (!this->hasDevice(c))
			{
				this->transmit(SNAP_SYNC);
				this->transmit(in_hdb2);
				this->transmit(in_hdb1);
				this->transmit(c);
				packetState = SNAP_haveDABPass;
				serialStatus &= ~ackRequestedBit; //clear
				serialStatus |= inTransmitMsgBit; 
			}
			else
			{
				//save our address, as we may have multiple addresses on one arduino.
				destAddress = c;
				
				this->computeCRC(c);
				packetState = SNAP_haveDAB;
			}
			break;

		case SNAP_haveDAB:
			// We should be reading the source address now
			if (this->hasDevice(c))
			{
				// If we receive a packet from ourselves, that means it went
				// around the ring and was never picked up, ie the device we
				// sent to is off-line or unavailable.

				/// @todo Deal with this situation
			}
			
			if (serialStatus & processingLockBit)
			{
				//we have not finished the last order, reject
				this->transmit(SNAP_SYNC);
				crc = 0;
				
				this->transmit(computeCRC(B01010011));	//HDB2
				this->transmit(computeCRC(B00110000));	// HDB1: 0 bytes, with 8 bit CRC
				this->transmit(computeCRC(sourceAddress));	// Return to sender
				this->transmit(computeCRC(destAddress));	// From us
				this->transmit(crc);  // CRC

				serialStatus &= ~ackRequestedBit; //clear
				serialStatus |= msgAbortedBit; //set

				packetState = SNAP_idle;
			}
			else
			{
				sourceAddress = c;
				rxBufferIndex = 0;
				this->computeCRC(c);

				packetState = SNAP_readingData;
			}
			break;

		case SNAP_readingData:
			rxBuffer[rxBufferIndex] = c;
			rxBufferIndex++;

			this->computeCRC(c);

			if (rxBufferIndex == packetLength)
				packetState = SNAP_dataComplete;
			break;

		case SNAP_dataComplete:
			// We should be receiving a CRC after data, and it
			// should match what we have already computed
			{
				byte hdb2 = B01010000; // 1 byte addresses

				if (c == crc)
				{
					// All is good, so process the command.  Rather than calling the
					// appropriate function directly, we just set a flag to say
					// something is ready for processing.  Then in the main loop we
					// detect this and process the command.  This allows further
					// comms processing (such as passing other tokens around the
					// ring) while we're actioning the command.

					hdb2 |= B00000010;
					serialStatus |= processingLockBit;  //set processingLockBit
					receivedSourceAddress = sourceAddress;
				}
				else
				{
					// CRC mismatch, so we will NAK the packet
					hdb2 |= B00000011;
				}
				
				if (serialStatus & ackRequestedBit)
				{
					// Send ACK or NAK back to source
					this->transmit(SNAP_SYNC);
					crc = 0;
					this->transmit(this->computeCRC(hdb2));
					this->transmit(this->computeCRC(B00110000));	// HDB1: 0 bytes, with 8 bit CRC
					this->transmit(this->computeCRC(sourceAddress));	// Return to sender
					this->transmit(this->computeCRC(destAddress));	// From us
					this->transmit(crc);  						// CRC
					serialStatus &= ~ackRequestedBit;			//clear
				}
			}
			
			packetState = SNAP_idle;
			break;

		case SNAP_haveHDB2Pass:
		    this->transmit(c);  // We will be reading HDB1; pass it on

		    packetLength = c & 0x0f;
		    if (packetLength > RX_BUFFER_SIZE)
		      packetLength = RX_BUFFER_SIZE;

		    packetState = SNAP_haveHDB1Pass;
			break;

		case SNAP_haveHDB1Pass:
		    this->transmit(c);  // We will be reading dest addr; pass it on
		    packetState = SNAP_haveDABPass;
			break;

		case SNAP_haveDABPass:
				this->transmit(c);  // We will be reading source addr; pass it on

				// Increment data length by 1 so that we just copy the CRC
				// at the end as well.
				packetLength++;

				packetState = SNAP_readingDataPass;
			break;

		case SNAP_readingDataPass:
			this->transmit(c);  // This is a data byte; pass it on
			if (packetLength > 1)
				packetLength--;
			else
			{
				packetState = SNAP_idle;
				serialStatus &= ~inTransmitMsgBit; //clear
			}
			break;
			
	  default:
	    serialStatus |= serialErrorBit;  //set serialError
	    serialStatus |= wrongStateErrorBit;  
	    this->receiveError();
	}
}

void SNAP::addDevice(byte c)
{
	if (deviceCount == MAX_DEVICE_COUNT)
		return;
		
	deviceAddresses[deviceCount] = c;
	deviceCount++;
}

void SNAP::sendReply()
{
	this->sendMessage(receivedSourceAddress);
}

/// High level routine that queues a byte during construction of a packet
void SNAP::sendDataByte(byte c)
{
	// Put byte into packet sending buffer.  Don't calculated CRCs
	// yet as we don't have complete information.

	// Drop if trying to send too much
	if (txLength >= TX_BUFFER_SIZE)
		return;

	txBuffer[txLength] = c;
	txLength++;
}

void SNAP::sendMessage(byte dest)
{
	txDestination = dest;
	txLength = 0;
}

bool SNAP::packetReady()
{
	return processingLock;
}

void SNAP::releaseLock()
{
	processingLock = false;
}

bool SNAP::hasDevice(byte c)
{
	int i;
	
	for (i=0; i<deviceCount; i++)
	{
		if (deviceAddresses[i] == c)
			return true;
	}
	
	return false;
}

void SNAP::transmit(byte c)
{
	Serial.print(c, BYTE);
}

byte SNAP::computeCRC(byte c)
{
	byte i = c ^ crc;

	crc = 0;

	if(i & 1)
		crc ^= 0x5e;
	if(i & 2)
		crc ^= 0xbc;
	if(i & 4)
		crc ^= 0x61;
	if(i & 8)
		crc ^= 0xc2;
	if(i & 0x10)
		crc ^= 0x9d;
	if(i & 0x20)
		crc ^= 0x23;
	if(i & 0x40)
		crc ^= 0x46;
	if(i & 0x80)
		crc ^= 0x8c;

	return c;
}


void SNAP::endMessage()
{
	byte i;
	
    // init our CRC
    crc = 0;

	//here is our header.
    this->transmit(SNAP_SYNC);									// our sync byte
    this->transmit(this->computeCRC(B01010001));				// HDB2 - Request ACK
    this->transmit(this->computeCRC(B00110000 | txLength));		// HDB1 
    this->transmit(this->computeCRC(txDestination));			// Destination
    this->transmit(this->computeCRC(destAddress));				// Source (us)

	//payload.
    for(i=0; i<txLength; i++)
      this->transmit(this->computeCRC(txBuffer[i]));

	//our crc check.
    this->transmit(crc); /// @todo crc here
}
