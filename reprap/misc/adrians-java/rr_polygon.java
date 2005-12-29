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


rr_polygon: 2D polygons

First version 20 May 2005
This version: 2 October 2005 (translation to Java)

A polygon is an auto-extending list of rr_2points.  Its end is 
sometimes considered to join back to its beginning, depending
on context.

It also keeps its enclosing box.  

Each point is stored with a flag value.  This can be used to flag the
point as visited, or to indicate if the subsequent line segment is to
be plotted etc.

java.awt.Polygon is no use for this because it has integer coordinates.

*/

import java.io.*;
import java.util.*;


// Small class to return the results of a polygon's crossing itself

class self_x
{
    public boolean flag;
    public int l0;
    public int l1;

    public self_x(boolean f, int a0, int a1)
    {
	flag = f;
	l0 = a0;
	l1 = a1;
    }
}

// The main polygon class

class rr_polygon
{
    public List points;
    public List flags;
    public rr_box box;

    public rr_polygon()
    {
	points = new ArrayList();
	flags = new ArrayList();
	box = new rr_box();
    }

    public rr_polygon(rr_polygon p)
    {
	points = new ArrayList();
	flags = new ArrayList();
	box = new rr_box(p.box);
	int leng = p.points.size();
	for(int i = 0; i < leng; i++)
	    {
		points.add(new rr_2point((rr_2point)p.points.get(i)));
		flags.add(new Integer(((Integer)p.flags.get(i)).intValue())); // I hold this line up as a staggering 
                                                                              // example of all that is wrong with Java.
                                                                              // All I wanted was a self-extending list
                                                                              // of integers...
	    }		
    }

    public rr_polygon(String f_name)
    {
	points = new ArrayList();
	flags = new ArrayList();
	box = new rr_box();

	BufferedReader inp;
	try
	    {
		inp =  new BufferedReader(new FileReader(new File(f_name)));
		TextReader ip = new TextReader(inp);

		rr_2point r = new rr_2point(0, 0);

		while(!ip.eof())
		    {
			r.x = ip.getDouble();
			r.y = ip.getDouble();
			this.append(r, 1);
		    }

		try
		    {
			inp.close();
		    }
		catch(IOException err)
		    {
			System.err.println("rr_polygon(String): Can't close input file - " + f_name);
		    }
	    }
	catch(IOException err)
	    {
		System.err.println("rr_polygon(String): Can't open input file - " + f_name);
	    }
    }

    // Add a new point and its flag value to the polygon

    public void append(rr_2point p, int f)
    {
	points.add(new rr_2point(p));
	flags.add(new Integer(f));
	box.expand(p);
    }

    // Put a new polygon and its flag values on the end

    public void append(rr_polygon p)
    {
	int leng = p.points.size();
	if(leng == 0)
	    return;
	for(int i = 0; i < leng; i++)
	    {
		points.add(new rr_2point((rr_2point)p.points.get(i)));
		flags.add(new Integer(((Integer)p.flags.get(i)).intValue())); 
	    }
	box.expand(p.box);
    }


    // Remove a point.
    // N.B. This does not ammend the enclosing box

    public void remove(int i)
    {
	points.remove(i);
	flags.remove(i);
    }


    // Recompute the box (sometimes useful if points have been deleted)

    public void re_box()
    {
	box = new rr_box();
	int leng = points.size();
	for(int i = 0; i < leng; i++)
	    {
		box.expand((rr_2point)points.get(i)); 
	    }
    }


    // Output the polygon in SVG XML format

    public void svg(PrintStream opf)
    {
        opf.println("<polygon points=\"");
	int leng = points.size();
	for(int i = 0; i < leng; i++)
            opf.println(Double.toString(((rr_2point)points.get(i)).x) + "," + Double.toString(((rr_2point)points.get(i)).y));
        opf.println("\" />");
    }

    // Test for a self-intersecting polygon.  If the first entry in the
    // tuple returned is 0 the polygon does not self intersect.  If it is 1
    // the next two tuple entries give the start of the line segments first
    // encountered that intersect.  There may be others.
    
    public self_x self_cross()
    {
	int k;
	int leng = points.size();

	if(leng < 4)
            return new self_x(false, 0, 0);

        for(int i = 0; i < leng; i++)
	    {
		int ip = (i + 1) % leng;
		rr_line s1 = new rr_line((rr_2point)points.get(i), (rr_2point)points.get(ip));
		int m = i + 2;
		if(i > 0)
		    k = leng;
		else
		    k = leng - 1;
		for(int j = m; j <= k; j++)
		    {
			int jp = (j + 1) % leng;
			rr_line s2 = new rr_line((rr_2point)points.get(j), (rr_2point)points.get(jp));
			try
			    {
				double t = s1.cross_t(s2);

				if (t >= 0 && t < 1)
				    {
					try
					    {
						t = s2.cross_t(s1);
						if (t >= 0 && t < 1)
						    return new self_x(true, i, j);
					    }
					catch(rr_ParallelLineException ple)
					    {
						System.err.println("self_cross: A crosses B, but B does not cross A!");
					    }
				    }
			    }
			catch (rr_ParallelLineException ple)
			    {}

		    }
	    }
	return new self_x(false, 0, 0);
    }


    // Offset a polygon to the right by d

    public rr_polygon offset(double d)
    {
	int leng = points.size();
        rr_polygon r = new rr_polygon();
        int i = leng - 1;
        for (int j = 0; j < leng; j++)
	    {
		int k = (j + 1) % leng;

		// Is the Java distinction between primitive and reference types a pain, or what?...

		rr_bisector bs = rr_line.bisect((rr_2point)points.get(i), (rr_2point)points.get(j), (rr_2point)points.get(k));
		r.append(bs.b.point(d/bs.s_angle), ((Integer)flags.get(j)).intValue());
		i = (i + 1) % leng;
	    }
        return r;
    }

    // Intersect a line with a polygon, returning an
    // unsorted list of the intersection parameters

    public List pl_intersect(rr_line l0)
    {
	int leng = points.size();
        List t = new ArrayList();
	int it = 0;
        for(int i = 0; i < leng; i++)
	    {
		int ip = (i + 1) % leng;
		rr_line l1 = new rr_line((rr_2point)points.get(i), (rr_2point)points.get(ip));
		try
		    {
			double s = l1.cross_t(l0);
			if(s >= 0 && s < 1)
			    {
				try
				    {
					s = l0.cross_t(l1);
					t.add(new Double(s));
					it++;
				    }					
				catch(rr_ParallelLineException ple)
				    {
					System.err.println("pl_intersect: A crosses B, but B does not cross A!");
				    }
			    }
		    }
		catch (rr_ParallelLineException ple)
		    {}
	    }	
	return t;
    }

    // Simplify a polygon by deleting points from it that
    // are closer than d to lines joining other points

    public rr_polygon simplify(double d)
    {
        rr_polygon r = new rr_polygon();
        int leng = points.size();
        double d2 = d*d;
	int i = 0;
	int jold = 0;
        while(i < leng - 1)
	    {
		r.append((rr_2point)points.get(i), ((Integer)(flags.get(i))).intValue());
		int j = i + 1;
		find_ignored: while (j < leng + 1)
		    {
			jold = j;
			j++;
			rr_line line = new rr_line((rr_2point)points.get(i), (rr_2point)points.get(j%leng));
			for (int k = i+1; k < j; k++)
			    {
				if (line.d_2((rr_2point)points.get(k%leng)).x > d2)
					break find_ignored;
			    }
		    }
		i = jold;
	    }
	return r;
    }

    // Take a list of parameter values and a line, sort
    // them, and turn them into a polygon.  Use the trace
    // value to flag the start of solid lines.

    public static rr_polygon rr_t_polygon(List t, rr_line line, int fg, int fs)
    {
	rr_polygon r = new rr_polygon();
	java.util.Collections.sort(t);
	int leng = t.size();
	for(int i = 0; i < leng; i = i+2)
	    {
		r.append(line.point(((Double)(t.get(i))).doubleValue()), fg);
		r.append(line.point(((Double)(t.get(i+1))).doubleValue()), fs);
	    }
	return r;
    }


    // Figure out if all polygons in a list avoid the parametric interval [0, 1)
    // in the line ln.

    public boolean no_cross(rr_line ln, rr_p_list avoid)
    {
	List t_vals = avoid.pl_intersect(ln);
	int leng = t_vals.size();
	for(int i = 0; i < leng; i++)
	    {
		double t = ((Double)(t_vals.get(i))).doubleValue();
		if(t >= 0 && t < 1)
		    return false;
	    }
	return true;
    }


    // Take a gappy polygon (as from the hatch function below)
    // and join (almost) all the ends up while avoiding the polygons in rr_p_list

    public rr_polygon join_up(rr_p_list avoid)
    {
	rr_polygon old = new rr_polygon(this);
	rr_polygon r = new rr_polygon();
	int i = 0;
	while(i < old.points.size() - 1)
	    {
		rr_2point p0 = new rr_2point((rr_2point)old.points.get(i));
	        rr_2point p1 = new rr_2point((rr_2point)old.points.get(i+1));
		int f = ((Integer)old.flags.get(i)).intValue();
		if(((Integer)old.flags.get(i+1)).intValue() != 0)
		    System.err.println("join_up: non alternating polygon.");
		old.remove(i);
		old.remove(i); // i.e. i+1...
		rr_2point p3, p_near, p_far;
		int j_near = -1;
		p_near = null;
		p_far = null;
		double d2 = box.d_2();
		int leng = old.points.size();
		for(int j = 0; j < leng; j++)
		    {
			p3 = (rr_2point)old.points.get(j);
			double d = p3.d_2(p0);
			rr_line lin;
			if(d < d2)
			    {
				lin = new rr_line(p0, p3);
				if(no_cross(lin, avoid))
				    {
					d2 = d;
					p_near = p0;
					p_far = p1;
					j_near = j;
				    }
			    }
			d = p3.d_2(p1);
			if(d < d2)
			    {
				lin = new rr_line(p1, p3);
				if(no_cross(lin, avoid))
				    {
					d2 = d;
					p_near = p1;
					p_far = p0;
					j_near = j;
				    }
			    }
		    }
		if(j_near < 0)
		    {
			r.append(p0, f);
			r.append(p1, 0);
		    } else
		    {
			int j_far;
			if(((Integer)old.flags.get(j_near)).intValue() == 0)
				j_far = (j_near + 1)%leng;
			else
			    {
				j_far = j_near - 1;
				if(j_far < 0)
				    j_far = leng - 1;
			    }
			r.append(p_far, f);
			r.append(p_near, f);
			r.append((rr_2point)old.points.get(j_near), f);
			r.append((rr_2point)old.points.get(j_far), f);
			if(j_far > j_near)
			    {
				old.remove(j_near);
				if(j_near >= old.points.size())
				    old.remove(0);
				else
				    old.remove(j_near);
			    } else
			    {
				old.remove(j_far);
				if(j_far >= old.points.size())
				    old.remove(0);
				else
				    old.remove(j_far);
			    }
		    }

		i = i + 2;
	    }
	return r;
    }
}


// List of polygons class.  This too maintains a maximum enclosing rectangle.
// Each polygon has an associated type that can be used to record any attribute
// of the polygon.

class rr_p_list
{
    public List polygons;
    public rr_box box;

    public rr_p_list()
    {
	polygons = new ArrayList();
	box = new rr_box();
    }

    public rr_p_list(rr_p_list lst)
    {
	polygons = new ArrayList();
	box = new rr_box(lst.box);
	int leng = lst.polygons.size();
	for(int i = 0; i < leng; i++)
	    polygons.add(new rr_polygon((rr_polygon)lst.polygons.get(i)));
    }

    // Add a new polygon to the list

    public void append(rr_polygon p)
    {
	if(p.points.size() == 0)
	    return;
	polygons.add(new rr_polygon(p));
	box.expand(p.box);
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

    }
    */

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



