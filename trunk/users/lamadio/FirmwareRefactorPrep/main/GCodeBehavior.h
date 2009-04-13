/*
 *  GCodeBehavior.h
 *
 *  Created by Lou Amadio on 3/26/09.
 *     Provided under GPLv3 per gpl-3.0.txt
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
 *  COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
 *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
 *  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 *  POSSIBILITY OF SUCH DAMAGE. *
 */
 
 #define COMMAND_BUFFER_SIZE 128        // GCode max command length


#define GCODE_G	(1<<0)
#define G_G	'G'
#define GCODE_M	(1<<1)
#define G_M	'M'
#define GCODE_P	(1<<2)
#define G_P	'P'
#define GCODE_X	(1<<3)
#define G_X	'X'
#define GCODE_Y	(1<<4)
#define G_Y	'Y'
#define GCODE_Z	(1<<5)
#define G_Z	'Z'
#define GCODE_I	(1<<6)
#define G_I	'I'
#define GCODE_J	(1<<7)
#define G_J	'J'
#define GCODE_K	(1<<8)
#define G_K	'K'
#define GCODE_F	(1<<9)
#define G_F	'F'
#define GCODE_S	(1<<10)
#define G_S	'S'
#define GCODE_Q	(1<<11)
#define G_Q	'Q'
#define GCODE_R	(1<<12)
#define G_R	'R'
#define GCODE_COMMENT	(1<<13)

class GCodeCommand
{
    uint32_t _bits;
    
public:
    GCodeCommand(char* buffer, size_t size);
    
    int _G;
    int _M;
    float _P;
    float _X;
    float _Y;
    float _Z;
    float _I;
    float _J;
    float _F;
    float _S;
    float _R;
    float _Q;

    inline bool isComment() { return (_bits & GCODE_COMMENT) == GCODE_COMMENT; }
    bool has(uint32_t bit);
    inline bool hasAnyParameters() { return _bits != 0; }
    
    inline bool isM() { return (_bits & GCODE_M) == GCODE_M; }
    inline bool isG() { return (_bits & GCODE_G) == GCODE_G; }
    inline bool hasGCode() { return (_bits & (GCODE_G | GCODE_M)) != 0;}
    inline void setPreviousCode(uint32_t code) { _G = code; _bits |= GCODE_G; }
};

class FakeBot : public Observable,
                public EventLoopTimer

{
    float _x;
    float _y;
    float _z;
public:
    FakeBot();
    inline CartesianPoint position() 
        { return CartesianPoint(_x, _y, _z); }

    inline void moveTo(CartesianPoint pt)
        { moveTo(pt.x, pt.y, pt.z); }

    void setRate(float) { }

    void moveTo(float newX, float newY, float newZ);

    void pause();
    void start();

    void moveHome();
    virtual void fire();
};

class GCodeBehavior : public PeriodicCallback,
                      public Observer
{
    int _previousGCode;
    ExtruderDevice& _extruder;
    //CartesianDevice& _bot;
    FakeBot& _bot;
    enum tagGCodeState
    {
        GCodeState_Idle,
        GCodeState_BuildingCommand,
        GCodeState_ProcessingCommand,
        GCodeState_ExecutingCommand,
        GCodeState_PausingCommandForTemperature
    } _commandState;
    
    char _commandBuffer[COMMAND_BUFFER_SIZE];
    uint16_t _commandBufferLength;
    
    void processCommand();
	void executingCommand();
	void waitForCommand();
    
    bool _abs;
    bool _isMM;
    
    float translatePosition(float pos);
public:
    GCodeBehavior(ExtruderDevice& extruder, FakeBot& bot); //CartesianDevice& bot);
    
    virtual void service();
    virtual void notify(uint32_t eventId, void* context);
};

int scan_float(char *str, float *valp, uint32_t* seen, uint32_t flag);
int scan_int(char *str, int *valp, uint32_t* seen, uint32_t flag);


