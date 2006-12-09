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


rr_p_list: A collection of 2D polygons

First version 20 May 2005
This version: 8 March 2006

List of polygons class.  This too maintains a maximum enclosing rectangle.
Each polygon has an associated type that can be used to record any attribute
of the polygon.

*/


import java.io.*;
import java.util.*;


class rr_p_list
{
    public List polygons;
    public rr_box box;

    public rr_p_list()
    {
	polygons = new ArrayList();
	box = new rr_box();
    }

    // Deep copy

    public rr_p_list(rr_p_list lst)
    {
	polygons = new ArrayList();
	box = new rr_box(lst.box);
	int leng = lst.polygons.size();
	for(int i = 0; i < leng; i++)
	    polygons.add(new rr_polygon((rr_polygon)lst.polygons.get(i)));
    }


    // Put a new list on the end

    public void append(rr_p_list lst)
    {
	int leng = lst.polygons.size();
	if(leng == 0)
	    return;
	for(int i = 0; i < leng; i++)
		polygons.add(new rr_polygon((rr_polygon)lst.polygons.get(i)));
	box.expand(lst.box);
    }

    // Add one new polygon to the list

    public void append(rr_polygon p)
    {
	append(p.no_cross());
    }

    /*
    // Booleans on polygons

    public rr_p_list union(rr_p_list a,  rr_p_list b)
    {

    }

    public rr_p_list intersection(rr_p_list a,  rr_p_list b)
    {

    }


    public rr_p_list difference(rr_p_list a,  rr_p_list b)
    {
       return intersection(a, negate(b));
    }
    */
    
    // Negate all the polygons
    
    public rr_p_list negate()
    {
        rr_p_list result = new rr_p_list();
  	int leng = polygons.size();
	for(int i = 0; i < leng; i++)
        {
            result.polygons.add(((rr_polygon)polygons.get(i)).negate());
        }
        result.box = new rr_box(box);
        return result;
    }

    // Write as an SVG xml to file opf

    public void svg(PrintStream opf)
    {
        opf.println("<?xml version=\"1.0\" standalone=\"no\"?>");
        opf.println("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\"");
        opf.println("\"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">");
        opf.println("<svg");
        opf.println(" width=\"" + Double.toString(box.x.length()) + "mm\"");
        opf.println(" height=\""  + Double.toString(box.y.length()) +  "mm\"");
        opf.print(" viewBox=\"" + Double.toString(box.x.low));
        opf.print(" " + Double.toString(box.y.low));
        opf.print(" " + Double.toString(box.x.high));
	opf.println(" " + Double.toString(box.y.high) + "\"");
        opf.println(" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">");
	opf.println(" <desc>RepRap polygon list - http://reprap.org</desc>");

	int leng = polygons.size();
        for(int i = 0; i < leng; i++)
            ((rr_polygon)polygons.get(i)).svg(opf);

        opf.println("</svg>");
    }


    // Simplify all polygons by length d
    // N.B. this may throw away small ones completely

    public rr_p_list simplify(double d)
    {
        rr_p_list r = new rr_p_list();
        int leng = polygons.size();
        double d2 = d*d;

	for(int i = 0; i < leng; i++)
	    {
		rr_polygon p = (rr_polygon)polygons.get(i);
		if(p.box.d_2() > 2*d2)
		    r.append(p.simplify(d));
	    }

        return r;
    }


    // Intersect a line with a polygon list, returning an
    // unsorted list of the intersection parameters

    public List pl_intersect(rr_line l0)
    {
        int leng = polygons.size();
        List t = new ArrayList();

        for(int i = 0; i < leng; i++)
	    {
		List t1 = ((rr_polygon)polygons.get(i)).pl_intersect(l0);
		int leng1 = t1.size();
		for(int j = 0; j < leng1; j++)
		    t.add(t1.get(j));
	    }
	return t;
    }


    // Offset every polygon in the list

    public rr_p_list offset(double d)
    {
	int leng = polygons.size();
        rr_p_list r = new rr_p_list();
        for (int i = 0; i < leng; i++)
	    r.append(((rr_polygon)polygons.get(i)).offset(d));
	return r;
    }


    // Hatch a polygon list parallel to line l0 with index gap
    // Returning a polygon as the result with flag values f
    
    public rr_polygon hatch(rr_line l0, double gap, int fg, int fs)
    {
	rr_box big = box.scale(1.1);
	double d = Math.sqrt(big.d_2());
	rr_polygon r = new rr_polygon();
	rr_2point orth = new rr_2point(-l0.direction.y, l0.direction.x);
	orth.norm();

	int quad = (int)(2*Math.atan2(orth.y, orth.x)/Math.PI);

	rr_2point org;

	switch(quad)
	    {
	    case 0:
		org = big.min();
		break;

	    case 1:
		org = new rr_2point(big.x.high, big.y.low);
		break;

	    case 2:
		org = big.max();  // Do you want fries with that?  
		break;

	    case 3:
		org = new rr_2point(big.x.low, big.y.high);
		break;

	    default:
		System.err.println("rr_polygon hatch(): The atan2 function doesn't seem to work...");
		org = big.min();
	    }

        double g = 0;
        int i = 0;
	orth = orth.mul(gap);

	rr_line hatcher = new rr_line(org, org.add(l0.direction));

        while (g < d)
	    {
		hatcher = hatcher.neg();
		List t_vals = pl_intersect(hatcher);
		if (t_vals.size() > 0)
		    r.append(rr_polygon.rr_t_polygon(t_vals, hatcher, fg, fs));
		hatcher = hatcher.add(orth);
		g = g + gap;
	    }
	r.flags.set(0, new Integer(0));
        return r;
    }
        

}



