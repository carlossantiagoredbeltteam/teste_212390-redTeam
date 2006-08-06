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
 
 RrHalfPlane: 2D planar half-spaces
 
 First version 20 May 2005
 This version: 9 March 2006
 
 */

package org.reprap.geometry.polygons;

import java.util.ArrayList;
import java.util.List;

/**
 * Small class to hold parameter/quad pairs
 * @author Adrian
 *
 */
class lineIntersection
{
	private double t;          // The line's parameter
	private RrCSGPolygon quad; // Quad containing hit plane
	
	public lineIntersection(double v, RrCSGPolygon q)
	{
		t = v;
		quad = q;
	}
	
	public double parameter() { return t; }
	public RrCSGPolygon quad() { return quad; }
}


/**
 * Class to hold and manipulate linear half-planes
 */
public class RrHalfPlane
{
	
	// The half-plane is normal*(x, y) + offset <= 0
	
	private Rr2Point normal; 
	private double offset;
	private RrLine p;  // Keep the parametric equivalent to save computing it
	private List crossings;  // List of intersections with others
	
	/**
	 * Convert a parametric line
	 * @param l
	 */
	public RrHalfPlane(RrLine l)
	{
		p = new RrLine(l);
		p.norm();
		normal = new Rr2Point(-p.direction().y(), p.direction().x());
		offset = -Rr2Point.mul(l.origin(), normal());
		crossings = new ArrayList();
	}
	
	
	/**
	 * Make one from two points on its edge
	 * @param a
	 * @param b
	 */
	public RrHalfPlane(Rr2Point a, Rr2Point b)
	{
		this(new RrLine(a, b));
	}   
	
	/**
	 * Deep copy
	 * @param a
	 */
	public RrHalfPlane(RrHalfPlane a)
	{
		normal = new Rr2Point(a.normal);
		offset = a.offset;
		p = new RrLine(a.p);
		crossings = new ArrayList(); // No point in deep copy -
		                             // No pointers would match
	}
	
	/**
	 * Get the parametric equivalent
	 * @return
	 */
	public RrLine pLine()
	{
		return p;
	}
	
	/**
	 * The number of crossings
	 * @return
	 */
	public int size()
	{
		return crossings.size();
	}
	
	/**
	 * Get the i-th crossing parameter
	 * @param i
	 * @return
	 */
	public double getParameter(int i)
	{
		return ((lineIntersection)crossings.get(i)).parameter();
	}
	
	/**
	 * i-th point from the crossing list
	 * @param i
	 * @return
	 */
	public Rr2Point getPoint(int i)
	{
		return pLine().point(getParameter(i));
	}
	
	/**
	 * Get the i-th quad
	 * @param i
	 * @return
	 */
	public RrCSGPolygon getQuad(int i)
	{
		return ((lineIntersection)crossings.get(i)).quad();
	}
	
	/**
	 * Get the i-th CSG for the plane
	 * @param i
	 * @return
	 */
	public RrCSG getCSG(int i)
	{
		RrCSGPolygon q = getQuad(i);
		if(q.csg().complexity() == 1)
			return q.csg();
		else if(q.csg().complexity() == 2)
		{
			if(q.csg().c_1().plane() == this)
				return q.csg().c_2();
			if(q.csg().c_2().plane() == this)			
				return q.csg().c_1();
			
			double t = getParameter(i);
			double v = Math.abs(q.csg().c_1().plane().value(pLine().point(t)));
			if(Math.abs(q.csg().c_2().plane().value(pLine().point(t))) < v)
				return q.csg().c_2();
			else
				return q.csg().c_1();
		}
		
		System.err.println("RrHalfPlane.getCSG(): complexity: " + q.csg().complexity());
		return RrCSG.nothing();
	}
	
	/**
	 * Get the i-th plane.
	 * @param i
	 * @return
	 */
	public RrHalfPlane getPlane(int i)
	{
		return getCSG(i).plane();
	}
	

	/**
	 * Take the sorted list of parameter values and a shape, and
	 * make sure they alternate solid/void/solid etc.  Insert
	 * duplicate parameter values if need be to ensure this,
	 * or - if two are very close - delete one. 
	 * @param t
	 * @param l0
	 */
	public void solidSet(RrCSGPolygon p)
	{
		double v;
		boolean odd = true;
		int i = 0;
		while(i < size() - 1)
		{
			double pi = getParameter(i);
			double pi1 = getParameter(i+1);
			v = 0.5*(pi + pi1);
			boolean tiny = Math.abs(pi1 - pi) < 2*Math.sqrt(p.box().d_2()); // Is this too coarse a limit?
			v = p.value(pLine().point(v));
			if(odd)
			{
				if(v > 0)
				{
					if(tiny)
						crossings.remove(i);
					else
						crossings.add(i, crossings.get(i));
				}
			} else
			{
				if(v <= 0)
				{
					if(tiny)
						crossings.remove(i);
					else
						crossings.add(i, crossings.get(i));
				}	
			}
			odd = !odd;
			i++;
		}
		if (size()%2 != 0)    // Nasty hack that seems to work...
		{
			System.err.println("RrHalfPlane.solidSet(): odd number of crossings: " +
					crossings.size());
			crossings.remove(size() - 1);
		}
	}

	
	/**
	 * Add a crossing
	 * @param p
	 * @param q
	 * @param bounds
	 * @return
	 */
	private boolean maybeAdd(RrHalfPlane p, RrCSGPolygon q, RrInterval range, boolean me)
	{	
		// Ensure no duplicates
		
		for(int i = 0; i < crossings.size(); i++)
		{
			if(getPlane(i) == p)
				return false;     // Because we've already got it
		}
		
		RrInterval newRange = q.box().wipe(pLine(), range);
		if(!newRange.empty())
			try
		{
				double v = p.cross_t(pLine());
				if(v >= newRange.low() && v < newRange.high())
				{
					if(me)
					{
						crossings.add(new lineIntersection(v, q));
						return true;						
					} else
					{
						Rr2Point x = pLine().point(v);
						double r = Math.sqrt(q.resolution2());
						double pot = q.csg().value(x);
						if(pot > -r && pot < r)
						{
							crossings.add(new lineIntersection(v, q));
							return true;
						}
					}
				}
		} catch (RrParallelLineException ple)
		{}
		return false;
	}
	
	/**
	 * Add quad q if it contains a half-plane with an 
	 * intersection with a parameter within bounds.
	 * @param q
	 * @param bounds
	 * @return
	 */
	public boolean maybeAdd(RrCSGPolygon q, RrInterval range)
	{		
		switch(q.csg().operator())
		{
		case RrCSGOp.NULL:
		case RrCSGOp.UNIVERSE:
			return false;
		
		case RrCSGOp.LEAF:
			return maybeAdd(q.csg().plane(), q, range, false);
			
		case RrCSGOp.INTERSECTION:
		case RrCSGOp.UNION:	
			if(q.csg().complexity() != 2)
			{
				System.err.println("RrHalfPlane.maybeAdd(): too complex: " + q.csg().complexity());
				return false;
			}
			RrHalfPlane p1 = q.csg().c_1().plane();
			RrHalfPlane p2 = q.csg().c_2().plane();
			if(p1 == this)
				return maybeAdd(p2, q, range, true);
			if(p2 == this)
				return maybeAdd(p1, q, range, true);
			
			boolean b = maybeAdd(p1, q, range, false); 
			b = b | maybeAdd(p2, q, range, false);
			return b;
			
		default:
			System.err.println("RrHalfPlane.maybeAdd(): invalid CSG operator!");
		}
		
		return false;
	}
	
	/**
	 * Add a crossing
	 * @param qc
	 */
	public static boolean cross(RrCSGPolygon qc)
	{		
		if(qc.corner())
		{
			RrInterval range = RrInterval.big_interval();
			boolean b = qc.csg().c_1().plane().maybeAdd(qc, range);
			range = RrInterval.big_interval();
			b = b & qc.csg().c_2().plane().maybeAdd(qc, range);
			return (b);
		}
		System.err.println("RrHalfPlane.cross(): called for non-corner!");
		return false;
	}
	
	/**
	 * Find a crossing
	 * @param q
	 * @return the index of the quad
	 */
	public int find(RrCSGPolygon q)
	{	
		for(int i = 0; i < crossings.size(); i++)
		{
			if(getQuad(i) == q)
				return i;
		}
		System.err.println("RrHalfPlane.find(): quad not found!");
		return -1;
	}
	
	/**
	 * Find the index of a crossing plane
	 * @param h
	 * @return
	 */
	public int find(RrHalfPlane h)
	{	
		for(int i = 0; i < crossings.size(); i++)
		{
			if(getPlane(i) == h)
				return i;
		}
		System.err.println("RrHalfPlane.find(): plane not found!");
		return -1;
	}
	
	/**
	 * Remove all crossings
	 * @param a
	 * @param t
	 */
	public void removeCrossings()
	{
		crossings = new ArrayList();
	}
		
	
	/**
	 * Remove a crossing from the list
	 * @param i
	 */
	public void remove(int i)
	{
		crossings.remove(i);
	}
	
	
	
	/**
	 * Sort on ascending parameter value.
	 * @param up
	 */
	public void sort(boolean up, RrCSGPolygon q)
	{
		if(up)
		{
			java.util.Collections.sort(crossings, 
					new java.util.Comparator() 
					{
				public int compare(Object a, Object b)
				{
					if(((lineIntersection)a).parameter() < 
							((lineIntersection)b).parameter())
						return -1;
					else if (((lineIntersection)a).parameter() > 
					((lineIntersection)b).parameter())
						return 1;
					return 0;
				}
					}
			);
		} else
		{
			java.util.Collections.sort(crossings, 
					new java.util.Comparator() 
					{
				public int compare(Object a, Object b)
				{
					if(((lineIntersection)a).parameter() > 
							((lineIntersection)b).parameter())
						return -1;
					else if (((lineIntersection)a).parameter() < 
					((lineIntersection)b).parameter())
						return 1;
					return 0;
				}
					}
			);
		}		
		if(crossings.size()%2 != 0)
		{
			//System.err.println("RrHalfPlane.sort(): odd number of crossings: " +
					//crossings.size());
			solidSet(q);
		}
	}
	
	
	
	/**
	 * Return the plane as a string
	 * @return
	 */
	public String toString()
	{
		return "|" + normal.toString() + ", " + Double.toString(offset) + "|";
	} 
	
	// Get the components
	
	public Rr2Point normal() { return normal; }
	public double offset() { return offset; }
	
	// TO DO: make this spot complements too.
	/**
	 * Is another line the same within a tolerance?
	 * @param a
	 * @param b
	 * @param tolerance
	 * @return
	 */
	public static boolean same(RrHalfPlane a, RrHalfPlane b, double tolerance)
	{
		if(Math.abs(a.normal.x() - b.normal.x()) > tolerance)
			return false;
		if(Math.abs(a.normal.y() - b.normal.y()) > tolerance)
			return false;
		double rms = Math.sqrt((a.offset*a.offset + b.offset*b.offset)*0.5);
		if(Math.abs(a.offset - b.offset) > tolerance*rms)
			return false;
		
		return true;
	}
	
	
	/**
	 * Change the sense
	 * @return
	 */
	public RrHalfPlane complement()
	{
		RrHalfPlane r = new RrHalfPlane(this);
		r.normal = r.normal.neg();
		r.offset = -r.offset;
		r.p = r.p.neg();
		return r;
	}
	
	/**
	 * Move
	 * @param d
	 * @return
	 */
	public RrHalfPlane offset(double d)
	{
		RrHalfPlane r = new RrHalfPlane(this);
		r.offset = r.offset - d;
		r.p = p.offset(d);
		return r;
	}
	
	
	/**
	 * Find the potential value of a point
	 * @param p
	 * @return
	 */
	public double value(Rr2Point p)
	{
		return offset + Rr2Point.mul(normal, p);
	}
	
	
	/**
	 * Find the potential interval of a box
	 * @param b
	 * @return
	 */
	public RrInterval value(RrBox b)
	{
		return RrInterval.add(RrInterval.add((RrInterval.mul(b.x(), normal.x())), 
				(RrInterval.mul(b.y(), normal.y()))), offset);
	}
	
	/**
	 * The point where another line crosses
	 * @param a
	 * @return
	 * @throws RrParallelLineException
	 */
	public Rr2Point cross_point(RrHalfPlane a) throws RrParallelLineException
	{
		double det = Rr2Point.op(normal, a.normal);
		if(det == 0)
			throw new RrParallelLineException("cross_point: parallel lines.");
		det = 1/det;
		double x = normal.y()*a.offset - a.normal.y()*offset;
		double y = a.normal.x()*offset - normal.x()*a.offset;
		return new Rr2Point(x*det, y*det);
	}
	
	/**
	 * Parameter value where a line crosses
	 * @param a
	 * @return
	 * @throws RrParallelLineException
	 */
	public double cross_t(RrLine a) throws RrParallelLineException 
	{
		double det = Rr2Point.mul(a.direction(), normal);
		if (det == 0)
			throw new RrParallelLineException("cross_t: parallel lines.");  
		return -value(a.origin())/det;
	}
	
	/**
	 * Point where a parametric line crosses
	 * @param a
	 * @return
	 * @throws RrParallelLineException
	 */
	public Rr2Point cross_point(RrLine a) throws RrParallelLineException
	{
		return a.point(cross_t(a));
	}
	
	/**
	 * Take a range of parameter values and a line, and find
	 * the intersection of that range with the part of the line
	 * (if any) on the solid side of the half-plane.
	 * @param a
	 * @param range
	 * @return
	 */
	public RrInterval wipe(RrLine a, RrInterval range)
	{
		if(range.empty()) return range;
		
		// Which way is the line pointing relative to our normal?
		
		boolean wipe_down = (Rr2Point.mul(a.direction(), normal) >= 0);
		
		double t;
		
		try
		{
			t = cross_t(a);
			if (t >= range.high())
			{
				if(wipe_down)
					return range;
				else
					return new RrInterval();
			} else if (t <= range.low())
			{
				if(wipe_down)
					return new RrInterval();
				else
					return range;                
			} else
			{
				if(wipe_down)
					return new RrInterval(range.low(), t);
				else
					return new RrInterval(t, range.high());                 
			}
		} catch (RrParallelLineException ple)
		{
			t = value(a.origin());
			if(t <= 0)
				return range;
			else
				return new RrInterval();  
		}
	}
}
