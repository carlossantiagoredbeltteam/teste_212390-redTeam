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

typedef void (*DArrayForEach)(void* item, void* context);
typedef int (*DArraySortCallback)(const void* item1, const void* item2);


//
// Dynamic Array
//      Dynamic array implementation for Arduino which is memory efficient.
//      Implements several simple datastructures - Queue, Stack, and List
//
class DArray
{
    void** _array;
    size_t _count;
    size_t _allocated;
public:
    DArray();
    ~DArray();
    
    inline int count() { return _count; }
    void* item(int i);
    void push(void* item);
    void* pop();
    void* dequeue();
    void set(int i, void* item);
    bool insert(int i, void* item);
    void remove(int i);
    bool find(void* item, size_t* index = NULL);
    void* operator[](size_t index) { return item(index); }
    
    DArray* shallowClone();
    
    void sort(DArraySortCallback cb);
    // Do not modify the array during handling
    void foreach(DArrayForEach cb, void* context);
    
    int value(int i) { return (int)item(i); }
    void pushValue(int i) { push((void*)i); }
    int popValue() { return (int)pop(); }
    int dequeueValue() { return (int)dequeue(); }
    bool insertValue(int i, int value) { return insert(i, (void*)value); }
};

#endif

