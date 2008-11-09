from __future__ import with_statement
import sys

from kicad import *

PINGROUP_SPACING = 200
PIN_SPACING = 100
COMPONENT_MARGIN = 400
PIN_LENGTH = 300


def countPins(groups):
    l = 0
    for group in groups:
        l += len(group)
    return l

def reversePins(groups):
    groups.reverse()
    for group in groups:
        group.reverse()

pinGroupsLeft = [[]]
pinGroupsRight = [[]]
pinGroupsTop = [[]]
pinGroupsBottom = [[]]

allPinGroups = [pinGroupsRight, pinGroupsTop, pinGroupsLeft, pinGroupsBottom]

activePinGroups = pinGroupsRight


with open(sys.argv[1]) as f:    
    ComponentName = f.readline().strip()
    component = kicad_component(ComponentName)
    for line in f:
        line = line.strip()
        #print line

        if (line == '[right]'):
            activePinGroups = pinGroupsRight
        elif (line == '[top]'):
            activePinGroups = pinGroupsTop
        elif (line == '[left]'):
            activePinGroups = pinGroupsLeft
        elif (line == '[bottom]'):
            activePinGroups = pinGroupsBottom
        elif (line == ''):
            if (len(activePinGroups[-1]) > 0):
                activePinGroups.append([])
        else:
            pinData = line.split()
            pin = kicad_pin(pinData[0], int(pinData[1]), 0, 0, 0, pinData[2], PIN_LENGTH)
            component.add(pin)
            activePinGroups[-1].append(pin)


def calculateGroupsSize(groups):
    if (len(groups[-1]) == 0):
        groups.pop()
    groupCount = len(groups)
    pinCount = countPins(groups)
    return (pinCount-groupCount)*PIN_SPACING + (len(groups)-1)*PINGROUP_SPACING

    
sideSizes = [calculateGroupsSize(groups) for groups in allPinGroups]
maxSize = [max(sideSizes[0], sideSizes[2]), max(sideSizes[1], sideSizes[3])]

side = 0
for pinGroups in allPinGroups:

    currentPos = -sideSizes[side]/2
    otherDim = maxSize[(side+1)%2]/2 + COMPONENT_MARGIN + PIN_LENGTH

    # we always want the pin ordering to be from left to right and top to bottom
    if (pinGroups == pinGroupsRight or pinGroups == pinGroupsTop):
        #print "REVERSING!!!"
        #print pinGroups
        reversePins(pinGroups)
        #print pinGroups

    for pinGroup in pinGroups:
        for pin in pinGroup:
            pin.PinPositionY = currentPos
            pin.PinPositionX = otherDim
            currentPos += PIN_SPACING
            pin.rotateCCW(side)
        currentPos += PINGROUP_SPACING - PIN_SPACING
    side += 1

rectangle = kicad_rectangle(-(maxSize[1]/2+COMPONENT_MARGIN), \
                            maxSize[0]/2+COMPONENT_MARGIN, \
                            maxSize[1]/2+COMPONENT_MARGIN, \
                            -(maxSize[0]/2+COMPONENT_MARGIN))
component.add(rectangle)

print component.render()
