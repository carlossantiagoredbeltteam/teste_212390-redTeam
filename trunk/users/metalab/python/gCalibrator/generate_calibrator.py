#!/usr/bin/env python

from gcodegen import *
import math

feedrate = 1500.0
layerHeight = 0.372

testRuns = 15
testHeight = 4
preRun = 5.0
runPauseFactor = 3.0

raftHeight = (testRuns+2)*testHeight
raftWidth = 5.0
raftParts = int(math.ceil((2*preRun+runPauseFactor*testRuns)/raftWidth))


print "G21"
print "G90"
print "G28"
print "M103"
print "M108 S255.0"


print "M101"


(x,y,z)=(0,0,layerHeight/2.0)


layerStart(z);
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
    stopExtruder()
    (x,y) = moveToXY(x - runPauseFactor * i, y)
    startExtruder()
    (x,y) =  moveToXY(0,y)
    (x,y) = sCurveYAbs(x,y,testStartX,y-testHeight)

z += 10
moveTo(x,y,z,feedrate)
print "M103"




