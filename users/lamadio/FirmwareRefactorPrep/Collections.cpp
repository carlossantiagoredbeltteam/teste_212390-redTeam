/*
 *  Collections.cpp
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#include <stdlib.h>
#include <strings.h>
#include "Collections.h"


DArray::DArray()
: _array(NULL)
, _count(0)
{
    
}

DArray::~DArray()
{
    if (_array)
        free(_array);
}

void* DArray::item(int i)
{
    if (i >= 0 && i < _count)
    {
        return _array[i];
    }
    
    return NULL;
}

void DArray::push(void* item)
{
    insert(_count, item);
}

void* DArray::dequeue()
{
    void* item = NULL;
    if (_count)
    {
        item = _array[0];
    }
    
    remove(0);
    
    return item;
}

void* DArray::pop()
{
    void* item = NULL;
    if (_count)
    {
        item = _array[_count - 1];
        remove(_count - 1);
    }
    
    return item;
}

void DArray::set(int i, void* item)
{
    if (i < 0)
        i = 0;
    if (i < _count)
    {
        _array[i] = item;
    }
}

bool DArray::insert(int i, void* item)
{
    if (i < 0)
        i = 0;
    int needed = max(i, _count + 1);
    
    if (_array)
    {
        void** newArray = (void**)realloc(_array, needed * sizeof(void*));
        if (newArray)
            _array = newArray;
        else
            return false;
    }
    else
    {
        _array = (void**)malloc(needed * sizeof(void*));
        if (!_array)
            return false;
    }
    
    
    if (i < _count)
    {
        memmove(&_array[i + 1], &_array[i], (_count - i) * sizeof(void*));
    }
    
    _array[i] = item;
    
    _count = needed;
    
    return true;
}

void DArray::remove(int i)
{
    if (i < 0)
        return;
    
    if (i < _count)
    {
        memmove(&_array[i], &_array[i + 1], (_count - i) * sizeof(void*));
    }
    
    // We don't need to reallocate this, because realloc will handle this correctly.
    _count--;
}

int DArray::find(void* item)
{
    for (int index = 0; index < count(); index++)
    {
        void* i = this->item(index);
        if (i == item)
            return index;
    }
    
    return -1;
}


void DArray::sort(DArraySortCallback cb)
{
    qsort(_array, _count, sizeof(void*), cb);
}

DArray* DArray::shallowClone()
{
    DArray* newArray = new DArray();
    if (newArray)
    {
        newArray->_count = _count;
        newArray->_array = (void**)malloc(_count * sizeof(void**));
        if (newArray->_array)
        {
            memmove(newArray->_array, _array, _count * sizeof(void*));
        }
    }
    
    return newArray;
}

bool testCollections()
{
    int i = 0;
    DArray a;
    a.pushValue(i++);
    a.pushValue(i++);
    a.pushValue(i++);
    a.pushValue(i++);
    a.pushValue(i++);
    
    while (a.count())
    {
        if (a.popValue() != --i)
            return false;
    }
    
    a.insertValue(0, 3);
    a.insertValue(0, 3);
    a.insertValue(0, 1);
    a.insertValue(0, 1);
    a.insertValue(0, 4);
    a.insertValue(0, 4);
    
    int tests[] = { 4, 4, 1, 1, 3, 3};
    for (int index = 0; index < a.count(); index++)
    {
        if (tests[index] != a.value(index))
            return false;
    }
    
    return true;
}

