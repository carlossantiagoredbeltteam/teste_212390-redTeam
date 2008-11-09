MM2MILL = 393.700787 

#################################
### Templates for KiCAD symbols
#################################

COMPONENT_TEMPLATE_BEGIN = """EESchema-LIBRARY Version 2.3  Date: 8/2/2008-15:46:38
#
# %(ComponentName)s
#
DEF %(ComponentName)s U 0 40 Y Y 1 F N
F0 "U" 0 -50 60 H V C C
F1 "%(ComponentName)s" 0 50 60 H V C C
DRAW
"""
#X D 4 100 0 300 D 50 50 1 1 I
#X C 3 0 50 300 L 50 50 1 1 I
#X A 1 -700 0 300 R 50 50 1 1 I
#X B 2 0 -600 300 U 50 50 1 1 I

COMPONENT_TEMPLATE_END = """ENDDRAW
ENDDEF
#
#End Library
"""

COMPONENT_PIN_TEMPLATE = "X %(PinName)s %(PinNum)d %(PinPositionX)d %(PinPositionY)d %(PinLength)d %(PinOrientation)s 50 50 1 1 %(PinType)s\n"

COMPONENT_PIN_ROTATIONS = ['L', 'D', 'R', 'U']

COMPONENT_RECTANGLE_TEMPLATE = "S %(X1)d %(Y1)d %(X2)d %(Y2)d 0 1 0 N\n"

###################################
### Templates for PCB footprints
###################################

MODULE_TEMPLATE_BEGIN = """PCBNEW-LibModule-V1  24/1/2008-21:54:27
$INDEX
%(ModuleName)s
$EndINDEX
$MODULE %(ModuleName)s
Po 0 0 0 15 47990905 00000000 ~~
Li TestChip
Sc 00000000
Op 0 0 0
T0 0 0 600 600 0 120 N V 21 "%(ModuleName)s"
T1 0 0 600 600 0 120 N V 21 "VAL**"
"""

MODULE_TEMPLATE_END = """$EndMODULE  TestChip
$EndLIBRARY
"""

MODULE_PAD_TEMPLATE = """$PAD
Sh "%(PadNum)d" %(PadShape)s %(PadSizeX)d %(PadSizeY)d 0 0 %(Rotation)d
Dr 0 0 0)
At SMD N 00888000
Ne 0 ""
Po %(PadPositionX)d %(PadPositionY)d
$EndPAD
"""

MODULE_DRAWING_TEMPLATE = "%(Command)s %(X1)d %(Y1)d %(X2)d %(Y2)d %(Width)d 21\n"

###################################
### Templates for PCB .brd files
###################################

PCB_TRACK_TEMPLATE = """%(Command)s %(Type)d %(X1)d %(Y1)d %(X2)d %(Y2)d %(Width)d -1
%(Command2)s %(Layer)d %(ViaFlag)d 0 0 0
"""


