#ifndef _CIRCULAR_BUFFER_H_
#define _CIRCULAR_BUFFER_H_

#include <stddef.h>
#include <stdint.h>
#include "Timer1.h"

#include <util/atomic.h>

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
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      head = tail = 0;
      currentSize = 0;
    //}
    enableTimer1Interrupt();
  }

  uint8_t operator[](uint16_t i) {
    uint16_t idx;
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      idx = (i + tail) % capacity;
    //}
    enableTimer1Interrupt();
    return buffer[idx];
  }

  /// Check remaining capacity of this vector.
  uint16_t remainingCapacity()
  {
    uint16_t remaining;
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      remaining = (capacity - currentSize);
    //}
    enableTimer1Interrupt();
    return remaining;
  }

  /// Get the current number of elements in the buffer.
  uint16_t size() {
    uint16_t csize;
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      csize = currentSize;
    //}
    enableTimer1Interrupt();
    return csize;
  }

private:
  /// Append a character to the end of the circular buffer.
  void appendInternal(uint8_t datum)
  {
    if ((currentSize + 1) <= capacity)
    {
      buffer[head] = datum;
      head = (head + 1) % capacity;
      currentSize++;
    }
  }
  
public:
  void append(uint8_t datum) {
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      appendInternal(datum);
    //}
    enableTimer1Interrupt();
  }

  void append_16(uint16_t datum) {
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      appendInternal(datum & 0xff);
      appendInternal((datum >> 8) & 0xff);
    //}
    enableTimer1Interrupt();
  }

  void append_32(uint32_t datum) {
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      appendInternal(datum & 0xff);
      appendInternal((datum >> 8) & 0xff);
      appendInternal((datum >> 16) & 0xff);
      appendInternal((datum >> 24) & 0xff);
    //}
    enableTimer1Interrupt();
  }

private:
  uint8_t removeInternal() {
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

public:    
  /// Remove and return a character from the start of the
  /// circular buffer.
  uint8_t remove_8() {
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      return removeInternal();
    //}
    enableTimer1Interrupt();
  }

  uint16_t remove_16() {
    uint8_t v[2];
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      v[0] = removeInternal();
      v[1] = removeInternal();
    //}
    enableTimer1Interrupt();
    return v[0] | ((uint16_t)v[1] << 8);
  }

  uint32_t remove_32() {
    uint8_t v[4];
    disableTimer1Interrupt();
    //ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
      v[0] = removeInternal();
      v[1] = removeInternal();
      v[2] = removeInternal();
      v[3] = removeInternal();
    //}
    enableTimer1Interrupt();
    return v[0] |
      ((uint32_t)v[1] << 8) |
      ((uint32_t)v[2] << 16) |
      ((uint32_t)v[3] << 24);
  }
};

#endif // _CIRCULAR_BUFFER_H_
