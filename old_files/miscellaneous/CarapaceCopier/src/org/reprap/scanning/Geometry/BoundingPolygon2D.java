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
 *    This class takes a series of 2d points and creates a standard convex, closed polygon that encloses the points
 *    The polygon is defined by an array of ordered points (ordered in CCW or CW order)   
 *    
 *    
 *******************************************************************************/

public class BoundingPolygon2D {

	private static enum direction{up,left,down,right}; // anti-clockwise 
	//private static enum direction{left, up, right, down}; // clockwise
	// Note that this assumes a right hand coordinate system i.e. up is in the positive y direction, right is positive x etc.
	// But this is just for readability
	private static direction[] directionarray=direction.values();
	//This is a set of directions to cycle through in order to order the corner array in either clockwise or anti-clockwise direction 

	private Point2d[] orderedvertices;
	private AxisAlignedBoundingBox boundingbox;
	
	//Constructor
	public BoundingPolygon2D(Point2d vertices[]){
		boundingbox=new AxisAlignedBoundingBox();
		for (int i=0;i<vertices.length;i++)
			if (i==0){boundingbox.minx=vertices[i].x;boundingbox.maxx=vertices[i].x;boundingbox.miny=vertices[i].y;boundingbox.maxy=vertices[i].y;}
			else boundingbox.Expand2DBoundingBox(vertices[i]);
		orderedvertices=FindAndOrderVertices(vertices);
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
		LineSegment2D[] returnvalue=new LineSegment2D[orderedvertices.length-1];
		for (int i=0;i<returnvalue.length;i++)
			returnvalue[i]=new LineSegment2D(orderedvertices[i],orderedvertices[(i+1)%returnvalue.length]);
		return returnvalue;
	}
	public Line3d[] Get3DLineSegments(double zvalue){
		Line3d[] returnvalue=new Line3d[orderedvertices.length-1];
		for (int i=0;i<returnvalue.length;i++)
			returnvalue[i]=new Line3d(new Point3d(orderedvertices[i].x,orderedvertices[i].y,zvalue),new Point3d(orderedvertices[(i+1)%returnvalue.length].x,orderedvertices[(i+1)%returnvalue.length].y,zvalue));
		return returnvalue;
	}
	public void ExpandPolygon(Point2d point){
		Point2d[] newvertices=new Point2d[orderedvertices.length+1];
		for (int i=0;i<orderedvertices.length;i++) newvertices[i]=orderedvertices[i].clone();
		newvertices[orderedvertices.length]=point.clone();
		boundingbox.Expand2DBoundingBox(point);
		orderedvertices=FindAndOrderVertices(newvertices);
	}
	
//	 This re-orders the vertices so they are in clockwise or anti-clockwise order, depending on the directions enum array defined at the start of the class
// Any point in the array that is actually within the bounding polygon is ignored
	private Point2d[] FindAndOrderVertices(Point2d vertices[]){
		direction majordirection = directionarray[0];
		direction minordirection = directionarray[3];
		Point2d currentcorner=new Point2d(boundingbox.minx-1,boundingbox.miny-1); 
		// Assuming the bounding box has been calculated correctly, this will start with the leftmost point and try to find the closest point on its right.
		int[] vertexindices=new int[vertices.length];
		//Point2d[] tempFeatureCorner=new Point2d[corners.length];
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
					if ((majordirection==direction.right) && (vertices[i].x>=currentcorner.x)) lookat=true; 
					if ((majordirection==direction.left) && (vertices[i].x<=currentcorner.x)) lookat=true;
					//if ((majordirection==direction.down) && (vertices[i].y<=currentcorner.y)) lookat=true; // for inverted y
					if ((majordirection==direction.up) && (vertices[i].y<=currentcorner.y)) lookat=true;
					if ((majordirection==direction.down) && (vertices[i].y>=currentcorner.y)) lookat=true;
					//if ((majordirection==direction.up) && (vertices[i].y>=currentcorner.y)) lookat=true; //for inverted y
					
					
					if (lookat){ // if it is in the direction we are interested in, look at it
						if (minordirection==direction.right) distance=0-vertices[i].x;
						if (minordirection==direction.left) distance=vertices[i].x;
						//if (minordirection==direction.down) distance=vertices[i].y; // for inverted y 
						if (minordirection==direction.down) distance=0-vertices[i].y;
						//if (minordirection==direction.up) distance=0-vertices[i].y; // for inverted y
						if (minordirection==direction.up) distance=vertices[i].y; 
						if ((distance<mindistance) || first) { // if it is closer to the edge in the direction we are interested in (or is the first in this direction) mark it
							first=false;
							index=i;
							mindistance=distance;
						}// end if distance
					} // end if lookat
				} // end if !skip
			} //end for
			if (index==-1) { // if didn't find any corners in that direction, cycle to the next direction.
				minordirection=majordirection;
				majordirection=directionarray[(majordirection.ordinal()+1)%4];
			}else { // otherwise add that vertex to the array, skip it next time (unless it is the first vertex as the exit condition depends on eventually selecting this index again) and set this corner to be the current one
				currentcorner=vertices[index].clone();
				vertexindices[vertexnumber]= index;
				if (vertexnumber!=0){
					skip[index]=true;
					exit=index==vertexindices[0];
				}
				if (!exit) vertexnumber++;
			} // end else
		} // end while
		Point2d[] reorderedvertices=new Point2d[vertexnumber];
		for (int i=0;i<vertexnumber;i++) reorderedvertices[i]=vertices[vertexindices[i]].clone();
		return reorderedvertices;
	} // end set corners indexes
}
