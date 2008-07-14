#!/usr/bin/python

import sys
sys.path.append('/home/vasile/personal/reprap/svn/users/vasile/brl-cad/')

from brlcad import *
from brlcad_mechanical import *

def stepper_motor(vertex, height):
    x, y, z = vertex
    hx, hy, hz = height
#    return Box

def motor_mount(vertex, height):
    x, y, z = vertex
    hx, hy, hz = height
    return Box(0, 1, 0, 1, 0, 1)
    

def cross_slide_vice(vertex, height):
    x, y, z = vertex
    hx, hy, hz = height
    # base
    # 2 acme rods
    # 2 jaws
    # 3 handles
    # 2 sliding bases


def cartesian_bot(vertex, height):
    x, y, z = vertex
    hx, hy, hz = height

    cross_slide_vice(vertex, height)

    return motor_mount(vertex, height)

    motor_mount(vertex, height)
    stepper_motor(vertex, height)
    stepper_motor(vertex, height)

#print '\n'.join([warning, copyright, license]), '\n'
print Title('xslide_strap')
print Units('mm')
print 'killall *' ## This deletes all objects in the db!  Careful with it!
bot = cartesian_bot((0,0,0), (0,2,0))
print bot


def slater_base (vertex=(0,0,0), height=(0, 1.5, 0), radius=0.5):
    '''Thanks, Jamie!

    TODO: little nubs for the threads to bite
    TODO: a way to keep the pestle in'''

    x, y, z = vertex
    h = height
    hy = float(h[1])
    radius = float(radius)
    shell_cyl = Cylinder((x, y + 2*hy/3, z), (h[0], hy/3, h[2]), radius, name='shell_cyl')
    shell_cone =  Cone(vertex, (h[0], 2 * hy/3, h[2]), 0.25 ,radius)
    shell_group =  Group(shell_cyl, shell_cone)
    mortar =  Cylinder((x, y + 2 * hy / 3, z), 
                       (h[0], hy/3 + 0.0001, h[2]), 
                       radius * .75)
    funnel =  Cone((x, y + 2 * hy / 3, z), 
                   (h[0], hy/3 - 1, h[2]),
                   radius * .75 - .025, 0.125)
    threads =  Cylinder(vertex, (h[0], hy/3, h[2]), 0.25)
    return Script(
        Comment('Slater Mortar'),
        shell_cyl, shell_cone, shell_group,
        mortar, funnel, threads,
        Region ('u ' + shell_group.name +  
                ' - '.join(['', mortar.name, funnel.name, threads.name]), 
                name='base')
        )

def slater_pestle (vertex = (2,0,0), height=(0, 1, 0), radius=0.5):
    radius = float(radius)
    h = height
    hy = float(height[1])
    s = Script(Comment('Slater Pestle'))
    cyl1 = Cylinder(vertex, (h[0], hy, h[2]), radius * .75, name='pestle')
    cyl2 = Cylinder(vertex, (h[0], hy/2, h[2]), radius, name='cap')
    return s.append(cyl1, cyl2, Group(cyl1, cyl2, name='pestle'))


def slater(vertex=(0,0,0), height=(0,2,0), radius=0.5):
    x, y, z = vertex
    h = height
    hy = float(h[1])
    base = slater_base(vertex, (h[0], hy * 3 /4, h[2]), radius)
    pestle = slater_pestle((x,y+3,z), (h[0], hy * - 1 / 2, h[2]), radius)

    return '%s%s' % (base, pestle)    

#print '\n'.join([warning, copyright, license]), '\n'
#print Title('slater')
#print Units('inch')
#print 'killall *' ## This deletes all objects in the db!  Careful with it!
#print slater((-1,0,0), (0,2,0), 0.5)



