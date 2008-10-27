/*
 *  Collections.h
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */

#ifndef Collections_h
#define Collections_h

#ifndef max
inline int max(int x, int y) 
{
    return (x > y)?x:y;
}
#endif

typedef int (*DArraySortCallback)(const void* item1, const void* item2);
typedef void (*DArrayForEach)(void* item, void* context);


//
// Dynamic Array
//      Dynamic array implementation for Arduino which is memory efficient.
//      Implements several simple datastructures - Queue, Stack, and List
//
class DArray
{
    void** _array;
    size_t _count;
public:
    DArray();
    ~DArray();
    
    inline int count() { return _count; }
    void* item(size_t i);
    void push(void* item);
    void* pop();
    void* dequeue();
    void set(size_t i, void* item);
    bool insert(size_t i, void* item);
    void remove(size_t i);
    bool find(void* item, size_t* index = NULL);
    
    void* operator[](size_t index) { return item(index); }
    
    DArray* shallowClone();
    
    void sort(DArraySortCallback cb);
    
    // Do not modify the array during handling
    void foreach(DArrayForEach cb, void* context);
    
    inline int value(size_t i) { return (int)item(i); }
    inline bool findValue(int i, size_t* index) { return find((void*)i, index); }
    inline void pushValue(size_t i) { push((void*)i); }
    inline int popValue() { return (int)pop(); }
    inline int dequeueValue() { return (int)dequeue(); }
    inline bool insertValue(size_t i, int value) { return insert(i, (void*)value); }
};

bool testCollections();

#endif

