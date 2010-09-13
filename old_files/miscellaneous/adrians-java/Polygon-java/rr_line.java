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

rr_line: 2D parametric line

First version 20 May 2005
This version: 2 October 2005 (translation to Java)

*/

// Teeny class to hold bisectors of line pairs

class rr_bisector
{
	public rr_line b;      // The bisecting line
	public double s_angle; // The sine of the angle 
	
	public rr_bisector(rr_line l, double a)
	{
		b = l;
		s_angle = a;
	}
}


// Exception for when trying to intersect parallel lines

class rr_ParallelLineException extends Exception
{
    public rr_ParallelLineException(String s)
    {
	super(s);
    }
}

// Class to hold and manipulate linear half-planes

class rr_half_plane
{

    // The half-plane is normal*(x, y) + offset < 0

    public rr_2point normal; 
    public double offset;


    // Convert a parametric line

    public rr_half_plane(rr_line l)
    {
	double rsq = 1/(l.direction.mul(l.direction));
	normal = new rr_2point(-l.direction.y*rsq, l.direction.x*rsq);
	rr_2point p = l.origin.add(l.direction);
	offset = rsq*l.origin.op(p);
    }


    // Make one from two points on its edge

    public rr_half_plane(rr_2point a, rr_2point b)
    {
	this(new rr_line(a, b));
    }   

    // Deep copy

    public rr_half_plane(rr_half_plane a)
    {
	normal = new rr_2point(a.normal);
	offset = a.offset;
    }


    // Convert to a string

    public String toString()
    {
	return "|" + normal.toString() + ", " + Double.toString(offset) + "|";
    } 


    // Change the sense

    public rr_half_plane complement()
    {
	rr_half_plane r = new rr_half_plane(this);
	r.normal.x = -r.normal.x;
	r.normal.y = -r.normal.y;
	r.offset = -r.offset;
	return r;
    }


    // Find the potential value of a point

    public double value(rr_2point p)
    {
	return offset + normal.mul(p);
    }


    // Find the potential interval of a box

    public rr_interval value(rr_box b)
    {
	return ((b.x.mul(normal.x)).add(b.y.mul(normal.y))).add(offset);
    }


    // The point where another line crosses

    public rr_2point cross_point(rr_half_plane a) throws rr_ParallelLineException
    {
	double det = normal.op(a.normal);
	if(det == 0)
	    throw new rr_ParallelLineException("cross_point: parallel lines.");
	det = 1/det;
	double x = normal.y*a.offset - a.normal.y*offset;
	double y = a.normal.x*offset - normal.x*a.offset;
	return new rr_2point(x*det, y*det);
    }

    public double cross_t(rr_line a) throws rr_ParallelLineException 
    {
	double det = a.direction.mul(normal);
        if (det == 0)
	    throw new rr_ParallelLineException("cross_t: parallel lines.");  
	return value(a.origin)/det;
    }

    public rr_2point cross_point(rr_line a) throws rr_ParallelLineException
    {
	return a.point(cross_t(a));
    }

}


// Class to hold and manipulate parametric lines

class rr_line
{
    public rr_2point direction;
    public rr_2point origin;

    public rr_line(rr_2point a, rr_2point b)
    {
	origin = new rr_2point(a);
	direction = b.sub(a);
    }

    public rr_line(rr_line r)
    {
	origin = new rr_2point(r.origin);
	direction = new rr_2point(r.direction);
    }

    // Convert to a string

    public String toString()
    {
	return "<" + origin.toString() + ", " + direction.toString() + ">";
    }


    // The point at a given parameter value

    public rr_2point point(double t)
    {
	return origin.add(direction.mul(t));
    }


    // Normalise the direction vector

    public void norm()
    {
	direction = direction.norm();
    }


    // Arithmetic

    public rr_line neg()
    {
	rr_line a = new rr_line(this);
	a.direction = direction.neg();
	return a;
    }

    public rr_line add(rr_2point b)
    {
	rr_2point a = origin.add(b);
	rr_line r = new rr_line(a, a.add(direction));
	return r;
    }

    public rr_line sub(rr_2point b)
    {
	rr_2point a = origin.sub(b);
	rr_line r = new rr_line(a, a.add(direction));
	return r;
    }

    /*
    public rr_line add(rr_line a)
    {
	a.origin = a.origin.add(origin);
	return a;
    }
    */

    //public rr_line sub(rr_line a, rr_line b)
    //{
    //	return add(a, b.neg());
    //}

    // The parameter value where another line crosses

    public double cross_t(rr_line a) throws rr_ParallelLineException 
    {
	double det = a.direction.op(direction);
        if (det == 0)
	    throw new rr_ParallelLineException("cross_t: parallel lines.");  
        rr_2point d = a.origin.sub(origin);
	return a.direction.op(d)/det;
    }


    // The point where another line crosses

    public rr_2point cross_point(rr_line a) throws rr_ParallelLineException
    {
	return point(cross_t(a));
    }


    // The squared distance of a point from a line

    public rr_2point d_2(rr_2point p)
    {
        double fsq = direction.x*direction.x;
        double gsq = direction.y*direction.y;
        double finv = 1.0/(fsq + gsq);
        rr_2point j0 = p.sub(origin);
        double fg = direction.x*direction.y;
        double dx = gsq*j0.x - fg*j0.y;
        double dy = fsq*j0.y - fg*j0.x;
        double d2 = (dx*dx + dy*dy)*finv*finv;
        double t = direction.mul(j0)*finv;
        return new rr_2point(d2, t);
    }

    // Normalised line that bisects the angle between 
    // two others joining points a, b, and c and the sine
    // of the angle it makes with them.
    
    static public rr_bisector bisect(rr_2point a, rr_2point b, rr_2point c)
    {
    	rr_2point ab = (a.sub(b)).norm();
    	rr_2point cb = (c.sub(b)).norm();
    	rr_2point d = (ab.add(cb)).norm();
    	double ang = ab.op(d);
    	rr_line r = new rr_line(b, b.add(d));
    	return new rr_bisector(r, ang);
    }
}
