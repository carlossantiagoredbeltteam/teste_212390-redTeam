## povray.py is Copyright (C) 2008 James Vasile.  It is free software;
## you can redistribute it and/or modify it under the terms of the GNU
## General Public License as published by the Free Software
## Foundation; either version 3 of the License, or any later version.

## povray.py is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.  You should have received
## a copy of the GNU General Public License along with image-to-gcode;
## if not, write to the Free Software Foundation, Inc., 51 Franklin
## Street 5th Floor, Boston, MA 02110-1301 USA
##
## Not tested on Windows or Mac boxes.

from miscellaneous import *
import re

class object:
    x = X = y = Y = z = Z = None
    code = None
    __name = None

    def __init__(self, str = ''):
        # empty is no initial code, one line is a filespec, multiline is code
        import re
        p = re.compile("\n")
        m = re.search(p, str)
        if str:
            if m: self.code = str  # it's code
            else:  # it's a filespec
                ## TODO: error handling
                self.code = slurp_file(str)

    def name(self):
        if self.__name: return self.__name
        p = re.compile('\#declare\s*(\w*)')
        m = re.search(p, self.code)
        if not m:
            print fname+".inc improperly formatted.  Can't find object name.\n"
            sys.exit(2)
        self.__name = m.group(1)
        return self.__name

    def min_max(self):
        self.x = self.y = self.z = 9999999999
        self.X = self.Y = self.Z = -9999999999


        tri_regex = re.compile('triangle {.*?\n(.*?\n.*?\n.*?)\n')
        for tri in re.finditer(tri_regex, self.code):
            vertex_regex = re.compile ('<(.*?)>');
            for vertex in re.finditer(vertex_regex, tri.group(1)):
                (x, y, z) = vertex.group(1).split(', ', 2)
                if float(x) < self.x: self.x = float(x)
                if float(x) > self.X: self.X = float(x)
                if float(y) < self.y: self.y = float(y)
                if float(y) > self.Y: self.Y = float(y)
                if float(z) < self.z: self.z = float(z)
                if float(z) > self.Z: self.Z = float(z)


    def min_x(self):
        if self.x: return self.x
        else: self.min_max()
        return self.x

    def max_x(self):
        if self.X: return self.X
        else: self.min_max()
        return self.X

    def min_y(self):
        if self.y: return self.y
        else: self.min_max()
        return self.y

    def max_y(self):
        if self.Y: return self.Y
        else: self.min_max()
        return self.Y

    def min_z(self):
        if self.z: return self.z
        else: self.min_max()
        return self.z

    def max_z(self):
        if self.Z: return self.Z
        else: self.min_max()
        return self.Z

