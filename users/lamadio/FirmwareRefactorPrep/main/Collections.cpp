/*
 *  Collections.cpp
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *     Provided under GPLv3 per gpl-3.0.txt
 *
 */
#include <stdlib.h>
#include <string.h>
#include "WProgram.h"
#include "Collections.h"

#define ARRAY_GROWTH_COUNT 3


DArray::DArray()
: _array(NULL)
, _count(0)
, _allocated(0)
{
    
}

DArray::~DArray()
{
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
    if (needed > _allocated)
    {
        _allocated += ARRAY_GROWTH_COUNT;
                    
        /*
            NOTE: Ideally this codepath would use realloc in order to expand an 
            existing array, however, the current libc implementation of realloc
            has a subtle bug which causes freelist corruption. 
            Editorial of this bug is:
            http://www.ooeygui.com/?p=216
            With annotated fix here:
            http://www.ooeygui.com/?p=221

            The patch will be submitted to the AVR working group, however,
            the workaround posted will function, albeit more slowly as it requires
            a memmove on each allocation. This codepath attempts to workaround it
            with by keeping track of a separate count and allocated.
            void** newArray = (void**)realloc(_array, _allocated * sizeof(void*));
            if (newArray)
                _array = newArray;
            else
                return false;
        */
        void** newArray = (void**)malloc(_allocated * sizeof(void*));
        if (newArray)
        {
            if (_array)
            {
                memmove(newArray, _array, _count * sizeof(void*));
                free(_array);
            }
            
            _array = newArray;
        }
        else
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
    
    if (i < _count - 1)
    {
        memmove(&_array[i], &_array[i + 1], (_count - i - 1) * sizeof(void*));
    }
    
    _count--;
    
    if (_count == 0)
    {
        _allocated = 0;
        free(_array);
        _array = NULL;
    }
}

bool DArray::find(void* item, size_t* at)
{
    for (size_t index = 0; index < count(); index++)
    {
        void* i = this->item(index);
        if (i == item)
        {
            if (at)
                *at = index;
            return true;
        }
    }
    
    return false;
}


void DArray::foreach(DArrayForEach cb, void* context)
{
    for (size_t index = 0; index < count(); index++)
    {
        cb(_array[index], context);
    }
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
