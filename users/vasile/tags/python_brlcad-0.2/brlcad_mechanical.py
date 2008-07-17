## Copyright (C) 2008 James Vasile <james@hackervisions.org>

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

from brlcad import *

class stepper_motor(Shape):
    '''Vertex is center point box, along the center of the cylinder.

    TODO: implement mounting holes'''

    def __init__(self, vertex, base_height, base_width,
                 mount_hole_rad,
                 motor_height, motor_rad,
                 spindle_height, spindle_rad, **kwargs):

        x, y, z = vertex
        by = base_height
        my = motor_height

        bw = float(base_width) / 2

        self.vertex = vertex

        Shape.__init__(self, [
            Comment('Stepper Motor'),

            Cylinder((x, y+by, z), (0,motor_height,0), motor_rad),
            Cylinder((x, y+by+my, z), (0,spindle_height,0), spindle_rad),
            Box_rounded_edge_corners(x-bw,x+bw, y,y+by, z-bw,z+bw, bw/10),
            ], basename='stepper', suffix='', group=True, **kwargs)


class Threaded_rod():
    '''Threaded rod.  Horrible detail right now'''
    def __init__(self, name, vertex, length_vector, major_diameter, minor_diameter, tpi):
        '''If tpi is < 1, it's pitch in whatever the current units is,
           otherwise it's teeth per current units'''

        ## Pitch
        if tpi < 1:
            pitch = tpi
        else:
            pitch = 1/tpi

        ## Major and minor radii
        major = float(major_diameter) / 2
        minor = float(minor_diameter) / 2

        ## Mock it up as a cylinder in a cylinder
        ## Todo: improve mock up to use major diameter disks around a minor diameter core
        return Script(
            Cylinder('unique_name_token', vertex, length_vector, major),
            Cylinder('unique_name_token', vertex, length_vector, minor)
            )

    
class Threaded_hole():
    '''Threaded hole.  Horrible detail.'''
    def __init__(self, name, vertex, length_vector, major_diameter, minor_diameter, tpi):
        '''If tpi is < 1, it's pitch in whatever the current units is,
           otherwise it's teeth per current units'''

        ## Pitch
        if tpi < 1:
            pitch = tpi
        else:
            pitch = 1/tpi

        ## Major and minor radii
        major = float(major_diameter) / 2
        minor = float(minor_diameter) / 2

        ## Mock it up as a cylinder in a cylinder
        ## Todo: improve mock up to use major diameter disks around a minor diameter core
        return Script(
            Cylinder('unique_name_token', vertex, length_vector, major),
            Cylinder('unique_name_token', vertex, length_vector, minor)
            )


