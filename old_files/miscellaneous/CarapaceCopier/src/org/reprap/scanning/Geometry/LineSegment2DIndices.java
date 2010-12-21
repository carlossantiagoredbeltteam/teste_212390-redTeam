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
* Last modified by Reece Arnott 21st December 2010
*
*	This class stores a 2d line segment face which may be part of 0,1 or 2 triangles.
*	with the start and end points simple indexes to a Point2d array.
* 
*
* This was a copy of the Triangle3D class as at 21st Decemeber and changed from 3 3d points to 2 2d points. 
* 
***********************************************************************************/


public class LineSegment2DIndices {
	private int a;
	private int b;
	public Point2d normal; // This is the normal vector perpindicular to the represented line segment. It can be calculated to be pointing away from a particular point
	public double normaldota;//Just here so don't have to recalculate each time.
	public long hashvalue; // This is not set by default. It needs a call to the SetHash method with the maximum index that will be used in a,b, or c.
	// Constructors
	public LineSegment2DIndices(int pointa, int pointb, Point2d[] p){
		// Store the face as unsorted points - note that have to sort the points when calculating hashvalue if we do this
		a=pointa;
		b=pointb;
		CalculateNormalAwayFromPoint(p,p[a]); // pick a random normal direction
	}
	
	// Construct a null face - can be detected using IsNull method
	public LineSegment2DIndices(){
		a=-1;
		b=-1;
		normaldota=0;
		normal=new Point2d();
	}
	public LineSegment2D ConvertToLineSegment(Point2d[] p){
		return new LineSegment2D(p[a],p[b]);
	}
	public LineSegment2DIndices clone(){
		LineSegment2DIndices returnvalue=new LineSegment2DIndices();
		returnvalue.a=a;
		returnvalue.b=b;
		returnvalue.normaldota=normaldota;
		returnvalue.normal=normal.clone();
		returnvalue.hashvalue=hashvalue;
		return returnvalue;
	}
	public Point2d GetPointOnLine(Point2d[]p, double U){
		// The line can be described as start+U(end-start)
		Point2d vector=p[b].minusEquals(p[a]);
		vector.scale(U);
		return p[a].plusEquals(vector);
	}
	public boolean LineSegmentEqual(LineSegment2DIndices other){
		// This just checks that the  3 vertices of the triangle are the same, but they may not be in the same order etc.
		int count=0;
		int i;
		i=other.a; if ((a==i) || (b==i)) count++;
		i=other.b; if ((a==i) || (b==i)) count++;
		return (count==2);
	}

	public boolean IsNull(){
		return ((a==-1) && (b==-1));
	}
	
	public boolean IncludesPoint(int i){
		return ((a==i) || (b==i));
	}
	
	
	// Note this only gives a meaningful answer if the line segment is connected to one and only one triangle
	// If there are none or two triangles then the concept of dividing the space into inside and outside along the plane of this face triangle is meaningless 
	// but it can still be used to compare two points and see if they are on the same side of the triangular face plane if the normal has previously been calculated. 
	public boolean InsideHalfspace(Point2d p){
		return (normal.dot(p)<normaldota);
	}
		
	
	public int[] GetFace(){
		int[] returnvalue=new int[3];
		returnvalue[0]=a;
		returnvalue[1]=b;
		return returnvalue;
	}
	
	// Mainly used in OrderedListTriangularFace but also used in DeWall3D in a couple of places and in TrianglePlusVertexArray
	public void SetHash(int n){
		//Note that due to the storage limitations of long and the way the hash value is calculated this gives a unique hashvalue when n<2^21 (and a,b. and c are all less than n)
		if (a<b) hashvalue=((long)a*n)+(long)b;
		else hashvalue=((long)b*n)+(long)a;
	} // end of method
	
	public void CalculateNormalAwayFromPoint(Point2d[] p, Point2d other){
		// The normal to the line is calculated very simply 
		// dx=x2-x1 and dy=y2-y1, then the normals are (-dy, dx) and (dy, -dx).
		Point2d dxdy=p[b].minusEquals(p[a]);
		normal=new Point2d(-dxdy.y,dxdy.x);
		normal=normal.timesEquals(1/Math.sqrt(normal.lengthSquared())); // the normal should be of unit length
		normaldota=normal.dot(p[a]);
		// Flip the normal if it is pointing towards the other point
			if (normal.dot(other)>normaldota) {
				// flip the normal
				normal.scale(-1);
				normaldota=normal.dot(p[a]);
			}
	}
	
	public void print(){
		System.out.print(" ["+a+" "+b+"] hashvalue="+hashvalue);
	}
	// Used in TrianglePlusVertexArray class for PurgeIrreleventVertices and MergeAndReturn methods
	public void ChangeLineSegment(int pointa, int pointb){
		a=pointa;
		b=pointb;
	}
} // end of class
