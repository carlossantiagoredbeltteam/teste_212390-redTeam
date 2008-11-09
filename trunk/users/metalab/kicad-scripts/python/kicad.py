from kicad_templates import *
from kicad_templates_brd import *

class kicad_object(object):
    def __init__(self):
        pass

    def rotateCCW(self, times):
        for i in range(0, times):
            self.rotate90CCW()

class kicad_container(kicad_object):
    def __init__(self):
        kicad_object.__init__(self)
        self.children = []

    def add(self, child):
        self.children.append(child)

    def addall(self, children):
        for child in children:
            self.add(child)

    def renderChildren(self):
        s = ""
        for child in self.children:
            s += child.render()
        return s
    
    def render(self):
        return self.renderChildren()   

################################
### Component Classes
################################

# Component is the main class for Schematic Symbols
# Dimesnions are always in 1/1000 inch - no conversion to mm is done 
class kicad_component(kicad_container):
    def __init__(self, ComponentName):
        kicad_container.__init__(self)
        self.ComponentName = ComponentName

    def render(self):
        s = COMPONENT_TEMPLATE_BEGIN % { \
            'ComponentName' : self.ComponentName \
            }
        s += self.renderChildren()
        s += COMPONENT_TEMPLATE_END
        return s

class kicad_pin(kicad_object):
    def __init__(self, PinName, PinNum, PinPositionX, PinPositionY, PinOrientation, PinType, PinLength):
        kicad_object.__init__(self)
        self.PinName = PinName
        self.PinNum = PinNum
        self.PinPositionX = PinPositionX
        self.PinPositionY = PinPositionY
        self.PinOrientation = PinOrientation % 4
        self.PinType = PinType
        self.PinLength = PinLength

    def rotate90CCW(self):
        self.PinPositionX, self.PinPositionY  = -self.PinPositionY, self.PinPositionX
        self.PinOrientation = (self.PinOrientation+1)%4

    def render(self):
        return COMPONENT_PIN_TEMPLATE % { \
            'PinName' : self.PinName, \
	    'PinNum' : self.PinNum, \
	    'PinPositionX' : self.PinPositionX, \
	    'PinPositionY' : self.PinPositionY, \
            'PinOrientation' : COMPONENT_PIN_ROTATIONS[self.PinOrientation], \
            'PinType' : self.PinType, \
            'PinLength' : self.PinLength, \
	    }

class kicad_rectangle(kicad_object):
    def __init__(self, X1, Y1, X2, Y2):
        kicad_object.__init__(self)
	self.X1 = X1
	self.Y1 = Y1
	self.X2 = X2
	self.Y2 = Y2

    def rotate90CCW(self):
        self.X1, self.Y1 = self.Y1, -self.X1
        self.X2, self.Y2 = self.Y2, -self.X2

    def render(self):
        return COMPONENT_RECTANGLE_TEMPLATE % { \
            'X1' : self.X1, \
            'Y1' : self.Y1, \
	    'X2' : self.X2, \
	    'Y2' : self.Y2, \
	    }

#################################
### Module Classes
#################################   

# kicad_module is the main class for PCB Footprints
# Dimesnions are always in mm and translated to 1/1000 inch at render time 
class kicad_module(kicad_container):
    def __init__(self, ModuleName):
        kicad_container.__init__(self)
        self.ModuleName = ModuleName

    def render(self):
        s = MODULE_TEMPLATE_BEGIN % { \
            'ModuleName' : self.ModuleName \
            }
        s += self.renderChildren()
        s += MODULE_TEMPLATE_END
        return s             
        
class kicad_pad(kicad_object):
    def __init__(self, num, sizeX, sizeY, posX, posY):
        kicad_object.__init__(self)
	self.PadNum = num
	self.PadShape = "R"
	self.PadSizeX = sizeX
	self.PadSizeY = sizeY
	self.PadPositionX = posX
	self.PadPositionY = posY
        self.Rotation = 0

    def rotate90CCW(self):
        self.PadPositionX, self.PadPositionY = self.PadPositionY, -self.PadPositionX
        self.Rotation = (self.Rotation + 900) % 3600

    def render(self):
        return MODULE_PAD_TEMPLATE % { \
            'PadNum' : self.PadNum, \
	    'PadShape' : self.PadShape, \
	    'PadSizeX' : self.PadSizeX * MM2MILL, \
	    'PadSizeY' : self.PadSizeY * MM2MILL, \
	    'PadPositionX' : self.PadPositionX * MM2MILL, \
	    'PadPositionY' : self.PadPositionY * MM2MILL, \
            'Rotation' : self.Rotation, \
	    }

class kicad_drawing(kicad_object):
    def __init__(self, Command, X1, Y1, X2, Y2, Width):
        kicad_object.__init__(self)
        self.Command = Command
	self.X1 = X1
	self.Y1 = Y1
	self.X2 = X2
	self.Y2 = Y2
	self.Width = Width

    def rotate90CCW(self):
        self.X1, self.Y1 = self.Y1, -self.X1
        self.X2, self.Y2 = self.Y2, -self.X2

    def render(self):
        return MODULE_DRAWING_TEMPLATE % { \
            'Command' : self.Command, \
            'X1' : self.X1 * MM2MILL, \
            'Y1' : self.Y1 * MM2MILL, \
	    'X2' : self.X2 * MM2MILL, \
	    'Y2' : self.Y2 * MM2MILL, \
	    'Width' : self.Width * MM2MILL, \
	    }

class kicad_line(kicad_drawing):
    def __init__(self, X1, Y1, X2, Y2, Width):
        kicad_drawing.__init__(self, 'DS', X1, Y1, X2, Y2, Width)

class kicad_circle(kicad_drawing):
    def __init__(self, X1, Y1, X2, Y2, Width):
        kicad_drawing.__init__(self, 'DC', X1, Y1, X2, Y2, Width)


##################################
## PCB classes - for .brd files ##
##################################
        
class kicad_board(kicad_container):
    def __init__(self, ModuleName):
        kicad_container.__init__(self)
        self.ModuleName = ModuleName

    def render(self):
        s = KICAD_BRD_TEMPLATE % { \
            'Content' : self.renderChildren() \
            }
        return s   
        
        
class kicad_pcb_track_via(kicad_drawing):
    def __init__(self, X1, Y1, X2, Y2, Width, Layer, Type, ViaFlag):
        kicad_drawing.__init__(self, 'Po', X1, Y1, X2, Y2, Width)
        self.Layer = Layer
        self.Command2 = "De"
        self.Type = Type
        self.ViaFlag = ViaFlag

    def render(self):
        return PCB_TRACK_TEMPLATE % { \
            'Command' : self.Command, \
            'Command2' : self.Command2, \
            'Layer' : self.Layer, \
            'Type' : self.Type, \
            'ViaFlag' : self.ViaFlag, \
            'X1' : self.X1 * MM2MILL, \
            'Y1' : self.Y1 * MM2MILL, \
	    'X2' : self.X2 * MM2MILL, \
	    'Y2' : self.Y2 * MM2MILL, \
	    'Width' : self.Width * MM2MILL, \
	    }

class kicad_pcb_track(kicad_pcb_track_via):
    def __init__(self, X1, Y1, X2, Y2, Width, Layer):
        kicad_pcb_track_via.__init__(self, X1, Y1, X2, Y2, Width, Layer, 0, 0)

class kicad_pcb_via(kicad_pcb_track_via):
    def __init__(self, X1, Y1, X2, Y2, Width, Layer):
        kicad_pcb_track_via.__init__(self, X1, Y1, X2, Y2, Width, Layer, 3, 1)
