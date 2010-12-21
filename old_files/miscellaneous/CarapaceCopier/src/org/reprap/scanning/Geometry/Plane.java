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
* Last modified by Reece Arnott 5th May 2010
* 
* A plane is described by one point on the plane and a normal vector that is at right angles to the plane
* The normal is stored as a unit vector
* 
* 
************************************************************************************/


public class Plane {

	private Point3d P;
	private Point3d normal; // actually a vector of course. 
	public final double normaldotP; // precalculated as may be used a number of times
	
	public Plane clone(){
		Plane returnvalue=new Plane(P,normal);
		return returnvalue;
	}
	
	// Constructors
	// Construct the plane from a point and the normal
	public Plane(Point3d p, Point3d n){
		P=p.clone();
		normal=n.times(1/Math.sqrt(n.lengthSquared())); // normalise the normal to unit length
		normaldotP=normal.dot(P);
	}
	// Construct the plane from 3 points on the plane
	public Plane(Point3d a, Point3d b, Point3d c){
		// The normal to the plane will be ABxAC and we just choose point a arbitrarily as the point on the plane to store  
		P=a;
		Point3d AB=b.minus(a);
		Point3d AC=c.minus(a);
		Point3d n=AB.crossProduct(AC);
		normal=n.times(1/Math.sqrt(n.lengthSquared())); // normalise the normal to unit length
		normaldotP=normal.dot(P);
	}
	//Construct the plane from a trianglular face
	public Plane(TriangularFaceOf3DTetrahedrons face, Point3d[] PointsList){
	// Take point a of the triangle and the calculated normal and use those
		int[] vertices=face.GetFace();
		P=PointsList[vertices[0]];
		normal=face.normal.clone();
		normaldotP=face.normaldota;
	}
/// Construct the middle plane of a line segment i.e. one point on the plane will be the mid point of the line and the normal will be the direction of the line
	public Plane(Line3d l){
		// Find the middle of the line
		P=l.GetPointonLine(0.5);
		normal=l.V.times(1/Math.sqrt(l.V.lengthSquared())); // normalise the normal to unit length
		normaldotP=normal.dot(P);
	}
	public Point3d getNormal(){
		return normal;
	}
	public Point3d getPointonPlane(){
		return P;
	}
	
	// Assuming 3 planes aren't parallel they will meet in a point
	// http://local.wasp.uwa.edu.au/~pbourke/geometry/3planes/ gives a relatively easy derivation
	// The original DeWall C source downloadable from http://vcg.isti.cnr.it/~cignoni/DeWall-Delaunay.tar.gz gives another that looks more complicated but I haven't really looked into it
	public Point3d IntersectionPoint(Plane a, Plane b){
		Point3d p;
		// The point of intersection will be:
		// N1.P1(N2xN3)+N2.P2(N3xN1)+N3.P3(N1xN2)/N1.(N2xN3)
		Point3d N2xN3=a.normal.crossProduct(b.normal);
		double denominator=normal.dot(N2xN3);
		if (denominator==0) p=new Point3d(0,0,0);// the planes are parallel or N1 is a linear combination of N2 and N3
		else {
			Point3d N1xN2=normal.crossProduct(a.normal);
			Point3d N3xN1=b.normal.crossProduct(normal);
			Point3d numerator=N2xN3.times(normaldotP);
			numerator=numerator.plus(N3xN1.times(a.normaldotP));
			numerator=numerator.plus(N1xN2.times(b.normaldotP));
			p=numerator.times(1/denominator);
		}
		return p;
	}
	// If the planes intersect then N1.(N2xN3) will not be zero
	public boolean Intersect(Plane a, Plane b){
		return (normal.dot(a.normal.crossProduct(b.normal))!=0);
	}
//	 If the planes intersect then N1xN2 will not be zero
	public boolean Intersect(Plane other){
		return (normal.crossProduct(other.normal).lengthSquared()!=0);
	}
	
	
	// If the line and plane intersect normal.V will not be zero
	public boolean Intersect(Line3d l){
		return (normal.dot(l.V)!=0);
	}
	// There needs to not only be an intersection but it must be at P+tV with t>0 
	public boolean IntersectRay(Line3d l){
		boolean returnvalue=Intersect(l);
		if (returnvalue) {
			double normaldotV=normal.dot(l.V);
			double t=(normal.dot(P.minus(l.P)))/normaldotV;
			returnvalue=(t>=0);	
		}
		return returnvalue;
	}
	// There needs to not only be an intersection but it must be at P+tV with 0<t<1 
	public boolean IntersectLineSegment(Line3d l){
		boolean returnvalue=Intersect(l);
		if (returnvalue) {
			double normaldotV=normal.dot(l.V);
			double t=(normal.dot(P.minus(l.P)))/normaldotV;
			returnvalue=((t>=0) && (t<=1));	
		}
		return returnvalue;
	}
//	 From http://local.wasp.uwa.edu.au/~pbourke/geometry/planeline/
	// The intersection point is given by Pl+Vt where Pl and V come from the line, and t is calculated as the plane normal.(Pp-Pl)/normal.V - where Pp is the point on the plane and Pl is the point on the line
	// There is no intersection if normal.V=0
	public Point3d IntersectionPoint(Line3d l){
		Point3d p;
		
		double normaldotV=normal.dot(l.V);
		if (normaldotV==0) p=new Point3d(0,0,0);
		else {
			
			double t=(normal.dot(P.minus(l.P)))/normaldotV;
			p=l.GetPointonLine(t);
		}
		return p;
	}
	//	 From http://local.wasp.uwa.edu.au/~pbourke/geometry/planeplane/
	// The intersection line is given by c1N1+c2N2+t(N1*N2) where N1 and N2 are the normals of the planes, and c1 and c2 are calculated
	// If there is no intersection this returns a blank line
	public Line3d IntersectionLine(Plane other){
		// First get the line vector - a vector that is parallel to the line of intersection i.e. the cross product of the normals
		Line3d returnvalue=new Line3d();
		Point3d V=normal.crossProduct(other.normal);
		if (V.lengthSquared()!=0){
			// Now we need to find a point on the line P=c1N1+c2N2 where c1 and c2 are constants calculated using the following formula. 
			double determinant=(normal.dot(normal)*other.normal.dot(other.normal))-Math.pow(normal.dot(other.normal),2);
			double c1=((normaldotP*other.normal.dot(other.normal))-(other.normaldotP*normal.dot(other.normal)))/determinant;
			double c2=((other.normaldotP*normal.dot(normal))-(normaldotP*normal.dot(other.normal)))/determinant;
			Point3d P=normal.times(c1).plus(other.normal.times(c2));
			returnvalue.resetPandV(P,V);
			// Test: If we got it right then n1.p=c1(n1.n1)+c2(n1.n2) and n2.p=c1(n1.n2)+c2(n2.n2)
			//double n1dotp=(c1*(normal.dot(normal)))+(c2*(normal.dot(other.normal)));
			//double n2dotp=(c1*(normal.dot(other.normal)))+(c2*(other.normal.dot(other.normal)));
			//System.out.println(Math.abs(n1dotp-normaldotP)+" "+Math.abs(n2dotp-other.normaldotP));
		}
		return returnvalue;
	}
	
	public boolean GetHalfspace(Point3d p){
		return (normal.dot(p)<normaldotP);
	}
	
	
	// use the P point as the origin for the 2d coordinate system on the plane and calculate the 3d point that corresponds to the 2d point on the plane.
	// We also need a vector to use as one of the axes. This is passed in as the up parameter and is used to as a starting point for direction for plane v axis.
	// Currently only used in Graphics3DFeedback.
	public Point3d GetParametricPointOnPlane(Point3d up,double u, double v){
		Point3d vscalevector,uscalevector;
		// First find the point on the plane corresponding to the intersection of the line made by point P+up and the normal vector
		Line3d line=new Line3d();
		line.resetPandV(P.plus(up),normal);
		Point3d vscalepoint=IntersectionPoint(line);
		// Now make that a vector, and scale so that its length is one
		vscalevector=vscalepoint.minus(P);
		vscalevector.times(1/Math.sqrt(vscalevector.lengthSquared()));
		// First manufacture a vector that is perpindicular to the vscalepoint vector and the normal 
		uscalevector=vscalevector.crossProduct(normal);
		// now scale it to also have length of 1
		uscalevector.times(1/Math.sqrt(uscalevector.lengthSquared()));
		// Now calculate the point
		Point3d point=P.clone();
		point=point.plus(uscalevector.times(u));
		point=point.plus(vscalevector.times(v));
		return point;
	}
	
}
