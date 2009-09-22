/*
 * Class to handle internal communications in the machine via RS485
 *
 * Adrian Bowyer 3 July 2009
 *
 */

#include "intercom.h"

#if MOTHERBOARD > 1


#if RS485_MASTER == 1
intercom::intercom()
#else
intercom::intercom(extruder* e)
#endif
{
#if !(RS485_MASTER == 1)
  ex = e;
#endif
  pinMode(RX_ENABLE_PIN, OUTPUT);
  pinMode(TX_ENABLE_PIN, OUTPUT);
  digitalWrite(RX_ENABLE_PIN, 0); // Listen is always on
  resetOutput();
  resetInput();
  listen();
}


// Reset the output buffer and its associated variables

void intercom::resetOutput()
{
  outBuffer[0] = 0;
  outPointer = 0;
}

// Reset the input buffer and its associated variables

void intercom::resetInput()
{
  inBuffer[0] = 0;
  inPointer = 0;
  inPacket = false;
  packetReceived = false;  
}

// The checksum for a string is the least-significant nibble of the sum
// of the string's bytes added to the character RS485_CHECK.  It can thus take
// one of sixteen values, all printable.

char intercom::checksum(char* string)
{
  int cs = 0;
  int i = 0;
  while(string[i]) 
  {
    cs += string[i];
    i++;
  }
  cs &= 0xF;
  return RS485_CHECK + cs;
}

// Check the checksum of a string, presumed to be in the third (x[2]) byte

bool intercom::checkChecksum(char* string)
{
  char cs = string[2];
  string[2] = 0;
  char c = checksum(string);
  string[2] = cs;
  return (c == cs);
}

// Build a packet to device to from an input string.  See intercom.h for the
// packet structure.  ack should either be RS485_ACK or RS485_ERROR.

void intercom::buildPacket(char to, char ack, char* string)
{
  byte i, j, k;
  j = 0;
  while(j < RS485_START_BYTES)
  {
     outBuffer[j] = RS485_START;
     j++;
  }
  outBuffer[j] = to;
  j++;
  outBuffer[j] = MY_NAME;
  j++;
  outBuffer[j] = 0; // Where the checksum will go
  k = j;
  j++;
  outBuffer[j] = ack;
  j++;
  i = 0;
  while(string[i] && j < RS485_BUF_LEN - 4)
  {
    outBuffer[j] = string[i];
    j++;
    i++;
  }
  outBuffer[j] = 0;
  outBuffer[k] = checksum(&outBuffer[RS485_START_BYTES]);
  outBuffer[j] = RS485_END;
  j++;
  outBuffer[j] = 0;  
}

// Switch to listen mode

bool intercom::listen()
{
   if(inPacket)
   {
      listenCollision();
      return false;
   }
   digitalWrite(TX_ENABLE_PIN, 0);
   state = RS485_LISTEN;
   delayMicrosecondsInterruptible(RS485_STABILISE);
   resetWait();
   return true;
}

// Switch to talk mode

bool intercom::talk()
{
   if(state == RS485_TALK)
   {
      talkCollision();
      return false;
   }
   digitalWrite(TX_ENABLE_PIN, 1);
   state = RS485_TALK;
   delayMicrosecondsInterruptible(RS485_STABILISE);
   while(rs485Interface.available()) rs485Interface.read(); // Empty any junk from the input buffer
   resetWait();
   return true; 
}

// Something useful has happened; reset the timeout time

void intercom::resetWait()
{
   wait_zero = millis();
}

// Have we waited too long for something to happen?

bool intercom::tooLong()
{
  return (millis() - wait_zero > TIMEOUT)
}


// The master processing function.  Call this in a fast loop, or from a fast repeated interrupt

void intercom::tick()
{
  char b = 0;
    
  switch(state)
  {
  case RS485_TALK:
  
      // Has what we last sent (if anything) been echoed?
      
      if(rs485Interface.available())
      {
        b = rs485Interface.read();
        resetWait();
      } else
      {
        // Have we waited too long for an echo?
        
        if(tooLong())  
        {
          talkTimeout();
          return;  
        }
      }
      
      // Was the echo (if any) the last character of a packet?
      
      if(b == RS485_END)
      {
        // Yes - reset the output buffer and go back to listening
        
        resetOutput();
        listen();
        return;            
      }
        
      // Do we have anything to send?
  
      b = outBuffer[outPointer];
      if(!b)
        return;
      
      // Yes - send it and reset the timeout timer
      
      rs485Interface.print(b, BYTE);
      outPointer++;
      if(outPointer >= RS485_BUF_LEN)
              outputBufferOverflow();
      resetWait();
      break;
      
  // If we have timed out while sending, reset everything and go
  // back to listen mode
      
  case RS485_TALK_TIMEOUT:
      resetOutput();
      resetInput();
      listen();
      break;
      
  case RS485_LISTEN:
      if(rs485Interface.available())  // Got anything?
      {
        b = rs485Interface.read();
        switch(b)
        {
        case RS485_START:  // Start character - reset the input buffer
          inPointer = 0;
          inPacket = true;
          break;
        
        case RS485_END:   // End character - terminate, then process, the packet
          if(inPacket)
          {
            inBuffer[inPointer] = 0;
            processPacket();
          }
          break;

        default:     // Neither start or end - if we're in a packet it must be data
                     // if not, ignore it.
          if(inPacket)
          {
            inBuffer[inPointer] = b;
            inPointer++;
            if(inPointer >= RS485_BUF_LEN)
              inputBufferOverflow();
          }
        }
        
        // We just received something, so reset the timeout time
        
        resetWait();
      } else
      {
        
        // If we're in a packet and we've been waiting too long for the next byte
        // the packet has timed out.
        
        if(inPacket && tooLong())
          listenTimeout();
      }
      break;
        
  case RS485_LISTEN_TIMEOUT:
      resetInput();
      listen();
      break;
      
  default:
      corrupt();
      break;
  }
}

// We are busy if we are talking, or in the middle of receiving a packet

bool intercom::busy()
{
  return (state == RS485_TALK) || inPacket;
}


// Send string to device to.

bool intercom::queuePacket(char to, char ack, char* string)
{
  if(busy())
  {
    talkCollision();
    return false;
  }
  buildPacket(to, ack, string);
  talk();
  return true;
}

// Wait for a packet to arrive.  The packet will be in inBuffer[ ]

bool intercom::waitForPacket()
{
  long timeNow = millis();
  while(!packetReceived)
  {
     if(millis() - timeNow > TIMEOUT)
     {
       waitTimeOut();
       packetReceived = false;
       return false;
     }
  }
  packetReceived = false;
  return true;
}

// Send a packet and get an acknowledgement - used when no data is to bereturned.

bool intercom::sendPacketAndCheckAcknowledgement(char to, char* string)
{
  byte retries = 0;
  bool ok = false;
  while((inBuffer[0] != MY_NAME || inBuffer[3] != RS485_ACK) && retries < RS485_RETRIES && !ok)
  {
    if(queuePacket(to, RS485_ACK, string))
      ok = waitForPacket();
    ok &&= checkChecksum(inBuffer);
    if(!ok)
     delay(2*TIMEOUT);  // Wait twice timeout, and everything should have reset itself
    retries++;   
  }
  return ok;  
}

// Send a packet and get data in reply.  The string returned is just the data;
// it has no packet housekeeping information in.

char* intercom::sendPacketAndGetReply(char to, char* string)
{
  if(!sendPacketAndCheckAcknowledgement(to, string))
    inBuffer[4] = 0;
  strcpy(reply, &inBuffer[4]);
  return reply;
}

// This function is called when a packet has been received

void intercom::processPacket()
{
  if(inBuffer[0] != MY_NAME)
  {
    resetInput();
    return;
  }  
#if !(RS485_MASTER == 1)
  if(checkChecksum(inBuffer))
    queuePacket(inBuffer[1], RS485_ACK, ex->processCommand(&inBuffer[4]));
  else
  {
    reply[0] = 0;
    queuePacket(inBuffer[1], RS485_ERROR, reply);
  }
  resetInput();
#endif
  packetReceived = true;
}


// *********************************************************************************

// Error functions

// The output buffer has overflowed

void intercom::outputBufferOverflow()
{
  outPointer = 0;  
}


// The input buffer has overflowed

void intercom::inputBufferOverflow()
{
  resetInput();  
}

// An attempt has been made to start sending a new message before
// the old one has been fully sent.

void intercom::talkCollision()
{
  
}

// An attempt has been made to get a new message before the old one has been
// fully received or before the last transmit is finished.

void intercom::listenCollision()
{
  
}

// (Part of) the data structure has become corrupted

void intercom::corrupt()
{
  
}


// We have been trying to send a message, but something is taking too long

void intercom::talkTimeout()
{
  state = RS485_TALK_TIMEOUT  
}

// We have been trying to receive a message, but something has been taking too long

void intercom::listenTimeout()
{
  state = RS485_LISTEN_TIMEOUT   
}

// We have been waiting too long for an incomming packet

void intercom::waitTimeout()
{
    
}


#endif
