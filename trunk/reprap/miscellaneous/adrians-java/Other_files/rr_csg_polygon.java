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

rr_csg_polygon: 2D polygons as boolean combinations of half-planes,
together with spatial quad tree and other tools

First version 14 November 2005

*/


class rr_csg_polygon
{
    public rr_csg c;                        // The polygon
    public rr_box b;                        // Its enclosing box
    private rr_csg_polygon q0, q1, q2, q3;  // Quad tree division

    // Set one up

    public rr_csg_polygon(rr_csg p, rr_box bx)
    {
	c = new rr_csg(p);
	b = new rr_box(bx);
	q0 = null;
	q1 = null;
	q2 = null;
	q3 = null;
    }

    // Deep copy

    public rr_csg_polygon(rr_csg_polygon p)
    {
	c = new rr_csg(p.c);
	b = new rr_box(p.b);
	if(p.q0 != null)
	    {
		q0 = new rr_csg_polygon(p.q0);
		q1 = new rr_csg_polygon(p.q1);
		q2 = new rr_csg_polygon(p.q2);
		q3 = new rr_csg_polygon(p.q3);
	    } else
	    {
		q0 = null;
		q1 = null;
		q2 = null;
		q3 = null;
	    }
    }

    // Convert to a string

    public String toString()
    {
	return "rr_csg_polygon...";
    }

    public rr_csg_polygon divide(double resolution_2, double swell)
    {
	if(b.d_2() < resolution_2)
	    return new rr_csg_polygon(this);
    } 

}
