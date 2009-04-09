/*
 *  ExtruderDevice.h
 *
 *  Created by Lou Amadio on 3/2/09.
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

class ExtruderDevice : public Device, 
                       public Observer, 
                       public Observable
{
    enum ExtruderStates
    {
        Idle,
        Heating,
        Preheating,
        Extruding
    } _state;
    
    StepperDevice& _stepper;
    ThermisterDevice& _thermister;
    HeaterDevice& _heater;
    int16_t _extrusionTemp;
    
public:
    ExtruderDevice(int16_t extrusionTemp, StepperDevice& step, 
            ThermisterDevice& therm, HeaterDevice& hd);
    
    void extrude();
    void backup();
    void stop();
    void preheat();
    
    inline void setTemp(int16_t temp) { _extrusionTemp = temp; }
    inline int16_t temp() { return _extrusionTemp; }
    
    virtual void notify(uint32_t eventId, void* context);
};

