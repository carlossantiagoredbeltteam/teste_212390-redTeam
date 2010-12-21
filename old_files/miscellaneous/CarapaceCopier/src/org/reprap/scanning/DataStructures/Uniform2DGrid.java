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
* Last modified by Reece Arnott 21st December 2010
*
*	This class takes an array of points and splits the 2d space into a 2d cell structure and stores the indexes for the array in each cell.
*	 TODO - This class may benefit from using  unconstrained ArrayList rather than fixed length array.
* 
* 
***********************************************************************************/

import org.reprap.scanning.Geometry.Point2d;
import org.reprap.scanning.Geometry.AxisAlignedBoundingBox;
import org.reprap.scanning.Geometry.Point3d;

public class Uniform2DGrid{
	public Uniform2DGridCell[][] Grid;
	private AxisAlignedBoundingBox boundary; // not used if only one cell
	private double side; // this defines the size of a cell. Not used if only one cell
	public int arraysizex,arraysizey; // these store the length of the 2d arrays 
	// Constructors
	public Uniform2DGrid(Point2d[] p,int m){ // m is the minimum number of cells to divide the space into
		int[] subsetofindexes=new int[p.length];
		for (int i=0;i<p.length;i++) subsetofindexes[i]=i;
		init(p,subsetofindexes,m);
	}

	public Uniform2DGrid(Point2d[] p,int[] subsetofindexes, int m){ // m is the minimum number of cells to divide the space into
		init(p,subsetofindexes,m);		
	}	
			
	private void init(Point2d[] p,int[] subsetindexes, int m){	
		if (m<2){  // don't worry about an accurate grid if there are only a few points
			arraysizex=1;
			arraysizey=1;
			Grid=new Uniform2DGridCell[1][1];
			Grid[0][0]=new Uniform2DGridCell();
			Grid[0][0].pointslist=new int[p.length];
			for (int i=0;i<p.length;i++) Grid[0][0].pointslist[i]=i;
			
		}
		else {
//			 First Find the bounding box
			boundary=new AxisAlignedBoundingBox();
			for (int i=0;i<subsetindexes.length;i++){
					if (i==0){
					boundary.minx=p[subsetindexes[0]].x;
					boundary.miny=p[subsetindexes[0]].y;
					boundary.minz=0;
					boundary.maxx=p[subsetindexes[0]].x;
					boundary.maxy=p[subsetindexes[i]].y;
					boundary.maxz=0;
				}
				else boundary.Expand2DBoundingBox(p[i]);if (p[i].x<boundary.minx) boundary.minx=p[i].x;
					
			}
			// Now divide up the space into 2d cells
			double area=(boundary.maxx-boundary.minx)*(boundary.maxy-boundary.miny);
			side=Math.pow((area/(double)m),0.5);
			// How many cells in x and y directions
			arraysizex=(int)Math.ceil((boundary.maxx-boundary.minx)/side);
			arraysizey=(int)Math.ceil((boundary.maxy-boundary.miny)/side);
			// Adjust the bounding box out to have all the points within them.
			double xoffset=(arraysizex*side)-(boundary.maxx-boundary.minx);
			double yoffset=(arraysizey*side)-(boundary.maxy-boundary.miny);
			boundary.minx=boundary.minx-(xoffset/2);
			boundary.miny=boundary.miny-(yoffset/2);
			boundary.maxx=boundary.maxx+(xoffset/2);
			boundary.maxy=boundary.maxy+(yoffset/2);
			// Create the Grid array
			Grid=new Uniform2DGridCell[arraysizex][arraysizey];
			for (int i=0;i<arraysizex;i++)
				for (int j=0;j<arraysizey;j++)
						Grid[i][j]=new Uniform2DGridCell();
			// Now load the points into it
			for (int i=0;i<subsetindexes.length;i++){
				int x=(int)((p[subsetindexes[i]].x-boundary.minx)/side);
					int y=(int)((p[subsetindexes[i]].y-boundary.miny)/side);
					Grid[x][y].Add(i);
				}
			}	// end else
	} // end of constructor
	
		
	public int[] GetClosestPoints(Point2d target){
		// Find the grid cell containing the target point and return the indexes for it 
		if ((arraysizex==1) && (arraysizey==1)) return Grid[0][0].pointslist;
		else {
			if ((target.x<=boundary.maxx) && (target.x>=boundary.minx) && (target.y<=boundary.maxy) && (target.y>=boundary.miny)){
				int x=(int)((target.x-boundary.minx)/side);
				int y=(int)((target.y-boundary.miny)/side);
				int[] returnvalue=new int[0];
				int radius=1;
				boolean exit=false;
				// If the current set of cells is empty expand our catchment area from 9 to 25 to 49 etc.
				while ((returnvalue.length==0) && (!exit)){
					for (int dx=x-radius;dx<=x+radius;dx++){
						for (int dy=y-radius;dy<=y+radius;dy++){
							if ((dx>=0) && (dx<arraysizex) && (dy>=0) && (dy<arraysizey)){
								if (Grid[dx][dy].GetLength()!=0){
									// Add these indexes to the returnvalue array
									int[] newreturnvalue=new int[returnvalue.length+Grid[dx][dy].GetLength()];
									for (int i=0;i<returnvalue.length;i++) newreturnvalue[i]=returnvalue[i];
									for (int i=0;i<Grid[dx][dy].GetLength();i++) newreturnvalue[i+returnvalue.length]=Grid[dx][dy].pointslist[i];
									returnvalue=newreturnvalue.clone();
								}
							}
							else exit=true;
						} // end for dy
					} // end for dx
					radius++;	
				} // end while
				return returnvalue;
				}
		else {
			int[] returnvalue=new int[1];
			returnvalue[0]=-1;
			return returnvalue;
		}
		}
	}

// This is a nested class. Just used within this class.
class Uniform2DGridCell{
	private int[] pointslist;
	
	public Uniform2DGridCell(){
		pointslist=new int[0];
	}
	public Uniform2DGridCell clone(){
		Uniform2DGridCell returnvalue=new Uniform2DGridCell();
		returnvalue.pointslist=pointslist.clone();
		return returnvalue;
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

