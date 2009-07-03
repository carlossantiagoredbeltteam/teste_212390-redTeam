/*
 * Class to handle internal communications in the machine via RS485
 *
 * Adrian Bowyer 3 July 2009
 *
 */
 
#ifndef INTERCOM_H
#define INTERCOM_H

#if MOTHERBOARD > 1

#define IC_BUFFER 10
#define MASTER_ADDRESS "00"
 
class intercom
{
  private:
    char myBuffer[IC_BUFFER];
    bool ok;
  
  public:
    intercom();
    void sendPacket(byte address, char* string);
    void sendPacketWithReply(byte address, char* string, char* reply);
    void getPacket(char* string, int len);
};

extern intercom talker;

#endif
#endif
