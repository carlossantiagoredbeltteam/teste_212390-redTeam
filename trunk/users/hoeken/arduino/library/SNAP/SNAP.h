#ifndef SNAP_h
#define SNAP_h

// include types & constants of Wiring core API
#include "WConstants.h"
#include "HardwareSerial.h"

//how many devices we have on this meta device
#define MAX_DEVICE_COUNT 5        // size of our array to store virtual addresses
#define TX_BUFFER_SIZE 16        // Transmit buffer size.
#define RX_BUFFER_SIZE 16        // Receive buffer size.

//our sync packet value.
#define SNAP_SYNC 0x54

//The defines below are for error checking and such.
//Bit0 is for serialError-flag for checking if an serial error has occured,
//  if set, we will reset the communication
//Bit1 is set if we are currently transmitting a message, that means bytes of 
//  a message have been put in the transmitBuffer, but the message is not 
//  finished.
//Bit2 is set if we are currently building a send-message
//Bit3 is set if we are busy with the last command and have to abort the message
//Bit4 is set when we have a wrong uartState
//Bit5 is set when we receive a wrong byte
//Bit6 is set if we have to acknowledge a received message
//Bit7 is set if we have received a message for local processing
#define serialErrorBit          B00000001
#define inTransmitMsgBit        B00000010
#define inSendQueueMsgBit       B00000100
#define msgAbortedBit           B00001000
#define wrongStateErrorBit      B00010000
#define wrongByteErrorBit       B00100000
#define ackRequestedBit         B01000000
#define processingLockBit       B10000000

//these are the states for processing a packet.
enum SNAP_states {
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

class SNAP
{
 public:
  SNAP();
                
  void addDevice(byte b);

  void receivePacket();
  void receiveByte(byte b);

  bool packetReady();

  byte getDestination();
  byte getSource();
  byte getPacketLength();
  byte getByte(byte index);
  int getInt(byte index); // get 16 bits

  void sendReply();
  void sendMessage(byte dest);
  void sendDataByte(byte c);
  void sendDataInt(int data);
  void endMessage();

  void releaseLock();

 private:
  void receiveError();
  bool hasDevice(byte b);
  void transmit(byte c);
  byte computeCRC(byte c);
                
  byte packetState;               // Current SNAP packet state
  byte in_hdb1;                   // Temporary buffers needed to
  byte in_hdb2;                   // pass packets on from various states
  byte packetLength;              // Length of packet being received
  byte destAddress;               // Destination of packet being received
  byte sourceAddress;             // Source of packet being received
  byte crc;                       // Incrementally calculated CRC value
  byte serialStatus;              // flags for checking status of the serial-communication

  byte rxBufferIndex;                                // Current receive buffer index
  byte rxBuffer[RX_BUFFER_SIZE];        // Receive buffer
                
  // This buffer stores the last complete packet body (not the headers
  // as they can be reconstructed).  This is to allow automatic re-sending
  // if a NAK is received.
  byte txBuffer[TX_BUFFER_SIZE];        // Last packet data, for auto resending on a NAK
  byte txDestination;                                // Last packet destination
  byte txLength;                                        // Last packet length
                
  // When sending a packet this is set to 0 and incremented for
  // every NAK.  After too many have occurred, the packet is just
  // dropped.
  byte nakCount;

  // General flags:
  // @bug these should be "sbit" rather than "byte" but sdcc is breaking a bit
  bool ackRequested;

  // the address of our internal device sending message
  byte deviceAddresses[MAX_DEVICE_COUNT];
  byte deviceCount;
};

#endif
