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

from brlcad import *

class Primitive(Shape):
    "Primitive shapes executed in one or more statements."
    isprimitive=True
    def __init__(self, shape, args=[], **kwargs):
        self.name = build_name(shape, 's', **kwargs)
        self.statements = []

        self.guess_vertex(args)

        Shape.__init__(self, ( Kill(self.name), 
                               Statement('in %s %s' % (self.name, shape),args),), 
                       name=self.name, **kwargs)

    def guess_vertex(self, args):
        ## Guess at the vertex.  If this won't find the right vertex,
        ## you'll have to set it manually.
        i = 0
        while not hasattr(self, 'vertex') and i < len(args):
            if type(args[i]) == tuple and len(args[i]) == 3:
                self.vertex = args[i]
            i += 1

    def rotate(self, rotation, vertex=None):
        if vertex == None:
            vertex = self.vertex

        xrot, yrot, zrot = rotation
        xvert, yvert, zvert = vertex

        self.statements.append('sed %s\nkeypoint %f %f %f\nrot %f %f %f\naccept\n' % (
                self.name, xvert, yvert, zvert, xrot, yrot, zrot))

    def translate(self, xtra, ytra=None, ztra=None):
        '''Translate shape to new coordinates.

        Note that this is different from MGED's internal translate
        statement.  MGED moves the shape to the indicated coordinates.
        This function moves the shape relative to the current
        coordinates.  translate(1, 2, -3) moves the shape 1 to the
        right, 2 up and 3 back.'''

        if type(xtra) == tuple:
            xtra, ytra, ztra = xtra

        self.statements.append('sed %s\ntra %f %f %f\naccept' % (
                self.name, xtra, ytra, ztra))

class Box(Primitive):
    def __init__(self, xmin, xmax, ymin, ymax, zmin, zmax, **kwargs):
        self.vertex = (xmin, ymin, zmin)
        if not 'basename' in kwargs:
            kwargs['basename'] = 'box'
        Primitive.__init__(self, "rpp", (xmin, xmax, ymin, ymax, zmin, zmax), **kwargs)
class Ellipsoid_foci(Primitive):
    def __init__(self, focus_1, focus_2, chord_length, **kwargs):
        'TODO: test chord_length must be > distance between foci'
        Primitive.__init__(self, "ellg", (focus_1, focus_2, chord_length), **kwargs)

## Implement some primitive shapes
from string import Template
primitives = {
'Arb4':['arb4', 'v1, v2, v3, v4'],
'Arb5':['arb5', 'v1, v2, v3, v4, v5'],
'Arb6':['arb6', 'v1, v2, v3, v4, v5, v'],
'Arb7':['arb7', 'v1, v2, v3, v4, v5, v6, v7'],
'Arb8':['arb8', 'v1, v2, v3, v4, v5, v6, v7, v8'],
'Cone':['trc', 'vertex, height_vector, base_radius, top_radius'],
'Cone_elliptical':['tec', 'vertex, height_vector, major_axis, minor_axis, ratio'],
'Cone_general':['tgc', 'vertex, height_vector, avector, bvector, cscalar, dscalar'],
'Cylinder':['rcc', 'vertex, height_vector, radius'],
'Cylinder_elliptical':['rec', 'vertex, height_vector, major_axis, minor_axis'],
'Cylinder_hyperbolic':['rhc','vertex, height_vector, bvector, half_width, apex_to_asymptote'],
'Cylinder_parabolic':['rpc', 'vertex, height_vector, bvector, half_width'],
'Ellipsoid':['ell', 'vertex, avector, bvector, cvector'],
'Hyperboloid_elliptical': ['ehy', 'vertex, height_vector, avector, bscalar, apex_to_asymptote'],
'Paraboloid_elliptical': ['epa', 'vertex, height_vector, avector, bscalar'],
'Ellipsoid_radius':['ell1', 'vertex, radius'],
'Particle':['part', 'vertex, height_vector, radius_at_v_end, radius_at_h_end'],
'Sphere':['sph', 'vertex, radius'],
'Torus':['tor', 'vertex, normal, radius_1, radius_2'],
'Torus_elliptical':['eto', 'vertex, normal_vector, radius, cvector, axis'],
}
for p in primitives:
    exec Template('''class $classname(Primitive):
    def __init__(self, $args, **kwargs):
        Primitive.__init__(self, "$mged", ($args), **kwargs)'''). \
            substitute(classname = p, mged = primitives[p][0], args = primitives[p][1])
