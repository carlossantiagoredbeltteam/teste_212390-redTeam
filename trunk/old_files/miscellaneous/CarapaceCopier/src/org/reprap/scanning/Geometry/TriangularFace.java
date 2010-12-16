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
* Last modified by Reece Arnott 3rd August 2010
*
*	This class stores a triangluar face which may be part of 0,1 or 2 tetrahedrons.
*	A triangular face is 3 vertices a,b,c and potentially 0,1, or 2 other points relating 
*   to the tetrahedrons that it is a face for. These are stored as simple indexes to a Point3d array.
* 
*	
* 
***********************************************************************************/
import org.reprap.scanning.DataStructures.QuickSortScalarDouble;


public class TriangularFace {
	private int a;
	private int b;
	private int c;
	private int d1; // This may contain a negative number which indicates whether the tetrahedron isn't known or if it is known to not exist. 
	private int d2; // This may contain a negative number which indicates whether the tetrahedron isn't known or if it is known to not exist.
	// -1 means Null i.e. that tetrahedron doesn't currently exist
	// -2 means that the tetrahedron in that half space has been tested for and is known to not exist i.e. it is invalid 
	public Point3d normal; // If there is only one tetrahedron, the normal is oriented in such a way as it is pointing away from the fourth point otherwise it doesn't really matter
	public double normaldota;//Just here so don't have to recalculate each time.
	public long hashvalue; // This is not set by default. It needs a call to the SetHash method with the maximum index that will be used in a,b, or c.
	// Constructors
	public TriangularFace(int pointa, int pointb, int pointc){
		// Store the face as unsorted points - note that have to sort the points when calculating hashvalue if we do this
		a=pointa;
		b=pointb;
		c=pointc;
		d1=-1;
		d2=-1;
		normaldota=0;
		normal=new Point3d();
		resetHash();
	}
	// Construct a null face - can be detected using IsNull method
	public TriangularFace(){
		a=-1;
		b=-1;
		c=-1;
		d1=-1;
		d2=-1;
		normaldota=0;
		normal=new Point3d();
		resetHash();
	}
	
	// This is the only constructor that sets the normal and orients it so it is pointing away from the fourth point
	public TriangularFace(int pointa, int pointb, int pointc, int pointd, Point3d[] p){
		// Store the face as unsorted points - note that have to sort the points when calculating hashvalue if we do this
		a=pointa;
		b=pointb;
		c=pointc;
	
		d1=pointd;
		d2=-1;
		resetHash();
		CalculateNormal(p);	
	}
	
	public TriangularFace clone(){
		TriangularFace returnvalue=new TriangularFace(a,b,c);
		returnvalue.d1=d1;
		returnvalue.d2=d2;
		returnvalue.normaldota=normaldota;
		returnvalue.normal=normal.clone();
		returnvalue.hashvalue=hashvalue;
		return returnvalue;
	}
	
	public boolean TriangleEqual(TriangularFace other){
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
	
	
	public boolean IncludesPointinTetrahedron(int i){
		return ((a==i) || (b==i) || (c==i) || (d1==i) || (d2==i));
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
	
	public boolean FaceTestedForMultipleTetrahedrons(){
		return ((d1!=-1) && (d2!=-1));
	}
	public void SetFaceTestedForMultipleTetrahedrons(){
		if (d1<0) d1=-2;
		if (d2<0) d2=-2;
	}
	
	
	public void SetFirstTetrahedronInvalid(){
		d1=-2;
	}
	public void SetSecondTetrahedronInvalid(){
		d2=-2;
	}
	public boolean GetFirstTetrahedronInvalid(){
		return (d1==-2);
	}
	public boolean GetSecondTetrahedronInvalid(){
		return (d2==-2);
	}
	public void SetFirstTetrahedronNull(){
		d1=-1;
	}
	public void SetSecondTetrahedronNull(){
		d2=-1;
	}
	public boolean GetFirstTetrahedronNull(){
		return (d1==-1);
	}
	public boolean GetSecondTetrahedronNull(){
		return (d2==-1);
	}
	public void SetFirstTetrahedronPointD(int pointd1, Point3d[] p){
		d1=pointd1;
		if (d2<0) CalculateNormal(p);
	}
	public void SetSecondTetrahedronPointD(int pointd2, Point3d[] p){
		d2=pointd2;
		if (d1<0) CalculateNormal(p);
	}
	public int GetFirstTetrahedronPointD(){
		return d1;
	}
	public int GetSecondTetrahedronPointD(){
		return d2;
	}
	
	public int[] GetFace(){
		int[] returnvalue=new int[3];
		returnvalue[0]=a;
		returnvalue[1]=b;
		returnvalue[2]=c;
		return returnvalue;
	}
	public int[] GetFirstTetrahedron(){
		int[] returnvalue=new int[4];
		returnvalue[0]=a;
		returnvalue[1]=b;
		returnvalue[2]=c;
		returnvalue[3]=d1;
		return returnvalue;
	}
	public TriangularFace GetFirstTetrahedron(Point3d[] p){
		TriangularFace returnvalue=new TriangularFace(); 
		if (d1>=0) returnvalue=new TriangularFace(a,b,c,d1,p);
		return returnvalue;
	}
	public TriangularFace GetSecondTetrahedron(Point3d[] p){
		TriangularFace returnvalue=new TriangularFace(); 
		if (d2>=0) returnvalue=new TriangularFace(a,b,c,d2,p);
		return returnvalue;
	}
		
	public int[] GetSecondTetrahedron(){
		int[] returnvalue=new int[4];
		returnvalue[0]=a;
		returnvalue[1]=b;
		returnvalue[2]=c;
		returnvalue[3]=d2;
		return returnvalue;
	}
	
	public boolean IncludesTriangleinTetrahedron(TriangularFace tri){
		int[] vertices=tri.GetFace();
		boolean returnvalue=true;
		for (int i=0;i<vertices.length;i++) returnvalue=returnvalue && (IncludesPointinTetrahedron(vertices[i]));
		return returnvalue;
	}
	public boolean IncludesFirstTetrahedroninTetrahedron(TriangularFace tri){
		int[] vertices=tri.GetFirstTetrahedron();
		boolean returnvalue=true;
		for (int i=0;i<vertices.length;i++) returnvalue=returnvalue && (IncludesPointinTetrahedron(vertices[i]));
		return returnvalue;
	}
	public boolean IncludesSecondTetrahedroninTetrahedron(TriangularFace tri){
		int[] vertices=tri.GetSecondTetrahedron();
		boolean returnvalue=true;
		for (int i=0;i<vertices.length;i++) returnvalue=returnvalue && (IncludesPointinTetrahedron(vertices[i]));
		return returnvalue;
	}
//	 When calling the GetFaces method on a triangular face that is part of a single tetrahedron you get an array of triangular faces with the a,b,c and d1 points swapped around
// with the normal calculated to point to the outside
	//TODO add in code to deal with faces for 2 tetrahedrons and when we simply have a triangle 
	public TriangularFace[] GetFaces(Point3d[] p){
		TriangularFace[] returnvalue=new TriangularFace[4];
		if (((d1>=0) && (d2<0)) || ((d2>=0) && (d1<0))) { // only do this if there is only one tetrahedron
			int d=d1;
			if (d<0) d=d2;
			// Based on those returned by C DeWall BuildTetra
			returnvalue[0]=new TriangularFace(a,b,c,d,p);
			// This returns faces so that a normal calculated from ABxAC for each face will all point in the same direction, either out or in relative to the original tetrahedron
			returnvalue[1]=new TriangularFace(a,d,c,b,p);
			returnvalue[2]=new TriangularFace(c,d,b,a,p);
			returnvalue[3]=new TriangularFace(b,d,a,c,p);
			
		}
		else returnvalue=new TriangularFace[0];
	return returnvalue;
	}
	
	public void SetHash(int n){
		//Note that due to the storage limitations of long and the way the hash value is calculated this gives a unique hashvalue when n<2^21 (and a,b. and c are all less than n)
		if (hashvalue==Long.MIN_VALUE){ // only set it if it hasn't already been set
//			 Quicksort the points
			QuickSortScalarDouble qsort=new QuickSortScalarDouble(a,b,c);
			double[] points=qsort.SortAndReturn();
			hashvalue=((long)points[0]*n*n)+((long)points[1]*n)+(long)points[2];
		}

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
	
	public void CalculateNormal(Point3d[] p){
		// The normal to the plane will be ABxAC, we want to have normal.A as well and if there is one tetrahedron, orient the normal away from the fourth point 
		Point3d AB=p[b].minus(p[a]);
		Point3d AC=p[c].minus(p[a]);
		normal=AB.crossProduct(AC);
		normal=normal.times(1/Math.sqrt(normal.lengthSquared())); // the normal should be of unit length
		normaldota=normal.dot(p[a]);
		
		// check the normal points in the correct direction if there is only one tetrahedron
		if ((d1>=0) && (d2<0)){
			if (normal.dot(p[d1])>normaldota) {
				// flip the normal
				normal=normal.times(-1);
				normaldota=normal.dot(p[a]);
			}
		}
		else if ((d2>=0) && (d1<0)){
				if (normal.dot(p[d2])>normaldota) {
					// flip the normal
						normal=normal.times(-1);
					normaldota=normal.dot(p[a]);
				} 
			}
}

	public void print(){
		System.out.print(" ["+a+" "+b+" "+c+"] + "+d1+","+d2+" hashvalue="+hashvalue);
	}
	public boolean LineSegmentIntersectionTriangularFace(Line3d line,Point3d[] PointsList){
//		 Test for intersection between face and the linesegment
		boolean returnvalue=false;
		double r=0;
		//Does the line segment intersect with the plane made by the triangle face, logic taken from http://softsurfer.com/Archive/algorithm_0105/algorithm_0105.htm
		// If it does, the intersection point is P0+r(P1-P0) where r is between 0 and 1 and is defined as normal.(V0-P0)/normal.(P1-P0). If normal.(P1-P0)=0, then the line segment is parallel to the plane
		Point3d P0=line.GetPointonLine(0);
		Point3d P1=line.GetPointonLine(1);
		Point3d P1minusP0=P1.minus(P0);
		Plane plane=new Plane(PointsList[a],PointsList[b],PointsList[c]);
		double normaldotP=plane.getNormal().dot(P1minusP0);
		if (normaldotP!=0) r=plane.getNormal().dot(PointsList[a].minus(P0))/normaldotP;
			// May need to take into account rounding errors here
			if ((r>0) && (r<1)) {
				// Now is this point also inside the triangle.
				// Could do this with a single barycentric coordinates call if had 3d points rather than 2d implemented, as it is the below is the equivalent using s,t, and s+t
				// Uses the form found at http://softsurfer.com/Archive/algorithm_0105/algorithm_0105.htm
				Point3d intersectionpoint=P0.plus(P1minusP0.times(r));
				Point3d u=PointsList[b].minus(PointsList[a]);
				Point3d v=PointsList[c].minus(PointsList[a]);
				Point3d w=intersectionpoint.minus(PointsList[a]);
				double denominator=(u.dot(v)*u.dot(v))-(u.dot(u)*v.dot(v));
				double s=((u.dot(v)*w.dot(v))-(v.dot(v)*w.dot(u)))/denominator;
				double t=((u.dot(v)*w.dot(u))-(u.dot(u)*w.dot(v)))/denominator;
				if ((s>0) && (s<1) && (t>0) && ((s+t)<1)) 
					returnvalue=true;
			} // end if 0<r<1
		return returnvalue;
	}
	
	// Note that we have to actually calculate the intersection point in order to test for intersection so we may as well return the point.
	// If there is no intersection the origin is returned. Obviously if that is ever possibly going to be an intersection point then the above method should be called to check the result. 
	public Point3d LineSegmentIntersectTriangularFace(Line3d line,Point3d[] PointsList){
//		 Test for intersection between face and the linesegment
		Point3d returnvalue=new Point3d();
		double r=0;
		//Does the line segment intersect with the plane made by the triangle face, logic taken from http://softsurfer.com/Archive/algorithm_0105/algorithm_0105.htm
		// If it does, the intersection point is P0+r(P1-P0) where r is between 0 and 1 and is defined as normal.(V0-P0)/normal.(P1-P0). If normal.(P1-P0)=0, then the line segment is parallel to the plane
		Point3d P0=line.GetPointonLine(0);
		Point3d P1=line.GetPointonLine(1);
		Point3d P1minusP0=P1.minus(P0);
		Plane plane=new Plane(PointsList[a],PointsList[b],PointsList[c]);
		double normaldotP=plane.getNormal().dot(P1minusP0);
		if (normaldotP!=0) r=plane.getNormal().dot(PointsList[a].minus(P0))/normaldotP;
			// May need to take into account rounding errors here
			if ((r>0) && (r<1)) {
				// Now is this point also inside the triangle.
				// Could do with a single barycentric coordinates call if had 3d points rather than 2d implemented, as it is the below is the equivalent using s,t, and s+t
				// Uses the form found at http://softsurfer.com/Archive/algorithm_0105/algorithm_0105.htm
				Point3d intersectionpoint=P0.plus(P1minusP0.times(r));
				Point3d u=PointsList[b].minus(PointsList[a]);
				Point3d v=PointsList[c].minus(PointsList[a]);
				Point3d w=intersectionpoint.minus(PointsList[a]);
				double denominator=(u.dot(v)*u.dot(v))-(u.dot(u)*v.dot(v));
				double s=((u.dot(v)*w.dot(v))-(v.dot(v)*w.dot(u)))/denominator;
				double t=((u.dot(v)*w.dot(u))-(u.dot(u)*w.dot(v)))/denominator;
				if ((s>0) && (s<1) && (t>0) && ((s+t)<1)) 
					returnvalue=intersectionpoint;
			} // end if 0<r<1
		return returnvalue;
	}
	public void resetHash(){
		hashvalue=Long.MIN_VALUE;
	}

	public void ChangeTriangle(int pointa, int pointb, int pointc){
		a=pointa;
		b=pointb;
		c=pointc;
	}
	
	
} // end of class



