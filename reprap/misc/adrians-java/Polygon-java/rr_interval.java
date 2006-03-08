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

rr_interval: 1D intervals

First version 20 May 2005
This version: 7 March 2006

*/

// Real intervals

class rr_interval
{
    public double low;
    public double high;
    private boolean empty;

    public rr_interval()
    {
	empty = true;
    }

    // Two ends...

    public rr_interval(double l, double h)
    {
	low = l;
	high = h;
	empty = (low > high);
	if(empty)
	    System.err.println("rr_interval: low value bigger than high.");
    }

    // Deep copy

    public rr_interval(rr_interval i)
    {
	low = i.low;
	high = i.high;
	empty = i.empty;
    }

    // Convert to a string
    
    public String toString()
    {
	if(empty)
	    return "[empty]";
        return "[" + Double.toString(low) + ", " + Double.toString(high) + "]";
    }


    // Accomodate v

    public void expand(double v)
    {
	if(empty)
	    {
		low = v;
		high = v;
	    } else
	    {
		if(v < low)
		    low = v;
		if(v > high)
		    high = v;
	    }
    }

    // Accommodate another interval

    public void expand(rr_interval i)
    {
	expand(i.low);
	expand(i.high);
    }

    // Size

    public double length()
    {
	return high - low;
    }


    // Interval addition

    public rr_interval add(rr_interval a)
    {
	if(a.empty || empty)
	    System.err.println("add(...): adding empty interval(s).");	    
	return new rr_interval(a.low + low, a.high + high);
    }

    public rr_interval add(double b)
    {
	if(empty)
	    System.err.println("add(...): adding an empty interval.");	    
	return new rr_interval(low + b, high + b);
    }


    // Interval subtraction

    public rr_interval sub(rr_interval a)
    {
	if(a.empty || empty)
	    System.err.println("difference(...): subtracting empty interval(s).");
	return new rr_interval(low - a.high, high - a.low);
    }

    public rr_interval sub(double b)
    {
	if(empty)
	    System.err.println("difference(...): subtracting an empty interval.");
	return new rr_interval(low - b, high - b);
    }

    // Interval multiplication

    public rr_interval mul(rr_interval a)
    {
	if(a.empty || empty)
	    System.err.println("multiply(...): multiplying empty intervals.");
	double d = a.low*low;
	rr_interval r = new rr_interval(d, d);
	r.expand(a.low*high);
	r.expand(a.high*low);
	r.expand(a.high*high);
	return r;
    }

    public rr_interval mul(double f)
    {
	if(empty)
	    System.err.println("multiply(...): multiplying an empty interval.");
	if(f > 0)
	    return new rr_interval(low*f, high*f);
	else
	    return new rr_interval(high*f, low*f);	    
    }

    // Negative, zero, or positive?

    public boolean neg()
    {
	return high <= 0;
    }

    public boolean pos()
    {
	return low > 0;
    }

    // Does the interval _contain_ zero?

    public boolean zero()
    {
	return(!neg() && !pos());
    }

    // Absolute value of an interval

    public rr_interval abs()
    {
	rr_interval result = new rr_interval(this);
        double p;

        if (low < 0)
	    {
                if (high <= 0)
		    {
			result = new rr_interval(-high, -low);
		    } else
		    {
                        result = new rr_interval(0, result.high);
			p = -low;
                        if ( p > high ) result = new rr_interval(result.low, p);
		    }
	    }
        return(result);
    }

    // Sign of an interval
/*
    public rr_interval sign()
    {
        return( new rr_interval(sign(low), sign(high)) );
    }
*/
    // Max and min

    public rr_interval max(rr_interval a, rr_interval b)
    {
	rr_interval result = new rr_interval(b);
        if (a.low > b.low) result = new rr_interval(a.low, result.high);
        if (a.high > b.high) result = new rr_interval(result.low, a.high);
        return(result);
    }

    public rr_interval min(rr_interval a, rr_interval b)
    {
	rr_interval result = new rr_interval(b);
        if (a.low < b.low) result = new rr_interval(a.low, result.high);
        if (a.high < b.high) result = new rr_interval(result.low, a.high);
        return(result);
    }
}
