/*
 *  EventLoop.h
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *
 */
#ifndef EventLoop_h
#define EventLoop_h

//
// Periodic Event Callback
//  Derive from this class to implement a periodic servicing
//
class PeriodicCallback
{
public:
    PeriodicCallback();
    virtual ~PeriodicCallback() { }
    
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
    EventLoopTimer();
    EventLoopTimer(milliclock_t period);
    virtual ~EventLoopTimer() { }
    
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

bool eventLoopTest();

#endif
