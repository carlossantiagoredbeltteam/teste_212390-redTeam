#!/usr/bin/env python

from gcodegen import *
import math

feedrate = 42.0*60
layerHeight = 0.25

testRuns = 10
testHeight = 4.0
testLength = 40.0

rafts = 5 # should  be an odd number :)
raftHeight = (testRuns+2)*testHeight
raftWidth = 5.0
raftParts = int(math.ceil((testLength)/raftWidth))


print "G21"
print "G90"
print "G28"
print "M103"
print "M108 S255.0"


startExtruder()


(x,y,z)=(0,0,layerHeight/2.0)

moveTo(x,y,z,feedrate);

for j in range(0, rafts):
    if (j%2==0):
        for i in range(0, raftParts):
            (x, y) = raftPartX(x, y, raftWidth, raftHeight) 
    else:
        for i in range(0, raftParts):
            (x, y) = raftPartX(x, y, -raftWidth, raftHeight) 
    z += layerHeight
    moveTo(x,y,z,feedrate);


(x,y) = moveToXY(x,y+raftHeight-testHeight)


z += layerHeight
layerStart(z);
moveTo(x,y,z,feedrate);

testStartX = x

for i in range(0, testRuns):
    (x,y) =  moveToXY(0,y)
    (x,y) = sCurveYAbs(x,y,testStartX,y-testHeight)

z += 10
moveTo(x,y,z,feedrate)
print "M103"




