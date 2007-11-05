/*
  PackIt.h - Simple packet transmission library - Version 0.1

  This library is used to send basic packets to the host software.

  History:
  * Created initial library (0.1) by Zach Smith.

*/

// ensure this library description is only included once
#ifndef PackIt_h
#define PackId_h

//give us a default size of 255
#ifndef MAX_PACKET_SIZE
#define MAX_PACKET_SIZE 255
#ifndef

// library interface description
class PackIt {
  public:

    // constructors:
    PackIt(byte to, byte from);

	//our interface methods
	boolean add(byte b);
	boolean add(boolean b);
	boolean add(char c);
	boolean add(int i);
	boolean add(unsigned int i);
	boolean add(long l);
	boolean add(unsigned long l);
	boolean add(float f);
	boolean add(double d);
	
	//our sender function
	void send();

  private:

    byte to;
	byte from;
	byte crc;
	byte size;
	byte packets[MAX_PACKET_SIZE];
};

#endif
