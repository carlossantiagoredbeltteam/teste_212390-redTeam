#include "shared.h"

// Packet format:
// 1 - Sync
// 2 - HDB1 (ff=token)
// 3 - SRC
// 4 - DST
// 5 - HDB2
// 6..n - data
// n+1 - DCRC

// Data states
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
  RAP_readingDataPass,  // 9
  RAP_expectDCRCPass,   // 10

  RAP_expectDSTDrop,    // 11
  RAP_expectSRCDrop,    // 12
  RAP_readingDataDrop,  // 13
  RAP_expectDCRCDrop    // 14
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

#define PKT_SEND_TIMEOUT 100
#define PKT_RECEIVE_TIMEOUT 10
#define PKT_TOKEN_TIMEOUT 110

static volatile byte uartState = RAP_idle; ///< Current RAP state machine state
static volatile byte crc; ///< Incrementally calculated CRC value

// Single bit flags
static volatile struct flags1_s {
  unsigned xmitBufferReady : 1; ///< We have data ready to send
  unsigned xmitBufferSent : 1;  ///< Data has been sent
  unsigned in_bufferBusy : 1;
  unsigned out_bufferBusy : 1;
  unsigned out_timedout : 1;

  /// When dropping data, this determines the action we'll take after
  /// all of the packet is received.
  unsigned in_dropAction : 2;
} flags1 = {0,0,0,0,0,0};

// Receive buffer information
static volatile byte in_hdb1;
static volatile byte in_src;
static volatile byte in_dest;
static volatile byte in_hdb2;

static volatile byte in_bufferIndex;
static volatile byte in_buffer[MAX_PAYLOAD];

static volatile byte lastReceive = -1;
static volatile byte lastTransmit = -1;

static volatile byte out_hdb1;
static volatile byte out_dest;
static volatile byte out_hdb2;
static volatile byte out_length;
static volatile byte out_buffer[MAX_PAYLOAD];

static volatile byte out_resendTimer = -1;
static volatile byte in_packetTimer = -1; // also token timeout
static volatile byte in_tokenTimer = 0;

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

static void sendCurrentOutBuffer()
{
  byte i;

  if (flags1.xmitBufferSent) {
     printf("Sending already sent packet!\n");
     fflush(stdout);
     return;
  }

  if (!flags1.xmitBufferReady) {
     printf("Transmit buffer not ready!!\n");
     fflush(stdout);
     return;
  }

  flags1.xmitBufferSent = 1;
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
}

static void sendTokenImmediate()
{
  uartTransmit(RAP_SYNC);
  uartTransmit(0xff);
  uartState = RAP_idle;
  in_packetTimer = -1;
}

void timer_ping()
{
  if (in_packetTimer != 255) {
    in_packetTimer--;
    if (in_packetTimer == 0) {
      in_packetTimer = -1;
      printf("  packet receive timed out at %d\n", address);
      fflush(stdout);
      flags1.in_bufferBusy = 0;
      uartState = RAP_idle;
    }
  }
  if (out_resendTimer != 255) {
    out_resendTimer--;
    if (out_resendTimer == 0) {
      out_resendTimer = -1;
      flags1.out_timedout = 1;
      printf("  send timed out at %d\n", address);
      fflush(stdout);
    }
  }

  // Master re-inserts token if it is lost
  if (address == 0 && ++in_tokenTimer == PKT_TOKEN_TIMEOUT) {
    printf("  re-inserting lost token\n");
    fflush(stdout);
    sendTokenImmediate();
    in_tokenTimer = 0;
  }
}

void uartNotifyReceive()
{
  byte c = RCREG;

  printTime();
  if (address) printf("                  ");
  printf("    <-- %d rx %02x in state %d\n", address, c, uartState);
  fflush(stdout);

  switch(uartState) {

  // ----------------------------------------------------------------------- //
  case RAP_idle:
    // In the idle state, we wait for a sync byte.  If none is
    // received, we remain in this state.
    if (c == RAP_SYNC) {
      uartState = RAP_expectHDB1;
      in_packetTimer = PKT_RECEIVE_TIMEOUT;
    }
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectHDB1:
    if (c == 0xff) {
      // We have received a token, so if we have any data to send we
      // can send it now.
      in_tokenTimer = 0;
      if (flags1.xmitBufferReady && !flags1.xmitBufferSent) {
	sendCurrentOutBuffer();
	uartState = RAP_idle;
	in_packetTimer = -1;
	flags1.out_bufferBusy = 0;
      } else if (flags1.out_timedout) {
	// If our last send timed out, send it again
	out_resendTimer = PKT_SEND_TIMEOUT;
	flags1.out_timedout = 0;
	flags1.xmitBufferSent = 0;
	sendCurrentOutBuffer();
	uartState = RAP_idle;
	in_packetTimer = -1;
	flags1.in_bufferBusy = 0;      
      } else {
	// Nothing to send, so pass the token on
	sendTokenImmediate();
      }
    } else {
      // Header of a normal packet
      if (flags1.in_bufferBusy) {
	// Inward buffer still busy, so have to drop packet.
	printf("%d Buffer busy, drop %02x\n", address, c);
	fflush(stdout);
	uartState = RAP_expectSRCDrop;
	flags1.in_dropAction = Drop_None;
      } else {
	flags1.in_bufferBusy = 1;
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
      flags1.in_dropAction = Drop_None;

      printf("Valid header CRC\n");
      fflush(stdout);

      // Restart timer
      in_packetTimer = PKT_RECEIVE_TIMEOUT;

      // We now have a valid header, so we can process it
      if (in_src == address) {
	printf("Packet has cycled, so drop it\n");
	fflush(stdout);

	uartState = RAP_readingDataDrop;
	flags1.in_dropAction = Drop_None;
	ok = 0;
      } else if (in_dest != address) {
	printf("Not for me (%d), forward it on\n", in_dest);
	fflush(stdout);
	uartTransmit(RAP_SYNC);
	uartTransmit(in_hdb1);
	uartTransmit(in_src);
	uartTransmit(in_dest);
	uartTransmit(in_hdb2);
	uartTransmit(c);
	flags1.in_bufferBusy = 0;
	uartState = RAP_readingDataPass;
	ok = 0;
      }

      if (in_hdb1 & RAP_HDB1_RST)
	lastReceive = lastTransmit = -1;

      if (ok) {
	// Deal with incoming transmit sequence (incoming data)
	byte lastrs, nextrs;
	lastrs = (lastReceive & 3);
	nextrs = (lastrs + 1) & 3;

	printf("tseq is %d, lastrec is %d\n", tseq, lastReceive);
	fflush(stdout);

	tseq = RAP_TSEQ(in_hdb2);

	if (tseq == lastrs && ((in_hdb2 & RAP_HDB2_LENMASK) == 0)) {
	  // They are sending a bare ACK
	  printf("Bare ACK received\n");
	  fflush(stdout);
	} else if (tseq == lastrs) {
	  // They are re-sending data, so our previous packet must have been
	  // lost.  Retransmit it.
	  out_resendTimer = -1;  // Also kill the resend timer if we had one
	  printf("Lost previous packet, retransmit\n");
	  fflush(stdout);
	  uartState = RAP_readingDataDrop;
	  flags1.in_dropAction = Drop_ResendLast;
	  ok = 0;
	} else if (tseq == nextrs) {
	  printf("Valid sequence\n");
	  fflush(stdout);
	} else {
	  printf("Invalid tsequence %d (lastReceive=%d), drop and reset\n",
		 tseq, lastReceive);
	  fflush(stdout);
	  flags1.in_dropAction = Drop_Reset;
	  uartState = RAP_readingDataDrop;
	  ok = 0;
	}
      }

      if (ok && (in_hdb1 & RAP_HDB1_NAK)) {
	// TODO: check sequence of NAK
	printf("Received NAK, resend last packet\n");
	fflush(stdout);
	flags1.xmitBufferSent = 0;
	sendCurrentOutBuffer();
	uartState = RAP_idle;
	in_packetTimer = -1;
	flags1.in_bufferBusy = 0;
	out_resendTimer = PKT_SEND_TIMEOUT;
	flags1.out_timedout = 0;
	break;
      }

      // Deal with incoming receive sequence (responded to outgoing data)
      if (ok && (in_hdb1 & RAP_HDB1_ACK)) {
	byte rseq;
	rseq = RAP_RSEQ(in_hdb2);
	if (rseq == (lastTransmit & 3)) {
	  printf("Previous data acknowledged\n");
	  flags1.xmitBufferReady = 0;
	  fflush(stdout);
	  out_resendTimer = 255;
	  flags1.out_timedout = 0;
	} else {
	  printf("Invalid rsequence, dropping packet\n");
	  fflush(stdout);
	}
      }
      
      if (ok) {
	if ((in_hdb2 & RAP_HDB2_LENMASK) == 0) {
	  // We don't bother with the second CRC if there is
	  // no data payload.
	  sendTokenImmediate();
	} else
	  uartState = RAP_readingData;
      }
    } else {
      printf("Header CRC failure (got %02x, expected %02x), drop packet\n",
	     c, crc);
      fflush(stdout);
      flags1.in_dropAction = Drop_None;
      uartState = RAP_readingDataDrop;
    }
    break;

  // ----------------------------------------------------------------------- //
  case RAP_readingData:
    in_buffer[in_bufferIndex] = c;
    in_bufferIndex++;
    // Restart timer
    in_packetTimer = PKT_RECEIVE_TIMEOUT;
    computeCRC(c);
    if (in_bufferIndex == (in_hdb2 & RAP_HDB2_LENMASK))
      uartState = RAP_expectDCRC;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectDCRC:
    if (c == crc) {
      if ((in_hdb2 & RAP_HDB2_LENMASK) > 0)
	lastReceive = (lastReceive + 1) & 3;
      packetNotifyReceive((byte *)in_buffer, (in_hdb2 & RAP_HDB2_LENMASK));
      sendTokenImmediate();
    } else {
      // Failure, so NAK the packet.  Possible optimisation: rather
      // than putting a token out, just NAK immediately.
      printf("Data CRC failure (got %02x, expected %02x), NAK packet\n",
	     c, crc);
      fflush(stdout);
      if (flags1.out_bufferBusy) {
	// Already waiting to send a packet, so just drop it.
	printf("Outward buffer already busy, drop\n");
	fflush(stdout);
      } else {
	flags1.out_bufferBusy = 1;
	out_hdb1 = RAP_HDB1_NAK;
	out_hdb2 = 0;
	out_length = 0;
	out_dest = in_src;
	flags1.xmitBufferReady = 1;
	flags1.xmitBufferSent = 0;
	flags1.in_bufferBusy = 0;

	// Put out a new token
	sendTokenImmediate();
      }
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
    in_packetTimer = -1;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_readingDataDrop:
    in_bufferIndex++;
    if (in_bufferIndex == (in_hdb2 & RAP_HDB2_LENMASK))
      uartState = RAP_expectDCRCDrop;
    break;

  // ----------------------------------------------------------------------- //
  case RAP_expectDCRCDrop:
    flags1.in_bufferBusy = 0;
    switch(flags1.in_dropAction) {
    case Drop_None:
      // Drop and do nothing.  Except of course, we still
      // need to put a token back into circulation
      sendTokenImmediate();
      break;
    case Drop_ResendLast:
      flags1.xmitBufferSent = 0;
      sendCurrentOutBuffer();
      uartState = RAP_idle;
      in_packetTimer = -1;
      flags1.in_bufferBusy = 0;
      out_resendTimer = PKT_SEND_TIMEOUT;
      flags1.out_timedout = 0;
      break;
    case Drop_NAK:
    case Drop_Reset:
    default:
      printf("Unknown drop action %d\n", flags1.in_dropAction);
      fflush(stdout);
    }
    break;
    
  // ----------------------------------------------------------------------- //
  default:
    printf("%d Unimplemented state %d\n", address, uartState);
    fflush(stdout);
    break;

  }
}

void releaseReceiveBuffer()
{
  // Send an ACK and free buffer for other data
  if (flags1.in_bufferBusy) {
    printf("Sending bare ACK\n");
    fflush(stdout);
    flags1.out_bufferBusy = 1;
    out_hdb1 = RAP_HDB1_ACK;
    out_hdb2 = ((lastTransmit & 3) << 6) | ((lastReceive & 3) << 4);
    out_length = 0;
    out_dest = in_src;
    flags1.in_bufferBusy = 0;
    flags1.xmitBufferReady = 1;
    flags1.xmitBufferSent = 0;
  } else {
    printf("Release called, probably should have called endMessage\n");
    fflush(stdout);
  }
}

void reply()
{
  if (flags1.in_bufferBusy) {
    sendMessage(in_src);
  } else {
    printf("Sending reply when no data received\n");
    fflush(stdout);
  }
}

void sendMessage(byte dest)
{
  flags1.out_bufferBusy = 1;
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

  if (flags1.in_bufferBusy)  // piggyback ACK
    out_hdb1 |= RAP_HDB1_ACK;
  out_hdb2 |= out_length & 15;  // packet length

  lastTransmit++;
  out_hdb2 |= (lastTransmit & 3) << 6;
  out_hdb2 |= (lastReceive & 3) << 4;

  flags1.xmitBufferReady = 1;
  flags1.xmitBufferSent = 0;

  // If there was a receive buffer we were locking free it now
  flags1.in_bufferBusy = 0;
  out_resendTimer = PKT_SEND_TIMEOUT;
  flags1.out_timedout = 0;
}

void printTime()
{
  //  struct timeval tv;
  //  gettimeofday(&tv, NULL);
  //  printf("%ld", tv.tv_sec * 10000000 + tv.tv_usec);
}

