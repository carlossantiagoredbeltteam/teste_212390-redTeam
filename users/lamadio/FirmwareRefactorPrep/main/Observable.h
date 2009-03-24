/*
 *  Observable.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 10/18/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#ifndef Observable_h
#define Observable_h

class DArray;
class Observer;

class Observable
{
    DArray _observers;
    
public:
    Observable();
    virtual ~Observable();
    
    bool hasObservers();
    void notifyObservers(uint32_t eventId, void* context = NULL);

    void addObserver(Observer* o);
    void removeObserver(Observer* o);
};


class Observer
{
    // Used to remove this class from observables when this is destroyed
    DArray _observing;
public:
    Observer();
    virtual ~Observer();
    
    virtual void notify(uint32_t eventId, void* context);
};


#endif

