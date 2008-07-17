#!/usr/bin/python

## Copyright (C) 2008 James Vasile <james@hackervisions.org>'

## This is a freed work; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## any later version.

## This is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
## or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
## License for more details.  You should have received a copy of the
## GNU General Public License along with the work; if not, write
## to the Free Software Foundation, Inc., 51 Franklin Street, 5th
## Floor, Boston, MA 02110-1301 USA

import sys

from brlcad import *
from brlcad_mechanical import *

class sanyo_stepper(stepper_motor):
    def __init__(self, vertex, **kwargs):
        base_width = float(3)
        stepper_motor.__init__(self, vertex,       # vertex
                               .25, base_width,    # base thickness, base width
                                0.25,              # motor hole radius
                                2.5, base_width/2, # motor height and radius
                                1, 0.1,             #spindel height and radius
                                **kwargs)

class l_bracket(Shape):
    def __init__(self, vertex, width, length1, length2, thickness):
        pass

class motor_mount(Shape):
    def __init__(self, vertex, height):
        x, y, z = vertex
        hx, hy, hz = height
        Shape.__init__(self, '')

class cross_slide_vice(Shape):
    def __init__(self, vertex, height):
        x, y, z = vertex
        hx, hy, hz = height
        Shape.__init__(self, [
                Box(0,15,0,12,0,2, basename='base', suffix='')
                # 2 acme rods
                # 1 jaw threaded screw 
                # 2 jaws
                # 3 handles
                # 2 sliding bases
                ], basename='vice', suffix='', group=True)
        


class cartesian_bot(Shape):
    def __init__(self, vertex, height, **kwargs):
        x, y, z = vertex
        hx, hy, hz = height

        s1 = sanyo_stepper((x-5,y+5,z), rotate=(0,0,90))
#        s1.rotate((0, 0, 90))
        s2 = sanyo_stepper((x+10, y-5, z))


        Shape.__init__(self, [
                cross_slide_vice(vertex, height),
#            motor_mount(vertex, height),
#            motor_mount(vertex, height),
                s1, s2,
                ], basename='cartesian_bot', suffix='', group=True)


#print warning, '\n\n', copyright, '\n', license, '\n'

bot = 1
print Script(
    Comment('Cartesian bot based on cross-slide vice'),
    Title('xslide_strap'),
    Units('mm'),
    cartesian_bot((0,1,2), (0,2,0))
    )

