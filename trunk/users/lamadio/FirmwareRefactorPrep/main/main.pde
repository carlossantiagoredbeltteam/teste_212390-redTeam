#include "WProgram.h"
#include "Collections.h"
#include "EventLoop.h"
#include "EventLoop.h"
#include "Collections.h"
#include "Observable.h"
#include "Device.h"
#include "OpticalInterrupt.h"
#include "StepperDevice.h"
#include "LinearActuator.h"

extern char* __data_start;
extern char* __data_end;
extern char* __bss_end;

void setup()
{
    Serial.begin(115200);
    /*
    Interesting heap data when working with dynamic memory
    Serial.print("Heap Start:");
    Serial.println((long)__malloc_heap_start);
    Serial.print("Heap End:");
    Serial.println((long)__malloc_heap_end);
    Serial.print("data start:");
    Serial.println((long)__data_start);
    Serial.print("data end:");
    Serial.println((long)__data_end);
    Serial.print("bss end:");
    Serial.println((long)__bss_end);
    Serial.print("Size of size_t:");
    Serial.println((long)sizeof(size_t));
    Serial.print("Size of void*:");
    Serial.println((long)sizeof(void*));
    */
}

class HeartbeatTimer : public EventLoopTimer
{
public:
    HeartbeatTimer(unsigned long period) : EventLoopTimer(period)
    {
        Serial.println("Created heartbeat");
    }
    
    virtual void fire()
    {
        Serial.println("*");
        Serial.flush();
        
    }
};


void loop()
{
    Serial.println("Starting");
    HeartbeatTimer heartbeat(1000);
	StepperDevice xAxisStepper(2, 3, 300, 1000);
//	OpticalInterrupt xAxisFar(10);
//	OpticalInterrupt xAxisNear(11);
//	StepperLinearActuator linearActuator(4.5f, xAxisStepper, xAxisFar, xAxisNear);

    xAxisStepper.goForward();
    xAxisStepper.turn();
    EventLoop::current()->addTimer(&heartbeat);
	EventLoop::current()->run();
}


