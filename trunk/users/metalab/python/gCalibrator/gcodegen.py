#!/usr/bin/python

from math import pi, cos, sin

def layerStart(z):
    print "(<layerStart> %(Z)f)\n" % {'Z':z}

def startExtruder():
    print "M101"

def stopExtruder():
    print "M103"

def setExtruderPWM(speed):
    print "M108 S%d" % (speed)

def pause(ms):
    print "G04 P%d" % ms;

def moveTo(x, y, z, f):
    print "G1 X%(X).2f Y%(Y).2f Z%(Z).2f F%(F).2f" % {'X':x,'Y':y, 'Z':z, 'F':f}

def moveToXY(x, y):
    print "G1 X%(X).2f Y%(Y).2f" % {'X':x,'Y':y}
    return (x, y)

def moveToXYF(x, y, f):
    print "G1 X%(X).2f Y%(Y).2f F%(F).2f" % {'X':x,'Y':y,'F':f}
    return (x, y)

def linInterConstDist(x1,y1,x2,y2, f1, f2, steps):
    for i in range(0,steps+1):
        d=float(i)/steps
        moveToXYF(x1*(1-d) + x2*d, y1*(1-d) + y2*d, f1*(1-d) + f2*d)
    return (x2, y2)
 


#     -----
#     |
# -----
def sCurveXAbs(x1, y1, x2, y2):
    #moveToXY(x1, y1)
    moveToXY((x1+x2)/2.0, y1)
    moveToXY((x1+x2)/2.0, y2)
    moveToXY(x2, y2)
    return (x2, y2)

#    |
# ___|
#|
#|
def sCurveYAbs(x1, y1, x2, y2):
    #moveTo(x1, y1)
    moveToXY(x1, (y1+y2)/2.0)
    moveToXY(x2, (y1+y2)/2.0)
    moveToXY(x2, y2)
    return (x2, y2)

# ---
# | |
# | |
# | |
# | |__
def raftPartX(x, y, width, height):
    #moveToXY(x, y)
    moveToXY(x, y + height)
    moveToXY(x + width / 2.0, y + height)
    moveToXY(x + width / 2.0, y)
    moveToXY(x+width, y)
    return (x+width, y)        
#|
#|--------
#        | 
#---------
def raftPartY(x, y, width, height):
    #moveTo(x, y)
    moveToXY(x + width, y)
    moveToXY(x + width, y + height / 2.0)
    moveToXY(x, y + height / 2.0)
    moveToXY(x, y + height);
    
