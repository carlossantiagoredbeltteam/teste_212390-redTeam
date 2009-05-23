#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "EventLoop.h"
#include "EventLoop.h"
#include "Collections.h"
#include "Observable.h"
#include "Device.h"
#include "OpticalInterrupt.h"
#include "StepperDevice.h"
#include "LinearActuator.h"
#include "CartesianDevice.h"
#include "ThermisterDevice.h"
#include "HeaterDevice.h"
#include "ExtruderDevice.h"
#include "GCodeBehavior.h"

void setup()
{
    Serial.begin(115200);
}

class ExtruderWatcher : public Observer
{
    uint16_t _lastTemp;
    bool _extruderAtTemp;
    bool _extruderExtruding;
    void printStats()
    {
        Serial.print("\r Last Temp - ");
        Serial.print((int)_lastTemp);
        if (_extruderAtTemp)
            Serial.print("; Extruder At Temp");
        if (_extruderExtruding)
            Serial.print("; Extruder extruding");
            
        Serial.println("");
    }
    
public:
    ExtruderWatcher()
    : _lastTemp(0)
    , _extruderAtTemp(false)
    , _extruderExtruding(false)
    {
        
    }
    
    virtual void notify(uint32_t event, void* context)
    {
        switch(event)
        {
            case ThermisterEvent_Change:
            {
                ThermisterDevice* t = (ThermisterDevice*)context;
                _lastTemp = t->temp();
            }
            break;
            
            case ExtruderDevice_AtTemp:
            {
                _extruderAtTemp = true;
            }
            break;
            
            case ExtruderDevice_OutOfTemp:
            {
                _extruderAtTemp = false;
            }
            break;
            
            case ExtruderDevice_Extruding:
            {
                _extruderExtruding = true;
            }
            break;
            
            case ExtruderDevice_Stopped:
            {
                _extruderExtruding = false;
            }
            break;
            default:
                Observer::notify(event, context);
            break;
        }

        printStats();
    }
};

class AxisWatcher : public Observer
{
public:
    AxisWatcher()
    {
    }
    
    virtual void notify(uint32_t event, void* context)
    {
        switch(event)
        {
            case LinearActuator_CompletedMove:
            Serial.println("Competed");
            break;
            case LinearActuator_Homed:
            {
                LinearActuator* la = (LinearActuator*)context;
                Serial.println("Homed");
                la->moveToExtent();
            }
            break;
            case LinearActuator_Extent:
            Serial.println("extent");
            break;
            
            case CartesianDevice_Homed:
            {
                CartesianDevice* cd = (CartesianDevice*)context;
                Serial.println("CartBot - Homed");
                cd->moveTo(25.0f, 25.0f, 0.0f);
            }
            break;
            
            
            default:
                Observer::notify(event, context);
            break;
        }
    }
};

void loop()
{
    Serial.println("ready");
    // XAxis
	StepperDevice xAxisStepper(1, 0, 3, 200, 3);
	OpticalInterrupt xAxisNear(4);
	OpticalInterrupt xAxisFar(2, true);
	LinearActuator xLinearActuator(.944f, xAxisStepper, xAxisFar, xAxisNear);

    // YAxis
	StepperDevice yAxisStepper(21, 20, 23, 200, 3, true);
	OpticalInterrupt yAxisFar(22);
	OpticalInterrupt yAxisNear(10, true);
	LinearActuator yLinearActuator(.944f, yAxisStepper, yAxisFar, yAxisNear);

    // ZAxis
	StepperDevice zAxisStepper(16, 15, 18, 200, 200);
	OpticalInterrupt zAxisFar(19, true);
	OpticalInterrupt zAxisNear(17, true);
	LinearActuator zLinearActuator(.944f, zAxisStepper, zAxisFar, zAxisNear);

    // Cartesian Bot
    CartesianDevice bot(xLinearActuator, yLinearActuator, zLinearActuator);
    
    // Extruder
	StepperDevice extruderStepper(12, 13, 11, 200, 200);
    HeaterDevice heater(14);
    ThermisterDevice thermister(7);
    ExtruderDevice extruder(200, extruderStepper, thermister, heater);

//    GCodeBehavior gcoder(extruder, bot);

/*    ExtruderWatcher watcher;
    extruder.addObserver(&watcher);
    thermister.addObserver(&watcher);
    extruder.extrude();
*/

    AxisWatcher watcher;
    bot.addObserver(&watcher);

    bot.moveHome();
    
	EventLoop::current()->run();
}


