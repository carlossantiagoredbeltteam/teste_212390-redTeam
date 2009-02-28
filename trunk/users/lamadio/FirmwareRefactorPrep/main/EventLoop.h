/*
 *  EventLoop.h
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#ifndef EventLoop_h
#define EventLoop_h

typedef unsigned long milliclock_t;
extern const unsigned long MILLICLOCK_MAX;

//
// Periodic Event Callback
//  Derive from this class to implement a periodic servicing
//
class PeriodicCallback
{
public:
  // NOTE: This is a harmless warning: 
  //  alignment of 'PeriodicCallback::_ZTV16PeriodicCallback' is greater than maximum object file alignment.
  // Bug in avr-g++. See http://www.mail-archive.com/avr-chat@nongnu.org/msg00982.html
    PeriodicCallback();
    virtual ~PeriodicCallback();
    
    virtual void service() = 0;
};

//
// Timer
//  Derive from this class to implement a periodic timer.
//  This class also contains information needed for maintianing a timer, designed to be memory efficient.
//
class EventLoopTimer
{
    milliclock_t _lastTimeout;
    milliclock_t _period;
public:
    EventLoopTimer(unsigned long period);
    virtual ~EventLoopTimer();
    
    virtual void fire() = 0;
    
    inline milliclock_t period() const { return _period; }
    inline milliclock_t lastTimeout() const { return _lastTimeout; }
    milliclock_t nextTimeout() const;
    
    inline void setLastTimeout(milliclock_t nextTimeout) { _lastTimeout = nextTimeout; }
};

//
// Event Loop
//  This class implements the main loop. 
//  It allows clients to register for periodic servicing, or timed servicing.
//  
class EventLoop
{
private:
    DArray _periodicEvents;
    DArray _timers;
    milliclock_t _lastTimeout;
    bool _running;
    
    void sortTimers();
    DArray* findFiringTimers();
public:
    EventLoop();
    ~EventLoop();
    
    void addPeriodicCallback(PeriodicCallback* callback);
    void removePeriodicCallback(PeriodicCallback* callback);
    
    int periodicCallbacks() { return _periodicEvents.count(); }

    void addTimer(EventLoopTimer* timer);
    void removeTimer(EventLoopTimer* timer);
    int timers() { return _timers.count(); }
    
    bool running() { return _running; }
    void exit() { _running = false; }

    void run();
    
    static EventLoop* current();
};

#endif
