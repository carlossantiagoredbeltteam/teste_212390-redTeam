from kicad import *

### ALL measurements are in mm


class meander(kicad_container):
    def __init__(self, dim1, dim2, width, n):
        kicad_container.__init__(self)
        self.length = 0
        for i in range(0, n):
            self.length += dim1 + dim2
            if i % 2 == 0:
                self.add(kicad_pcb_track(0,    i*dim2,     dim1, i*dim2, width, 0))
                self.add(kicad_pcb_track(dim1, i*dim2, dim1, (i+1)*dim2, width, 0))
            else:
                self.add(kicad_pcb_track(dim1, i*dim2,     0,    i*dim2,     width, 0))
                self.add(kicad_pcb_track(0, i*dim2, 0, (i+1)*dim2, width, 0))
                

        
        
    


module = kicad_board('RepRap Heating Plate')
p = meander(100, 2, 0.8, 1000/102)
module.add(p)

print module.render()

