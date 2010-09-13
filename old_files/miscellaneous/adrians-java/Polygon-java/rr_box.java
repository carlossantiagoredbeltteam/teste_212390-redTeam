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

rr_box: 2D rectangles

First version 20 May 2005
This version: 2 October 2005 (translation to Java)

*/


// A 2D box is an X and a Y interval

class rr_box
{
    public rr_interval x;
    public rr_interval y;
    private boolean empty;

    public rr_box()
    {
	empty = true;
    }

    public rr_box(rr_box b)
    {
	x = new rr_interval(b.x);
	y = new rr_interval(b.y);
        empty = b.empty;
    }


    // Expand the box to incorporate another or a point

    public void expand(rr_box a)
    {
	if(a.empty)
	    return;
	if(empty)
	    {
                empty = false;
                x = new rr_interval(a.x);
                y = new rr_interval(a.y);
	    } else
	    {
		x.expand(a.x);
		y.expand(a.y);
	    }
    }

    public void expand(rr_2point a)
    {
	if(empty)
	    {
                empty = false;
                x = new rr_interval(a.x, a.x);
                y = new rr_interval(a.y, a.y);
	    } else
	    {
		x.expand(a.x);
		y.expand(a.y);
	    }
    }

    // Corner points and center

    public rr_2point max()
    {
	return new rr_2point(x.high, y.high);
    }

    public rr_2point min()
    {
	return new rr_2point(x.low, y.low);
    }

    public rr_2point center()
    {
	return ((max().add(min()).mul(0.5)));
    }

    // Scale the box by a factor about its center
    
    public rr_box scale(double f)
    {
        rr_box r = new rr_box();
	if(empty)
	    return r;
	f = 0.5*f;
	rr_2point p = new rr_2point(x.length()*f, y.length()*f);
	rr_2point c = center();
        r.expand(c.add(p));
        r.expand(c.sub(p));
	return r;
    }

    // Convert to a string
    
    public String toString()
    {
	if(empty)
	    return "[empty]";
        return "<BOX x:" + x.toString() + ", y: " + y.toString() + ">";
    }
 

    // Squared diagonal

    public double d_2()
    {
	if(empty)
	    return 0;
	return max().d_2(min());
    }
}

