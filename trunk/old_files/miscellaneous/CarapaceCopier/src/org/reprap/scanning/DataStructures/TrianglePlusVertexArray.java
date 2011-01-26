package org.reprap.scanning.DataStructures;
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
 * Last modified by Reece Arnott 24th August 2010
 * 
 * This is simply a dual array with points in one and triangles in the other.
 * The triangles are defined by three indices that relate to the points array. This is used so that two triangles that share an edge i.e. two vertices will not have a problem with rounding errors
 * leading to the two common vertices not being exactly the same points.
 * 
 * Note that some formulae that traditionally use pi have been replaced to use tau where tau is defined as 2*pi. For an explanation of why this may make things clearer see That Tau Manifesto available at http://tauday.com/
* 
****************************************************************************************************************************/

import org.reprap.scanning.FeatureExtraction.TexturePatch;
import org.reprap.scanning.Geometry.AxisAlignedBoundingBox;
import org.reprap.scanning.Geometry.Coordinates;
import org.reprap.scanning.Geometry.Line3d;
import org.reprap.scanning.Geometry.LineSegment2D;
import org.reprap.scanning.Geometry.Plane;
import org.reprap.scanning.Geometry.Point2d;
import org.reprap.scanning.Geometry.Point3d;
import org.reprap.scanning.Geometry.Triangle3D;
import Jama.Matrix;


public class TrianglePlusVertexArray {
	private final static double tau=Math.PI*2;
	private Point3d[] vertices;
	private Triangle3D[] triangles;
	
	
	// Constructors
	public TrianglePlusVertexArray(Point3d[] points){
		vertices=new Point3d[points.length];
		for (int i=0;i<points.length;i++) vertices[i]=points[i].clone();
		triangles=new Triangle3D[0];
	}
	public TrianglePlusVertexArray(Point3d[] points,Triangle3D[] triangle ){
		vertices=new Point3d[points.length];
		for (int i=0;i<points.length;i++) vertices[i]=points[i].clone();
		triangles=new Triangle3D[triangle.length];
		for (int i=0;i<triangles.length;i++) triangles[i]=triangle[i].clone();
	}
	public TrianglePlusVertexArray clone(){
		return new TrianglePlusVertexArray(vertices,triangles);
	}
	
	public Point3d[] GetVertexArray(){
		return vertices;
	}
	public Triangle3D[] GetTriangleArray(){
		return triangles;
	}
	public boolean AddTriangle(Triangle3D add){
		boolean returnvalue=true;
		// Sanity check to make sure the triangle contains valid indices 
		int[] indices=add.GetFace();
		for (int i=0;i<indices.length;i++) returnvalue=returnvalue && (indices[i]<vertices.length) && (indices[i]>=0);
		if (returnvalue){ // add the triangle
			Triangle3D[] newtriangles=new Triangle3D[triangles.length+1];
			for (int i=0;i<triangles.length;i++) newtriangles[i]=triangles[i].clone();
			newtriangles[triangles.length]=add.clone();
			triangles=newtriangles.clone();
		}
		return returnvalue;
	}
	public void AddVertex(Point3d add){
			Point3d[] newvertices=new Point3d[vertices.length+1];
			for (int i=0;i<vertices.length;i++) newvertices[i]=vertices[i].clone();
			newvertices[vertices.length]=add.clone();
			vertices=newvertices.clone();
	}
	//Purge the vertices in the array and only keep those for which triangles have been added
	public void PurgeIrreleventVertices(){
		// initialise the mapping between old and new indices
		int[] map=new int[vertices.length];
		for (int i=0;i<map.length;i++) map[i]=-1;
		// set up the mapping 
		int count=0;
		for (int i=0;i<triangles.length;i++){
			int[] tri=triangles[i].GetFace();
			for (int j=0;j<tri.length;j++) if (map[tri[j]]==-1) {map[tri[j]]=count; count++;} 
		} // end for i
		// apply the mapping to the vertices
		Point3d[] newpoints=new Point3d[count];
		for (int i=0;i<vertices.length;i++) if (map[i]!=-1){
			newpoints[map[i]]=vertices[i].clone();
		}
		vertices=newpoints.clone();
		//apply the mapping to the triangles
		for (int i=0;i<triangles.length;i++){
			int[] old=triangles[i].GetFace();
			triangles[i].ChangeTriangle(map[old[0]],map[old[1]],map[old[2]]);
			triangles[i].SetHash(triangles.length);
		}
		
	}
	public TrianglePlusVertexArray MergeAndReturn(TrianglePlusVertexArray other){
		// Merge the vertices
		Point3d[] newvertices=new Point3d[vertices.length+other.vertices.length];
		for (int i=0;i<vertices.length;i++) newvertices[i]=vertices[i].clone();
		for (int i=0;i<other.vertices.length;i++) newvertices[i+vertices.length]=other.vertices[i].clone();
		// set up the return value vertices
		TrianglePlusVertexArray returnvalue=new TrianglePlusVertexArray(newvertices);
		
		// merge the first set of triangles (no change)
		Triangle3D[] newtriangles=new Triangle3D[triangles.length+other.triangles.length];
		for (int i=0;i<triangles.length;i++) newtriangles[i]=triangles[i].clone();
		// Now add the second set of triangles and for each change the indices of the 3 vertices
		for (int i=0;i<other.triangles.length;i++) {
			Triangle3D tri=other.triangles[i].clone();
			int[] old=tri.GetFace();
			tri.ChangeTriangle(old[0]+vertices.length,old[1]+vertices.length,old[2]+vertices.length);
			tri.SetHash(triangles.length);
			newtriangles[i+triangles.length]=tri.clone();
		}
		// set the return value triangles
		returnvalue.triangles=newtriangles.clone();
		return returnvalue;
	}
	
	public int GetTriangleArrayLength(){
		return triangles.length;
	}
	public int GetVertexArrayLength(){
		return vertices.length;
	}
	
	public void ExpandTexturePatch(int current,AxisAlignedBoundingBox aabb, int numberofranges, int numberofsubdivisions,Image[] images, int squaresize, double minimumsimilarityrange, double mindistancesquaredbetweenvertices){
		// We are only concerned with angles between -90 and 90 degrees.
		double minangle=-tau/4;
		double maxangle=tau/4;
		
		// There are a maximum of 2 new patches we can get from this patch, as it is assumed that the point on the otherside of the line ab has already been found.
		// Note that we will not expand in a direction if it means going outside the bounding box or if it is a circular triangle creation. 
		// TODO The latter is determined simply by seeing if there is any other triangle that contains both points a and c or b and c respectively
		
		int[] points=triangles[current].GetFace();
		// Just for additional readability
		int a=points[0];
		int b=points[1];
		int c=points[2];
		
		for (int loop=0;loop<2;loop++){
			int newa,newb,newc;
			if (loop==0){newa=a;newb=c;newc=b;}
			else{newa=b;newb=c;newc=a;}
		
			boolean skip=false;
			int j=0;
			while ((j<triangles.length) && (!skip)){
				if (j!=current)	if (triangles[j].IncludesPoint(newa)) if (triangles[j].IncludesPoint(newb)) skip=true;
				j++;
			} // end while
			if (!skip){
				// Find the new patch on the other side of line newa-newb
				int newcindex=vertices.length;
				Point3d newczero=MatrixManipulations.RotatePointCaroundLineAB(Math.PI,vertices[newa],vertices[newb],vertices[newc]); // rotate 180 degrees
				Point3d[] newcandnormal=FindNewCandNormal(minangle,maxangle,numberofranges,numberofsubdivisions,newczero,vertices[newa],vertices[newb],triangles[current].normal,images,squaresize,minimumsimilarityrange);
				
				// Find if the specified point is close to a point we already have and snap to it if that is the case
				int i=0;
				boolean exit=false;
				while ((i<vertices.length) && (!exit)){
					if (newcandnormal[0].CalculateDistanceSquared(vertices[i])<mindistancesquaredbetweenvertices) {newcindex=i; exit=true;}
					i++;
				}
			
				// Find if the point is inside the bounding box, if so, add the triangle
				if (aabb.PointInside3DBoundingBox(newcandnormal[0])) {
					if (newcindex==vertices.length) AddVertex(newcandnormal[0]);
					AddTriangle(new Triangle3D(newa,newb,newcindex,vertices,newcandnormal[1]));
				} // end if within boundingbox
			} // end if skip
		} // end for loop
	}
	
	private static Point3d[] FindNewCandNormal(double minangle, double maxangle, int numberofranges, int numberofsubdivisions,Point3d newczero,Point3d newa,Point3d newb,Point3d normal,Image[] images, int squaresize, double minimumrange){ 
	 
		// Initialise with 0 angle so if no real texture, it will just continue
		Point3d[] returnvalue=new Point3d[2];
		double minvarianceangle=0;
		returnvalue[0]=newczero.clone();
		returnvalue[1]=normal.clone();
		double minvariance=TexturePatch.FindSimilarityMeasure(images, newa, newb, newczero, squaresize, normal);
		double maxvariance=minvariance;
		for (int loop=0;loop<numberofsubdivisions;loop++){
		 double step=(maxangle-minangle)/numberofranges;
		 for (double angle=(minangle+(step/2));angle<=maxangle;angle=angle+step){
			 Matrix R=MatrixManipulations.Calculate3x3RotationMatrixFor3DVectorUsingQuarternions(angle,newb.minus(newa));
			 Point3d rotatedpoint=new Point3d(R.times(newczero.minus(newa).ConvertPointTo3x1Matrix()));
			 rotatedpoint=rotatedpoint.plus(newa);
			 Point3d rotatedupvector=new Point3d(R.times(normal.ConvertPointTo3x1Matrix()));	
		 	 double averagevariance=TexturePatch.FindSimilarityMeasure(images, newa, newb, rotatedpoint, squaresize, rotatedupvector);
		 if (averagevariance<minvariance){
			 minvariance=averagevariance;
			 minvarianceangle=angle;
			 returnvalue[0]=rotatedpoint.clone();
			 returnvalue[1]=new Point3d(R.times(normal.ConvertPointTo3x1Matrix()));	
		 }
		 else if (averagevariance>maxvariance) maxvariance=averagevariance;
	 } // end for angle
	 	minangle=minvarianceangle-(step/2);
	 	maxangle=minvarianceangle+(step/2);
	 } // end for loop
		// If there is not enough variation to be able to tell, just leave it at zero degrees.
		if ((maxvariance-minvariance)<minimumrange){
			returnvalue[0]=newczero.clone();
			returnvalue[1]=normal.clone();
		}
	return returnvalue;
	}
	//TODO uncomment and get working
	/*
	public boolean Interpenetration(TriangularTexturePatch[] others, int skip){
		boolean interpenetration=false;
		Line3d[] perimeter=new Line3d[3];
		perimeter[0]=new Line3d(a,b);
		perimeter[1]=new Line3d(b,c);
		perimeter[2]=new Line3d(c,a);
		
		int k=0;
		while ((k<others.length) && (!interpenetration))if (k!=skip){
			Plane plane=new Plane(others[k].a,others[k].b,others[k].c);
			//Test for penetration of each edge, first with the plane, then with the triangle
			for (int linesegment=0;linesegment<3;linesegment++) if (!interpenetration){
				// Test to see if the line segment intersects the plane which it will unless it is the 
				// special case that the line segment and plane are parallel in which case we need to do more testing
				boolean parallel=plane.Intersect(perimeter[linesegment]);
				// If it is parallel are the points close enough to be considered part of the plane and if they are are they within the triangle
				if (parallel) { // these are the special cases
					Point3d point=plane.FindClosestPointOnPlane(perimeter[linesegment].P);
					if (perimeter[linesegment].P.ApproxEqual(point)){
						// Test to see if either end of the line segment are within the triangle, using barycentric coordinates after transferring to 2d barycentric coordinates
						// if neither end is, does the line segment intersect with the other line segments
						Point3d up=others[k].b.minus(others[k].a);
						Point2d[] triangularvertices;
						triangularvertices=new Point2d[3];
						triangularvertices[0]=plane.GetParametricCoordinatesFromPointOnPlane(up, others[k].a);
						triangularvertices[1]=plane.GetParametricCoordinatesFromPointOnPlane(up, others[k].b);
						triangularvertices[2]=plane.GetParametricCoordinatesFromPointOnPlane(up, others[k].c);
						Point2d point1=plane.GetParametricCoordinatesFromPointOnPlane(up, point);
						Coordinates test=new Coordinates(3);
						test.pixel=point1.clone();
						test.calculatebary(triangularvertices);
						if (test.isOutside()){
							point=plane.FindClosestPointOnPlane(perimeter[linesegment].GetPointonLine(1));
							Point2d point2=plane.GetParametricCoordinatesFromPointOnPlane(up, point);
							test.pixel=point2.clone();
							test.calculatebary(triangularvertices);
							if (test.isOutside()) {
								// Both ends of the line segment are outside the triangle but does the line segment itself intersect the perimeter of the triangle
								LineSegment2D line=new LineSegment2D(point1,point2);
								interpenetration=point1.isEqual(line.SingleIntersectionPointBetweenStartAndEndExclusive(new LineSegment2D(triangularvertices[0],triangularvertices[1])));
								if (!interpenetration) interpenetration=point1.isEqual(line.SingleIntersectionPointBetweenStartAndEndExclusive(new LineSegment2D(triangularvertices[1],triangularvertices[2])));
								if (!interpenetration) interpenetration=point1.isEqual(line.SingleIntersectionPointBetweenStartAndEndExclusive(new LineSegment2D(triangularvertices[2],triangularvertices[0])));
								if (interpenetration) System.out.println("Interpenetration detected: The triangle and line segment are parallel, on the same plane with line segment "+linesegment+" crossing the triangle");
							} else {interpenetration=true; System.out.println("Interpenetration detected: The triangle and line segment are parallel, on the same plane with the end of line segment "+linesegment+" inside the triangle"+k);}
						} else {interpenetration=true;System.out.println("Interpenetration detected: The triangle and line segment are parallel, on the same plane with the start of line segment "+linesegment+" inside the triangle"+k);}
					} // end if on the plane
				} // end if parallel
				else if (plane.IntersectLineSegment(perimeter[linesegment])){ // this is the general case
					Point3d intersectionpoint=plane.IntersectionPoint(perimeter[linesegment]);
					// Now use barycentric coordinates after transforming to 2d parameteric coordinates to see if the point is in the triangle
					Point3d up=others[k].b.minus(others[k].a);
					Point2d[] triangularvertices;
					triangularvertices=new Point2d[3];
					triangularvertices[0]=plane.GetParametricCoordinatesFromPointOnPlane(up, others[k].a);
					triangularvertices[1]=plane.GetParametricCoordinatesFromPointOnPlane(up, others[k].b);
					triangularvertices[2]=plane.GetParametricCoordinatesFromPointOnPlane(up, others[k].c);
					Point2d point=plane.GetParametricCoordinatesFromPointOnPlane(up, intersectionpoint);
					Coordinates test=new Coordinates(3);
					test.pixel=point.clone();
					test.calculatebary(triangularvertices);
					interpenetration=(!test.isOutside()); 
					if (interpenetration) System.out.println("Interpenetration detected: The triangle and line segment are not parallel, but the line segment "+linesegment+" intersects the plane made by the triangle at a point inside the triangle "+k);
				} // end else if
				} // end for linesegments
			k++;
				} // end if/while loop
			else k++;
		return interpenetration;
	}
	*/
	
	
}
