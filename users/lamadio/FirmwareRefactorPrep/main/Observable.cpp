/*
 *  Observable.cpp
 *
 *  Created by Lou Amadio on 10/18/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#include "WProgram.h"
#include "Constants.h"
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


