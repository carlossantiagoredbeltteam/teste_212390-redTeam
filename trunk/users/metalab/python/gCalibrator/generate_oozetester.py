#!/usr/bin/env python

from gcodegen import *
import math

feedrate = 1500.0
layerHeight = 0.372
extruderPWM = 255

testRuns = 15
testHeight = 4
preRun = 5.0
runPauseFactor = 1.25
offLength=40

raftHeight = (testRuns+2)*testHeight
raftWidth = 5.0
raftParts = int(math.ceil((2*preRun+runPauseFactor*testRuns+offLength)/raftWidth))


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
#layerStart(z);
moveTo(x,y,z,feedrate);

testStartX = x

for i in range(0, testRuns):
    (x,y) = moveToXY(x - preRun, y)
    setExtruderPWM(-extruderPWM)
    startExtruder() 

    (x,y) = moveToXY(x - runPauseFactor * i, y)
    stopExtruder() 
    
    (x,y) = moveToXY(x - (offLength - 2*runPauseFactor * i), y)

    setExtruderPWM(extruderPWM)
    startExtruder()

    (x,y) = moveToXY(x - runPauseFactor * i, y)

    startExtruder() # to get mark
    (x,y) =  moveToXY(0,y)
    (x,y) = sCurveYAbs(x,y,testStartX,y-testHeight)

z += 10
print "M103"
moveTo(x,y,z,feedrate)





