package org.reprap.scanning.Geometry;

/******************************************************************************
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 * 
 * The license can be found on the WWW at: http://www.fsf.org/copyleft/gpl.html
 * 
 * Or by writing to: Free Software Foundation, Inc., 59 Temple Place - Suite
 * 330, Boston, MA 02111-1307, USA.
 *  
 * 
 * If you make changes you think others would like, please contact one of the
 * authors or someone at the reprap.org web site.
 * 
 * 				Author list
 * 				===========
 * 
 * Reece Arnott	reece.arnott@gmail.com
 * 
 * Last modified by Reece Arnott 22nd Feburary 2010
 *
 *****************************************************************************/


public class LineSegment2D {
	public Point2d start;   
	public Point2d end;
	
	//Constructor
		public LineSegment2D(Point2d x0, Point2d x1){
		start=x0.clone();
		end=x1.clone();
	} // end Constructor


	public LineSegment2D clone(){
		LineSegment2D returnvalue=new LineSegment2D(start,end);
		return returnvalue;
	}

	public Point2d CalculateClosestPoint(Point2d other){
		// The line can be described as start+U(end-start) so we want to find U and then substitute it in. Note can't solve if start and end are the same point but in that case the closest point is the start/end point
		Point2d returnvalue=start.clone();
		if (CalculateLengthSquared()!=0){
			// See http://local.wasp.uwa.edu.au/~pbourke/geometry/pointline/ for the derivation of this equation
			double u=(((other.x-start.x)*(end.x-start.x))+((other.y-start.y)*(end.y-start.y)))/CalculateLengthSquared();
			if (u<0) u=0;
			if (u>1) u=1;
			returnvalue.x=start.x+u*(end.x-start.x);
			returnvalue.y=start.y+u*(end.y-start.y);
		}
		return returnvalue;
	}
	public Point2d GetPointOnLine(double U){
		// The line can be described as start+U(end-start)
		Point2d vector=end.minusEquals(start);
		vector.timesEquals(U);
		return start.plusEquals(vector);
	}
public double CalculateLengthSquared(){
		return end.CalculateDistanceSquared(start);
	}
	
	public boolean Intersect(Point2d other){
		// Due to rounding errors in the calculations we will accept a point as intersecting if it is within 0.001 of the closest point on the line
		return (CalculateClosestPoint(other).isApproxEqual(other,0.001));
	}
	
} // end class LineSegment
