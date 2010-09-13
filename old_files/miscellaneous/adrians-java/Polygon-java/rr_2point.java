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


rr_2point: 2D vectors

First version 20 May 2005
This version: 2 October 2005 (translation to Java)


*/

// Class for (x, y) points and vectors

class rr_2point
{
    public double x, y;

    public rr_2point()
    {
	x = 0;
	y = 0;
    }

    public rr_2point(double a, double b)
    {
	x = a;
	y = b;
    }

    public rr_2point(rr_2point r)
    {
	x = r.x;
	y = r.y;
    }


    // Convert to a string
    
    public String toString()
    {
	return Double.toString(x) + " " + Double.toString(y);
    }


    // Arithmetic
    
    public rr_2point neg()
    {
	return new rr_2point(-x, -y);
    }
    
    public rr_2point add(rr_2point a)
    {
	rr_2point r = new rr_2point(a);
	r.x += x;
	r.y += y;
	return r;
    }

    
    public rr_2point sub(rr_2point a)
    {
        return add(a.neg());
    }


    // Scaling

    public rr_2point mul(double a)
    {
        return new rr_2point(x*a, y*a);
    }

    
    public rr_2point div(double a)
    {
	return mul(1/a);
    }

    // Inner product

    public double mul(rr_2point a)
    {
	return x*a.x + y*a.y;
    }

        
    // Modulus
    
    public double mod()
    {
        return Math.sqrt(mul(this));
    }


    // Unit length normalization
    
    public rr_2point norm()
    {
        return div(mod());
    }


    // Outer product

    public double op(rr_2point a)
    {
	return x*a.y - y*a.x;
    }


    // Squared distance

    public double d_2(rr_2point a)
    {
	rr_2point c = sub(a);
	return c.mul(c);
    }
}


