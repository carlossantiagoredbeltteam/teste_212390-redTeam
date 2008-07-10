#!/usr/bin/python

## stl2gcode generates gcode from stereolithographic triangles.  This
## gcode can be fed to CNC fab machines to create physical 3D models.
## stl2gcode also generates intermediate file formats (i.e. pov and
## png files).

## Copyright (C) 2008 James Vasile <james@hackervisions.org>.  This is
## free software; you can redistribute it and/or modify it under the
## terms of the GNU General Public License as published by the Free
## Software Foundation; either version 3 of the License, or any later
## version.

## This is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
## or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
## License for more details.  You should have received a copy of the
## GNU General Public License along with image-to-gcode; if not, write
## to the Free Software Foundation, Inc., 51 Franklin Street 5th
## Floor, Boston, MA 02110-1301 USA
##
## See http://www.evilmadscientist.com/article.php/slicingstl
## See http://forums.reprap.org/read.php?12,9756,page=1
##
## Not tested on Windows or Mac boxes.
## 
## Needs PIL, the Python Imaging Library (aptitude install
## python-imaging)
##
## stl2gcode includes some code from image-to-gcode.py.  That code is
## Copyright (C) 2005 Chris Radek (chris@timeguy.com)

## TODO: adjust the scale so that the png represents 1 step per bit in the bitmap
## TODO: decide whether this is a module or a class

import os
import Image
import gcode
import povray
from miscellaneous import *

def povray_include (base_fname, inside_vector):
    'Convert an stl file into a POVRAY include object'
    ## TODO: use the -e distance option for stl2pov
    stdout_handle = os.popen("stl2pov -s " + base_fname + '.stl', "r")
    inc = stdout_handle.read()

    vec_string = 'inside_vector <%f, %f, %f>' % (
        inside_vector[0],inside_vector[1],inside_vector[2])

    ## write out include file with inside vector added
    out = open(base_fname+'.inc', 'w')
    out.write(inc.rpartition('} //')[0] + vec_string + "\n}\n")
    out.close

    return povray.object(inc);

def make_pov(fname, include, delta_y):
    'Write a povray file that calls our included object'
    obj_name = include.name()
    min_x = include.min_x()
    max_x = include.max_x()
    min_y = include.min_y()
    max_y = include.max_y()
    min_z = include.min_z()
    max_z = include.max_z()

    max_dimension = max(max_x, max_z)

    ## TODO: do we really want to center the object?

    pov = '''
#include "%s"
background {color rgb 1 }
camera {
  orthographic
  up <0, %f, 0>
  right <%f, 0, 0>
  location <%f, %f, %f>
  look_at <%f, %f, %f>
}
#declare overview = 0;
#if (overview) 
 object { %s }
#else 
  intersection {
    object {  %s }
    box { <%f, %f, %f>, <%f, %f, %f>
	  translate y * frame_number * %f}
  }
#end''' % (fname+'.inc',
           max_dimension, max_dimension,
           (max_x - min_x) / 2, max_y, (max_z - min_z) / 2,
           (max_x - min_x) / 2, min_y, (max_z - min_z) /2, 
           obj_name, obj_name,
           min_x, min_y, min_z,
           max_x, min_y + delta_y, max_z,
           delta_y)

    out = open(fname+'.pov', 'w')
    out.write(pov)
    out.close

def make_png(fname, frames):
    '''Takes a pov file and generates png files that are slices of that pov scene
    TODO: lower png color depth'''
    cmd = 'povray +Q0 -D0 +KFF'+ str(frames) + ' ' + fname + '.pov'
    stdout_handle = os.popen(cmd, 'r')
    povray_output = stdout_handle.read()

def image_to_gcode(in_file, step, depth, x, y, out_file):
    '''Take a bitmapped image and generate gcode for cutting that image out.

    x and y are offsets for the initial x and y position
    step is the minimum distance you can move in the x or y directions.
    TODO: figure out how to use color depth'''

    im = Image.open(in_file)
    size = im.size
    im = im.convert("L") #grayscale
    w, h = im.size

    g = gcode.gcode(safetyheight=0.02)

    out = open(out_file, 'w')
    out.write(g.begin() + g.continuous() + g.safety() + g.rapid(0,0))

    for j in range(h-1,-1,-1):
        if j%2==1:
            for i in range(w):
                d = float(im.getpixel((i, h-j-1)) / 255.0) * depth - depth
                out.write(g.cut(x, y, d, feed=12))
                x += step
            x -= step
        else:
            for i in range(w-1,-1,-1):
                d = float(im.getpixel((i, h-j-1)) / 255.0) * depth - depth
                out.write(g.cut(x, y, d, feed=12))
                x -= step
            x += step
        y -= step
        out.write(g.cut(y=y))

    out.write(g.end())
    out.close

def png_to_gcode(fname, frames, step, depth):
    'Given a range of png files, convert each to gcode'
    for i in range(1, frames):
        image_to_gcode('%s%02d.png' % (fname, i), step, depth, 0, 0, '%s%02d.gcode' % (fname, i))

class stl2gcode:
    step = 1
    depth = 0.008
    x, y = 0, 0

    #tolerance = 0.000000001
    inside_vector = [-0.5, 0.68, 0.5] # TODO: calculate this
    delta_y = 0.1
    target = 'gcode'  # target format should be one of inc, pov, png, gcode

    filename=''
    base_fname=''

    def __init__(self, params):
        for p in params: exec('self.' + p + ' = params[p]')

    def convert(self):
        'The main sub-- it converts stl to inc/pov to png to gcode'
        self.base_fname, dot, extension = self.filename.rpartition('.');

        ## Generate inc file from stl
        if extension != 'stl':
            povray_inc = povray.object(self.base_fname + '.inc') # pull object from file
        else:
            povray_inc = povray_include(self.base_fname, self.inside_vector)
            if self.target == 'inc': return povray_inc

        ## Generate pov file from stl
        if extension in (['stl', 'inc']):
            make_pov(self.base_fname, povray_inc, self.delta_y)
            if self.target == 'pov': return

        frames = int((povray_inc.max_y() - povray_inc.min_y()) / self.delta_y) + 1

        ## Generate png files from pov and inc
        if extension in (['stl', 'inc', 'pov']):
            make_png(self.base_fname, frames)
            if self.target == 'png': return

        ## Generate gcode files from png
        if extension in (['stl', 'inc', 'pov', 'png']):
            png_to_gcode(self.base_fname, frames, self.step, self.depth)


