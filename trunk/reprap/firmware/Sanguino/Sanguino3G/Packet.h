#ifndef _PACKET_H_
#define _PACKET_H_

//include our various libraries.
#include <util/crc16.h>
//#include <stddef.h>
#include <stdint.h>
#include "CircularBuffer.h"
#include "HardwareSerial.h"

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

#define START_BYTE 0xD5
#define MAX_PACKET_LENGTH 32

class Packet {
private:
  //variables for our incoming packet.
  PacketState state;
  uint8_t target_length;
  uint8_t length;
  uint8_t response_length;
  uint8_t data[MAX_PACKET_LENGTH];
  uint8_t crc;
  uint8_t is_command_packet;
  ResponseCode response_code;

  uint8_t uart;

public:

  Packet(uint8_t uart)
  {
	this->uart = uart;
	
    init();
  }

  void init()
  {
    state = PS_START;
    response_code = RC_OK;
    length = 0;
    target_length = 0;
    response_length = 0;
    crc = 0;
    is_command_packet = false;
  }

  //process a byte from our packet
  bool process_byte(uint8_t b)
  {
    if (state == PS_START)  // process start byte
    {
      //cool!  its the start of a packet.
      if (b == START_BYTE)
      {
        init();
        state = PS_LEN;
      }
      else
      {
        // throw an error message?
        // nah, ignore it as garbage.
      }
    }
    else if (state == PS_LEN) // process length byte
    {
      //figure out how much data is coming.
      //please note: data may go into command buffer
      //instead of query packet buffer, so don't check the size
      target_length = b;
      length = 0;
      state = PS_PAYLOAD;
    }
    else if (state == PS_PAYLOAD)  // process payload byte
    {
      //the first byte determines command vs query
      if (length == 0)
      {
        // top bit high == bufferable command packet (eg. #128-255)
        if (b & 1 << 7)
          is_command_packet = true;
        // top bit low == reply needed query packet (eg. #0-127)
        else
          is_command_packet = false;
      }
      //just keep reading bytes while we got them.
      if (length < target_length)
      {
        //keep track of CRC.
        crc = _crc_ibutton_update(crc, b);

        //we put different things in different buffers.  (query vs command)
        if (is_command_packet)
        {
          //will it fit?
          if (commandBuffer.remainingCapacity() == 0)
            response_code = RC_BUFFER_OVERFLOW;
          else
            commandBuffer.append(b);
        }
        else
        {
          //will it fit?
          if (length < MAX_PACKET_LENGTH)
            data[length] = b;
          else
            response_code = RC_PACKET_TOO_BIG;
        }

        length++;
      }

      //are we done?
      if (length >= target_length)
        state = PS_CRC;
    }
    else if (state == PS_CRC)  // check crc
    {
      // did the packet check out?
      if (crc != b)
        response_code = RC_CRC_MISMATCH;

      //okay, the packet is done.
      state = PS_LAST;
    }
  }

  bool isFinished()
  {
    return (state == PS_LAST);	
  }

  bool isQuery()
  {
    return (response_code == RC_OK && !is_command_packet);
  }

  uint8_t getData(uint8_t i)
  {
	return data[i];
  }

  void unsupported()
  {
	response_code = RC_CMD_UNSUPPORTED;
  }

  void sendReply()
  {
    //initialize our response CRC
    crc = 0;
    crc = _crc_ibutton_update(crc, response_code);

    //actually send our response.
    transmit(START_BYTE);
	transmit(length+1);
    transmit(response_code);

    //loop through our reply packet payload and send it.
    for (uint8_t i=0; i<length; i++)
    {
      transmit(data[i]);
      crc = _crc_ibutton_update(crc, data[i]);
    }

    //okay, send our CRC.
    transmit(crc);

    //okay, now reset.
    init();
  }

  void transmit(uint8_t data)
  {
	if (uart == 0)
		Serial.print(data, BYTE);
	else
		Serial1.print(data, BYTE);
  }

  //add a four byte chunk of data to our reply
  void add_reply_32(uint32_t data)
  {
    add_reply_8(data & 0xff);
    add_reply_8(data >> 8);
    add_reply_8(data >> 16);
    add_reply_8(data >> 24);
  }

  //add a two byte chunk of data to our reply
  void add_reply_16(uint16_t data)
  {
    add_reply_8(data & 0xff);
    add_reply_8(data >> 8);
  }

  //add a byte to our reply.
  void add_reply_8(uint8_t b)
  {
    //only add it if it will fit.
    if (response_length < MAX_PACKET_LENGTH)
    {
      data[response_length] = b;
      response_length++;
    }
  }
};

#endif // _PACKET_H_
