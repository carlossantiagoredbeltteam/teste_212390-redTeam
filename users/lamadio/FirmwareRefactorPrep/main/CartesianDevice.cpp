#include "WProgram.h"
#include "Constants.h"
#include "Collections.h"
#include "EventLoop.h"
#include "Observable.h"
#include "Device.h"
#include "OpticalInterrupt.h"
#include "StepperDevice.h"
#include "LinearActuator.h"
#include "CartesianDevice.h"

CartesianDevice::CartesianDevice(LinearActuator& x, LinearActuator& y, LinearActuator& z)
: _x(x)
, _y(y)
, _z(z)
, _xInMotion(false)
, _yInMotion(false)
, _zInMotion(false)
{
    _x.addObserver(this);
    _y.addObserver(this);
    _z.addObserver(this);
}

void CartesianDevice::pause()
{
    _x.pause();
    _y.pause();
    _z.pause();
}

void CartesianDevice::start()
{
    if (_xInMotion)
        _x.start();
    if (_yInMotion)
        _y.start();
    if (_zInMotion)
        _z.start();
}

void CartesianDevice::moveTo(float newX, float newY, float newZ)
{
    float deltaX = newX - _x.currentPosition();
    float deltaY = newY - _y.currentPosition();
    float deltaZ = newZ - _z.currentPosition();
    
    float absDeltaX = abs(deltaX);
    float absDeltaY = abs(deltaY); 
    float absDeltaZ = abs(deltaZ);
        
    if (absDeltaX == 0.0f &&
        absDeltaY == 0.0f &&
        absDeltaZ == 0.0f)
    {
        notify(CartesianDevice_MovingToNewPosition, this);
        notify(CartesianDevice_ReachedNewPosition, this);
        return;
    }
    
    float distance = sqrt(absDeltaX * absDeltaX +
                          absDeltaY * absDeltaY + 
                          absDeltaZ * absDeltaZ);
                          
                    
    if (absDeltaX > 0.0f)
    {      
        _x.setTempRate(absDeltaX / distance);
        _x.moveTo(newX);
        _xInMotion = true;
    }
    
    if (absDeltaY > 0.0f)
    {
        _y.setTempRate(absDeltaY / distance);
        _y.moveTo(newY);
        _yInMotion = true;
    }
    
    if (absDeltaZ > 0.0f)
    {
        _z.setTempRate(absDeltaZ / distance);
        _z.moveTo(newZ);
        _zInMotion = true;
    }
    
    if (axesInMotion())
        notify(CartesianDevice_MovingToNewPosition, this);
}

void CartesianDevice::moveHome()
{
    if (_x.currentPosition() > 0.0f)
    {
        _xInMotion = true;
        _x.moveHome();
    }
    if (_y.currentPosition() > 0.0f)
    {
        _yInMotion = true;
        _y.moveHome();
    }
    if (_z.currentPosition() > 0.0f)
    {
        _zInMotion = true;
        _z.moveHome();
    }
}

void CartesianDevice::notify(uint32_t eventId, void* context)
{
    switch (eventId)
    {
        case LinearActuator_Homed:
        {
            if (((LinearActuator*)context) == &_x)
                _xInMotion = false;
            if (((LinearActuator*)context) == &_y)
                _yInMotion = false;
            if (((LinearActuator*)context) == &_z)
                _zInMotion = false;
                
            if (!axesInMotion())
                notify(CartesianDevice_Homed, this);
        }
        
        case LinearActuator_CompletedMove:
        {
            if (((LinearActuator*)context) == &_x)
                _xInMotion = false;
            if (((LinearActuator*)context) == &_y)
                _yInMotion = false;
            if (((LinearActuator*)context) == &_z)
                _zInMotion = false;

            if (!axesInMotion())
                notify(CartesianDevice_ReachedNewPosition, this);
        }
        
        case LinearActuator_Extent:
        {
            notify(CartesianDevice_PositionError, this);
        }
    }
}
