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
#include "ThermisterDevice.h"
#include "HeaterDevice.h"
#include "ExtruderDevice.h"
#include "CartesianDevice.h"
#include "GCodeBehavior.h"

FakeBot::FakeBot()
: EventLoopTimer(300.0f)
, _x(0.0f)
, _y(0.0f)
, _z(0.0f)
{
    
}

void FakeBot::moveTo(float newX, float newY, float newZ)
{
    start();
}

void FakeBot::pause()
{
    EventLoop::current()->removeTimer(this);
}

void FakeBot::start()
{
    EventLoop::current()->addTimer(this);
}

void FakeBot::moveHome()
{
    start();
}

void FakeBot::fire()
{
    notifyObservers(CartesianDevice_ReachedNewPosition, this);
}


GCodeBehavior::GCodeBehavior(ExtruderDevice& extruder, FakeBot& bot) // CartesianDevice& bot)
: _extruder(extruder)
, _bot(bot)
, _commandState(GCodeState_Idle)
, _commandBufferLength(0)
, _previousGCode(-1)
, _abs(true)
, _isMM(true)
{
    _commandBuffer[0] = 0;
    bot.addObserver(this);
    extruder.addObserver(this);
}

void GCodeBehavior::service()
{
    // If we're executing, need to wait for it to finish, so no work
    if (_commandState == GCodeState_ExecutingCommand ||
        _commandState == GCodeState_PausingCommandForTemperature)
    {
        return;
    }
        
    if (Serial.available())
    {
        _commandState = GCodeState_BuildingCommand;
        
        char c = Serial.read();
        _commandBuffer[_commandBufferLength++] = c;
        
        if (c == '\n')
        {
            _commandState = GCodeState_ProcessingCommand;
            _commandBuffer[_commandBufferLength--] = 0;
            processCommand();
            _commandBuffer[0] = 0;
            _commandBufferLength = 0;
        }
    }
}

void GCodeBehavior::notify(uint32_t eventId, void* context)
{
    switch (eventId)
    {
        case CartesianDevice_Homed:
        case CartesianDevice_ReachedNewPosition:
            _commandState = GCodeState_Idle;
            break;
            
        case CartesianDevice_PositionError:
            // Bingo fuel
            break;
            
        case ExtruderDevice_OutOfTemp:
            _bot.pause();
            _commandState = GCodeState_PausingCommandForTemperature;
            break;
            
        case ExtruderDevice_AtTemp:
            if (_commandState == GCodeState_PausingCommandForTemperature)
            {
                _commandState = GCodeState_ExecutingCommand;
                _bot.start();
            }
            break;
    }
}

void GCodeBehavior::processCommand()
{
    CartesianPoint fp;
    GCodeCommand command(_commandBuffer, _commandBufferLength);
    
    if (command.isComment())
        return;
        
    if (!command.hasGCode() && command.hasAnyParameters())
    {
        command.setPreviousCode(_previousGCode);
    }
    
    if (command.isG())
    {
        _previousGCode = command._G;
        
        CartesianPoint pt;
        if (_abs) 
            pt = _bot.position();
            
        if (command.has(GCODE_X))
            pt.x = command._X;
        if (command.has(GCODE_Y))
            pt.y = command._X;
        if (command.has(GCODE_Z))
            pt.z = command._Z;
        
        if (command.has(GCODE_F))
        {
            _bot.setRate(command._F);
        }
        
        switch (command._G)
        {
        case 0:
        case 1:
            _bot.moveTo(pt);
            _commandState = GCodeState_ExecutingCommand;
            break;
        
        case 4:
		    delay((int)(command._P + 0.5));  // Changed by AB from 1000*gc.P
            break;
            
        case 20:
            _isMM = false;
            break;
        case 21:
            _isMM = true;
            break;
        case 28:
            _bot.moveHome();
            _commandState = GCodeState_ExecutingCommand;
            break;
            
        case 30:
            // TODO: home via intermediate point;
            break;
            
        case 90:
            _abs = true;
            break;
            
        case 91:
            _abs = false;
            break;
        }
    }
    
    if (command.isM())
    {
        switch (command._M)
        {
        case 0:
            break;
            
        case 101:
            _extruder.extrude();
            break;
        case 102:
            _extruder.backup();
            break;
        case 103:
            _extruder.stop();
            break;
            
        case 104:
            if (command.has(GCODE_S))
            {
                _extruder.setTemp((int)command._S);
                _bot.pause();
                _commandState = GCodeState_PausingCommandForTemperature;
            }
        }
    }
}


float GCodeBehavior::translatePosition(float pos)
{
    if (!_isMM)
    {
        pos = pos * 250.0f;
    }
    
    return pos;
}


#define PARSE_INT(ch) \
	case G_##ch: \
		length = scan_int(parameters, &_##ch, &_bits, GCODE_##ch); \
		break;

#define PARSE_FLOAT(ch) \
	case G_##ch: \
		length = scan_float(parameters, &_##ch, &_bits, GCODE_##ch); \
		break;



GCodeCommand::GCodeCommand(char* buffer, size_t size)
{
    size_t length = 0;
	for (int i = 0; i < size; i += (1 + length))
	{
		length = 0;
        char* parameters = &buffer[i+1];
		switch (buffer[i])
		{
			  PARSE_INT(G);
			  PARSE_INT(M);
			PARSE_FLOAT(S);
			PARSE_FLOAT(P);
			PARSE_FLOAT(X);
			PARSE_FLOAT(Y);
			PARSE_FLOAT(Z);
			PARSE_FLOAT(I);
			PARSE_FLOAT(J);
			PARSE_FLOAT(F);
			PARSE_FLOAT(R);
			PARSE_FLOAT(Q);
			case '/':
                _bits |= GCODE_COMMENT;
            default:
            break;
		}
	}
}


bool GCodeCommand::has(uint32_t bit)
{
    return (_bits & bit) == bit;
}

int scan_float(char *str, float *valp, uint32_t* seen, uint32_t flag)
{
	char *end;
     
	float res = (float)strtod(str, &end);
      
	int len = end - str;

	if (len > 0)
	{
		*valp = res;
		*seen |= flag;
	}
	else
		*valp = 0;
          
	return len;	/* length of number */
}

int scan_int(char *str, int *valp, uint32_t* seen, uint32_t flag)
{
	char *end;

	int res = (int)strtol(str, &end, 10);
	int len = end - str;

	if (len > 0)
	{
		*valp = res;
		*seen |= flag;
	}
	else
		*valp = 0;
          
	return len;	/* length of number */
}
