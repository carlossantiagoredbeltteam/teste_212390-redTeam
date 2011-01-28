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
* Last modified by Reece Arnott 26th January 2011
*
*	This class stores a triangluar face which may be part of 0,1 or 2 tetrahedrons.
*	A triangular face is 3 vertices a,b,c and potentially 0,1, or 2 other points relating 
*   to the tetrahedrons that it is a face for. These are stored as simple indexes to a Point3d array.
* 
*	
* 
***********************************************************************************/
import org.reprap.scanning.DataStructures.QuickSortScalarDouble;


public class Triangle3D {
	private int a;
	private int b;
	private int c;
	public Point3d normal; // can be calculated to be specifically pointing away from a point
	public double normaldota;//Just here so don't have to recalculate each time.
	public long hashvalue; // This is not set by default. It needs a call to the SetHash method with the maximum index that will be used in a,b, or c.
	// Constructors
	public Triangle3D(int pointa, int pointb, int pointc, Point3d[] p){
		// Store the face as unsorted points - note that have to sort the points when calculating hashvalue if we do this
		a=pointa;
		b=pointb;
		c=pointc;
		CalculateNormalAwayFromPoint(p,p[a]); // pick a random normal direction
	}
	public Triangle3D(int pointa, int pointb, int pointc, Point3d[] p, Point3d normalvector){
		// Store the face as unsorted points - note that have to sort the points when calculating hashvalue if we do this
		a=pointa;
		b=pointb;
		c=pointc;
		normal=normalvector.clone();
		normal=normalvector.times(Math.sqrt(normalvector.lengthSquared()));
		normaldota=normal.dot(p[a]);
	}
	// Construct a null face - can be detected using IsNull method
	public Triangle3D(){
		a=-1;
		b=-1;
		c=-1;
		normaldota=0;
		normal=new Point3d();
	}
	
	public Triangle3D clone(){
		Triangle3D returnvalue=new Triangle3D();
		returnvalue.a=a;
		returnvalue.b=b;
		returnvalue.c=c;
		returnvalue.normaldota=normaldota;
		returnvalue.normal=normal.clone();
		returnvalue.hashvalue=hashvalue;
		return returnvalue;
	}
//	TODO delete when not needed
	/*
	public double getArea(Point3d[] P){
		// Using Herons formula A=sqrt(p(p-a)(p-b)(p-c)) where a,b,c are the lengths of the sides of the triangle and p is half the perimeter i.e. (a+b+c)/2
		double ab=Math.sqrt(P[b].minus(P[a]).lengthSquared());
		double bc=Math.sqrt(P[c].minus(P[b]).lengthSquared());
		double ac=Math.sqrt(P[c].minus(P[a]).lengthSquared());
		double p=(ab+ac+bc)/2;
		return (Math.sqrt(p*(p-ac)*(p-bc)*(p-ac)));
	}
	public Point3d GetPointA(Point3d[] P){
		Point3d returnvalue=new Point3d();
		if ((a>=0) && (a<P.length)) returnvalue=P[a].clone();
		return returnvalue;
	}
	public Point3d GetPointB(Point3d[] P){
		Point3d returnvalue=new Point3d();
		if ((b>=0) && (b<P.length)) returnvalue=P[b].clone();
		return returnvalue;
	}
	public Point3d GetPointC(Point3d[] P){
		Point3d returnvalue=new Point3d();
		if ((c>=0) && (c<P.length)) returnvalue=P[c].clone();
		return returnvalue;
	}
	*/
	public boolean TriangleEqual(Triangle3D other){
		// This just checks that the  3 vertices of the triangle are the same, but they may not be in the same order etc.
		int count=0;
		int i;
		i=other.a; if ((a==i) || (b==i) || (c==i)) count++;
		i=other.b; if ((a==i) || (b==i) || (c==i)) count++;
		i=other.c; if ((a==i) || (b==i) || (c==i)) count++;
		return (count==3);
		
	}

	public boolean IsNull(){
		return ((a==-1) && (b==-1) && (c==-1));
	}
	
	public boolean IncludesPoint(int i){
		return ((a==i) || (b==i) || (c==i));
	}
	
	// Note this only gives a meaningful answer if the face is connected to one and only one tetrahedron
	// If there are none or two tetrahedrons then the concept of dividing the space into inside and outside along the plane of this face triangle is meaningless 
	// but it can still be used to compare two points and see if they are on the same side of the triangular face plane if the normal has previously been calculated. 
	public boolean InsideHalfspace(Point3d p){
		return (normal.dot(p)<normaldota);
	}
		
	
	public int[] GetFace(){
		int[] returnvalue=new int[3];
		returnvalue[0]=a;
		returnvalue[1]=b;
		returnvalue[2]=c;
		return returnvalue;
	}
	
	// Mainly used in OrderedListTriangularFace but also used in DeWall3D in a couple of places and in TrianglePlusVertexArray
	public void SetHash(int n){
		//Note that due to the storage limitations of long and the way the hash value is calculated this gives a unique hashvalue when n<2^21 (and a,b. and c are all less than n)
		//			 Quicksort the points
			QuickSortScalarDouble qsort=new QuickSortScalarDouble(a,b,c);
			double[] points=qsort.SortAndReturn();
			hashvalue=((long)points[0]*n*n)+((long)points[1]*n)+(long)points[2];
		} // end of method
	
	public void CalculateNormalAwayFromPoint(Point3d[] p, Point3d other){
		// The normal to the plane will be ABxAC, we want to have normal.A as well 
		Point3d AB=p[b].minus(p[a]);
		Point3d AC=p[c].minus(p[a]);
		normal=AB.crossProduct(AC);
		normal=normal.times(1/Math.sqrt(normal.lengthSquared())); // the normal should be of unit length
		normaldota=normal.dot(p[a]);
		// Flip the normal if it is pointing towards the other point
			if (normal.dot(other)>normaldota) {
				// flip the normal
				normal=normal.times(-1);
				normaldota=normal.dot(p[a]);
			}
	}
	
	public void print(){
		System.out.print(" ["+a+" "+b+" "+c+"] hashvalue="+hashvalue);
	}
	// Used in TrianglePlusVertexArray class for PurgeIrreleventVertices and MergeAndReturn methods
	public void ChangeTriangle(int pointa, int pointb, int pointc){
		a=pointa;
		b=pointb;
		c=pointc;
	}
} // end of class



