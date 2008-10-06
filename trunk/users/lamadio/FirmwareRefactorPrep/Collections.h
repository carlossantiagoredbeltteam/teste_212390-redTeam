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


//
// Dynamic Array
//      Dynamic array implementation for Arduino which is memory efficient.
//      Implements several simple datastructures - Queue, Stack, and List
//
class DArray
{
    void** _array;
    int _count;
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
    int find(void* item);
    
    DArray* shallowClone();
    
    void sort(DArraySortCallback cb);
    
    inline int value(int i) { return (int)item(i); }
    inline void pushValue(int i) { push((void*)i); }
    inline int popValue() { return (int)pop(); }
    inline int dequeueValue() { return (int)dequeue(); }
    inline bool insertValue(int i, int value) { return insert(i, (void*)value); }
};

bool testCollections();

#endif

