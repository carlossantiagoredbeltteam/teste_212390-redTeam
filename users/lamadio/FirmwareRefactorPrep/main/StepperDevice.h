/*
 *  StepperDevice.h
 *
 *  Created by Lou Amadio on 2/24/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
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

class StepperDevice : public EventLoopTimer, 
                      public Device, 
                      public Observable
{
    int8_t _stepPin;
    int8_t _dirPin;
	int8_t _enablePin;
    bool _forward;
    bool _inverted;
    int _currentTick;
    int _targetTick;
    int _ticksPerRev;
    milliclock_t _maxRate;
    bool _running;
public:
    StepperDevice(int8_t stepPin, int8_t dirPin, int8_t enablePin, int ticksPerRev, milliclock_t rate, bool inverted = false);
    
    void goForward();
    void goBackward();
    inline bool running() { return _running; }
    inline bool goingForward() { return _forward; }
    void turn(float numberOfRevolutions = 0.0f);
    void start();
    void stop();
    void pause();
	void enable(bool enable);
    void setTempRate(float rate);
    virtual void fire();
};

