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
* Last modified by Reece Arnott 18th March 2010
*
*	This class takes an array of points and splits the 3d space into a 3d cell structure and stores the indexes for the array in each cell.
*	 TODO - This class may benefit from using  unconstrained ArrayList rather than fixed length array.
* 
* 
***********************************************************************************/

import org.reprap.scanning.Geometry.Point3d;
import org.reprap.scanning.Geometry.AxisAlignedBoundingBox;
import org.reprap.scanning.Geometry.Triangle3D;

public class Uniform3DGrid{
	public UniformGridCell[][][] Grid;
	private boolean[][][] marked; // this is used to flag if the cell is empty or has been tested already
	private AxisAlignedBoundingBox boundary; // not used if only one cell
	private double side; // this defines the size of a cell. Not used if only one cell
	public int arraysizex,arraysizey,arraysizez; // these store the length of the 3d arrays 
	// Constructor
	public Uniform3DGrid(Point3d[] p,int[] subsetindexes,int m){ // m is the minimum number of cells to divide the space into
		if (m<2){  // don't worry about an accurate grid if there are only a few points
			arraysizex=1;
			arraysizey=1;
			arraysizez=1;
			Grid=new UniformGridCell[1][1][1];
			marked=new boolean[1][1][1];
			Grid[0][0][0]=new UniformGridCell();
			Grid[0][0][0].pointslist=subsetindexes.clone();
			marked[0][0][0]=(Grid[0][0][0].GetLength()==0);
		}
		else {
//			 First Find the bounding box
			boundary=new AxisAlignedBoundingBox();
			for (int i=0;i<subsetindexes.length;i++){
				if (i==0){
					boundary.minx=p[subsetindexes[0]].x;
					boundary.miny=p[subsetindexes[0]].y;
					boundary.minz=p[subsetindexes[0]].z;
					boundary.maxx=p[subsetindexes[0]].x;
					boundary.maxy=p[subsetindexes[0]].y;
					boundary.maxz=p[subsetindexes[0]].z;
				}
				else boundary.Expand3DBoundingBox(p[subsetindexes[i]]);
			}
			// Now divide up the space into 3d cells
			double volume=(boundary.maxx-boundary.minx)*(boundary.maxy-boundary.miny)*(boundary.maxz-boundary.minz);
			side=Math.pow((volume/(double)m),0.33333);
			// How many cells in each of x,y,z directions
			arraysizex=(int)Math.ceil((boundary.maxx-boundary.minx)/side);
			arraysizey=(int)Math.ceil((boundary.maxy-boundary.miny)/side);
			arraysizez=(int)Math.ceil((boundary.maxz-boundary.minz)/side);
			// Adjust the bounding box out to have all the points within them.
			double xoffset=(arraysizex*side)-(boundary.maxx-boundary.minx);
			double yoffset=(arraysizey*side)-(boundary.maxy-boundary.miny);
			double zoffset=(arraysizez*side)-(boundary.maxz-boundary.minz);
			boundary.minx=boundary.minx-(xoffset/2);
			boundary.miny=boundary.miny-(yoffset/2);
			boundary.minz=boundary.minz-(zoffset/2);
			boundary.maxx=boundary.maxx+(xoffset/2);
			boundary.maxy=boundary.maxy+(yoffset/2);
			boundary.maxz=boundary.maxz+(zoffset/2);
			// Create the Grid array
			Grid=new UniformGridCell[arraysizex][arraysizey][arraysizez];
			for (int i=0;i<arraysizex;i++)
				for (int j=0;j<arraysizey;j++)
					for (int k=0;k<arraysizez;k++)
						Grid[i][j][k]=new UniformGridCell();
			// Now load the points into it
			for (int i=0;i<subsetindexes.length;i++){
				int x=(int)((p[subsetindexes[i]].x-boundary.minx)/side);
				int y=(int)((p[subsetindexes[i]].y-boundary.miny)/side);
				int z=(int)((p[subsetindexes[i]].z-boundary.minz)/side);
				Grid[x][y][z].Add(subsetindexes[i]);
			}
			// Create and set the marked array
			marked=new boolean[arraysizex][arraysizey][arraysizez];
			resetMarked();
		}	// end else
	} // end of constructor
	
	// This returns true if the cell should be examined for whether or not it contains points that may be of use in making the triangle to be a tetrahedron
	// i.e. the cell is not marked as already checked or empty, and the cell is not in the inside half space (determined by checking the corner closest to the plane)
	public boolean ExaminableCell(Triangle3D triangle,int cellx, int celly, int cellz){
		boolean returnvalue=!marked[cellx][celly][cellz];
		if ((arraysizex>1) || (arraysizey>1) || (arraysizez>1))
			if (returnvalue){
				// Find the corner closest to plane normal - assuming the normal is oriented in the correct way
				Point3d n=triangle.normal.clone();
				// now use the sign of the normal x,y,z coordinates to determine which corner to test
				// default to the bottom/left/front corner and then adjust
				double x=cellx*side+boundary.minx;
				double y=celly*side+boundary.miny;
				double z=cellz*side+boundary.minz;
				// if the x,y, or z value of the normal is positive then the closest corner is further in that direction 
				if (n.x>0) x=x+side;
				if (n.y>0) y=y+side;
				if (n.z>0) z=z+side;
			
				// Now test it
				returnvalue=!triangle.InsideHalfspace(new Point3d(x,y,z));
			}
		return returnvalue;
	}
	
	public void CellExamined(int x,int y,int z){
		marked[x][y][z]=true;
	}

	// Get the bounding box containing the centre is the given point 
	public AxisAlignedBoundingBox GetBoundingBox(Point3d centre, double radius){
		AxisAlignedBoundingBox returnvalue=new AxisAlignedBoundingBox();
		if ((arraysizex==1) && (arraysizey==1) && (arraysizez==1)){
			returnvalue.minx=0;
			returnvalue.miny=0;
			returnvalue.minz=0;
			returnvalue.maxx=0;
			returnvalue.maxy=0;
			returnvalue.maxz=0;
		}
		else {// find the indexes of the UG array for the bounding box corners
		returnvalue.minx=(int)((centre.x-boundary.minx-radius)/side);
		returnvalue.miny=(int)((centre.y-boundary.miny-radius)/side);
		returnvalue.minz=(int)((centre.z-boundary.minz-radius)/side);
		returnvalue.maxx=(int)((centre.x-boundary.minx+radius)/side);
		returnvalue.maxy=(int)((centre.y-boundary.miny+radius)/side);
		returnvalue.maxz=(int)((centre.z-boundary.minz+radius)/side);
		// Make sure everything is in the grid
		if (returnvalue.minx<0) returnvalue.minx=0;
		if (returnvalue.miny<0) returnvalue.miny=0;
		if (returnvalue.minz<0) returnvalue.minz=0;
		if (returnvalue.minx>(arraysizex-1)) returnvalue.minx=arraysizex-1;
		if (returnvalue.miny>(arraysizey-1)) returnvalue.miny=arraysizey-1;
		if (returnvalue.minz>(arraysizez-1)) returnvalue.minz=arraysizez-1;
		if (returnvalue.maxx<0) returnvalue.maxx=0;
		if (returnvalue.maxy<0) returnvalue.maxy=0;
		if (returnvalue.maxz<0) returnvalue.maxz=0;
		if (returnvalue.maxx>(arraysizex-1)) returnvalue.maxx=arraysizex-1;
		if (returnvalue.maxy>(arraysizey-1)) returnvalue.maxy=arraysizey-1;
		if (returnvalue.maxz>(arraysizez-1)) returnvalue.maxz=arraysizez-1;
		} // end else
		return returnvalue;
	}
	
	public void resetMarked(){
		for (int i=0;i<arraysizex;i++)
			for (int j=0;j<arraysizey;j++)
				for (int k=0;k<arraysizez;k++)
					marked[i][j][k]=(Grid[i][j][k].GetLength()==0);
	} // end of resetMarked method
	
	public int GetFirst(int x,int y, int z){
		int returnvalue=-1;
		if ((x>=0) && (x<arraysizex) && (y>=0) && (y<arraysizey) && (z>=0) && (z<arraysizez)) returnvalue=Grid[x][y][z].GetFirst();
		return returnvalue;
	}
	public int GetNext(int x,int y, int z){
		int returnvalue=-1;
		if ((x>=0) && (x<arraysizex) && (y>=0) && (y<arraysizey) && (z>=0) && (z<arraysizez)) returnvalue=Grid[x][y][z].GetNext();
		return returnvalue;
	}
	
	public void Print(){
		for (int x=0;x<arraysizex;x++) for (int y=0;y<arraysizey;y++)for (int z=0;z<arraysizez;z++){
			System.out.print("["+x+","+y+","+z+"]: ");
			int i=Grid[x][y][z].GetFirst();
			while (i!=-1){
				System.out.print(i+" ");
				i=Grid[x][y][z].GetNext();
			}
			System.out.println();
		}
	}

// This is a nested class. Just used within this class.
class UniformGridCell{
	private int[] pointslist;
	private int nextpointer;
	
	public UniformGridCell(){
		pointslist=new int[0];
		nextpointer=0;
	}
	public UniformGridCell clone(){
		UniformGridCell returnvalue=new UniformGridCell();
		returnvalue.pointslist=pointslist.clone();
		returnvalue.nextpointer=nextpointer;
		return returnvalue;
	}
	public int GetFirst(){
		nextpointer=-1;
		return GetNext();
	}
	public int GetNext(){
		nextpointer++;
		if (nextpointer>=pointslist.length) return -1;
		else return pointslist[nextpointer];
	}
	public int GetLength(){
		return pointslist.length;
	} 
	public void Add(int add){
		if (pointslist.length!=0){
			int[] temp=new int[pointslist.length+1];
			for (int i=0;i<pointslist.length;i++)temp[i]=pointslist[i];
			temp[pointslist.length]=add;
			pointslist=temp.clone();
		}
		else {
			pointslist=new int[1];
			pointslist[0]=add;
		}
	} // end of method Add 
} // end of nested class UniformGridCell
}// end of class UniformGrid

