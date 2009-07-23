/*
 * Class to handle internal communications in the machine via RS485
 *
 * Adrian Bowyer 3 July 2009
 *
 */
 
 /* 
 
   A data packet looks like this:
 
     * T F d a t a $
     
   All these are printable characters.  * is the start character; it is not included in the string that is the result of 
   reading the packet.  T (to) is the one-char name of the destination, 
   F (from) is the one-char name of the source, d a t a is a char string containing the message, which is 
   terminated by a $ character.   If users wish they can include checksum and length information in the data, 
   as long as it is all printable.   The total length of a packet with all of that should not exceed RS485_BUF_LEN 
   (defined in configuration.h) characters.  When a packet is received the $ character is replaced by 0, thus 
   forming a standard C string.
 
 */
 
#ifndef INTERCOM_H
#define INTERCOM_H

#if MOTHERBOARD > 1

// Our RS485 driver and timeout

#if RS485_MASTER == 1
 #define rs485Interface Serial1
 #define TIMEOUT 3
#else
 #define rs485Interface Serial
 #define TIMEOUT (64*3)     // 3 ms, but TIMER0 has been messed with in the slave
#endif

// Communication speed

#define RS485_BAUD 115200


// The acknowledge, start, end and error characters
#define RS485_ACK 'A'
#define RS485_START '*'
#define RS485_END '$'
#define RS485_ERROR '!'

// Size of the transmit and receive buffers
#define RS485_BUF_LEN 30

class intercom
{
  private:
  
    char inputByte;
  // The input and output buffers for packets
    char inBuffer[RS485_BUF_LEN];
    volatile byte inPointer;
    char outBuffer[RS485_BUF_LEN];
    volatile byte outPointer;
    volatile byte echoPointer;
    bool inPacket;
    bool newPacket;

/*
 Any short message can be returned with the next acknowledgement in the string reply[].
 This includes things like temperatures and so on.
 
 Assign to it like this: 
 
    setReply(" My message");
    
 with a blank first character.  This will be overwritten with the ACK
 character.  
 
 Errors should be flagged with '!': 
 
    setReply(" !Horrible error.");
    
 You can append extra information on the end with
 
    addReply("additional info");
    
 Don't exceed RS485_BUF_LEN - 5
 
*/
   char reply[RS485_BUF_LEN];
   void queuePacket(char to, char* string);
   byte mystrcpy(char* buf, char* s);
   //void sendByte(char b);
   void dudEcho(byte b, byte echo);
   void reset();
   void talk();
   void listen();
   bool waitInput();
   bool waitOutput();
    
#if RS485_MASTER == 1
    bool ok;
    bool getPacket(char* string, int len);
#else
    void acknowledgeAndReset(char to);
#endif

  public:
    intercom();
    void tick();
#if RS485_MASTER == 1
    void fireAndForget(char to, char* string);
    char* sendPacketAndGetReply(char to, char* string);
#else 
    void getAndProcessCommand();
    void setReply(char* string);
    void addReply(char* string);
    char* getReply();
#endif
};

extern intercom talker;

#endif
#endif
