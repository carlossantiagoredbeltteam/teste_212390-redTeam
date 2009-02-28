/*
 *  Collections.cpp
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#include <WProgram.h>
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

void* DArray::item(size_t i)
{
    if (i < _count)
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

void DArray::set(size_t i, void* item)
{
    if (i < _count)
    {
        _array[i] = item;
    }
}

bool DArray::insert(size_t i, void* item)
{
    size_t needed = max(i, _count + 1);
    
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

void DArray::remove(size_t i)
{
    if (i < _count)
    {
        memmove(&_array[i], &_array[i + 1], (_count - i) * sizeof(void*));

        // We don't need to reallocate this, because realloc will handle this correctly.
        _count--;
    }
}

bool DArray::find(void* itemToFind, size_t* at)
{
    for (size_t index = 0; index < count(); index++)
    {
        void* i = this->item(index);
        if (i == itemToFind)
        {
            if (at)
            {
                *at = index;
            }
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

bool testCollections()
{
//    {
        int i = 0;
        DArray a;
        a.pushValue(i++);
        a.pushValue(i++);
        a.pushValue(i++);
        a.pushValue(i++);
        a.pushValue(i++);

        Serial.print("DArray: Count:");
        Serial.println(a.count());
    
        Serial.println("DArray: poping values");
        while (a.count())
        {
            if (a.popValue() != --i)
            {
                Serial.println("DArray: poping not in order");
                return false;
            }
        }
    
        a.insertValue(0, 3);
        a.insertValue(0, 3);
        a.insertValue(0, 1);
        a.insertValue(0, 1);
        a.insertValue(0, 4);
        a.insertValue(0, 4);
    
        Serial.print("Inserted 6 items, got Count:");
        Serial.println(a.count());
        int tests[] = { 4, 4, 1, 1, 3, 3};
        for (int index = 0; index < a.count(); index++)
        {
            if (tests[index] != a.value(index))
            {
                Serial.println("DArray: inserted values not in order");
                for (index = 0; index < a.count(); index++)
                {
                    Serial.print((long)a[index]);
                    Serial.print(", ");
                }
                
                return false;
            }
        }
    
        DArray b;
        b.pushValue(0);
        b.pushValue(1);
        b.pushValue(2);
        b.pushValue(3);
        b.pushValue(4);
    
        Serial.print("pushed 5 values got Count:");
        Serial.println(a.count());
        size_t index;
    
        Serial.println("Finding value 1");
        bool found = b.findValue(1, &index);
        if (found)
        {
            Serial.println("Found value 1");
        }
        else
        {
            Serial.println("Did not find value 1");
        }
        if (!found || index != 1)
        {
            Serial.println("DArray: values not found correctly");
            return false;
        }
//    }
    Serial.println("DArray: test succeeded");
    
    return true;
}

