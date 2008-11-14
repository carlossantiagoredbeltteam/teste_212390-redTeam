from kicad import *
import sys

### ALL measurements are in mm


class meander(kicad_container):
    def __init__(self, sizeX, sizeY, padsX, padsY, width, spacing):
        kicad_container.__init__(self)
        self.length = 0
        posX = 0
        posY = 0
        newPosX = 0
        newPosY = 0
        while (posY < sizeY):
            
            if (posX == 0):
                if (posY < padsY + spacing or posY > sizeY - (padsY + spacing)):
                    newPosX = sizeX - padsX
                    self.length += sizeX - padsX
                else:
                    newPosX = sizeX
                    self.length += sizeX
            else:
                newPosX = 0

            self.add(kicad_pcb_track(posX, posY, newPosX, posY, width, 0))
            newPosY += spacing
            self.length += spacing
            self.add(kicad_pcb_track(newPosX, posY, newPosX, newPosY, width, 0))
            posX = newPosX
            posY = newPosY
        

module = kicad_board('RepRap Heating Plate')
p = meander(148, 97, 7, 7, 0.55, 1.05)
module.add(p)
sys.stderr.write("length: " + str(p.length))
print module.render()

