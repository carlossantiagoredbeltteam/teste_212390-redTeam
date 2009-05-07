#!/usr/bin/env python

from gcodegen import *
import math

    

feedrate = 1500.0
layerHeight = 0.372
extruderPWM = 255

testRuns = 15
testHeight = 4
preRun = 10.0
run = 10.0
runPauseFactor = 20.0
offLength=40

steps=10

raftHeight = (testRuns+2)*testHeight
raftWidth = 5.0
raftParts = int(math.ceil((2*(preRun+run)+offLength)/raftWidth))

print """
(homing routing)
G21
G90
G92 X0 Y0 Z0
G0 Z10
M104 S220 T0
M108 S255
M6 T0
G04 P5000
M101
G04 P5000
M103
M01 (Ready to print?)
G0 Z0	
(end of start.)
"""

print "G21"
print "G90"
print "G28"
print "M103"
setExtruderPWM(extruderPWM)


print "M101"


(x,y,z)=(0,0,layerHeight/2.0)


#layerStart(z);
moveTo(x,y,z,feedrate);
for i in range(0, raftParts):
    (x, y) = raftPartX(x, y, raftWidth, raftHeight) 

(x,y) = moveToXY(x,y+raftHeight-testHeight)


z += layerHeight
layerStart(z);
moveTo(x,y,z,feedrate);

testStartX = x

for i in range(0, testRuns):
    (x,y) = moveToXY(x - preRun, y)

    setExtruderPWM(-extruderPWM)
    startExtruder()

    (x,y) = linInterConstDist(x,y, x - run, y, feedrate, feedrate/(i+1), steps)

    pause(i*runPauseFactor)
    stopExtruder()

    (x,y) = moveToXY(x - offLength, y)

    setExtruderPWM(extruderPWM)
    startExtruder()
    
    (x,y) = linInterConstDist(x,y, x - run, y, feedrate/(i+1), feedrate, steps)

    #(x,y) = moveToXY(x - preRun, y)
    (x,y) =  moveToXY(0,y)
    (x,y) = sCurveYAbs(x,y,testStartX,y-testHeight)

z += 10
print "M103"
moveTo(x,y,z,feedrate)





