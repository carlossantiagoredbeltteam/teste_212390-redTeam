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
 *    This class takes a series of 2d points and creates a standard triangulated 2d mesh from them which is preprocessed to give the polygon bounding line segments (unordered).
 *    
 *   TODO: would it be better to just calculate the ordered polygon vertices from the dewall space carving and use a standard method to triangulate this if need be? 
 *******************************************************************************/

import javax.swing.JProgressBar;

import org.reprap.scanning.DataStructures.TrianglePlusVertexArray;
import org.reprap.scanning.DataStructures.OrderedListLineSegment2dIndices;
import org.reprap.scanning.FeatureExtraction.DeWall2D;
public class BoundingPolygon2D {
	private final static double tau=Math.PI*2;
	
	
	private Point2d[] allpoints; //TODO currently not used, except for testing purposes delete if not needed.
	private AxisAlignedBoundingBox boundingbox;
	
	// If AlreadyConvertedToTriangles is set then the triangles array is the polygon carved around the points using the 2D DeWall algoritm and the Unorderedboundinglinesegments array is as it says
	// All the line segments were taken from the triangles and the ones that only belonged to 1 triangle were added to this array.
	private Triangle2D[] triangles;
	private LineSegment2DIndices[] unorderedboundinglinesegments;
	private boolean AlreadyConvertedToTriangles;
	
	//Constructors
	public BoundingPolygon2D(Point2d vertices[]){
		triangles=new Triangle2D[0];
		unorderedboundinglinesegments=new LineSegment2DIndices[0];
		AlreadyConvertedToTriangles=false;
		boundingbox=new AxisAlignedBoundingBox();
		allpoints=new Point2d[vertices.length];
		for (int i=0;i<vertices.length;i++){
			allpoints[i]=vertices[i].clone();
			if (i==0){boundingbox.minx=vertices[i].x;boundingbox.maxx=vertices[i].x;boundingbox.miny=vertices[i].y;boundingbox.maxy=vertices[i].y;}
			else boundingbox.Expand2DBoundingBox(vertices[i]);
		}
	} // end of constructor
	public BoundingPolygon2D(){
		triangles=new Triangle2D[0];
		unorderedboundinglinesegments=new LineSegment2DIndices[0];
		AlreadyConvertedToTriangles=false;
		boundingbox=new AxisAlignedBoundingBox();
		allpoints=new Point2d[0];
	} // end of constructor
	
	public BoundingPolygon2D clone(){
		BoundingPolygon2D returnvalue=new BoundingPolygon2D();
		returnvalue.allpoints=new Point2d[allpoints.length];
		returnvalue.triangles=new Triangle2D[triangles.length];
		returnvalue.unorderedboundinglinesegments=new LineSegment2DIndices[unorderedboundinglinesegments.length];
		returnvalue.boundingbox=boundingbox.clone();
		returnvalue.AlreadyConvertedToTriangles=AlreadyConvertedToTriangles;
		for (int i=0;i<allpoints.length;i++) returnvalue.allpoints[i]=allpoints[i].clone();
		for (int i=0;i<triangles.length;i++) returnvalue.triangles[i]=triangles[i].clone();
		for (int i=0;i<unorderedboundinglinesegments.length;i++) returnvalue.unorderedboundinglinesegments[i]=unorderedboundinglinesegments[i].clone();
		
		return returnvalue;
	}
	public AxisAlignedBoundingBox GetAxisAlignedBoundingBox(){
		return boundingbox;
	}
	public Point2d[] GetUnOrderedBoundingVertices(){
		if (!AlreadyConvertedToTriangles) ConvertToTriangles();
		boolean[] include=new boolean[allpoints.length];
		for (int i=0;i<include.length;i++) include[i]=false;
		for (int i=0;i<unorderedboundinglinesegments.length;i++){
			int[] indices=unorderedboundinglinesegments[i].GetStartAndEndPointIndices();
			include[indices[0]]=true;
			include[indices[1]]=true;
		}
		int count=0;
		for (int i=0;i<include.length;i++) if (include[i]) count++;
		Point2d[] unorderedvertices=new Point2d[count];
		count=0;
		for (int i=0;i<include.length;i++) if (include[i]) {
			unorderedvertices[count]=allpoints[i].clone();
			count++;
		}
		
		return unorderedvertices;
	}
	public Point2d[] GetAllPointsWithinPolygon(){
		return allpoints;
	}
	public void scale(double s){
		boundingbox.scale(s);
		for (int i=0;i<allpoints.length;i++) allpoints[i].scale(s);
	}
	public void ResetOrigin(Point2d neworigin){
		boundingbox.ResetOrigin(neworigin.ExportAs3DPoint(0));
		for (int i=0;i<allpoints.length;i++) allpoints[i].minus(neworigin);
	}
	
	public LineSegment2D[] GetUnorderedBounding2DLineSegments(){
		if (!AlreadyConvertedToTriangles) ConvertToTriangles();
		
		LineSegment2D[] returnvalue=new LineSegment2D[unorderedboundinglinesegments.length];
		for (int i=0;i<unorderedboundinglinesegments.length;i++)
			returnvalue[i]=unorderedboundinglinesegments[i].ConvertToLineSegment(allpoints);
		return returnvalue;
	}
	
	public void ExpandPolygon(Point2d point){
		AlreadyConvertedToTriangles=false;
		// Expand the bounding box
		if (allpoints.length==0){boundingbox.minx=point.x;boundingbox.maxx=point.x;boundingbox.miny=point.y;boundingbox.maxy=point.y;}
		else boundingbox.Expand2DBoundingBox(point);
		
		
		// Add the point to the all points array
		Point2d[] allnewpoints=new Point2d[allpoints.length+1];
		for (int i=0;i<allpoints.length;i++) allnewpoints[i]=allpoints[i].clone();
		allnewpoints[allpoints.length]=point.clone();
		allpoints=allnewpoints.clone();
	}
	public boolean PointIsOutside(Point2d point){
		AxisAlignedBoundingBox box=boundingbox.clone();
		box.Expand2DBoundingBox(point);
		boolean returnvalue=(!boundingbox.isEqual(box));
		
		if (!returnvalue){
			if (allpoints.length==0) returnvalue=true;
			else if (allpoints.length==1) returnvalue=!allpoints[0].isEqual(point);
			else if (allpoints.length==2) returnvalue=!new LineSegment2D(allpoints[0],allpoints[1]).Intersect(point);
			else {
				// Go through each triangle and use barycentric coordinate transform to test to see if it is inside or outside the triangle
				if (!AlreadyConvertedToTriangles) ConvertToTriangles();
				Coordinates test=new Coordinates(3);
				test.pixel=point.clone();
				boolean outside=true;
				int i=0;
				while ((i<triangles.length) && (outside)){
					// Get the vertices of the triangle
					int[] vertices=triangles[i].GetVertices();
					Point2d[] vertexpoints=new Point2d[3];
					for (int j=0;j<3;j++) vertexpoints[j]=allpoints[vertices[j]].clone();
					test.calculatebary(vertexpoints);
					outside=test.isOutside();
					i++;
				} // end while i
				returnvalue=outside;
			} //end else
		} // end if within bounding box
		return returnvalue;
	}
	public TrianglePlusVertexArray ExtrudeTo3DAndConvertToTriangles(double zheight, double minzvalue){
		double minz=minzvalue;
		double maxz=minzvalue+zheight;
		if (maxz<minz) {
			minz=maxz; maxz=minzvalue;
		}
		
		TrianglePlusVertexArray bottom=ConvertToTrianglesOnZplane(minz, false);
		TrianglePlusVertexArray top=ConvertToTrianglesOnZplane(maxz,true);
		TrianglePlusVertexArray returnvalue=bottom.MergeAndReturn(top);
		Point3d[] points=returnvalue.GetVertexArray();
		
		// Now make the side values - for this we need the points to be ordered
		Point2d[] orderedvertices=GetOrderedVertices();
		// Note that for this to work properly the merge and return must end up with the vertex 1d array composed of the bottom points in the first half and the top points in the second 
		for (int i=0;i<orderedvertices.length;i++){
			// This takes each pair of vertices which make a rectangle when extended out in z and makes them into two triangles
			int a=i;
			int b1=(i+1)%orderedvertices.length;
			int c=b1+orderedvertices.length;
			int b2=a+orderedvertices.length;
			
			Triangle3D tri1=new Triangle3D(a,b1,c,points);
			Triangle3D tri2=new Triangle3D(a,b2,c,points);
			// now we have to orient the normal in the correct manner
			// If the vertices are ordered in a clockwise direction we want the normal to be pointing to the left of the line segment (as seen when looking from the start to the end)
			// So we use the angle of the line segment, subtract 90 degrees from it, find a point in that direction from the line/triangle plane and make sure the normal points the other way 
			double angle=orderedvertices[a].GetAngleMeasuredClockwiseFromPositiveX(orderedvertices[b1]);
			angle=angle-(tau*0.25);
			Point2d point=orderedvertices[a].GetOtherPoint(angle,1);
			// Now convert this to 3d point
			Point3d pointawayfromnormal=point.ExportAs3DPoint(minz);
			tri1.CalculateNormalAwayFromPoint(points,pointawayfromnormal);
			tri2.CalculateNormalAwayFromPoint(points,pointawayfromnormal);
			returnvalue.AddTriangle(tri1);
			returnvalue.AddTriangle(tri2);
		} // end for
		return returnvalue;
	}
		public TrianglePlusVertexArray ConvertToTrianglesOnZplane(double zvalue, boolean normalfacingup){
			TrianglePlusVertexArray triangles3d=new TrianglePlusVertexArray(new Point3d[0]);
			if (allpoints.length>2){
				if (!AlreadyConvertedToTriangles) ConvertToTriangles();
				
			// convert the 2d vertices to 3d points with the same z value
			Point3d[] vertices3d=new Point3d[allpoints.length];
			for (int i=0;i<vertices3d.length;i++)
				vertices3d[i]=allpoints[i].ExportAs3DPoint(zvalue);
			triangles3d=new TrianglePlusVertexArray(vertices3d);
			// Now go through all the triangles and convert to 3d triangles with the normal pointing in the correct way
			for (int i=0;i<triangles.length;i++){
				int[] indices=triangles[i].GetVertices();
				Triangle3D newtriangle=new Triangle3D(indices[0],indices[1],indices[2],vertices3d);
				if (normalfacingup) newtriangle.CalculateNormalAwayFromPoint(vertices3d,allpoints[indices[0]].ExportAs3DPoint(zvalue-1));
				else newtriangle.CalculateNormalAwayFromPoint(vertices3d,allpoints[indices[0]].ExportAs3DPoint(zvalue+1));
				triangles3d.AddTriangle(newtriangle);
			} // end for
			} // end if >2 vertices
		return triangles3d;
	}
	
	public Point2d[] GetOrderedVertices(){
		if (!AlreadyConvertedToTriangles) ConvertToTriangles();
		// Note that we are assuming the bounding vertices are each attached to 2 other points. Not a problem usless something has gone wrong
		int[][] vertexconnections=new int[allpoints.length][2];
		for (int i=0;i<allpoints.length;i++)for (int j=0;j<2;j++) vertexconnections[i][j]=-1;
		int count=0;
		for (int i=0;i<unorderedboundinglinesegments.length;i++){
			int[] indices=unorderedboundinglinesegments[i].GetStartAndEndPointIndices();
			if (vertexconnections[indices[0]][0]==-1) {vertexconnections[indices[0]][0]=indices[1];count++;}
			else if (vertexconnections[indices[0]][1]==-1)vertexconnections[indices[0]][1]=indices[1];
			else System.out.println("Error, vertex "+indices[0]+" is already connected to two other vertices");
			 
			if (vertexconnections[indices[1]][0]==-1){vertexconnections[indices[1]][0]=indices[0];count++;}
			else if (vertexconnections[indices[1]][1]==-1)vertexconnections[indices[1]][1]=indices[0];
			else System.out.println("Error, vertex "+indices[1]+" is already connected to two other vertices");
		}
		
		Point2d[] orderedpoints=new Point2d[count];
		if (count!=0){
			count=0;
			// Now walk the tree in a clockwise direction
			int current=0;
			while ((vertexconnections[current][0]==-1) && (vertexconnections[current][1]==-1) && (current<allpoints.length))current++; 
			if (current<allpoints.length){
				int first=current;
				orderedpoints[count]=allpoints[current].clone();count++;
				int previous=current;
				int next=current;
				// We have two choices, one will walk around the polygon clockwise, the other anti-clockwise, we want to choose the one that is clockwise.
				// Find the angle between the points 
				//double angleto0=allpoints[current].GetAngleMeasuredClockwiseFromPositiveX(allpoints[vertexconnections[current][0]]);
				//double angleto1=allpoints[current].GetAngleMeasuredClockwiseFromPositiveX(allpoints[vertexconnections[current][1]]);
				// The angle 0->current->1 is clockwise if angleto1 is between 0 and 180 degrees greater than angleto0
				//if (angleto0<(tau*0.5)){
				//	if ((angleto1>angleto0) && (angleto1<(angleto0+(tau*0.5)))) next=vertexconnections[current][1];
				//	else next=vertexconnections[current][0];
				//}
				//else { // may need to do some adjustments as angle is only measure 0-360 degrees
				//	if ((angleto1>angleto0) || (angleto1<(angleto0-(tau*0.5)))) next=vertexconnections[current][1];
				//	else next=vertexconnections[current][0];	
				//}
				// Alternatively,
				// Logic taken from http://www.gamedev.net/reference/articles/article425.asp
				// if the determinant is less than 0 then the points are ordered clockwise
				Point2d a=allpoints[vertexconnections[current][0]].clone();
				Point2d b=allpoints[current].clone();
				Point2d c=allpoints[vertexconnections[current][1]].clone();
				
				double determ = ((b.x-a.x)*(c.y-a.y))-((c.x-a.x)*(b.y-a.y));
				if (determ<0) next=vertexconnections[current][1];
				else next=vertexconnections[current][0];
				
				current=-1;
				while (current!=first){
					current=next;
					if (current!=first) {
						orderedpoints[count]=allpoints[current].clone();count++;
						if(vertexconnections[current][0]==previous) next=vertexconnections[current][1];
						else next=vertexconnections[current][0];
						previous=current;
					}
				} // end while
			} // end if
		} // end if
		return orderedpoints;
	}	
	private void ConvertToTriangles(){
		if (allpoints.length>2){
			DeWall2D dewall=new DeWall2D(allpoints);
			AlreadyConvertedToTriangles=true;
			triangles=dewall.Triangularisation(new JProgressBar(0,1), true,"x");
		
			if ((dewall.IsCyclicTriangle2DCreationError()) || (triangles.length==0)) {
				System.out.println("Error in recursive x start, trying recursive y");
				triangles=dewall.Triangularisation(new JProgressBar(0,1), true,"y");
			}
			if ((dewall.IsCyclicTriangle2DCreationError()) || (triangles.length==0)) {
				System.out.println("Error in recursive y start, trying sequential x");
				triangles=dewall.Triangularisation(new JProgressBar(0,1), false,"x");
			}
			if ((dewall.IsCyclicTriangle2DCreationError()) || (triangles.length==0)) {
				System.out.println("Error in sequential x start, trying sequential y");
				triangles=dewall.Triangularisation(new JProgressBar(0,1), false,"y");
			}
			if (dewall.IsCyclicTriangle2DCreationError()) { 
				System.out.println("Unrecoverable CTC error. Pathological points? Total number of points is "+allpoints.length);
				AlreadyConvertedToTriangles=false;
			}
			else if (triangles.length==0){
				System.out.println("No triangles could be calculated. Pathological points? Total number of points is "+allpoints.length);
				AlreadyConvertedToTriangles=false;
			}
			else {
				// Now get the unordered line segments of the bounding polygon.
				// A bounding line segment will only be associated with 1 triangle, all others will be associated with two.
				OrderedListLineSegment2dIndices list=new OrderedListLineSegment2dIndices(allpoints.length); 
				for (int i=0;i<triangles.length;i++){
					LineSegment2DIndices[] lines=triangles[i].GetLineSegment2DIndices(allpoints);
					for (int j=0;j<lines.length;j++){
						boolean deleted=list.DeleteIfExist(lines[j]);
						if (!deleted) list.InsertIfNotExist(lines[j]);
					} // end for j
				} // end for i
				unorderedboundinglinesegments=list.GetFullUnorderedList();
			} // end if
		} // end else
	} // end private ConvertToTriangles() method
	
	
}
