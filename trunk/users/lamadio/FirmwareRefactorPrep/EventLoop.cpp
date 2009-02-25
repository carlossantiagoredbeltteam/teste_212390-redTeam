/*
 *  EventLoop.cpp
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#include <stdlib.h>
#include <stdio.h>
#include "WProgram.h"
#include "Collections.h"
#include "EventLoop.h"


PeriodicCallback::PeriodicCallback()
{
    
}

EventLoopTimer::EventLoopTimer()
: _lastTimeout(0)
, _period(0)
{
    
}

EventLoopTimer::EventLoopTimer(milliclock_t period)
: _lastTimeout(0)
, _period(period)
{
    
}

milliclock_t EventLoopTimer::nextTimeout() const
{
    milliclock_t nextTimeout = 0;
    if (_lastTimeout > millis())
    {
        nextTimeout = millis() + period() - (MILLICLOCK_MAX - _lastTimeout);
    }
    else
    {
        nextTimeout = millis() + period();
    }
    
    return nextTimeout;
}



static EventLoop* g_eventLoop = NULL;

EventLoop::EventLoop()
: _lastTimeout(0)
, _running(false)
{
    g_eventLoop = this;
}

EventLoop::~EventLoop()
{
    
}

void EventLoop::addPeriodicCallback(PeriodicCallback* callback)
{
    // No checking done for duplicates. Don't do it.
    _periodicEvents.push(callback);
}

void EventLoop::removePeriodicCallback(PeriodicCallback* callback)
{
    _periodicEvents.remove(_periodicEvents.find(callback));
}

void EventLoop::addTimer(EventLoopTimer* timer)
{
    // No checking done for duplicates. Don't do it.
    _timers.push(timer);
    sortTimers();
}

void EventLoop::removeTimer(EventLoopTimer* timer)
{
    _timers.remove(_timers.find(timer));
}

void EventLoop::run()
{
    _running = true;
    while (_running)
    {
        incrementMillis();
        // This clone prevents changes to the event loop during a pass from interrupting the run.
        if (_periodicEvents.count())
        {
            DArray* clone = _periodicEvents.shallowClone();
            if (clone)
            {
                for (int i = 0; i < clone->count(); i++)
                {
                    PeriodicCallback* cb = (PeriodicCallback*)clone->item(i);
                    cb->service();
                }
                
                delete clone;
            }
        }
        
        if (_timers.count())
        {
            milliclock_t currentTimeout = millis();
            DArray* firingTimers = findFiringTimers();
            if (firingTimers)
            {
                for (int i = 0; i < firingTimers->count(); i++)
                {
                    EventLoopTimer* cb = (EventLoopTimer*)firingTimers->item(i);
                    cb->fire();
                    cb->setLastTimeout(currentTimeout);
                }
                
                delete firingTimers;
                
                sortTimers();
            }
            
            _lastTimeout = currentTimeout;
        }
    }
}

int timerSort(const void* item1, const void* item2)
{
    const EventLoopTimer* one = (const EventLoopTimer*)item1;
    const EventLoopTimer* two = (const EventLoopTimer*)item2;
    if (one->nextTimeout() == two->nextTimeout())
        return 0;
    else if (one->nextTimeout() < two->nextTimeout())
        return -1;
    else
        return 1;
}


void EventLoop::sortTimers()
{
    _timers.sort(timerSort);
}

DArray* EventLoop::findFiringTimers()
{
    DArray* firingTimers = NULL;
    for (int i = 0; i < _timers.count(); i++)
    {
        EventLoopTimer* cb = (EventLoopTimer*)_timers.item(i);        
        milliclock_t delta = 0;
        if (cb->lastTimeout() > millis())
        {
            delta += MILLICLOCK_MAX - cb->lastTimeout();
            delta += millis();
        }
        else
        {
            delta += millis() - cb->lastTimeout();
        }

        if (delta >= cb->period())
        {
            if (firingTimers == NULL)
                firingTimers = new DArray();
            if (firingTimers)
                firingTimers->push(cb);
        }
    }
    
    return firingTimers;
}

EventLoop* EventLoop::current()
{
    return g_eventLoop;
}

class EventCallbackTest : public PeriodicCallback
{
    int _num;
public:
    EventCallbackTest(int num)
    : _num(num)
    {
        
    }
    virtual void service()
    {
        if (_num-- == 0)
        {
            printf("Serviced\n");
            EventLoop::current()->removePeriodicCallback(this);
            
            delete this;
        }
    }
};

class EventTimerTest : public EventLoopTimer
{
public:
    EventTimerTest(unsigned long period)
    : EventLoopTimer(period)
    {
    }
    void fire()
    {
        milliclock_t delta = 0;
        if (lastTimeout() > millis())
        {
            delta += MILLICLOCK_MAX - lastTimeout();
            delta += millis();
        }
        else
        {
            delta += millis() - lastTimeout();
        }
        if (delta != period())
        {
            printf("Epic Failure");
        }
        
        printf("Timer %u - Delta %u\n", millis(), delta);
    }
    
};

bool eventLoopTest()
{
    EventLoop loop;
//    loop.addPeriodicCallback(new EventCallbackTest(5000));
//    loop.addPeriodicCallback(new EventCallbackTest(2000));
//    loop.addPeriodicCallback(new EventCallbackTest(4000));
//    loop.addPeriodicCallback(new EventCallbackTest(8000));
    loop.addTimer(new EventTimerTest(3));
    loop.run();
    return true;
}

