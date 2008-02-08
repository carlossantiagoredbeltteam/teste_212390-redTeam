

#include "SNAP.h"
#include "WConstants.h"

SNAP::SNAP()
{
  this->packetState = SNAP_idle;
  this->deviceCount = 0;
  this->serialStatus = 0;
  crc = 0;
}

void SNAP::begin(long baud)
{
	Serial.begin(baud);
}

void SNAP::receivePacket()
{
  byte cmd;

  while (Serial.available() > 0) {
    cmd = Serial.read();
    this->receiveByte(cmd);
  }
}

void SNAP::receiveError()
{
  byte i;

  if (this->serialStatus & msgAbortedBit == 0) {
    //wipe the corrupt-message out of the receive-buffers of the nodes
    for (i=0; i<8; i++) {
      //if we are sending too much for the transmit-buffer, it is discarded
      this->transmit(0);
    }
  }
  
  //clear all bits except msgAbortedBit;
  this->serialStatus = this->serialStatus & msgAbortedBit;
        
  this->packetState = SNAP_idle;
}

void SNAP::receiveByte(byte c)
{
  if (this->serialStatus & serialErrorBit) {
    this->receiveError();
    return;
  }

  
  switch (this->packetState) {
  case SNAP_idle:
    // In the idle state, we wait for a sync byte.  If none is
    // received, we remain in this state.
    if (c == SNAP_SYNC) {
      this->packetState = SNAP_haveSync;
      this->serialStatus &= ~msgAbortedBit; //clear
    }
    break;

  case SNAP_haveSync:
    // In this state we are waiting for header definition bytes. First
    // HDB2.  We currently insist that all packets meet our expected
    // format which is 1 byte destination address, 1 byte source
    // address, and no protocol specific bytes.  The ACK/NAK bits may
    // be anything.
    this->in_hdb2 = c;
    if ((c & B11111100) != B01010000) {
      // Unsupported header.  Drop it an reset
      this->serialStatus |= serialErrorBit;  //set serialError
      this->serialStatus |= wrongByteErrorBit; 
      this->receiveError();
    }
    else {
      // All is well
      if ((c & B00000011) == B00000001) {
        this->serialStatus |= ackRequestedBit;  //set ackRequested-Bit
      }
      else {
        this->serialStatus &= ~ackRequestedBit; //clear
      }
      crc = 0;
      this->computeCRC(c);

      this->packetState = SNAP_haveHDB2;
    }
    break;

  case SNAP_haveHDB2:
    // For HDB1, we insist on high bits are 0011 and low bits are the length 
    // of the payload.
    this->in_hdb1 = c;
    if ((c & B11110000) != B00110000) {
      this->serialStatus |= serialErrorBit;  //set serialError
      this->serialStatus |= wrongByteErrorBit; 
      this->receiveError();
    }
    else {
      // FIXME: This doesn't correspond to the SNAP specs since the length
      // should become non-linear after 8 bytes. The original reprap code
      // does the same thing though. kintel 20071120.
      this->packetLength = c & 0x0f;
      if (this->packetLength > RX_BUFFER_SIZE) {
        this->packetLength = RX_BUFFER_SIZE;
      }
                                
      this->computeCRC(c);
                                
      this->packetState = SNAP_haveHDB1;
    }
    break;

  case SNAP_haveHDB1:
    // We should be reading the destination address now
    if (!this->hasDevice(c)) {
      this->transmit(SNAP_SYNC);
      this->transmit(this->in_hdb2);
      this->transmit(this->in_hdb1);
      this->transmit(c);
      this->packetState = SNAP_haveDABPass;
      this->serialStatus &= ~ackRequestedBit; //clear
      this->serialStatus |= inTransmitMsgBit; 
    }
    else {
      //save our address, as we may have multiple addresses on one arduino.
      this->destAddress = c;
                                
      this->computeCRC(c);
      this->packetState = SNAP_haveDAB;
    }
    break;

  case SNAP_haveDAB:
    // We should be reading the source address now
    if (this->hasDevice(c)) {
      // If we receive a packet from ourselves, that means it went
      // around the ring and was never picked up, ie the device we
      // sent to is off-line or unavailable.

      // FIXME: Deal with this situation
    }
                        
    if (this->serialStatus & processingLockBit) {
      //we have not finished the last order, reject (send a NAK)
      this->transmit(SNAP_SYNC);
      crc = 0;
                                
      this->transmit(computeCRC(B01010011));        //HDB2: NAK
      this->transmit(computeCRC(B00110000));        // HDB1: 0 bytes, with 8 bit CRC
      this->transmit(computeCRC(this->sourceAddress));        // Return to sender
      this->transmit(computeCRC(this->destAddress));        // From us
      this->transmit(crc);  // CRC

      this->serialStatus &= ~ackRequestedBit; //clear
      this->serialStatus |= msgAbortedBit; //set

      this->packetState = SNAP_idle;
    }
    else {
      this->sourceAddress = c;
      rxBufferIndex = 0;
      this->computeCRC(c);

      this->packetState = SNAP_readingData;
    }
    break;

  case SNAP_readingData:
    rxBuffer[rxBufferIndex] = c;
    rxBufferIndex++;

    this->computeCRC(c);

    if (rxBufferIndex == this->packetLength) {
      this->packetState = SNAP_dataComplete;
    }
    break;

  case SNAP_dataComplete:
    // We should be receiving a CRC after data, and it
    // should match what we have already computed
    {
      byte hdb2 = B01010000; // 1 byte addresses

      if (c == crc) {
        // All is good, so process the command.  Rather than calling the
        // appropriate function directly, we just set a flag to say
        // something is ready for processing.  Then in the main loop we
        // detect this and process the command.  This allows further
        // comms processing (such as passing other tokens around the
        // ring) while we're actioning the command.

        hdb2 |= B00000010;
        this->serialStatus |= processingLockBit;  //set processingLockBit
      }
      else {
        // CRC mismatch, so we will NAK the packet
        hdb2 |= B00000011;
      }
                                
      if (this->serialStatus & ackRequestedBit) {
        // Send ACK or NAK back to source
        this->transmit(SNAP_SYNC);
        crc = 0;
        this->transmit(this->computeCRC(hdb2));
        this->transmit(this->computeCRC(B00110000));        // HDB1: 0 bytes, with 8 bit CRC
        this->transmit(this->computeCRC(this->sourceAddress));        // Return to sender
        this->transmit(this->computeCRC(this->destAddress));        // From us
        this->transmit(crc);                                          // CRC
        this->serialStatus &= ~ackRequestedBit;                        // clear
      }
    }
                        
    this->packetState = SNAP_idle;
    break;

  case SNAP_haveHDB2Pass:
    this->transmit(c);  // We will be reading HDB1; pass it on

    this->packetLength = c & 0x0f;
    if (this->packetLength > RX_BUFFER_SIZE)
      this->packetLength = RX_BUFFER_SIZE;

    this->packetState = SNAP_haveHDB1Pass;
    break;

  case SNAP_haveHDB1Pass:
    this->transmit(c);  // We will be reading dest addr; pass it on
    this->packetState = SNAP_haveDABPass;
    break;

  case SNAP_haveDABPass:
    this->transmit(c);  // We will be reading source addr; pass it on

    // Increment data length by 1 so that we just copy the CRC
    // at the end as well.
    this->packetLength++;

    this->packetState = SNAP_readingDataPass;
    break;

  case SNAP_readingDataPass:
    this->transmit(c);  // This is a data byte; pass it on
    if (this->packetLength > 1)
      this->packetLength--;
    else {
      this->packetState = SNAP_idle;
      this->serialStatus &= ~inTransmitMsgBit; //clear
    }
    break;
                        
  default:
    this->serialStatus |= serialErrorBit;  //set serialError
    this->serialStatus |= wrongStateErrorBit;  
    this->receiveError();
  }
}

void SNAP::addDevice(byte c)
{
  if (this->deviceCount == MAX_DEVICE_COUNT) return;
                
  this->deviceAddresses[this->deviceCount] = c;
  this->deviceCount++;
}

void SNAP::startMessage(byte from)
{
	this->destAddress = from;
	
	//TODO: we probably need something to handle being mid-message
}

/*!
  Initiates a message to whoever we last received a message from
*/
void SNAP::sendReply()
{
  this->sendMessage(this->sourceAddress);
}

/*!
  Initiates a message to dest
*/
void SNAP::sendMessage(byte dest)
{
  this->txDestination = dest;
  this->txLength = 0;
}

/*!
  High level routine that queues a byte during construction of a packet.
*/
void SNAP::sendDataByte(byte c)
{
  // Put byte into packet sending buffer.  Don't calculated CRCs
  // yet as we don't have complete information.

  // Drop if trying to send too much
  if (this->txLength >= TX_BUFFER_SIZE) {
    return;
  }

  this->txBuffer[this->txLength] = c;
  this->txLength++;
}

void SNAP::sendDataInt(int i)
{
	this->sendDataByte(i & 0xff);
	this->sendDataByte(i >> 8);
}

void SNAP::sendDataLong(long i)
{
	this->sendDataByte(i >> 24);
	this->sendDataByte(i >> 16);
	this->sendDataByte(i >> 8);
	this->sendDataByte(i & 0xff);
}


/*!
  Create headers and synchronously transmit the message.
*/
void SNAP::endMessage()
{
  crc = 0;

  //here is our header.
  this->transmit(SNAP_SYNC);
  this->transmit(this->computeCRC(B01010001));                   // HDB2 - Request ACK
  this->transmit(this->computeCRC(B00110000 | this->txLength));  // HDB1 
  // FIXME: This doesn't correspond to the SNAP specs since the length
  // should become non-linear after 8 bytes. The original reprap code
  // does the same thing though. kintel 20071120.
  this->transmit(this->computeCRC(this->txDestination));         // Destination
  this->transmit(this->computeCRC(this->destAddress));           // Source (us)

  //payload.
  for (byte i=0; i<this->txLength; i++)
    this->transmit(this->computeCRC(this->txBuffer[i]));

  this->transmit(crc);
}

bool SNAP::packetReady()
{
	this->receivePacket();
	
	return (this->serialStatus & processingLockBit);
}

/*!
  Must be manually called by the main loop when the message payload
  has been consumed.
*/
void SNAP::releaseLock()
{
  this->serialStatus &= ~processingLockBit;
}

bool SNAP::hasDevice(byte c)
{
  for (int i=0; i<this->deviceCount; i++) {
    if (this->deviceAddresses[i] == c)
      return true;
  }

  return false;
}

void SNAP::transmit(byte c)
{
  Serial.print(c, BYTE);
}

/*!
  Incrementally adds c to crc computation and updates this->crc.
  returns \c.
*/
byte SNAP::computeCRC(byte c)
{
  byte i = c ^ this->crc;

  this->crc = 0;

  if (i & 1) this->crc ^= 0x5e;
  if (i & 2) this->crc ^= 0xbc;
  if (i & 4) this->crc ^= 0x61;
  if (i & 8) this->crc ^= 0xc2;
  if (i & 0x10) this->crc ^= 0x9d;
  if (i & 0x20) this->crc ^= 0x23;
  if (i & 0x40) this->crc ^= 0x46;
  if (i & 0x80) this->crc ^= 0x8c;

  return c;
}


byte SNAP::getDestination()
{
  return this->destAddress;
}

byte SNAP::getSource()
{
  return this->sourceAddress;
}

byte SNAP::getPacketLength()
{
  return this->packetLength;
}

byte SNAP::getByte(byte index)
{
  return this->rxBuffer[index];
}

unsigned int SNAP::getInt(byte index)
{
  return (this->rxBuffer[index+1] << 8) + this->rxBuffer[index];
}

// Preinstantiate Objects
SNAP snap = SNAP();
