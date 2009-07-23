/*
 * Class to handle internal communications in the machine via RS485
 *
 * Adrian Bowyer 3 July 2009
 *
 */

#include "intercom.h"

#if MOTHERBOARD > 1


intercom::intercom()
{
  outBuffer[0] = 0;
  outPointer = 0;
  reset();
  pinMode(RX_ENABLE_PIN, OUTPUT);
  pinMode(TX_ENABLE_PIN, OUTPUT);
  digitalWrite(RX_ENABLE_PIN, 0); // Listen is always on
  listen();
}

void intercom::listen()
{
   digitalWrite(TX_ENABLE_PIN, 0);   
}

void intercom::talk()
{
   digitalWrite(TX_ENABLE_PIN, 1);   
}

bool intercom::waitInput()
{
  long zero = millis();
  while(!rs485Interface.available())
  {
    if(millis() - zero > TIMEOUT)
      return false;
  }
  return true;
}

bool intercom::waitOutput()
{
  long zero = millis();
  while(outBuffer[0])
  {
    tick();
    if(millis() - zero > TIMEOUT)
      return false;
  }
  return true;
}


void intercom::reset()
{
   inPacket = false;
   inPointer = 0;
   reply[0] = 0;
}

void intercom::sendByte(char b)
{
  char echo;
  bool timeOK;
  rs485Interface.print(b, BYTE);
  timeOK = waitInput();
  echo = rs485Interface.read();
  if(echo == b)
    return;

// Ooops...

#if RS485_MASTER == 1
    char be[3];
    debugstring[0] = 0;
    if(!timeOK)
      strcat(debugstring,"T, ");
    strcat(debugstring, "ECHOX: ");
    be[0] = b;
    be[1] = echo;
    be[2] = 0;
    strcat(debugstring, be);
#endif
}


void intercom::tick()
{
  if(outBuffer[outPointer])
  {
   sendByte(outBuffer[outPointer]);
   outPointer++;
   return;
  }
  if(!outPointer)
    return;
  listen();
  outBuffer[0] = 0;
  outPointer = 0;
}



byte intercom::mystrcpy(char* buf, char* s)
{
  byte i = 0;
  while(s[i])
  {
    buf[i] = s[i];
    i++;
  }
  buf[i] = 0;
  return i;  
}


void intercom::queuePacket(char to, char* string)
{
#if RS485_MASTER == 1
  if(outBuffer[0])
  {
    strcpy(debugstring, "Packet collision!");
    return;
  }
#endif

  byte len;
  talk();
  while(rs485Interface.available()) rs485Interface.read(); // Empty any junk from the input buffer
  outBuffer[0] = RS485_START;
  outBuffer[1] = to;
  outBuffer[2] = MY_NAME;
  len = mystrcpy(&outBuffer[3], string) + 3;
  outBuffer[len] = RS485_END;
  len++;
  outBuffer[len] = 0;
  outPointer = 0;
}

#if RS485_MASTER == 1

bool intercom::getPacket(char* string, int len)
{
    if(!waitOutput())
    {
       strcat(debugstring,"Timeout on sendpacket!");
       return false;
    }
    
    int i = -1;
    inPacket = false;
    
    do
    {
      if(!waitInput())
      {
        string[i+1] = 0;
        return false;
      }
      inputByte = rs485Interface.read();
      inPacket = (inputByte == RS485_START);
    } while(!inPacket); 
  
    do
    {
      if(!waitInput())
      {
        inPacket = false;
        string[i+1] = 0;
        return false;
      }
      inputByte = rs485Interface.read();
      i++;
      // Stop runaway buffer overflow
      if(i >= len)
      {
        inPacket = false; 
        i--;
      } else
      string[i] = inputByte;
    } while(inputByte != RS485_END && inPacket);
    string[i] = 0;
    if(!inPacket)
      return false;
    inPacket = false;
    return true;
}

void intercom::fireAndForget(char to, char* string)
{
  queuePacket(to, string);  
}

char* intercom::sendPacketAndGetReply(char to, char* string)
{
  reply[0] = 0;
  byte retries = 0;
  bool ok = false;
  while((reply[0] != MY_NAME || reply[2] != RS485_ACK || reply[3] == RS485_ERROR) && retries < 3 && !ok)
  {
    queuePacket(to, string);
    ok = getPacket(reply, RS485_BUF_LEN - 5); 
    retries++;   
  }
  
  debugstring[0] = 0;
  
  if(!ok)
      strcat(debugstring, "G, ");  
  
  if(reply[0] != MY_NAME)
  {
      strcat(debugstring, "N, ");
      ok = false;
  }
  
  if(reply[2] != RS485_ACK || reply[3] == RS485_ERROR)
  {
      strcat(debugstring, "E: ");
      ok = false;
  }
  
  if(!ok)    
    strcat(debugstring, reply);
   
  return &reply[3];
}

#else

void intercom::acknowledgeAndReset(char to)
{
  if(!reply[0])
    reply[1] = 0;
  reply[0] = RS485_ACK;
  queuePacket(to, reply);
  reset();
}
  
void intercom::getAndProcessCommand()
{
  if(!rs485Interface.available())
    return;
  inputByte = rs485Interface.read();
  if(inPacket)
  {
    if(inputByte == RS485_END)
    {
      inBuffer[inPointer] = 0;
      if(inBuffer[0] != MY_NAME) // For me?
      {
        reset(); // No
        return;
      }
      if(ex.processCommand(&inBuffer[2]))
        acknowledgeAndReset(inBuffer[1]);
    }else
    {
      inBuffer[inPointer] = inputByte;
      inPointer++;      
    }
    if(inPointer >= RS485_BUF_LEN)
    {
     reset();
     setReply(" !Buffer overrun");
    }
  }else
  {
     if(inputByte == RS485_START)
       inPacket = true;
  }
}

void intercom::setReply(char* string)
{
  strcpy(reply, string);
}

void intercom::addReply(char* string)
{
  strcat(reply, string);  
}

char* intercom::getReply()
{
  return reply;  
}

#endif
#endif
