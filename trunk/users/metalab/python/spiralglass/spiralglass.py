from math import pi, cos, sin

def moveTo(x, y, z, f):
    print "G1 X%(X)f Y%(Y)f Z%(Z)f F%(F)f" % {'X':x,'Y':y, 'Z':z, 'F':f}

def spiral(x, y, z, f, r, roh, outward):
    phimax = (2*pi*r)/roh
    if outward==1:
        phi = 0.0
        while (phi < phimax):
            r = (phi*roh)/(2*pi)
            nextx= x+cos(phi)*r
            nexty= y+sin(phi)*r
            moveTo(nextx, nexty, z, f)
            phi += 0.2
    else:
        phi = phimax
        while (phi > 0):
            r = (phi*roh)/(2*pi)
            nextx= x+cos(phi)*r
            nexty= y+sin(phi)*r
            moveTo(nextx, nexty, z, f)
            phi -= 0.2

def circle(x, y, z, f, r, outward):
    if outward==1:
        phi = 0.0
        while (phi < 2*pi):
            nextx= x+cos(phi)*r
            nexty= y+sin(phi)*r
            moveTo(nextx, nexty, z, f)
            phi += 0.2
    else:
        phi = 2*pi
        while (phi > 0):
            nextx= x+cos(phi)*r
            nexty= y+sin(phi)*r
            moveTo(nextx, nexty, z, f)
            phi -= 0.2
        


feedrate = 180
layerheight = 0.7
density = 1.2
radius = 12

layer = layerheight / 2.0

print "G21"
print "G90"
print "G28"
print "M103"
print "M108 S130.0"
print "M101"

spiral(radius, radius, layer, feedrate, radius, density, 1)
layer += layerheight
spiral(radius, radius, layer, feedrate, radius, density, 0)
layer += layerheight
spiral(radius, radius, layer, feedrate, radius, density, 1)
layer += layerheight
for i in range(0, 40):
    circle(radius, radius, layer, feedrate, radius, 1)
    layer += layerheight

print "M103"
    
        
        
    
