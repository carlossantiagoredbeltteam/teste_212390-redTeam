
#include <util/crc16.h>

#define START_BYTE 0xD5
#define MAX_PACKET_LENGTH 32

// packet states
typedef enum {
  PS_START = 0,
  PS_LEN,
  PS_PAYLOAD,
  PS_CRC,
  PS_LAST
} PacketState;

// various error codes
typedef enum {
  RC_GENERIC_ERROR   = 0,
  RC_OK              = 1,
  RC_BUFFER_OVERFLOW = 2,
  RC_CRC_MISMATCH    = 3,
  RC_PACKET_TOO_BIG  = 4,
  RC_CMD_UNSUPPORTED = 5
} ResponseCode;

//variable to keep track of our packet.
PacketState packet_state = PS_START;
byte packet_target_len = 0;
byte packet_len = 0;
byte packet_data[MAX_PACKET_LENGTH];
byte packet_crc = 0;
boolean is_command_packet = false;

//variables for our response packet
byte response_packet_len = 0;
ResponseCode response_packet_code = RC_OK;
byte response_packet_data[MAX_PACKET_LENGTH];
byte response_packet_crc = 0;

//process a byte from our packet
bool process_packet_byte(byte b)
{
  if (packet_state == PS_START)  // process start byte
  {
    //cool!  its the start of a packet.
    if (b == START_BYTE)
    {
      //update our status and response code.
      packet_state = PS_LEN;
      packet_target_len = 0;
      packet_len = 0;
      packet_crc = 0;
      
      //init our response packet as well.
      response_packet_len = 0;
      response_packet_code = RC_OK;
      response_packet_crc = 0;
      
      is_command_packet = false;
    }
    else
    {
      // throw an error message?
      // nah, ignore it as garbage.
    }
  }
  else if (packet_state == PS_LEN) // process length byte
  {
    //figure out how much data is coming.
    //please note: data may go into command buffer
    //instead of query packet buffer, so don't check the size
    packet_target_len = b;
    packet_len = 0;
    packet_state = PS_PAYLOAD;
  }
  else if (packet_state == PS_PAYLOAD)  // process payload byte
  {
    //the first byte determines command vs query
    if (packet_len == 0)
    {
      // top bit high == bufferable command packet (eg. #128-255)
      if (b & 1 << 7)
	is_command_packet = true;
      // top bit low == reply needed query packet (eg. #0-127)
      else
	is_command_packet = false;
    }
    //just keep reading bytes while we got them.
    if (packet_len < packet_target_len)
    {
      //keep track of CRC.
      packet_crc = _crc_ibutton_update(packet_crc, b);

      //we put different things in different buffers.  (query vs command)
      if (is_command_packet)
      {
	//will it fit?
        if (commandBuffer.remainingCapacity() == 0)
          response_packet_code = RC_BUFFER_OVERFLOW;
        else
          commandBuffer.append(b);
      }
      else
      {
        //will it fit?
        if (packet_len < MAX_PACKET_LENGTH)
	  packet_data[packet_len] = b;
	else
	  response_packet_code = RC_PACKET_TOO_BIG;
      }
      
      packet_len++;
    }

	//are we done?
    if (packet_len >= packet_target_len)
      packet_state = PS_CRC;
  }
  else if (packet_state == PS_CRC)  // check crc
  {
    // did the packet check out?
    if (packet_crc != b)
      response_packet_code = RC_CRC_MISMATCH;

	//okay, the packet is done.
    packet_state = PS_LAST;
  }
}

//handle our packets.
void process_packets()
{
	//read through our available data
	while (Serial.available() > 0)
	{
		//grab a byte and process it.
		byte d = Serial.read();
		process_packet_byte(d);
		
		//do we have a finished packet?
		if (packet_state == PS_LAST)
		{
			//are we cool?
			if (response_packet_code == RC_OK && !is_command_packet)
				handle_query();		

			//okay, send our response
			send_reply_packet();

			//now we're done.
			packet_state = PS_START;

			//only process one packet at a time.
			break;		
		}
	}
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
void add_reply_8(uint8_t data)
{
  //only add it if it will fit.
  if (response_packet_len < MAX_PACKET_LENGTH)
  {
    response_packet_data[response_packet_len] = data;
    response_packet_len++;
  }
}

//send a response back to the host.
void send_reply_packet()
{
	//initialize our response CRC
	response_packet_crc = 0;
	response_packet_crc = _crc_ibutton_update(response_packet_crc, response_packet_code);
	
	//actually send our response.
	Serial.print(START_BYTE, BYTE);
	Serial.print(response_packet_len+1, BYTE);
	Serial.print(response_packet_code, BYTE);

	//loop through our reply packet payload and send it.
	for (byte i=0; i<response_packet_len; i++)
	{
	  Serial.print(response_packet_data[i], BYTE);
	  response_packet_crc = _crc_ibutton_update(response_packet_crc, response_packet_data[i]);
	}

	//okay, send our CRC.
	Serial.print(response_packet_crc, BYTE);
}
