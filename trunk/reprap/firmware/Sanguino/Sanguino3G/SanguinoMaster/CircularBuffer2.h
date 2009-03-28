#ifndef _CIRCULAR_BUFFER_H_
#define _CIRCULAR_BUFFER_H_

#include <stddef.h>
#include <stdint.h>

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
  volatile size_t capacity;
  volatile size_t head;
  volatile size_t tail;
public:
  CircularBuffer(size_t capacity, uint8_t* pBuf) {
    this->capacity = capacity;
    buffer = pBuf;
    clear();
  }

  ~CircularBuffer() {
  }

  /// Reset buffer.  (Note: does not zero data.)
  void clear() {
    head = tail = 0;
  }

  uint8_t operator[](const size_t i) {
    const size_t idx = (i + head) % capacity;
    return buffer[idx];
  }

  /// Check remaining capacity of this vector.
  size_t remainingCapacity() {
    return capacity - size();
  }

  /// Get the current number of elements in the buffer.
  size_t size() {
    return (capacity + head - tail) % capacity;
  }

  /// Append a character to the end of the circular buffer.
  void append(const uint8_t datum) {

  	size_t i = (head + 1) % capacity;

  	// if we should be storing the received character into the location
  	// just before the tail (meaning that the head would advance to the
  	// current location of the tail), we're about to overflow the buffer
  	// and so we don't write the character or advance the head.
  	if (i != tail) {
  		buffer[head] = datum;
  		head = i;
  	}
  }
  
  void append_16(const uint16_t datum) {
    append(datum & 0xff);
    append(datum >> 8);
  }

  void append_32(const uint32_t datum) {
    append_16(datum & 0xffff);
    append_16(datum >> 16);
  }

  /// Remove and return a character from the start of the
  /// circular buffer.
  const uint8_t remove_8() {
    if (head == tail)
      return 0;
    else
    {
      uint8_t c = buffer[tail];
      tail = (tail + 1) % capacity;
      return c;
    }
  }

  const uint16_t remove_16() {
    //order is important here!
    return remove_8() | ((int16_t)remove_8() << 8);
  }

  const uint32_t remove_32() {
    //order is important here!
    return remove_16() | ((int32_t)remove_16() << 16);
  }
};

#endif // _CIRCULAR_BUFFER_H_
