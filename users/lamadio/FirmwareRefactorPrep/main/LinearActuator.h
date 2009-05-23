/*
 *  LinearActuator.h
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
 
class LinearActuator : public Device, 
                       public Observable,
                       public Observer
{
    float _currentPos;
    float _revPerMM;
    StepperDevice& _stepper;
    OpticalInterrupt& _nearInterrupter;
    OpticalInterrupt& _farInterrupter;
    
public:
    LinearActuator(float _revPerMM, StepperDevice& stepper, OpticalInterrupt& far, OpticalInterrupt& near);
    
    inline float currentPosition() { return _currentPos; }
    inline void setTempRate(float rate) { _stepper.setTempRate(rate); }
    void moveTo(float newPosMM);
    void moveHome();
    void moveToExtent();
    inline bool running() { _stepper.running(); }
    inline void pause() { _stepper.pause(); }
    inline void start() { _stepper.start(); }
    inline void stop() { _stepper.stop(); }
    virtual void notify(uint32_t eventId, void* context);
};
