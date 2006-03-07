/*

RepRap
------

The Replicating Rapid Prototyper Project


Copyright (C) 2005
Adrian Bowyer & The University of Bath

http://reprap.org

Principal author:

Adrian Bowyer
Department of Mechanical Engineering
Faculty of Engineering and Design
University of Bath
Bath BA2 7AY
U.K.

e-mail: A.Bowyer@bath.ac.uk

RepRap is free; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
Licence as published by the Free Software Foundation; either
version 2 of the Licence, or (at your option) any later version.

RepRap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public Licence for more details.

For this purpose the words "software" and "library" in the GNU Library
General Public Licence are taken to mean any and all computer programs
computer files data results documents and other copyright information
available from the RepRap project.

You should have received a copy of the GNU Library General Public
Licence along with RepRap; if not, write to the Free
Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA,
or see

http://www.gnu.org/

=====================================================================

rr_csg: 2D polygons as boolean combinations of half-planes

First version 14 November 2005

*/



// CSG operators - god knows why this doesn't work...

// public enum rr_csg_op {UNION, INTERSECTION}

class rr_csg
{
    private static final byte UNION = 1;
    private static final byte INTERSECTION = 2;

    public rr_half_plane hp;  // Leaf half plane
    private byte op;          // Non-leaf operator
    private rr_csg c1, c2;    // Non-leaf child operands
    public int complexity;    // How much is in here?

    // Make a blank one for internal use

    private rr_csg()
    { }


    // Make a leaf from a single half-plane

    public rr_csg(rr_half_plane h)
    {
	hp = new rr_half_plane(h);
	op = 0;
	c1 = null;
	c2 = null;
	complexity = 1;
    }


    // Deep copy

    public rr_csg(rr_csg c)
    {
	if(c.op == 0)
	    {
		hp = new rr_half_plane(c.hp);
		op = 0;
		c1 = null;
		c2 = null;
		complexity = 1;
	    } else
	    {
		hp = null;
		op = c.op;
		c1 = new rr_csg(c.c1);
		c2 = new rr_csg(c.c2);
		complexity = c1.complexity + c2.complexity;
	    }
    }


    // Convert to a string

    public String toString()
    {
	return "rr_csg...";
    }


    // Private function for common work setting up booleans

    private rr_csg set_op(rr_csg a, rr_csg b)
    {
	rr_csg r = new rr_csg();
	r.hp = null;
	if(a.complexity <= b.complexity)
	    {
		r.c1 = a;
		r.c2 = b;
	    } else
	    {
		r.c1 = b;
		r.c2 = a;
	    }
	r.complexity = a.complexity + b.complexity;
	return r;
    }

    // Boolean operations

    public rr_csg union(rr_csg a, rr_csg b)
    {
	rr_csg r = set_op(a, b);
	r.op = UNION;
	return r;
    }

    public rr_csg intersection(rr_csg a, rr_csg b)
    {
	rr_csg r = set_op(a, b);
	r.op = INTERSECTION;
	return r;
    }

    public rr_csg complement()
    {
	rr_csg r = new rr_csg();

	if(op == 0)
	    {
		r.hp = hp.complement();
		r.op = 0;
		r.c1 = null;
		r.c2 = null;
		r.complexity = 1;
	    } else
	    {
		r.hp = null;
		if(op == UNION)
		    r.op = INTERSECTION;
		else
		    r.op = UNION;
		r.c1 = c1.complement();
		r.c2 = c2.complement();
		r.complexity = r.c1.complexity + r.c2.complexity;
	    }
	return r;
    }

    public rr_csg difference(rr_csg a, rr_csg b)
    {
	return intersection(a, b.complement());
    }


    // "Potential" value of a point; i.e. a membership test
    // -ve means inside; 0 means on the surface; +ve means outside

    public double value(rr_2point p)
    {
	if(op == 0)
	    {
		return hp.value(p);
	    } else
	    {
		if(op == UNION)
		    {
			return Math.min(c1.value(p), c2.value(p));
		    } else
		    {
			return Math.max(c1.value(p), c2.value(p));
		    }
	    }
    }


    // The interval value of a box (analagous to point)

    public rr_interval value(rr_box b)
    {
	if(op == 0)
	    {
		return hp.value(b);
	    } else
	    {
		if(op == UNION)
		    {
			return c1.value(b).min(c2.value(b));
		    } else
		    {
			return c1.value(b).max(c2.value(b));
		    }
	    }
    }

}
