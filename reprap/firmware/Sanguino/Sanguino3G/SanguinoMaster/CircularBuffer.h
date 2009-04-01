#ifndef _CIRCULAR_BUFFER_H_
#define _CIRCULAR_BUFFER_H_

#include <stddef.h>
#include <stdint.h>
#include "Timer1.h"

///
/// Implementation of an in-memory circular byte buffer.
/// Originally a template, bowlderized to make the
/// arduino build happy.  Sigh.
///
/// No safety checks are made in this
/// implementation.  It will allow you to cheerfully
/// write bytes all over yourself.
///
/// Hacked to make it safer for multi-access by Hoeken.
///

class CircularBuffer {
private:
  uint8_t* buffer;
  uint16_t capacity;
  uint16_t head;
  uint16_t tail;
  uint16_t currentSize;
public:
  CircularBuffer(uint16_t capacity, uint8_t* pBuf) {
    this->capacity = capacity;
    buffer = pBuf;
    clear();
  }

  ~CircularBuffer() {
  }

  /// Reset buffer.  (Note: does not zero data.)
  void clear() {
    disableTimer1Interrupt();
    head = tail = 0;
    currentSize = 0;
    enableTimer1Interrupt();
  }

  uint8_t operator[](uint16_t i) {
    disableTimer1Interrupt();
    uint16_t idx = (i + tail) % capacity;
    enableTimer1Interrupt();
    return buffer[idx];
  }

  /// Check remaining capacity of this vector.
  uint16_t remainingCapacity()
  {
    disableTimer1Interrupt();
    uint16_t remaining = (capacity - currentSize);
    enableTimer1Interrupt();
    return remaining;
  }

  /// Get the current number of elements in the buffer.
  uint16_t size() {
    return currentSize;
  }

  /// Append a character to the end of the circular buffer.
  void append(uint8_t datum)
  {
    disableTimer1Interrupt();
  	
  	if ((currentSize + 1) <= capacity)
  	{
  		buffer[head] = datum;
  		head = (head + 1) % capacity;
  		currentSize++;
  	}
  	
    enableTimer1Interrupt();
  }
  
  void append_16(uint16_t datum) {
    append(datum & 0xff);
    append(datum >> 8);
  }

  void append_32(uint32_t datum) {
    append_16(datum & 0xffff);
    append_16(datum >> 16);
  }

  /// Remove and return a character from the start of the
  /// circular buffer.
  uint8_t remove_8() {
    if (currentSize == 0)
      return 0;
    else
    {
      uint8_t c = buffer[tail];
      tail = (tail + 1) % capacity;
      currentSize--;
      return c;
    }
  }

  uint16_t remove_16() {
    //order is important here!
    return remove_8() | ((int16_t)remove_8() << 8);
  }

  uint32_t remove_32() {
    //order is important here!
    return remove_16() | ((int32_t)remove_16() << 16);
  }
};

#endif // _CIRCULAR_BUFFER_H_
