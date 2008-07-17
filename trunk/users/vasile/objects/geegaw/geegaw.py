#!/usr/bin/python

import sys, os

def path_munge():
    found = False
    for p in sys.path:
        if os.path.exists(p + 'primitive.py') and p[-7:-1] == 'brlcad':
            found = True

    if not found:
        sys.path.insert(1,'/home/vasile/personal/reprap/users/vasile/brlcad/')

path_munge()

from brlcad import *

VERSION=0.2

class base(Shape):
    def __init__(self, vertex=(0,0,0), height=(0, 1.5, 0), radius=0.5):
        '''TODO: little nubs for the threads to bite?
        TODO: a way to keep the pestle in'''

        x, y, z = vertex
        h = height
        hy = float(h[1])
        radius = float(radius)

        shell = Shape( [
                Cylinder((x, y + 2*hy/3, z), (h[0], hy/3, h[2]), radius),
                Cone(vertex, (h[0], 2 * hy/3, h[2]), 0.25 ,radius)
                ], basename='shell', suffix='', group=True)

        innards = Shape ( [
                Cylinder((x, y + 2 * hy / 3, z), 
                         (h[0], hy/3 + 0.0001, h[2]), 
                         radius * .75),
                Cone((x, y + 2 * hy / 3, z), 
                     (h[0], hy/3 - 1, h[2]),
                     radius * .75 - .025, 0.125),
                Cylinder(vertex, (h[0], hy/3, h[2]), 0.25)
                ], basename='innards', suffix='', group=True)

        Shape.__init__(self, [
                shell, innards
                ], combination = shell - innards, basename='base')

class pestle(Shape):
    def __init__(self, vertex = (2,0,0), height=(0, 1, 0), radius=0.5):
        radius = float(radius)
        h = height
        hy = float(height[1])

        Shape.__init__(self, [
                Cylinder(vertex, (h[0], hy, h[2]), radius * .75, basename='pestle'),
                Cylinder(vertex, (h[0], hy/2, h[2]), radius, basename='cap')
                ], group=True)


class slater(Shape):
    def __init__(self, vertex=(0,0,0), height=(0,2,0), radius=0.5):
        x, y, z = vertex
        h = height
        hy = float(h[1])

        Shape.__init__(self, [
                base(vertex, (h[0], hy * 3 /4, h[2]), radius),
                pestle((x,y+3,z), (h[0], hy * - 1 / 2, h[2]), radius)
                ], basename='slater', suffix='', group=True)

print warning, '\n\n', copyright, '\n', license, '\n'
print Script(
    Title('slater'),
    Units('inch'),
    slater((-1,0,0), (0,2,0), 0.5)
    )



