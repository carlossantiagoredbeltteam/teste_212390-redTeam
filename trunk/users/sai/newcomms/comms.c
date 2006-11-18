#include "shared.h"

enum RAP_states {
  RAP_idle = 0,
  RAP_expectHDB1,    // 1
  RAP_expectSRC,     // 2
  RAP_expectDST,     // 3
  RAP_expectHDB2,    // 4
  RAP_expectHCRC,    // 5
  RAP_readingData,   // 6
  RAP_expectDCRC,    // 7

  RAP_expectHDB2Pass,   // 8
  RAP_expectHCRCPass,   // 9
  RAP_readingDataPass,  // 10
  RAP_expectDCRCPass,   // 11

  RAP_expectDSTDrop,    // 12
  RAP_expectSRCDrop,    // 13
  RAP_expectHDB2Drop,   // 14
  RAP_expectHCRCDrop,   // 15
  RAP_readingDataDrop,  // 16
  RAP_expectDCRCDrop    // 17
};

enum Drop_Actions {
  Drop_None,
  Drop_NAK,
  Drop_ResendLast,
  Drop_Reset
};

#define MAX_PAYLOAD 8
#define RAP_SYNC BIN(01010100)
#define RAP_HDB1_RST  BIN(10000000)
#define RAP_HDB1_ACK  BIN(01000000)
#define RAP_HDB1_NAK  BIN(00100000)
#define RAP_HDB1_ENUM BIN(00010000)
#define RAP_HDB2_LENMASK BIN(00001111)
#define RAP_TSEQ(v) (((v)&BIN(11000000)) >> 6)
#define RAP_RSEQ(v) (((v)&BIN(00110000)) >> 4)

static volatile byte uartState = RAP_idle; ///< Current RAP state machine state
static volatile byte crc; ///< Incrementally calculated CRC value

// Single bit flags
static volatile byte xmitBufferReady = 0;
static volatile byte in_bufferBusy = 0;
static volatile byte out_bufferBusy = 0;
static volatile byte comms_inited = 0;

// Receive buffer information
static volatile byte in_hdb1;
static volatile byte in_src;
static volatile byte in_dest;
static volatile byte in_hdb2;

/// When dropping data, this determines the action we'll take after
/// all of the packet is received.
static volatile byte in_dropAction;

static volatile byte in_bufferIndex;
static volatile byte in_buffer[MAX_PAYLOAD];

/// @todo change default to 1 to rset is required
static volatile byte lastReceive = 3;
static volatile byte lastTransmit = 0;

static volatile byte out_hdb1;
static volatile byte out_dest;
static volatile byte out_hdb2;
static volatile byte out_length;
static volatile byte out_buffer[MAX_PAYLOAD];


byte computeCRC(byte dataval)
{
  byte i = dataval ^ crc;
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
  return dataval;
}

void timer_ping()
{
}

void uartNotifyReceive()
{
  byte c = RCREG;

  if (address) printf("                  ");
  printf("    <-- %d rx %02x in state %d\n", address, c, uartState);

  switch(uartState) {

  // ----------------------------------------------------------------------- //
  case RAP_idle:
    // In the idle state, we wait for a sync byte.  If none is
    // received, we remain in this state.
    if (c == RAP_SYNC)
      uartState = RAP_expectHDB1;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectHDB1:
    if (c == 0xff) {
      // We have received a token, so if we have any data to send we
      // can send it now.
      if (xmitBufferReady) {
	byte i;
	uartTransmit(RAP_SYNC);
	crc = 0;
	uartTransmit(computeCRC(out_hdb1));
	uartTransmit(computeCRC(address));
	uartTransmit(computeCRC(out_dest));
	uartTransmit(computeCRC(out_hdb2));
	uartTransmit(crc);
	if (out_length > 0) {
	  for(i = 0; i < out_length; i++)
	    uartTransmit(computeCRC(out_buffer[i]));
	  uartTransmit(crc);
	}
	xmitBufferReady = 0;
	out_bufferBusy = 0;
	uartState = RAP_idle;
      } else {
	// Nothing to send, so pass the token on
	uartTransmit(RAP_SYNC);
	uartTransmit(0xff);
	uartState = RAP_idle;
      }
    } else {
      // Header of a normal packet
      if (in_bufferBusy) {
	// Inward buffer still busy, so have to drop packet.
	printf("%d Buffer busy, drop %02x\n", address, c);
	uartState = RAP_expectSRCDrop;
	in_dropAction = Drop_None;
      } else {
	in_bufferBusy = 1;
	in_hdb1 = c;
	crc = 0;
	computeCRC(c);
	uartState = RAP_expectSRC;
      }
    }
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectSRC:
    in_src = c;
    computeCRC(c);
    uartState = RAP_expectDST;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectDST:
    in_dest = c;
    computeCRC(c);
    uartState = RAP_expectHDB2;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectHDB2:
    in_hdb2 = c;
    computeCRC(c);
    uartState = RAP_expectHCRC;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectHCRC:
    in_bufferIndex = 0;
    if (c == crc) {
      byte tseq;
      byte ok = 1;
      in_dropAction = Drop_None;

      printf("Valid header CRC\n");

      // We now have a valid header, so we can process it
      if (in_hdb1 & RAP_HDB1_RST)
	lastReceive = lastTransmit = -1;

      if (in_src == address) {
	printf("Packet has cycled, so drop it\n");
	uartState = RAP_readingDataDrop;
	in_dropAction = Drop_None;
	ok = 0;
      } else if (in_dest != address) {
	printf("Not for me (%d), forward it on\n", in_dest);
	uartTransmit(RAP_SYNC);
	uartTransmit(in_hdb1);
	uartTransmit(in_src);
	uartTransmit(in_dest);
	uartTransmit(in_hdb2);
	uartTransmit(c);
	in_bufferBusy = 0;
	uartState = RAP_readingDataPass;
	ok = 0;
      }

      if (ok) {
	// Deal with incoming transmit sequence (incoming data)
	tseq = RAP_TSEQ(in_hdb2);
	if (tseq == (lastReceive & 3)) {
	  // Our previous packet was lost, so retransmit it
	  printf("Load previous packet, retransmit\n");
	  uartState = RAP_readingDataDrop;
	  in_dropAction = Drop_ResendLast;
	  ok = 0;
	} else if (tseq == ((lastReceive + 1) & 3)) {
	  printf("Valid sequence\n");
	} else {
	  printf("Invalid tsequence %d (lastReceive=%d), drop and reset\n",
		 tseq, lastReceive);
	  in_dropAction = Drop_Reset;
	  uartState = RAP_readingDataDrop;
	  ok = 0;
	}
      }

      // Deal with incoming receive sequence (responde to outgoing data)
      if (ok && (in_hdb1 & RAP_HDB1_ACK)) {
	byte rseq;
	rseq = RAP_RSEQ(in_hdb2);
	if (rseq == (lastTransmit & 3)) {
	  printf("Previous data acknowledged\n");
	} else {
	  printf("Invalid rsequence, dropping packet\n");
	}
      }
      
      if (ok) {
	if ((in_hdb2 & RAP_HDB2_LENMASK) == 0) {
	  // We don't bother with the second CRC if there is
	  // no data payload.
	  uartTransmit(RAP_SYNC);
	  uartTransmit(0xff);
	  uartState = RAP_idle;
	} else
	  uartState = RAP_readingData;
      } else {
	printf("Failure, will drop packet\n");
      }
    } else {
      // We want to NAK the packet but we need to wait
      // until it is all received first
      printf("Header CRC failure (got %02x, expected %02x), drop packet\n",
	     c, crc);
      in_dropAction = Drop_None;
      uartState = RAP_readingDataDrop;
    }
    break;

  // ----------------------------------------------------------------------- //
  case RAP_readingData:
    in_buffer[in_bufferIndex] = c;
    in_bufferIndex++;
    computeCRC(c);
    if (in_bufferIndex == (in_hdb2 & RAP_HDB2_LENMASK))
      uartState = RAP_expectDCRC;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectDCRC:
    if (c == crc) {
      packetNotifyReceive((byte *)in_buffer, (in_hdb2 & RAP_HDB2_LENMASK));
      uartTransmit(RAP_SYNC);
      uartTransmit(0xff);
      uartState = RAP_idle;
    } else {
      // We want to NAK the packet but we need to wait
      // until it is all received first
      printf("Data CRC failure (got %02x, expected %02x), NAK packet\n",
	     c, crc);
      uartState = RAP_idle;
    }
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectHDB2Pass:
    uartTransmit(c);
    in_bufferIndex = 0;
    uartState = RAP_readingDataPass;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_readingDataPass:
    uartTransmit(c);
    in_bufferIndex++;
    if (in_bufferIndex == (in_hdb2 & RAP_HDB2_LENMASK))
      uartState = RAP_expectDCRCPass;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectDCRCPass:
    uartTransmit(c);
    uartState = RAP_idle;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_readingDataDrop:
    in_bufferIndex++;
    if (in_bufferIndex == (in_hdb2 & RAP_HDB2_LENMASK))
      uartState = RAP_expectDCRCDrop;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectDCRCDrop:
    in_bufferBusy = 0;
    switch(in_dropAction) {
    case Drop_None:
      // Drop and do nothing.  Except of course, we still
      // need to put a token back into circulation
      uartTransmit(RAP_SYNC);
      uartTransmit(0xff);
      uartState = RAP_idle;
      break;
    case Drop_NAK:
    case Drop_ResendLast:
    case Drop_Reset:
    default:
      printf("Unknown drop action %d\n", in_dropAction);
    }
    break;
    
  // ----------------------------------------------------------------------- //
  default:
    printf("%d Unimplemented state %d\n", address, uartState);
    break;

  }
}

void releaseReceiveBuffer()
{
  // Send an ACK and free buffer for other data
  if (in_bufferBusy) {
    printf("Sending bare ACK\n");
    out_bufferBusy = 1;
    out_hdb1 = RAP_HDB1_ACK;
    out_hdb2 = 0;
    out_length = 0;
    out_dest = in_src;
    in_bufferBusy = 0;
    xmitBufferReady = 1;
  } else {
    printf("Release called, probably should have called endMessage\n");
  }
}

void reply()
{
  if (in_bufferBusy) {
    sendMessage(in_src);
  } else {
    printf("Sending reply when no data received\n");
  }
}

void sendMessage(byte dest)
{
  out_bufferBusy = 1;
  out_dest = dest;
  out_length = 0;
  out_hdb1 = 0;
  out_hdb2 = 0;
}

void sendDataByte(byte c)
{
  // Put byte into packet sending buffer.  Don't calculate CRCs
  // yet as we don't have complete information.

  // Drop if trying to send too much
  if (out_length >= MAX_PAYLOAD)
    return;

  out_buffer[out_length++] = c;
}

void endMessage()
{
  byte i;

  if (in_bufferBusy)  // piggyback ACK
    out_hdb1 |= RAP_HDB1_ACK;
  if (!comms_inited) {
    out_hdb1 |= RAP_HDB1_RST;
    lastTransmit = -1;
    lastReceive = -1;
    comms_inited = 1;
  }
  out_hdb2 |= out_length & 15;  // packet length

  lastTransmit++;
  out_hdb2 |= (lastTransmit & 3) << 6;
  out_hdb2 |= (lastReceive & 3) << 4;

  xmitBufferReady = 1;

  // If there was a receive buffer we were locking free it now
  in_bufferBusy = 0;
}
