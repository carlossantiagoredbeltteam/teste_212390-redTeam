/*
 *  CartesianDevice.h
 *
 *  Created by Lou Amadio on 3/22/09.
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

class CartesianPoint
{
public:
    CartesianPoint()
    : x(0.0f)
    , y(0.0f)
    , z(0.0f)
    {

    }

    CartesianPoint(float a, float b, float c)
    : x(a)
    , y(b)
    , z(c)
    {

    }

    float x;
    float y;
    float z;
};

class CartesianDevice : public Device, 
                         public Observable,
                         public Observer
 {
     LinearActuator& _x;
     LinearActuator& _y;
     LinearActuator& _z;
     bool _xInMotion;
     bool _yInMotion;
     bool _zInMotion;
     
     float _maxFeed;
public:
     CartesianDevice(LinearActuator& x, LinearActuator& y, LinearActuator& z);
     
     CartesianPoint position() 
         { return CartesianPoint(_x.currentPosition(), 
                                 _y.currentPosition(), 
                                 _z.currentPosition()); }

     void moveTo(float newX, float newY, float newZ);
     
     inline void moveTo(CartesianPoint pt)
         { moveTo(pt.x, pt.y, pt.z); }

     void pause();
     void start();
     
     void moveHome();
     inline bool axesInMotion() { return _x.running() || _y.running() || _z.running(); }
     
     void setRate(float rate) { _maxFeed = rate; }
     
     virtual void notify(uint32_t eventId, void* context);
 };
