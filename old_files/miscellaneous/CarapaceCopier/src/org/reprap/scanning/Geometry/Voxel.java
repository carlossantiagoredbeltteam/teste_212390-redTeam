package org.reprap.scanning.Geometry;

import org.reprap.scanning.DataStructures.Image;
import org.reprap.scanning.DataStructures.MatrixManipulations;
import org.reprap.scanning.DataStructures.TrianglePlusVertexArray;
import javax.swing.JProgressBar;

import Jama.Matrix;

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
* Last modified by Reece Arnott 25th November 2010
*
* 
**********************************************************************************/

public class Voxel {
	private boolean outside,inside; // surface=(!outside) && (!inside)  Note that outside=true and inside=true is the initial but invalid setting
	private Point3d[] vertices;
	public Voxel[][][] SubVoxel;
	private int subvoxeldivision;
	
	
	public Voxel(){
		subvoxeldivision=0;
		vertices=new Point3d[0];
		SubVoxel=new Voxel[0][0][0];
		outside=true;
		inside=true;
		}
	public boolean isInside(){
		return (inside);
	}
	public boolean isOutside(){
		return outside;
	}
	public boolean isSurface(){
		return ((!outside) && (!inside));
	}
	
	private void setOutside(){
		outside=true;
		inside=false;
	}
	private void setInside(){
		outside=false;
		inside=true;		
	}
	private void setSurface(){
	outside=false;
	inside=false;
	}
	
	// Get the maximum size of the voxel dimensions
	public double getVoxelResolution(){
		Point3d min=vertices[0].clone();
		Point3d max=vertices[vertices.length-1].clone();
		double resolution=max.x-min.x;
		if (max.y-min.y>resolution) resolution=max.y-min.y;
		if (max.z-min.z>resolution) resolution=max.z-min.z;
		return resolution;
	}
	
	public void RestrictSubVoxelsToGroundedOnes(){
		// TODO - Add in to the Voxelise method? 
		boolean[][][] setToOutside;
		setToOutside=new boolean[subvoxeldivision][subvoxeldivision][subvoxeldivision];
		for (int x=0;x<subvoxeldivision;x++)
			for (int y=0;y<subvoxeldivision;y++)
				for (int z=0;z<subvoxeldivision;z++)
					setToOutside[x][y][z]=false;
		
		// Seed with the first level of subvoxels all having set to outside set to false
		// Don't have to do anything as above all are initialised anyway
		// TODO would it be better to seed with the voxels around the center of the first level rather than all voxels on the first level?
		//This would replace the assumption that the object is touching the calibration sheet with the assumption that the object is touching the center of the calibration sheet

	
	// Go through the levels of subvoxels and mark for deletion any surface or inside voxels that aren't connected to the level below.
		for (int z=1;z<subvoxeldivision;z++)
			for (int y=0;y<subvoxeldivision;y++)
				for (int x=0;x<subvoxeldivision;x++)
					if (!SubVoxel[x][y][z].isOutside()){
						// If all the voxels immediately below this one are outside voxels, set this one to be ignored
						boolean mark=true;
						int dz=-1;
						for (int dy=-1;dy<=1;dy++)
							for (int dx=-1;dx<=1;dx++)
								if (mark) if (((x+dx)<subvoxeldivision) && ((x+dx)>=0) && ((y+dy)<subvoxeldivision) && ((y+dy)>=0)){
										mark=(SubVoxel[x+dx][y+dy][z+dz].isOutside() || setToOutside[x+dx][y+dy][z+dz]);
							}
						setToOutside[x][y][z]=mark;
					} // end if not outside
//Now need to go through and do essentially a 3d flood fill for those voxels that are currently to be reset to outside.
// TODO replace this with eg 3D version of Quickfill?
// TODO test this with object that actually have overhangs!
boolean end=false;
	while (!end){ // Inside this while loop is what I call a sweep fill. The while loop may need to be run for each zig-zag change of direction in the object which may be wasteful.
		end=true;
//		 first go through in positive direction and unmark those that have an unmarked voxel neighbour
		for (int z=0;z<subvoxeldivision;z++)
			for (int y=0;y<subvoxeldivision;y++)
				for (int x=0;x<subvoxeldivision;x++)
					if (setToOutside[x][y][z]) {
						boolean unmark=false;
						for (int dz=-1;dz<=1;dz++)
							for (int dy=-1;dy<=1;dy++)
								for (int dx=-1;dx<=1;dx++) 
									if (!unmark) if (((x+dx)<subvoxeldivision) && ((x+dx)>=0) && ((y+dy)<subvoxeldivision) && ((y+dy)>=0) && ((z+dz)<subvoxeldivision) && ((z+dz)>=0) && (!((dx==0) && (dy==0) && (dz==0)))){
										unmark=((!SubVoxel[x+dx][y+dy][z+dz].isOutside()) && (!setToOutside[x+dx][y+dy][z+dz]));
									}
						if (unmark){
							setToOutside[x][y][z]=false;
							end=false;
						}
					} // end if set to outside
//		 now go through in negative direction and unmark those that have an unmarked voxel neighbour
		for (int z=(subvoxeldivision-1);z>=0;z--)
			for (int y=(subvoxeldivision-1);y>=0;y--)
				for (int x=(subvoxeldivision-1);x>=0;x--)
					if (setToOutside[x][y][z]) {
						boolean unmark=false;
						for (int dz=-1;dz<=1;dz++)
							for (int dy=-1;dy<=1;dy++)
								for (int dx=-1;dx<=1;dx++) 
									if (!unmark) if (((x+dx)<subvoxeldivision) && ((x+dx)>=0) && ((y+dy)<subvoxeldivision) && ((y+dy)>=0) && ((z+dz)<subvoxeldivision) && ((z+dz)>=0) && (!((dx==0) && (dy==0) && (dz==0)))){
										unmark=((!SubVoxel[x+dx][y+dy][z+dz].isOutside()) && (!setToOutside[x+dx][y+dy][z+dz]));
									}
						if (unmark){
							setToOutside[x][y][z]=false;
							end=false;
						}
					} // end if set to outside
	} // end while loop
		// Finally reset to outside those voxels that have been marked as needing it
		for (int z=1;z<subvoxeldivision;z++)
			for (int y=0;y<subvoxeldivision;y++)
				for (int x=0;x<subvoxeldivision;x++)
					if (setToOutside[x][y][z]){
						SubVoxel[x][y][z].setOutside();
						} // end if set to outside
	} // end method
	
	// The SubVoxel array is a 3D array with each dimension having the same number of elements so can be characterised by just this one number.
	public int getSubVoxelArraySize(){
		return subvoxeldivision;
	}
	public AxisAlignedBoundingBox getSubVoxel(int x, int y, int z){
		
		if ((x<0) || (x>=subvoxeldivision) || (y<0) || (y>=subvoxeldivision) || (z<0) || (z>=subvoxeldivision)) return new AxisAlignedBoundingBox();
		else {
			Point3d min=vertices[VertexTo1DIndex(x,y,z)].clone();
			Point3d max=vertices[VertexTo1DIndex(x+1,y+1,z+1)].clone();
			AxisAlignedBoundingBox returnvalue=new AxisAlignedBoundingBox();
			returnvalue.minx=min.x;
			returnvalue.miny=min.y;
			returnvalue.minz=min.z;
			returnvalue.maxx=max.x;
			returnvalue.maxy=max.y;
			returnvalue.maxz=max.z;
			return returnvalue;
		}
	}
	public AxisAlignedBoundingBox[] getSurfaceVoxels(){
		// Count up how many there are
		int surfacesubvoxels=0;
		for (int z=0;z<subvoxeldivision;z++)
			for (int y=0;y<subvoxeldivision;y++)
				for (int x=0;x<subvoxeldivision;x++)
					if (SubVoxel[x][y][z].isSurface()) surfacesubvoxels++;
		AxisAlignedBoundingBox[] returnvalue=new AxisAlignedBoundingBox[surfacesubvoxels];
		int count=0;
		for (int z=0;z<subvoxeldivision;z++)
			for (int y=0;y<subvoxeldivision;y++)
				for (int x=0;x<subvoxeldivision;x++)
					if (SubVoxel[x][y][z].isSurface()){
						returnvalue[count]=getSubVoxel(x,y,z);
						count++;
					}
		return returnvalue;
	}
	
//	 This should be called from a while progressbar != max type loop
	public JProgressBar Voxelise(Image[] images,AxisAlignedBoundingBox volumeofinterest, int subdivision, JProgressBar bar){
		
		if (bar.getValue()==bar.getMinimum()){
			bar.setMaximum(subdivision);
			subvoxeldivision=subdivision;
			double stepx=(volumeofinterest.maxx-volumeofinterest.minx)/subdivision;
			double stepy=(volumeofinterest.maxy-volumeofinterest.miny)/subdivision;
			double stepz=(volumeofinterest.maxz-volumeofinterest.minz)/subdivision;
			// Create the subvoxel array and vertex array and initialise
			vertices=new Point3d[VertexTo1DIndex(subdivision,subdivision,subdivision)+1];
			SubVoxel=new Voxel[subdivision][subdivision][subdivision];
			for (int z=0;z<=subdivision;z++) {
				double zvalue=(z*stepz)+volumeofinterest.minz;
				for (int y=0;y<=subdivision;y++){ 
						double yvalue=(y*stepy)+volumeofinterest.miny;
						for (int x=0;x<=subdivision;x++){
							double xvalue=(x*stepx)+volumeofinterest.minx;
							if ((x<subdivision) && (y<subdivision) && (z<subdivision)) SubVoxel[x][y][z]=new Voxel();
							vertices[VertexTo1DIndex(x,y,z)]=new Point3d(xvalue,yvalue,zvalue);
							}
					}
				}
		} // end if bar.value=min
		// Find the boolean value for each vertex
		if (bar.getValue()!=bar.getMaximum()){
			int z=bar.getValue();
			for (int y=0;y<=subdivision;y++){
				for (int x=0;x<=subdivision;x++){
					Point3d point=vertices[VertexTo1DIndex(x,y,z)].clone();
					boolean voxelisoutside=false; // Start with the assumption that the voxel is to be defined as inside
					// Check to see if the point projects to a proccessed pixel (at this point thats just the calibration sheet) in any image
					for (int j=0; j<images.length;j++)  if (!images[j].skipprocessing) if (!voxelisoutside) voxelisoutside=!images[j].PointIsUnprocessed(point);
					// Update the vertex for up to 8 different voxels
						// To keep track of things we will use 3 combinations of 3 pairs: left/right (x), front/back (y) and top/bottom (z)
						// The voxels are numbered compared to the vertices based on the left front bottom vertex
						
						//outside = outside && voxelisoutside
						//inside = inside && !voxelisoutside
						if ((x<subdivision) && (y<subdivision) && (z<subdivision)) UpdateInOut(x,y,z,voxelisoutside);// left front bottom  
						if ((x<subdivision) && (y>0) && (z<subdivision)) UpdateInOut(x,y-1,z,voxelisoutside);// left back bottom
						if ((x>0) && (y<subdivision) && (z<subdivision)) UpdateInOut(x-1,y,z,voxelisoutside); // right front bottom
						if ((x>0) && (y>0) && (z<subdivision)) UpdateInOut(x-1,y-1,z,voxelisoutside); // right back bottom
						if ((x<subdivision) && (y<subdivision) && (z>0)) UpdateInOut(x,y,z-1,voxelisoutside); // left front top  
						if ((x<subdivision) && (y>0) && (z>0)) UpdateInOut(x,y-1,z-1,voxelisoutside); // left back top
						if ((x>0) && (y<subdivision) && (z>0)) UpdateInOut(x-1,y,z-1,voxelisoutside); // right front top
						if ((x>0) && (y>0) && (z>0)) UpdateInOut(x-1,y-1,z-1,voxelisoutside); // right back top
				} // end for x
			} // end for y
			bar.setValue(bar.getValue()+1);
		} // end if bar value != max
		
		if (bar.getValue()==bar.getMaximum()){
			// Potentially reclassify an inside voxel to surface if it has an outside voxel as a neighbour
			for (int z=0;z<subdivision;z++)
					for (int y=0;y<subdivision;y++)
							for (int x=0;x<subdivision;x++)
								if (SubVoxel[x][y][z].isInside()){
									// Check the voxel that ajoins each face
									for (int i=0;i<6;i++){
										int dx=0;
										int dy=0;
										int dz=0;
										switch(i){
										case 0: dx=-1;break;
										case 1: dx=1; break;
										case 2: dy=-1;break;
										case 3: dy=1; break;
										case 4: dz=-1;break;
										case 5: dz=1; break;
										} // end swich
										// If the voxel is at an edge set it to surface
										if ((x+dx<0) || (x+dx>=subdivision) || (y+dy<0) || (y+dy>=subdivision) || (z+dz<0) || (z+dz>=subdivision)) SubVoxel[x][y][z].setSurface();
										else if (SubVoxel[x+dx][y+dy][z+dz].isOutside()) SubVoxel[x][y][z].setSurface(); // else set to surface if a neighbour is outside
									} // end for i
								} // end if
											
		} // end if bar value = max
			return bar;
	} // end of SubDivideVoxel method

	// TODO add recursion?
	public  TrianglePlusVertexArray ConvertSurfaceVoxelsToTriangles(JProgressBar bar){
		bar.setMinimum(0);
		bar.setMaximum(subvoxeldivision);
		TrianglePlusVertexArray returnvalue=new TrianglePlusVertexArray(vertices);
		for (int z=0;z<subvoxeldivision;z++){
			bar.setValue(z);
			for (int y=0;y<subvoxeldivision;y++)
					for (int x=0;x<subvoxeldivision;x++)
						if (SubVoxel[x][y][z].isSurface()){
							Point3d center=getSubVoxel(x,y,z).GetMidpointof3DBoundingBox();
							// Extract the 6 faces, each having the four corners in order, either clockwise or anti clockwise (so that quad 1 and 2 are on opposite edges of the face) as well as the neighbours
							for (int i=0;i<6;i++){
								int neighbourx=x;
								int neighboury=y;
								int neighbourz=z;
								int[] quads=new int[4];
								switch (i){
								case 0: //left face
									quads[0]=VertexTo1DIndex(x,y,z);
									quads[1]=VertexTo1DIndex(x,y+1,z);
									quads[2]=VertexTo1DIndex(x,y+1,z+1);
									quads[3]=VertexTo1DIndex(x,y,z+1);
									neighbourx--;
									break;
								case 1: // right face
									quads[0]=VertexTo1DIndex(x+1,y,z);
									quads[1]=VertexTo1DIndex(x+1,y+1,z);
									quads[2]=VertexTo1DIndex(x+1,y+1,z+1);
									quads[3]=VertexTo1DIndex(x+1,y,z+1);
									neighbourx++;
									break;
								case 2: // top
									quads[0]=VertexTo1DIndex(x,y,z+1);
									quads[1]=VertexTo1DIndex(x,y+1,z+1);
									quads[2]=VertexTo1DIndex(x+1,y+1,z+1);
									quads[3]=VertexTo1DIndex(x+1,y,z+1);
									neighbourz++;
									break;
								case 3: // bottom
									quads[0]=VertexTo1DIndex(x,y,z);
									quads[1]=VertexTo1DIndex(x,y+1,z);
									quads[2]=VertexTo1DIndex(x+1,y+1,z);
									quads[3]=VertexTo1DIndex(x+1,y,z);
									neighbourz--;
									break;
								case 4: //front
									quads[0]=VertexTo1DIndex(x,y,z);
									quads[1]=VertexTo1DIndex(x+1,y,z);
									quads[2]=VertexTo1DIndex(x+1,y,z+1);
									quads[3]=VertexTo1DIndex(x,y,z+1);
									neighboury--;
									break;
								case 5: //back
									quads[0]=VertexTo1DIndex(x,y+1,z);
									quads[1]=VertexTo1DIndex(x+1,y+1,z);
									quads[2]=VertexTo1DIndex(x+1,y+1,z+1);
									quads[3]=VertexTo1DIndex(x,y+1,z+1);
									neighboury++;
									break;
								}
								// Check if at edge of volume or neighbour isOutside
								boolean add=((neighbourx<0) || (neighbourx>=subvoxeldivision) || (neighboury<0) || (neighboury>=subvoxeldivision) || (neighbourz<0) || (neighbourz>=subvoxeldivision));
								if (!add) add=SubVoxel[neighbourx][neighboury][neighbourz].isOutside();
								// If applicable convert the four corner vertices into 2 triangles and add to list
								if (add){
									TriangularFace tri1=new TriangularFace(quads[0],quads[1],quads[2]);
									TriangularFace tri2=new TriangularFace(quads[0],quads[2],quads[3]);
									tri1.CalculateNormalAwayFromPoint(vertices,center);
									tri2.CalculateNormalAwayFromPoint(vertices,center);
									returnvalue.AddTriangle(tri1);
									returnvalue.AddTriangle(tri2);
								}// end if add
							} // end for
							} // end if
		
		} // end for z
		returnvalue.PurgeIrreleventVertices();
		return returnvalue;
		
	}
	
	
	
	//	outside = outside && skip
	//inside = inside && !skip
	
	private void UpdateInOut(int x,int y, int z, boolean skip){
		SubVoxel[x][y][z].outside=SubVoxel[x][y][z].outside && (skip);
		SubVoxel[x][y][z].inside=SubVoxel[x][y][z].inside && (!skip);
	}
	private int VertexTo1DIndex(int x, int y, int z){
		return (x+(y*(subvoxeldivision+1))+(z*(subvoxeldivision+1)*(subvoxeldivision+1)));
	}
	
}
