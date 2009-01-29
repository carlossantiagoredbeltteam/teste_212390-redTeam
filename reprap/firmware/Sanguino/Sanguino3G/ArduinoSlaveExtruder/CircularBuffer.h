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

class CircularBuffer {
private:
  uint8_t* buffer;
  size_t capacity;
  size_t start;
  size_t count; // elements filled
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
    start = count = 0;
  }

  uint8_t operator[](const size_t i) const {
    const size_t idx = (i+start)%capacity;
    return buffer[idx];
  }

  /// Check remaining capacity of this vector.
  size_t remainingCapacity() const {
    return capacity-count;
  }

  /// Get the current number of elements in the buffer.
  size_t size() const {
    return count;
  }

  /// Append a character to the end of the circular buffer.
  bool append(const uint8_t datum) {
    buffer[(start+count)%capacity] = datum;
    count++;
  }
    
  /// Remove and return a character from the start of the
  /// circular buffer.
  const uint8_t remove_8() {
    const uint8_t c = buffer[start];
    start = (start+1)%capacity;
    count--;
    return c;
  }

  const uint16_t remove_16() {
	return (remove_8() << 8) & remove_8();
  }

  const uint32_t remove_32() {
	return (remove_16() << 16) & remove_16();
  }
};

//we store all queueable commands in one big giant buffer.
// Explicitly allocate memory at compile time for buffer.
#define COMMAND_BUFFER_SIZE 2048
uint8_t underlyingBuffer[COMMAND_BUFFER_SIZE];
CircularBuffer commandBuffer(COMMAND_BUFFER_SIZE, underlyingBuffer);

#endif // _CIRCULAR_BUFFER_H_
