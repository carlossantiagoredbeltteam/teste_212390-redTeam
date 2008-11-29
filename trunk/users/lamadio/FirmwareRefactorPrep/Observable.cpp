/*
 *  Observable.cpp
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 10/18/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Collections.h"
#include "Observable.h"

struct forEachNotifyContext
{
    void* observerContext;
    uint32_t event;
    forEachNotifyContext(uint32_t evt, void* oc = NULL)
    : observerContext(oc)
    , event(evt)
    {
        
    }
};

void forEachFireEvent(void* item, void* context)
{
    forEachNotifyContext* ctx = (forEachNotifyContext*)context;
    ((Observer*)item)->notify(ctx->event, ctx->observerContext);
}


Observable::Observable()
{
    
}


Observable::~Observable()
{
    notifyObservers(ObservedEvent_Destroyed, this);
}

void Observable::notifyObservers(uint32_t eventId, void* context)
{
    forEachNotifyContext ctx(eventId, context);
    _observers.foreach(forEachFireEvent, &ctx);
}

bool Observable::hasObservers()
{
    return _observers.count() > 0;
    
}
        
void Observable::addObserver(Observer* o)
{
    if (!_observers.find(o))
    {
        _observers.push(o);
        o->notify(ObservedEvent_Attached, this);
    }
    
}

void Observable::removeObserver(Observer* o)
{
    size_t index;
    if (_observers.find(o, &index))
    {
        ((Observer*)_observers[index])->notify(ObservedEvent_Detached, this);
        _observers.remove(index);
    }
}


Observer::Observer()
{
    
}

void removeObserver(void* item, void* context)
{
    ((Observable*)item)->removeObserver((Observer*)context);
}

Observer::~Observer()
{
    _observing.foreach(removeObserver, this);
}
        
void Observer::notify(uint32_t eventId, void* context)
{
    switch (eventId)
    {
    case ObservedEvent_Attached:
        if (!_observing.find(context))
            _observing.push(context);
        break;
            
    case ObservedEvent_Destroyed:
    case ObservedEvent_Detached:
        {
            size_t index;
            if (_observing.find(context, &index))
                _observing.remove(index);
        }
        break;
    }
}

const uint32_t ObservedEvent_TestEvent1 = ObservedEvent_ComponentFirst + 0;
const uint32_t ObservedEvent_TestEvent2 = ObservedEvent_ComponentFirst + 1;

static uint32_t firedEvent = 0;

class TestWatched : public Observable
{
public:
    
};

class TestWatching : public Observer
{
public:
    virtual void notify(uint32_t eventId, void* context)
    {
        switch (eventId)
        {
            case ObservedEvent_TestEvent1:
                firedEvent++;
                break;
            case ObservedEvent_TestEvent2:
                firedEvent++;
                break;
                
        }

        Observer::notify(eventId, context);
    }
    
};

bool testObservable()
{
    TestWatched watched;
    {

        TestWatching watching1;
        TestWatching watching2;
        
        watched.addObserver(&watching1);
        watched.addObserver(&watching2);
        
        watched.notifyObservers(ObservedEvent_TestEvent1);
        watched.notifyObservers(ObservedEvent_TestEvent2);
        
        if (firedEvent != 4)
        {
            return false;
        }
        
        watched.removeObserver(&watching2);
        watched.notifyObservers(ObservedEvent_TestEvent1);
        if (firedEvent != 5)
        {
            return false;
        }
    }
    
    if (watched.hasObservers() == true)
    {
        return false;
    }
    
    
    return true;
    
    
}

