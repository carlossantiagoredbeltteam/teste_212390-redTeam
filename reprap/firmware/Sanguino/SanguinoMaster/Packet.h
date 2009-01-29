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
  uint8_t rx_length;
  uint8_t rx_data[MAX_PACKET_LENGTH];
  uint8_t rx_crc;
  uint8_t tx_length;
  uint8_t tx_data[MAX_PACKET_LENGTH];
  uint8_t tx_crc;
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
	target_length = 0;
    rx_length = 0;
	rx_crc = 0;
    tx_length = 0;
	tx_crc = 0;
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
      rx_length = 0;
      state = PS_PAYLOAD;
    }
    else if (state == PS_PAYLOAD)  // process payload byte
    {
      //the first byte determines command vs query
      if (rx_length == 0)
      {
        // top bit high == bufferable command packet (eg. #128-255)
        if (b & 1 << 7)
          is_command_packet = true;
        // top bit low == reply needed query packet (eg. #0-127)
        else
          is_command_packet = false;
      }
      //just keep reading bytes while we got them.
      if (rx_length < target_length)
      {
        //keep track of CRC.
        rx_crc = _crc_ibutton_update(rx_crc, b);

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
          if (rx_length < MAX_PACKET_LENGTH)
            rx_data[rx_length] = b;
          else
            response_code = RC_PACKET_TOO_BIG;
        }

        rx_length++;
      }

      //are we done?
      if (rx_length >= target_length)
        state = PS_CRC;
    }
    else if (state == PS_CRC)  // check crc
    {
      // did the packet check out?
      if (rx_crc != b)
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

  uint8_t getLength()
  {
	return rx_length;
  }

  uint8_t getData(uint8_t i)
  {
	return rx_data[i];
  }

  void unsupported()
  {
	response_code = RC_CMD_UNSUPPORTED;
  }

  void sendReply()
  {
    //initialize our response CRC
    tx_crc = 0;
    tx_crc = _crc_ibutton_update(tx_crc, response_code);

    //actually send our response.
    transmit(START_BYTE);
	transmit(tx_length+1);
    transmit(response_code);

    //loop through our reply packet payload and send it.
    for (uint8_t i=0; i<tx_length; i++)
    {
      transmit(tx_data[i]);
      tx_crc = _crc_ibutton_update(tx_crc, tx_data[i]);
    }

    //okay, send our CRC.
    transmit(tx_crc);

    //okay, now reset.
    init();
  }

  void sendPacket()
  {
	tx_crc = 0;
    transmit(START_BYTE);
	transmit(tx_length);

    //loop through our reply packet payload and send it.
    for (uint8_t i=0; i<tx_length; i++)
    {
      transmit(tx_data[i]);
      tx_crc = _crc_ibutton_update(tx_crc, tx_data[i]);
    }

    //okay, send our CRC.
    transmit(tx_crc);
  }

  void transmit(uint8_t d)
  {
	if (uart == 0)
		Serial.print(d, BYTE);
	else
		Serial1.print(d, BYTE);
  }

  //add a four byte chunk of data to our reply
  void add_32(uint32_t d)
  {
    add_16(d);
    add_16(d >> 16);
  }

  //add a two byte chunk of data to our reply
  void add_16(uint16_t d)
  {
    add_8(d & 0xff);
    add_8(d >> 8);
  }

  //add a byte to our reply.
  void add_8(uint8_t d)
  {
    //only add it if it will fit.
    if (tx_length < MAX_PACKET_LENGTH)
    {
      tx_data[tx_length] = d;
      tx_length++;
    }
  }

  uint8_t get_8(uint8_t idx)
  {
	return rx_data[idx];
  }

  uint16_t get_16(uint8_t idx)
  {
	return (get_8(idx+1) << 8) & get_8(idx);
  }

  uint32_t get_32(uint8_t idx)
  {
	return (get_16(idx+2) << 16) & get_16(idx);
  }
};

#endif // _PACKET_H_
