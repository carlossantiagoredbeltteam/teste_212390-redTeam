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

import os
import sys
import getopt
import Image
import gcode
import povray
from miscellaneous import *

## Defaults
step = 0.002 # this is the x and y step length, I think
depth = 0.008 # I think this is color depth
x, y = 0, 0 # starting offset for x and y

#tolerance = 0.000000001
inside_vector = [-0.5, 0.68, 0.5] # TODO: calculate this
inside_vector = [0, 0, 0]
delta_y = 1
verbose = False
target = 'gcode'  # target format should be one of inc, pov, png, gcode

filename=''

VERSION = 0.1

def help():
    print '''\nBy specifying a file with [inc|pov|png] extension, you can skip
initial steps.  And by using the --target option, you can end the
processing at whatever step you need.  If intermediary files are what
you're looking for, there's no need to keep processing all the way to
gcode.'''

def usage():
    print '''Slices 3D stl models into layers and generates gcode for each layer.

stl2gcode [dstvxy] --file
    -d --depth d\t\t\tdepth
    -f --file f\t\t\t\tfilename (required)
    -h --help\t\t\thelp
    -s --step s\t\t\t\tstep
    -t --target [inc|pov|png|gcode]\ttarget format
    -v --verbose\t\t\tverbose
    -x --x x\t\t\t\tinitial x value
    -y --y y\t\t\t\tinitial y value'''

def do_args(argv):
    if len(argv) == 0: usage(); sys.exit()
    try:
        opts, args = getopt.getopt(argv, "hd:f:s:t:vx:y:",
                                   ["help", "file=", "depth=", "step=", "target=",
                                    "verbose", "x=", "y="])
    except getopt.GetoptError, err:
        print str(err); usage(); sys.exit(2)
    global filename
    for o, a in opts:
        if o in ("-h", "--help"): usage(); help(); sys.exit()
        elif o in ("-d", "--depth"): global depth; depth = float(a)
        elif o in ("-f", "--filename"): global filename; filename = a; 
        elif o in ("-s", "--step"): global step; step = float(a);
        elif o in ("-t", "--target"): global target; target = a;
        elif o in ("-v", "--verbose"): global verbose; verbose = True
        elif o in ("-x", "--x"): global x; x = float(a)
        elif o in ("-y", "--y"): global y; y = float(a)
        else: assert False, "unhandled option"
    if filename == "":
        print "Must specify filename.  Use -f option."
        usage()
        sys.exit(2)
    if target not in (['inc', 'pov', 'png', 'gcode']):
        print "Target must be inc|pov|png|gcode."
        usage()
        sys.exit(2)

###############################################################################

def povray_include (base_fname, inside_vector):
    'Convert an stl file into a POVRAY include object'
    ## TODO: use the -e distance option for stl2pov
    stdout_handle = os.popen("stl2pov -s " + base_fname + '.stl', "r")
    inc = stdout_handle.read()

    vec_string = 'inside_vector <' + \
        str(inside_vector[0]) + ', ' + \
        str(inside_vector[1]) + ', ' + \
        str(inside_vector[2]) + '>'

    inc = inc.rpartition('} //')[0] + vec_string + "\n}\n"

    out = open(base_fname+'.inc', 'w')
    out.write(inc)
    out.close

    return povray.object(inc);


def make_pov(fname, include):
    'Write a povray file that calls our included object'
    obj_name = include.name()
    min_x = include.min_x()
    max_x = include.max_x()
    min_y = include.min_y()
    max_y = include.max_y()
    min_z = include.min_z()
    max_z = include.max_z()

    pov = '''
#include "%s"
background {color rgb 1 }
camera {
  orthographic
  location <0, 10, 0>
  look_at <0, 0, 0>
}
#declare overview = 0;
#if (overview) 
 object { %s }
#else 
  intersection {
    object {  %s rotate 90*x }
    box { <%f, %f, %f>, <%f, %f, %f>
	  translate y * frame_number * %f}
  }
#end''' % (fname+'.inc', obj_name, obj_name,
           min_x, min_y, min_z,
           max_x, min_y + delta_y, max_z,
           delta_y)

    out = open(fname+'.pov', 'w')
    out.write(pov)
    out.close

def image_to_gcode(in_file, step, depth, x, y, out_file):
    'Take a bitmapped image and generate gcode for cutting that image out'
    # x and y are offsets for the initial x and y position
    # TODO: figure out how to use step and depth
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

def make_png(fname, frames):
    'Takes a pov file and generates png files that are slices of that pov scene'
    cmd = 'povray +Q0 -D0 +KFF'+ str(frames) + ' ' + fname + '.pov'
    if verbose: print cmd
    stdout_handle = os.popen(cmd, 'r')
    povray_output = stdout_handle.read()

def make_gcode(fname, frames, step, depth):
    'Given a range of png files, convert each to gcode'
    for i in range(1, frames):
        image_to_gcode('%s%02d.png' % (fname, i), step, depth, 0, 0, '%s%02d.gcode' % (fname, i))
        ## TODO: calculate the x and y offsets to center the object?

def main():
    do_args(sys.argv[1:])
    convert_object = stl2gcode({
            'delta_y': delta_y, 'depth': depth, 'filename': filename, 
            'target': target, 'step': step, 'verbose': verbose, 'x': x, 'y': y})
    convert_object.convert()

if __name__ == "__main__":
    main()

class stl2gcode:
    step = 1
    depth = 0.008
    x, y = 0, 0

    #tolerance = 0.000000001
    inside_vector = [-0.5, 0.68, 0.5] # TODO: calculate this
    delta_y = 0.1
    verbose = False
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
            if verbose: print 'Generating ' + self.base_fname + '.inc'
            povray_inc = povray_include(self.base_fname, self.inside_vector)
            if self.target == 'inc': return povray_inc

        ## Generate pov file from stl
        if extension in (['stl', 'inc']):
            if verbose: print 'Generating ' + self.base_fname + '.pov'
            make_pov(self.base_fname, povray_inc)
            if self.target == 'pov': return

        frames = int((povray_inc.max_y() - povray_inc.min_y()) / delta_y) + 1
        if verbose: print frames, 'layers'

        ## Generate png files from pov and inc
        if extension in (['stl', 'inc', 'pov']):
            if verbose: print 'Generating ' + self.base_fname + 'NN.png'
            make_png(self.base_fname, frames)
            if self.target == 'png': return

        ## Generate gcode files from png
        if extension in (['stl', 'inc', 'pov', 'png']):
            if verbose: print 'Generating ' + self.base_fname + 'NN.gcode'
            make_gcode(self.base_fname, frames, self.step, self.depth)
