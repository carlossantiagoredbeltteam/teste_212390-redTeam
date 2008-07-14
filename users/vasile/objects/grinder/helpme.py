#!/usr/bin/python 

class Vector:
    def __init__(self,*args):
        if len(args) == 1:
            self.v = args[0]
        else:
            self.v = args
    def __str__(self):
        return "%s"%(" ".join([str(x)for x in self.v]))
    def __repr__(self):
        return "Vector(%s)"%self.v
    def __mul__(self,other):
        return Vector( [r*other for r in self.v] )
    def __rmul__(self,other):
        return Vector( [r*other for r in self.v] )

class Statement:
    def __init__(self, statement, args=[]):
        args = list(args)
        for i in range(len(args)):
            if type(args[i]) == tuple or type(args[i]) == list:
                args[i] = Vector(args[i])
        self.args = args
        self.statement = statement

    def __str__(self):
        return '%s %s' % (self.statement, ' '.join([str(s) for s in self.args]))


class Group(Statement):
    def __init__(self, *shapes, **kwargs):
        shapes = list(shapes)
        l = []
        self.name = 'group_name.g'
        for i in range(len(shapes)):
            if not isinstance(shapes[i], basestring):
                t = shapes[i].name
                l.append(t)
        Statement.__init__(self, 'g', (self.name, ' '.join(l)))

    def __unpack_name(item):
        if isinstance(item, basestring):
            return item
        else:
            return item.name

class Shape(Statement):
    def __init__(self, shape, args=[], **kwargs):
        "Primitive shapes"
        self.name = 'name_goes_here'
        Statement.__init__(self,'in %s %s' % (self.name, shape),args)

class Cylinder(Shape):
    def __init__(self, vertex, height_vector, radius, **kwargs):
        Shape.__init__(self, "rcc", (vertex, height_vector, radius), **kwargs)


#l=['test', 'me']
#l.append('now')
#print ' '.join(l)
#import sys; sys.exit()
cyl = Cylinder((0, 2, 0), (0, 3, 0), 3)
cyl2 = Cylinder((1, 2, 0), (1, 3, 0), 3)
print  Group(cyl, cyl2)
