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
* Last modified by Reece Arnott 13th December 2010
* 
* Note that this encapsulates a line, a ray, and a line segment in the same class.
* 
* A line can be described as P+Vt where P is a point on the line, V is a vector in the direction of the line and t is a variable parameter
* For a line segment t is restricted to the values between 0 and 1.
* For a ray t is restricted to non-negative values.
* 
* 
************************************************************************************/
import org.reprap.scanning.DataStructures.MatrixManipulations;

import Jama.Matrix;

public class Line3d {
	public Point3d P;
	public Point3d V; // This is a vector not a point
	// Constructors
	public Line3d(){ 
		P=new Point3d();
		V=new Point3d();
	}
	// Note this constructor has been changed from what it was originally. It does not take a point and vector but two points and calculates the vector from them.
	// As the point and vector are both Point3d it would be easy to make a mistake!
	public Line3d(Point3d p1, Point3d p2){
		P=p1.clone();
		V=p2.clone();
		V.minusEquals(p1);
		
	}
	
	// Construct a line from a point and the matrix describing the camera position etc.
	//	 The camera centre and the inverse of P are passed in as parameters so they doesn't need to be calculated each time
	public Line3d( Point3d C,Matrix Pplus, Point2d point){
//		 first convert point to a 3x1 matrix x
		Matrix x=new Matrix(3,1);
		x.set(0,0,point.x);
		x.set(1,0,point.y);
		x.set(2,0,1);
		// we know two points on the ray, P+x (P+ is the pseudo inverse of P) and C the camera centre i.e. where PC=0
		// so use them
		Point3d Pplusx=new Point3d(Pplus.times(x));
		P=Pplusx.clone();
		V=C.clone();
	}
	// Same as the constructor above except that the camera centre and pseudo-inverse of P are calculated on the fly
	// Construct a line from a point and the matrix describing the camera position etc.
	public Line3d(Matrix p, Point2d point){
		Point3d C=new Point3d(MatrixManipulations.GetRightNullSpace(p));
		Matrix Pplus=MatrixManipulations.PseudoInverse(p);
//		 first convert point to a 3x1 matrix x
		Matrix x=new Matrix(3,1);
		x.set(0,0,point.x);
		x.set(1,0,point.y);
		x.set(2,0,1);
		// we know two points on the ray, P+x (P+ is the pseudo inverse of P) and C the camera centre i.e. where PC=0
		// so use them
		Point3d Pplusx=new Point3d(Pplus.times(x));
		P=Pplusx.clone();
		V=C.clone();
	}
	
	public Line3d clone(){
		Line3d returnvalue=new Line3d();
		returnvalue.resetPandV(P,V);
		return returnvalue;
	}
//	 This method, in conjunction with the empty constructor is used so that the P point and V vector can be set rather than have to have 2 points. 
	public void resetPandV(Point3d p, Point3d v){
		P=p.clone();
		V=v.clone();
	}
	
	public Point3d GetPointonLine(double parameter){
		return P.plus(V.times(parameter));
	}
	
}
