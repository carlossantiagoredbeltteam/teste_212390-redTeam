from kicad import *

### ALL measurements are in mm

E = 6.0  # Width of IC
NE = 10  # Pins on E sides
D = 6.0  # Height of IC
ND = 10  # Pins on D sides

E2 = 4.1 # Width of the exposed Pad
D2 = 4.1 # Height of the exposed Pad

e = 0.5  # spacing between center of pins
N = (NE+ND)*2   # number of pins

b = 0.25 # width of one pin
L = 0.4  # height of one pin

drawingWidth = 0.05
dotSize = 0.1


# according to ST Technical note TN0019 the adds should be 0.1mm
# according to OnSemi AND8086/D the adds should be 0mm

L_add = 0.1 # gets added to the PCB land of the Pin
b_add = 0.1
E2_add = 0.1    # gets added to the width of the exposed pad
D2_add = E2_add

module = kicad_module('TFQN40')

for side in range(0, 2):
    # Pins on the bottom and top side
    for pinNr in range(0, NE):
        p = kicad_pad(1+pinNr+side*(NE+ND), b+b_add, L+L_add, pinNr*e - (NE-1)*e/2, D/2-L/2)
        p.rotateCCW(side*2)
        module.add(p)
    # Package outline bottom and top side
    l = kicad_line(-E/2, D/2, E/2, D/2, drawingWidth)
    l.rotateCCW(side*2)
    module.add(l)

    for pinNr in range(0, ND):
        p = kicad_pad(1+pinNr+NE+side*(NE+ND), b+b_add, L+L_add, pinNr*e - (ND-1)*e/2, E/2-L/2)
        p.rotateCCW(side*2+1)
        module.add(p)

    l = kicad_line(-D/2, E/2, D/2, E/2, drawingWidth)
    l.rotateCCW(side*2+1)
    module.add(l) 

p = kicad_pad(N+1, E2+E2_add, D2+D2_add, 0, 0)
module.add(p)


pin1Circle = kicad_circle(-(NE-1)*e/2, D/2-L/2, dotSize-(NE-1)*e/2, D/2-L/2, drawingWidth)
module.add(pin1Circle)

print module.render()
