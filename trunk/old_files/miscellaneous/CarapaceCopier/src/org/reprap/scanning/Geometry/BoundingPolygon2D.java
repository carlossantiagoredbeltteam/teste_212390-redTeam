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
 * Last modified by Reece Arnott 14th December 2010
 * 
 *    This class takes a series of 2d points and creates a standard convex, closed polygon that encloses the points
 *    The polygon is defined by an array of ordered points (ordered in CCW or CW order)   
 *    
 *    Note that some formulae that traditionally use pi have been replaced to use tau where tau is defined as 2*pi. For an explanation of why this may make things clearer see That Tau Manifesto available at http://tauday.com/
 *    
 *******************************************************************************/

import org.reprap.scanning.DataStructures.TrianglePlusVertexArray;
public class BoundingPolygon2D {
	private final static double tau=Math.PI*2;
	
	private static enum direction{up,left,down,right}; // anti-clockwise 
	//private static enum direction{left, up, right, down}; // clockwise
	// Note that this assumes a right hand coordinate system i.e. up is in the positive y direction, right is positive x etc.
	// But this is just for readability
	
	private static direction[] directionarray=direction.values();//This is a set of directions to cycle through in order to order the corner array in either clockwise or anti-clockwise direction 
	private static boolean clockwiseordering=directionarray[0]==direction.left; // The triangulation routine needs to know if the vertices are ordered clockwise or anti-clockwise 
	
	private Point2d[] orderedvertices;
	private AxisAlignedBoundingBox boundingbox;
	
	//Constructor
	public BoundingPolygon2D(Point2d vertices[]){
		boundingbox=new AxisAlignedBoundingBox();
		orderedvertices=new Point2d[vertices.length];
		if (vertices.length>1){
			for (int i=0;i<vertices.length;i++)
				if (i==0){boundingbox.minx=vertices[i].x;boundingbox.maxx=vertices[i].x;boundingbox.miny=vertices[i].y;boundingbox.maxy=vertices[i].y;}
				else boundingbox.Expand2DBoundingBox(vertices[i]);
			orderedvertices=FindAndOrderVertices(vertices);
		}
		else if (vertices.length==1) orderedvertices[0]=vertices[0].clone();
	} // end of constructor
	
	public BoundingPolygon2D clone(){
		BoundingPolygon2D returnvalue=new BoundingPolygon2D(orderedvertices);
		return returnvalue;
	}
	public AxisAlignedBoundingBox GetAxisAlignedBoundingBox(){
		return boundingbox;
	}
	public Point2d[] GetOrderedVertices(){
		return orderedvertices;
	}
	public LineSegment2D[] Get2DLineSegments(){
		LineSegment2D[] returnvalue=new LineSegment2D[0];
		if (orderedvertices.length>1) returnvalue=new LineSegment2D[orderedvertices.length-1];
		for (int i=0;i<returnvalue.length;i++)
			returnvalue[i]=new LineSegment2D(orderedvertices[i],orderedvertices[(i+1)%returnvalue.length]);
		return returnvalue;
	}
	public Line3d[] Get3DLineSegments(double zvalue){
		Line3d[] returnvalue=new Line3d[0];
		if (orderedvertices.length>1) returnvalue=new Line3d[orderedvertices.length-1];
		for (int i=0;i<returnvalue.length;i++)
			returnvalue[i]=new Line3d(new Point3d(orderedvertices[i].x,orderedvertices[i].y,zvalue),new Point3d(orderedvertices[(i+1)%returnvalue.length].x,orderedvertices[(i+1)%returnvalue.length].y,zvalue));
		return returnvalue;
	}
	public void ExpandPolygon(Point2d point){
		Point2d[] newvertices=new Point2d[orderedvertices.length+1];
		for (int i=0;i<orderedvertices.length;i++) newvertices[i]=orderedvertices[i].clone();
		newvertices[orderedvertices.length]=point.clone();
		boundingbox.Expand2DBoundingBox(point);
		if (newvertices.length>2) orderedvertices=FindAndOrderVertices(newvertices);
		else orderedvertices=newvertices.clone();
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
		// Now make the side values
		// Note that for this to work properly the merge and return must end up with the vertex 1d array composed of the bottom points in the first half and the top points in the second 
		for (int i=0;i<orderedvertices.length;i++){
			// This takes each pair of vertices which make a rectangle when extended out in z and makes them into two triangles
			int a=i;
			int b1=(i+1)%orderedvertices.length;
			int c=b1+orderedvertices.length;
			int b2=a+orderedvertices.length;
			
			TriangularFace tri1=new TriangularFace(a,b1,c);
			TriangularFace tri2=new TriangularFace(a,b2,c);
			// now we have to orient the normal in the correct manner
			// If the vertices are ordered in a clockwise direction we want the normal to be pointing to the left of the line segment (as seen when looking from the start to the end)
			// If they are ordered counter clockwise we want the normal to be pointing to the right, again as seen when looking from the start to the end
			// So we use the angle of the line segment, add or subtract 90 degrees from it, find a point in that direction from the line/triangle plane and make sure the normal points the other way 
			double angle=orderedvertices[a].GetAngleMeasuredClockwiseFromPositiveX(orderedvertices[b1]);
			if (clockwiseordering) angle=angle-(tau*0.25);
			else angle=angle+(tau*0.25);
			Point2d point=orderedvertices[a].GetOtherPoint(angle,1);
			// Now convert this to 3d point
			Point3d pointawayfromnormal=new Point3d(point.x,point.y,minz);
			tri1.CalculateNormalAwayFromPoint(points,pointawayfromnormal);
			tri2.CalculateNormalAwayFromPoint(points,pointawayfromnormal);
			returnvalue.AddTriangle(tri1);
			returnvalue.AddTriangle(tri2);
		} // end for
		return returnvalue;
	}
		public TrianglePlusVertexArray ConvertToTrianglesOnZplane(double zvalue, boolean normalfacingup){
		// convert the 2d vertices to 3d points with the same z value
		Point3d[] vertices3d=new Point3d[orderedvertices.length];
		boolean[] skip=new boolean[orderedvertices.length];
		for (int i=0;i<vertices3d.length;i++) {
			vertices3d[i]=new Point3d(orderedvertices[i].x,orderedvertices[i].y,zvalue);
			skip[i]=false;
		}
		
		TrianglePlusVertexArray triangles=new TrianglePlusVertexArray(vertices3d);
		// Slice off triangles until nothing remains
		boolean exit=orderedvertices.length<3;
		while (!exit){
			double minhypotenusesquared=Double.MAX_VALUE;
			// traverse around the remaining vertices and find the smallest (internal) triangle that can be made from neighbouring triangles
			int a,b,c;
			int newa=0;
			int newb=0;
			int newc=0;
			for (int i=0;i<orderedvertices.length;i++){
				if (!skip[i]){
					a=i;
					// Now go forwards to find the closest vertex to be used as b and then again for c
					int j=1;
					while (skip[(a+j)%skip.length] && (j<=skip.length))j++;
					b=(a+j)%skip.length;
					j=1;
					while (skip[(b+j)%skip.length])j++;
					c=(b+j)%skip.length;
					exit=((a==b) || (a==c)|| (b==c)); // if there isn't a triangle to form don't continue
					if (!exit){
						// Check that the triangle is a good candidate
						//1) the hypotenuse is small
						double hypotenusesquared=orderedvertices[a].CalculateDistanceSquared(orderedvertices[c]);
						if (hypotenusesquared<minhypotenusesquared){
							//2) The triangle has the same ordering of points as the polygon 
							double determ = (orderedvertices[b].x - orderedvertices[a].x) * (orderedvertices[c].y - orderedvertices[a].y) - (orderedvertices[c].x - orderedvertices[a].x) * (orderedvertices[b].y - orderedvertices[a].y);
							boolean sameorientation=((determ >= 0.0)==clockwiseordering);
							if (sameorientation){
								// 3) no other vertices are inside the triangle
								boolean alloutside=true;
								Coordinates test=new Coordinates();
								for (int k=0;k<orderedvertices.length;k++) if (alloutside){
									if ((k!=a) && (k!=b) && (k!=c)){
										test.pixel=orderedvertices[k].clone();
										test.calculatebary(orderedvertices,a,b,c);
										alloutside=test.isOutside();
									}
								} // end for if
								if (alloutside){
									minhypotenusesquared=hypotenusesquared;
									newa=a;
									newb=b;
									newc=c;
								} // end if all outside
							} // end if sameorientation
						} // end if less than min hypotenusesquared
					} // end if !exit
				} // end if !skip[i]
			} // end for i
			if (!exit){
				// We should now be able to add a triangle to the list and take vertex b out of the list
				TriangularFace newtriangle=new TriangularFace(newa,newb,newc);
				if (normalfacingup) newtriangle.CalculateNormalAwayFromPoint(vertices3d,new Point3d(0,0,zvalue-1));
				else newtriangle.CalculateNormalAwayFromPoint(vertices3d,new Point3d(0,0,zvalue+1));
				triangles.AddTriangle(newtriangle);
				skip[newb]=true;
				// Now count up how many vertices are left 
				int count=0;
				for (int i=0;i<skip.length;i++) if (!skip[i]) count++;
				exit=(count<3);
			}	
		} // end while
		
		
		return triangles;
	}
	
	
	
	
	
	/***********************************************************************************************************************************************
	 * 
	 * Private methods from here down
	 * 
	 ***********************************************************************************************************************************************/
	
	
	
	
//	 This re-orders the vertices so they are in clockwise or anti-clockwise order, depending on the directions enum array defined at the start of the class
// Any point in the array that is actually within the bounding polygon is ignored
	private Point2d[] FindAndOrderVertices(Point2d vertices[]){
		direction majordirection = directionarray[0];
		direction minordirection = directionarray[3];
		Point2d currentcorner=new Point2d(boundingbox.minx-1,boundingbox.miny-1); 
		// Assuming the bounding box has been calculated correctly, this will start with the leftmost point and try to find the closest point on its right.
		int[] vertexindices=new int[vertices.length];
		boolean[] skip=new boolean[vertices.length]; 
		for (int i=0;i<skip.length;i++) skip[i]=false;
		int vertexnumber=0;
		boolean exit=false;
		while (!exit){
			int index=-1;
			double mindistance=0;
			double distance=0;  
			boolean first=true;
			// find the corner in the specified major direction that is furtherest to the minor direction (this may mean that it is the closest in the opposite minor direction)  
			for (int i=0; i<vertices.length;i++)
			{
				if (!skip[i]){	
				boolean lookat=false;
					if ((majordirection==direction.right) && (vertices[i].x>currentcorner.x)) lookat=true; 
					if ((majordirection==direction.left) && (vertices[i].x<currentcorner.x)) lookat=true;
					if ((majordirection==direction.up) && (vertices[i].y<currentcorner.y)) lookat=true;
					if ((majordirection==direction.down) && (vertices[i].y>currentcorner.y)) lookat=true;
					//if ((majordirection==direction.up) && (vertices[i].y>currentcorner.y)) lookat=true; //for inverted y
					//if ((majordirection==direction.down) && (vertices[i].y<currentcorner.y)) lookat=true; // for inverted y
					
					
					if (lookat){ // if it is in the direction we are interested in, look at it
						if (minordirection==direction.right) distance=0-vertices[i].x;
						if (minordirection==direction.left) distance=vertices[i].x;
						if (minordirection==direction.down) distance=0-vertices[i].y;
						if (minordirection==direction.up) distance=vertices[i].y; 
						//if (minordirection==direction.up) distance=0-vertices[i].y; // for inverted y
						//if (minordirection==direction.down) distance=vertices[i].y; // for inverted y 
						if ((distance<mindistance) || first) { // if it is closer to the edge in the direction we are interested in (or is the first in this direction) mark it
							first=false;
							index=i;
							mindistance=distance;
						}// end if distance
					} // end if lookat
				} // end if !skip
			} //end for
			if (index==-1) { // if didn't find any vertices in that direction, cycle to the next direction.
				minordirection=majordirection;
				majordirection=directionarray[(majordirection.ordinal()+1)%4];
			}else { // otherwise add that vertex to the array, skip it next time (unless it is the first vertex) and set this corner to be the current one
				if (vertexnumber!=0){
					exit=(index==vertexindices[0]);
				}
				if (!exit){
					currentcorner=vertices[index].clone();
					vertexindices[vertexnumber]= index;
					skip[index]=(vertexnumber!=0); // we need to keep the first vertex in play so that we can detect when to exit the loop i.e. when we have completed encircling the points and come back to the starting point. 
					vertexnumber++;
					exit=(vertexnumber==vertices.length);
				}
			} // end else
		} // end while
		Point2d[] reorderedvertices=new Point2d[vertexnumber];
		for (int i=0;i<vertexnumber;i++) reorderedvertices[i]=vertices[vertexindices[i]].clone();
		return reorderedvertices;
	} // end set corners indexes
}
