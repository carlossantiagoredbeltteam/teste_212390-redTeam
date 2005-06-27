
/**
 * Implementation of interrupt driven SNAP communications routines for
 * use in a token ring configuration.  Being completely interrupt
 * driven improves performance and simplifies development of the core
 * logic in each device.  This is not really a true token ring in that
 * there is no token frame and the procedure for ring insertion etc.
 * is trivial -- it is however a network with ring topology.
 *
 * Overview/notes:
 *
 * A receive buffer accepts payload data as it arrives.  Upon
 * completion, a global flag is set that acts as a lock to prevent
 * further receives occuring until the lock is removed.  If a receive
 * does occur, but it is for somebody else, it is passed onto the next
 * node in the loop.  If the receive is for ourself then we fail and
 * NAK the packet so that it will be re-sent at a time we can
 * hopefully act on it.
 *
 * The lock flag also indicates to the main loop that data is awaiting
 * and the main loop is responsible for calling any processing on the
 * data.  It is not called directly by the ISR to prevent re-entrancy
 * problems.  The act of receiving the byte will wake the CPU and
 * allow it to check for the present of the lock.  After processing is
 * complete it may sleep if it wishes.  It will be woken after every
 * byte is received but can just repeatedly sleep again if it likes.
 *
 * The main loop that is acting on the lock flag must process the
 * command and send any necessary data.  It must also wait for an ACK
 * or NAK before finally removing the lock and allowing further
 * receives.
 *
 * When sending any packet (including ACK or NAK packets), a timeout
 * is started.  If the timeout expires, the response is considered to
 * be a NAK and the ACK/NAK is resent.  The timeout should be generous
 * enough to allow for full ring propagation with worst-case delays.
 * If the packets comes back to the sender, it is also treated as a
 * NAK.  An error counter should limit the number of re-sends before
 * dropping the packet and returning an error.
 *
 * When data is received, only the payload is available to the main
 * loop.  A copy of the source address is also saved until the lock is
 * released.  This allows replies to be sent regardless of other
 * packets received or forwarded during processing.
 *
 * For the moment, data packets will not have ACK/NAK piggybacked
 * with them and each will be sent separately.  This is because
 * ACKs are automatically and immediately sent by the ISR routines
 * because a response is even computed.
 *
 * @todo NAKing a packet while busy should ideally send a special NAK
 * that indicates busy as opposed to failed CRC, etc.  This would allow
 * a small pause before re-sending, rather than resending immediately
 * and probably causing the same problem again.
 *
 * General API:
 *
 * - Main loop inspects processingLock flag.  If set, it actions the data
 *   in buffer.
 *
 * - A reply is optionally constructed by calling sendReply.  This uses
 *   the saved source address to send appropriate header bytes.  Nothing
 *   much happens here because the header can't be constructed until
 *   the packet is complete (length is unknown).
 *
 * - Packet payload is sent by repeatedly calling sendDataByte
 *
 * - The sending is completed by calling endMessage, which will
 *   send the actual packet by constructing a header, length, body and
 *   CRC for the message.
 *
 * - awaitDelivery is called to wait for a response. A duplicate of
 *   the entire packet is kept in an additional buffer so that if a NAK
 *   arrives the same data can be re-sent without bothering the client.
 *   This method should do very little as the handling of this is
 *   interrupt driven.  If called, it will block until the delivery is
 *   complete and return fail/success.
 *
 * - deliveryStatus returns the same information as awaitDelivery
 *   (except tristate values indicating still sending, success,
 *   failure).  This does not block however.
 *
 * - When sending a new message rather than a reply, the sendMessage
 *   function is called with the destination address.
 *
 * - Call releaseLock to indicate processing is complete amd allow
 *   any necessary cleanups.  If no ACK is received yet, this
 *   will block until it arrives.  If endMessage is not called,
 *   the packet is dropped.
 *
 * In order for the routines to work the ISR must call the interrupt
 * handler serialInterruptHandler()
 *
 * When we get a packet not destined for us or with headers we don't
 * understand, we just pass them on.  In theory, a corrupt packet
 * could therefore just be passed on by everybody, forever.  To get
 * around this we could buffer the packet and check the CRC, then only
 * send it on if all is well.  However in doing so we greatly increase
 * the latency.  To prevent the possible long-term buildup of rogue
 * packets it is assumed that there is a node in the ring (such as a
 * more powerful PC) that will check things more thoroughly and mop up
 * any problem packets that are cycling the network.  By only having
 * one such node in the network, the latency effects are minimised.
 *
 * @todo An enhancement that may be needed is something to deal with
 * too much data arriving.  eg if fully occupied with incoming data
 * and a local transmit is occasionally needed, eventually
 * transmitting will block while waiting for the TSR to become free
 * (it won't be able to contain all the outgoing data).  This will
 * mean received data is lost and the packet will become corrupted.
 * However at least the next packet will also become corrupted.  This
 * situation should be detected and if anything arrives during
 * blocking transmits, they should be cleanly dropped up until the
 * packet ending.  This improvement just decreases the number of lost
 * packets, but is a little complex so it may or may not be worth
 * doing.  Also in most cases for a local transmit to be needed, there
 * would also be a command received, which would be consumed leaving
 * more buffer space.  Also responses from slave devices are not
 * expected to overwhelm the network so badly.
 *
 *
 * Problems with SNAP:
 *
 * Error correction is optional.  That means the flag itself could be
 * corrupted and no error correction will take place.  It should
 * be mandatory and cover the header.
 *
 * The destination address should occur sooner so packets can be
 * passed on in the network as soon as possible to decrease latency (only
 * relevant in a token ring situation).
 *
 * The lengths are not continuous up to the sizes we want.
 *
 * A lot of the other stuff is superfluous.
 *
 * An ARP protocol like SMBus has might be nice.
 *
 */

#include "serial-inc.h"

#define MAX_TRANSMIT_BUFFER 8  //< Transmit buffer size.
#define MAX_PAYLOAD 16        ///< Size of largest possible message.

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

#define SNAP_SYNC BIN(01010100)

static byte uartState = SNAP_idle; ///< Current SNAP state machine state
static byte in_hdb2,  ///< Temporary buffers needed to
  in_hdb1;            ///  pass packets on from various states
static byte packetLength;          ///< Length of packet being received
static byte sourceAddress;         ///< Source of packet being received
static byte receivedSourceAddress; ///< Source of packet previously received
static byte bufferIndex;           ///< Current receive buffer index
static byte buffer[MAX_PAYLOAD];   ///< Receive buffer
static byte crc; ///< Incrementally calculated CRC value

/// Circular transmit buffer.
/// Tail has the buffer index that will next be written to.  Head is
/// the buffer index that will next be transmitted.
/// If head == tail, the buffer is empty.
/// The purpose of this buffer is to allow background sending of
/// data rather than busy looping.
static byte transmitBuffer[MAX_TRANSMIT_BUFFER];
static byte transmitBufferHead; ///< Start of circular transmit buffer
static byte transmitBufferTail; ///< End of circular transmit buffer

/// This buffer stores the last complete packet body (not the headers
/// as they can be reconstructed).  This is to allow automatic re-sending
/// if a NAK is received.
static byte sendPacketDestination;
static byte sendPacket[MAX_PAYLOAD];
static byte sendPacketLength;
/// When sending a packet this is set to 0 and incremented for
/// every NAK.  After too many have occurred, the packet is just
/// dropped.
static byte nakCount;

/// General flags:
/// @bug these should be "sbit" rather than "byte" but sdcc is breaking a bit
static byte processingLock = 0;
static byte ackRequested;

//===========================================================================//
#pragma save
#pragma nooverlay
static void uartNotifyReceive()
{

  byte c = RCREG;

  // If error occurred then reset by clearing CREN, but
  // attempt to continue processing anyway.
  /// @todo Should we do something else in this situation?
  if (OERR)
    CREN = 0;
  else
    CREN = 1;

  //uartTransmit(c);
  //uartTransmit(uartState);

  switch(uartState) {

  // ----------------------------------------------------------------------- //
  case SNAP_idle:
    // In the idle state, we wait for a sync byte.  If none is
    // received, we remain in this state.
    if (c == SNAP_SYNC)
      uartState = SNAP_haveSync;
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_haveSync:
    // In this state we are waiting for header definition bytes. First
    // HDB2.  We currently insist that all packets meet our expected
    // format which is 1 byte destination address, 1 byte source
    // address, and no protocol specific bytes.  The ACK/NAK bits may
    // be anything.
    if ((c & BIN(11111100)) != BIN(01010000)) {
      // Unsupported header.  Just pass it on to the next node.
      // We assume there are 1 byte addresses still, for simplicity.
      uartTransmit(SNAP_SYNC);
      uartTransmit(in_hdb2 = c);
      uartState = SNAP_haveHDB2Pass;
    } else {
      // All is well
      if ((c & BIN(00000011)) == BIN(00000001))
	ackRequested = 1;
      else
	ackRequested = 0;
      uartState = SNAP_haveHDB2;
    }
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_haveHDB2:
    // For HDB1, we insist CMD = 0, EDM = 8-bit CRC.
    if ((c & BIN(11110000)) != BIN(00110000)) {
      // Bail out
      uartTransmit(SNAP_SYNC);
      uartTransmit(in_hdb2);
      uartTransmit(in_hdb1 = c);
      uartState = SNAP_haveHDB1Pass;
    } else {
      packetLength = c & 0x0f;
      if (packetLength & 8)
	packetLength = 8 << (c & 7);
      uartState = SNAP_haveHDB1;
    }
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_haveHDB1:
    // We should be reading the destination address now
    if (c != deviceAddress) {
      uartTransmit(SNAP_SYNC);
      uartTransmit(in_hdb2);
      uartTransmit(in_hdb1);
      uartTransmit(c);
      uartState = SNAP_haveDABPass;
    } else {
      uartState = SNAP_haveDAB;
    }
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_haveDAB:
    // We should be reading the source address now
    if (c == deviceAddress) {
      // If we receive a packet from ourselves, that means it went
      // around the ring and was never picked up, ie the device we
      // sent to is off-line or unavailable.

      /// @todo Deal with this situation
    }
    sourceAddress = c;
    bufferIndex = 0;
    uartState = SNAP_readingData;
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_readingData:
    if (!processingLock)
      buffer[bufferIndex] = c;

    bufferIndex++;

    /// @todo Compute partial CRC

    if (bufferIndex == packetLength)
      uartState = SNAP_dataComplete;
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_dataComplete:
    // We should be receiving a CRC after data, and it
    // should match what we have already computed
    {
      byte hdb2 = BIN(01010000); // 1 byte addresses
      
      crc = c;
      if (c == crc) { ///@todo Remove bypass here
	// All is good, so process the command.  Rather than calling the
	// appropriate function directly, we just set a flag to say
	// something is ready for processing.  Then in the main loop we
	// detect this and process the command.  This allows further
	// comms processing (such as passing other tokens around the
	// ring) while we're actioning the command.
	
	if (processingLock) {
	  // If we're already processing, NAK and ignore
	  hdb2 |= BIN(11);
	} else {
	  // Otherwise ACK and set the flag to allow processing to start
	  hdb2 |= BIN(10);
	  processingLock = 1;
	  receivedSourceAddress = sourceAddress;
	}
      } else {
	// CRC mismatch, so we will NAK the packet
	hdb2 |= BIN(11);
      }
      if (ackRequested) {
	// Send ACK or NAK back to source
	uartTransmit(SNAP_SYNC);
	uartTransmit(hdb2);
	uartTransmit(BIN(00110000));  // HDB1: 0 bytes, with 8 bit CRC
	uartTransmit(sourceAddress);  // Return to sender
	uartTransmit(deviceAddress);  // From us
	uartTransmit(0);  // CRC
      }
    }
    uartState = SNAP_idle;
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_haveHDB2Pass:
    uartTransmit(c);  // We will be reading HDB1; pass it on
    packetLength = c & 0x0f;
    if (packetLength & 8)
      packetLength = 8 << (c & 7);
    uartState = SNAP_haveHDB1Pass;
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_haveHDB1Pass:
    uartTransmit(c);  // We will be reading dest addr; pass it on
    uartState = SNAP_haveDABPass;
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_haveDABPass:
    uartTransmit(c);  // We will be reading source addr; pass it on

    // Increment data length by 1 so that we just copy the CRC
    // at the end as well.
    packetLength++;

    uartState = SNAP_readingDataPass;
    break;

  // ----------------------------------------------------------------------- //
  case SNAP_readingDataPass:
    uartTransmit(c);  // This is a data byte; pass it on
    if (packetLength > 0)
      packetLength--;
    else
      uartState = SNAP_idle;
    break;
  }
}
#pragma restore

//===========================================================================//
/// Low level routine that queue a byte directly for the hardware
void uartTransmit(byte c)
{
  byte newTail;
  transmitBuffer[transmitBufferTail] = c;

  newTail = transmitBufferTail + 1;
  if (newTail >= MAX_TRANSMIT_BUFFER)
    newTail = 0;

  while(newTail == transmitBufferHead)
    ;
  transmitBufferTail = newTail;
  TXIE = 1;
}

//===========================================================================//
/// High level routine that queues a byte during construction of a packet
void sendDataByte(byte c)
{
  // Put byte into packet sending buffer.  Don't calculated CRCs
  // yet as we don't have complete information.

  // Drop if trying to send too much
  if (sendPacketLength >= MAX_PAYLOAD)
    return;

  sendPacket[sendPacketLength++] = c;
}

//===========================================================================//
void releaseLock()
{
  processingLock = 0;

  /// @todo If sending is in progress or waiting for ACK, block.
}

//===========================================================================//
void sendMessage(byte dest)
{
  sendPacketDestination = dest;
  sendPacketLength = 0;
}

//===========================================================================//
void sendReply()
{
  sendMessage(receivedSourceAddress);
}

//===========================================================================//
void awaitDelivery()
{
}

//===========================================================================//
byte deliveryStatus()
{
  return 0;
}

//===========================================================================//
void endMessage()
{
  byte length = sendPacketLength;
  byte i;
  if (length > 7) {
    length = 8;
    sendPacketLength = 16;
  }

  // Send the message
  uartTransmit(SNAP_SYNC);
  uartTransmit(BIN(01010001));   // Request ACK
  uartTransmit(BIN(00110000) | length);
  uartTransmit(sendPacketDestination);
  uartTransmit(deviceAddress);
  for(i = 0; i < sendPacketLength; i++)
    uartTransmit(sendPacket[i]);
  uartTransmit(0); /// @todo crc here
}

//===========================================================================//
#pragma save
#pragma nooverlay
void serialInterruptHandler()
{
  // Process serial
  // Finished sending something?
  if (TXIF && TXIE) {
    if (transmitBufferHead != transmitBufferTail) {
      byte c = transmitBuffer[transmitBufferHead];
      transmitBufferHead++;
      if (transmitBufferHead >= MAX_TRANSMIT_BUFFER)
	transmitBufferHead = 0;
      // If empty now, disable XMIT interrupts
      if (transmitBufferHead == transmitBufferTail)
	TXIE = 0;
      TXREG = c;
    }

  }

  // Any data received?
  if (RCIF)
    uartNotifyReceive();
}
#pragma restore
