/*
 *  CartesianDevice.h
 *
 *  Created by Lou Amadio on 3/22/09.
 *  Copyright 2009 OoeyGUI. All rights reserved.
 *
 */

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
public:
     CartesianDevice(LinearActuator& x, LinearActuator& y, LinearActuator& z);

     void moveTo(float newX, float newY, float newZ);
     void moveHome();
     inline bool axesInMotion() { return _xInMotion || _yInMotion || _zInMotion; }
     virtual void notify(uint32_t eventId, void* context);
 };
