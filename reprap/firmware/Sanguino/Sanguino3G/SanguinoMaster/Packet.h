#ifndef _PACKET_H_
#define _PACKET_H_

//include our various libraries.
#include <util/crc16.h>
#include <stdint.h>
#include "HardwareSerial.h"

#define START_BYTE 0xD5

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
  ResponseCode response_code;
  uint8_t uart;

public:

  Packet(uint8_t my_uart)
  {
    uart = my_uart;
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
        // FIXME: Consider reporting such error in a special debug mode
      }
    }
    else if (state == PS_LEN) // process length byte
    {
      target_length = b;
      rx_length = 0;
      state = PS_PAYLOAD;

      if (target_length > MAX_PACKET_LENGTH)
        response_code = RC_PACKET_TOO_BIG;
    }
    else if (state == PS_PAYLOAD)  // process payload byte
    {
      //just keep reading bytes while we got them.
      if (rx_length < target_length)
      {
        //keep track of CRC.
        rx_crc = _crc_ibutton_update(rx_crc, b);

        //will it fit?
        if (rx_length < MAX_PACKET_LENGTH)
          rx_data[rx_length] = b;

        //keep track.
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

  // Length of the payload 
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
//#if defined(__AVR_ATmega644P__)
    else if(uart == 1)
    {
#ifdef ENABLE_COMMS_DEBUG
      Serial.print("OUT:");
      Serial.print(d, HEX);
      Serial.print("/");
      Serial.println(d, BIN);
#endif      
      Serial1.print(d, BYTE);
    }
//#endif
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
      tx_data[tx_length++] = d;
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
