#ifndef _SIMPLE_PACKET_H_
#define _SIMPLE_PACKET_H_

//include our various libraries.
#include <util/crc16.h>
#include <stdint.h>
#include "HardwareSerial.h"

#define START_BYTE 0xD5
#define MAX_PACKET_LENGTH 32

typedef void (*txFuncPtr)(unsigned char);

// packet states
typedef enum {
  PS_START = 0,
  PS_LEN,
  PS_PAYLOAD,
  PS_CRC,
  PS_LAST
} 
PacketState;

// various error codes
typedef enum {
  RC_GENERIC_ERROR   = 0,
  RC_OK              = 1,
  RC_BUFFER_OVERFLOW = 2,
  RC_CRC_MISMATCH    = 3,
  RC_PACKET_TOO_BIG  = 4,
  RC_CMD_UNSUPPORTED = 5
} 
ResponseCode;

class SimplePacket {
private:
  //variables for our incoming packet.
  PacketState state;
  unsigned char target_length;
  unsigned char rx_length;
  unsigned char rx_data[MAX_PACKET_LENGTH];
  unsigned char rx_crc;
  unsigned char tx_length;
  unsigned char tx_data[MAX_PACKET_LENGTH];
  unsigned char tx_crc;
  ResponseCode response_code;

  txFuncPtr txFunc;

public:

	SimplePacket(txFuncPtr myPtr);
	void init();

	//process a byte from our packet
	void process_byte(unsigned char b);
	bool isFinished();
	unsigned char getLength();
	PacketState getState();

	void unsupported();

	void sendReply();
	void sendPacket();
	void transmit(unsigned char d);

	void add_32(uint32_t d);
	void add_16(uint16_t d);
	void add_8(unsigned char d);

	unsigned char get_8(unsigned char idx);
	uint16_t get_16(unsigned char idx);
	uint32_t get_32(unsigned char idx);
};

#endif // _SIMPLE_PACKET_H_
