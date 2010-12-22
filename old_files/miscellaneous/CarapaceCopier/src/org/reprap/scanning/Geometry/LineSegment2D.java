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
 * Last modified by Reece Arnott 22nd December 2010
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
	
	public Line3d ConvertTo3DLine(double zvalue){
		Point3d start3d=new Point3d(start.x,start.y,zvalue);
		Point3d end3d=new Point3d(end.x,end.y,zvalue);
		return new Line3d(start3d,end3d);
	}
	
	public Point2d GetPointOnLine(double U){
		// The line can be described as start+U(end-start)
		Point2d vector=end.minusEquals(start);
		vector.scale(U);
		return start.plusEquals(vector);
	}
	public double CalculateLengthSquared(){
		return end.CalculateDistanceSquared(start);
	}
	
	public boolean Intersect(Point2d other){
		// Due to rounding errors in the calculations we will accept a point as intersecting if it is within 0.001 of the closest point on the line
		return (CalculateClosestPoint(other).isApproxEqual(other,0.001));
	}
	// This returns the intersection point x and y if there is one, otherwise it returns the start of this line segment 
	public Point2d SingleIntersectionPointBetweenStartAndEndExclusive(LineSegment2D other){
		// We want to find if 2 line segments intersect, we will exlucde an intersection if it happens at the start or end or either line and also if the two line segments are parallel
		// See http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/ for the derivation of this
		Point2d returnvalue=start.clone();
		double denominator=((other.end.y-other.start.y)*(end.x-start.x))-((other.end.x-other.start.x)*(end.y-start.y));
		if (denominator!=0){		//if the denominator is zero the two lines are parallel
			double numeratora=((other.end.x-other.start.x)*(start.y-other.start.y))-((other.end.y-other.start.y)*(start.x-other.start.x));
			double numeratorb=((end.x-start.x)*(start.y-other.start.y))-((end.y-start.y)*(start.x-other.start.x));
			double ua=numeratora/denominator;
			double ub=numeratorb/denominator;
			if ((ua>0) && (ua<1) && (ub>0) && (ub<1)) returnvalue=GetPointOnLine(ua);// Note we are excluding the start and end points themselves
		}
		return returnvalue;
	}
	public boolean Overlap(LineSegment2D other){
		double denominator=((other.end.y-other.start.y)*(end.x-start.x))-((other.end.x-other.start.x)*(end.y-start.y));
		boolean parallel=(denominator==0); // if denominator is zero lines are parallel See http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/ for the derivation of this test
		if (parallel){
			// Test the 4 combinations to see if one of the start or end points of one line segment lie on the other
			boolean overlap=CalculateClosestPoint(other.start).isEqual(other.start);
			if (!overlap) overlap=CalculateClosestPoint(other.end).isEqual(other.end);
			if (!overlap) overlap=other.CalculateClosestPoint(start).isEqual(start);
			if (!overlap) overlap=other.CalculateClosestPoint(end).isEqual(end);
			return overlap;
		}
		else return false;	
	}
	
//	 This returns the intersection point x and y if there is one, otherwise it returns the start of this line segment 
	public Point2d IntersectionPointofInfinite2DLines(LineSegment2D other){
		// We want to find if 2 line segments intersect, exluding if the two line segments are parallel
		// See http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/ for the derivation of this
		Point2d returnvalue=start.clone();
		double denominator=((other.end.y-other.start.y)*(end.x-start.x))-((other.end.x-other.start.x)*(end.y-start.y));
		if (denominator!=0){		//if the denominator is zero the two lines are parallel
			double numeratora=((other.end.x-other.start.x)*(start.y-other.start.y))-((other.end.y-other.start.y)*(start.x-other.start.x));
			double ua=numeratora/denominator;
			//double numeratorb=((end.x-start.x)*(start.y-other.start.y))-((end.y-start.y)*(start.x-other.start.x));
			//double ub=numeratorb/denominator;
			returnvalue=GetPointOnLine(ua);
		}
		return returnvalue;
	}
} // end class LineSegment
