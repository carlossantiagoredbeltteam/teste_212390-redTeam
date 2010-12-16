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
 * Last modified by Reece Arnott 8th December 2010
 * 
 * Note that some formulae that traditionally use pi have been replaced to use tau where tau is defined as 2*pi. For an explanation of why this may make things clearer see That Tau Manifesto available at http://tauday.com/
 * 
 *********************************************************************************/
import Jama.*;

public class Point2d
{
	private final static double tau=Math.PI*2;
	public double x, y;
	// constructors
	public Point2d(double newX,double newY) {x = newX; y = newY; }
	public Point2d(Matrix M){ x=0;y=0; ApplyTransform(M);}
	// Operations on internal components
	public void scale(double s)
	{ x=x*s;y=y*s; }
	public Point2d timesEquals(double n)
	{ return new Point2d(n*x,n*y); }
	public Point2d plusEquals(Point2d v)
	{ return new Point2d(x + v.x, y + v.y); }
	public void plus(Point2d v)
		{ x=x+v.x;y=y+v.y; }
	public void minus(Point2d v)
		{ x=x-v.x;y=y-v.y; }
	public Point2d minusEquals(Point2d v)
	{ return new Point2d(x - v.x, y - v.y); }

	public double  dot(Point2d v)
		{ return (x * v.x + y * v.y); }
	public double  crossLength(Point2d v)
		{ return Math.abs(x * v.y - y * v.x); }
	public	double  lengthSquared()
		{ return (x *x + y *y); }
	public Point2d clone(){
		Point2d returnvalue=new Point2d(x,y);
		return returnvalue;
		}
	public Point3d ExportAs3DPoint(double z){
		return new Point3d(x,y,z);
	}
	public double CalculateDistanceSquared(Point2d other){
		return (((x-other.x)*(x-other.x))+((y-other.y)*(y-other.y)));
		}
	public boolean isCollinear(Point2d x0, Point2d x1){
		LineSegment2D a=new LineSegment2D(this,x0);
		LineSegment2D b=new LineSegment2D(this,x1);
		LineSegment2D c=new LineSegment2D(x0,x1);
		return (a.Intersect(x1) || b.Intersect(x0) || c.Intersect(this));
	}
	//returns the angle in radians between two points measured anticlockwise from the positive x axis
	public double GetAngleMeasuredClockwiseFromPositiveX(Point2d C){
		// If B is this point,  C is the parameter point, and A is the constructed point with the x coordinate of the B and the y coordinate of C
		// This forms a right angle triangle with the angle we want at B. However this cannot be done in the special case of C being directly above or below B i.e. angle is 90 or 270 degrees
		
		double angle;
		if (C.x==x) angle=tau/4; // set the angle to 90 degrees
		else {
			// So first figure out the angle b, using standard trig this is cos(b)=BA/BC=abs(B.x-C-x)/BC
			double cosineangle=Math.abs(x-C.x)/Math.sqrt(CalculateDistanceSquared(C));
			// get the arc-cos of the angle using Math.acos which gives an answer between 0 and 180 degrees (0-pi radians) but in this case it will only be between 0 and 90 degrees;
			angle=Math.acos(cosineangle);
		}
		// If point B is to the right of point C, adjust the angle to take this into account so that it is in the 90-180 degree range
		if (x>C.x) angle=(tau/2)-angle;
		// If point B is below point C adjust to  take this into account so that it is in the range 180-360 degrees
		if (y<C.y) angle=tau-angle;
		return angle;
	}
	
	// This is a less computationally intensive method than the one above when all you want to know is which one of eight directions the other point lies in.
	public int GetOctant(Point2d C){
		// If B is this point,  C is the parameter point, and A is the constructed point with the x coordinate of the B and the y coordinate of C
		// This forms a right angle triangle with the angle we want at B. However this cannot be done in the special case of C being directly above or below B i.e. angle is 90 or 270 degrees
		int octant; // octant 0 is 0-45, 1 is 46-90 degrees etc.
		if (C.x==x) octant=1; // set the angle to 90 degrees
		else {
			// So first figure out the angle b, and whether or not it is greater than 45 degrees 
			// cos(b)=BA/BC=abs(B.x-C-x)/BC 
			// As cos(45degrees)=1/sqrt(2) (going from 1 at 0 to 0 at 90 degrees) so squaring this we get 1/2
			// Division is more work than multiplication as a general rule so...
			double BA=x-C.x;
			double BAsquaredtimes2=BA*BA*2;
			double BCsquared=CalculateDistanceSquared(C);
			if (BAsquaredtimes2<=BCsquared) octant=1;
			else octant=0;
		}
		// If point B is to the right of point C, adjust to take this into account so that it is in the 90-180 degree range
		if (x>C.x) octant=3-octant;
		// If point B is below point C adjust to take this into account so that it is in the range 180-360 degrees
		if (y<C.y) octant=7-octant;
		return octant;
		
	}
	
	// Note that this assumes the angle is in radians and distance is positive
	public Point2d GetOtherPoint(double angle, double distance){
		Point2d returnvalue;
		// Adjust angle so it is within 0 and 2 pi
		// adjust if it is negative
		angle=angle%tau; // This isn't actually a mod function, it is a remainder so can give a negative number
		if (angle<0) angle=tau+angle;
		
		// Construct a line of the form y=mx+c that crosses the current point.
		// m is directly calculated as tan(angle)
		// Note that there is a special case where the angle is exactly 90 or 270 degrees
		if (angle==(tau*0.25)) returnvalue=new Point2d(x,y+distance);
		else if (angle==(tau*0.75)) returnvalue=new Point2d(x,y-distance);
		else {
			double m=Math.tan(angle);
			// Use the point to find the constant c in the equation
			// rearranging gives c=y-mx
			double c=y-(m*x);
			// now distance^2=deltax^2+deltay^2 or distance^2=(m^2+1)deltax^2 (as deltay^2=m^2deltax^2 from y=mx+c)
			// so deltax=sqrt(distance^2/(m^2+1))
			double deltax=Math.sqrt((distance*distance)/(1+(m*m)));
			// If the angle is between 90 and 270 degrees then deltax is negative
			if ((angle>(tau*0.25)) && (angle<(tau*0.75))) deltax=deltax*-1;
			
			double newx=x+deltax;
			double newy=(m*newx)+c;
			returnvalue=new Point2d(newx,newy);
		}
		return returnvalue;
	}
	
	public boolean isNearCollinear(Point2d x0, Point2d x1, double coslimit){
		//cosine rule: b^2=a^2+c^2-2ac*cosB or CosB=(a^2+c^2-b^2)/2ac
		// where a,b,c are lengths of the lines joining the 3 points.
		double asquared=CalculateDistanceSquared(x0);
		double bsquared=CalculateDistanceSquared(x1);
		double csquared=x0.CalculateDistanceSquared(x1);
		// If there is an obtuse angle it will be opposite the longest side so if a or c are the longest side, swap them with b.
		if (asquared>bsquared) {
			double temp=bsquared;
			bsquared=asquared;
			asquared=temp;
		}
		if (csquared>bsquared) {
			double temp=bsquared;
			bsquared=csquared;
			csquared=temp;
		}
		double cosb=(asquared+csquared-bsquared)/Math.sqrt(4*asquared*csquared);
		return (cosb<=coslimit);
	}
	
	public boolean isEqual(Point2d v){
		return ((x==v.x) && (y==v.y));
	}
	// Due to rounding errors in the calculations we will accept a point as intersecting if it is within a threshold in the x and y directions
	public boolean isApproxEqual(Point2d v, double threshold){
		double dx=Math.abs(x-v.x);
		double dy=Math.abs(y-v.y);
		return ((dx<threshold) && (dy<threshold));
	}	
	public boolean ApplyTransform(Matrix M){
		int columns=M.getColumnDimension();
		int rows=M.getRowDimension();
		boolean success=false;
		// If there is only one column or one row assume that it simply a vector addition
		if (columns==1){
			if (rows==2) {
				x=x+M.get(0,0);
				y=y+M.get(1,0);
				success=true;
			}
			if (rows==3){
				x=x+(M.get(0,0)/M.get(2,0));
				y=y+(M.get(1,0)/M.get(2,0));
				success=true;
			}
		}
		if (rows==1){
			if (columns==2) {
				x=x+M.get(0,0);
				y=y+M.get(0,1);
				success=true;
			}
			if (columns==3){
				x=x+(M.get(0,0)/M.get(0,2));
				y=y+(M.get(0,1)/M.get(0,2));
				success=true;
			}
		}
		// Otherwise assume it is a right-multiplication i.e. x'=Mx where x is the old Point2d and x' is the new one
		// Automatically use either homogeneous or inhomogeneous coordinates depending on number of rows and columns
		if (columns==2){
			Matrix coord=new Matrix(2,1);
			coord.set(0,0,x);
			coord.set(1,0,y);
			coord=M.times(coord);
			if ((rows==2) || (rows==3)){
				x=coord.get(0,0);
				y=coord.get(1,0);
				success=true;
				if (rows==3){
					x=x/coord.get(2,0);
					y=y/coord.get(2,0);
				}
			}
		}
		if (columns==3){
			Matrix coord=new Matrix(3,1);
			coord.set(0,0,x);
			coord.set(1,0,y);
			coord.set(2,0,1);
			if ((rows==2) || (rows==3)){
				coord=M.times(coord);
				x=coord.get(0,0);
				y=coord.get(1,0);
				success=true;
				if (rows==3){
					x=x/coord.get(2,0);
					y=y/coord.get(2,0);
				}
			}
		}
		return success;
	} // end of ApplyTransform method
	
	public Matrix ConvertPointTo2x1Matrix(){
		Matrix p=new Matrix(2,1);
		p.set(0,0,x);
		p.set(1,0,y);
		return p;
	}
	
	public Matrix ConvertPointTo3x1Matrix(){
		Matrix p=new Matrix(3,1);
		p.set(0,0,x);
		p.set(1,0,y);
		p.set(2,0,1);
		return p;
	}
	
	
	
	public void print(){
		System.out.print("("+x+","+y+")");
	}
} // end Point2d Class
