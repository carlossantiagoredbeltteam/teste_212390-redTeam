package org.reprap.scanning.FeatureExtraction;
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
* Last modified by Reece Arnott 27th May 2010
*
* This class uses a modified version of the ADM (Absolute Difference Mask) algorithm to extract edges along with edge strength and direction values.
*  The modifications are described in "A robust, real-time ellipse detector" by Zhang, S.C. and Liu, Z.Q.in Pattern Recognition Volume 38, Issue 2, February 2005, Pages 273-287
*  available for download at http://dx.doi.org/10.1016/j.patcog.2004.03.014
*  with the original reference not available outside a pay-wall but a brief 2 page conference proceedings summary available called "A real-time high performance edge detector for computer vision applications"
*  by F Alzahrani, T Chen from The 1997 Asia and South Pacific Design Automation Conference, ASP-DAC; Chiba; Jpn; 28-31 Jan. 1997. pp. 671-672. 1997  
*  downloadable at http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.57.5146&rep=rep1&type=pdf
*  
*  
*  
*A brief outline of edge finding steps is as follows:
*	1. Take as input a greyscale image - preprocessed by CalibratedImage ReadImageFromFile
*	2. Apply semi-gaussian smoothing to minimise the effect of random noise (modified from the original ADM mask for better smoothing) - optional preprocessing step by CalibratedImage ReadImageFromFile
* 	3. Calculate edge-strength and direction at each pixel - Constructor
* 	4. Optionally apply non-maximal suppression and a threshold to determine the final edge - NonMaximalLocalSuppressionAndThresholdStrengthMap
*	5. Optionally post process to get rid of spurious points (i.e. completely connected and isolated points) - RemoveSpuriousPoints method
*
*	The first two steps are assumed to have already been done in a pre-processing stage when reading the image in.
*	
************************************************************************************/
import org.reprap.scanning.DataStructures.Image;
import org.reprap.scanning.DataStructures.MatrixManipulations;
import org.reprap.scanning.Geometry.*;

import Jama.Matrix;

public class EdgeExtraction2D {
	enum direction {diagonalrighttoptoleftbottom,horizontal,diagonallefttoptorightbottom,vertical}; // In the FindEllipses class ConvexDirectionWithinLimits method it is assumed these directions are in order so don't change! 

	
	private int height;
	private int width;
	private byte[][] strengthmap;
	private direction[][] directionmap;
	private int edgecount;
	private int threshold;
	
	// Constructors
	// normally used by clone method
	public EdgeExtraction2D(){
		height=0;
		width=0;
		strengthmap=new byte[0][0];
		directionmap=new direction[0][0];
		edgecount=0;
		threshold=0;
		
	}
	
	public EdgeExtraction2D(Image image){
		edgecount=0; 
		threshold=0;
		height=image.height;
		width=image.width;
		byte[][] imagemap=image.ExportImageMap(); //The image map is currently the greyscale values of the blurred image
		// This is used as the source to create the edge strength, direction and convexity maps.
		strengthmap=new byte[width][height];
		directionmap=new direction[width][height];
		int[] strength=new int[direction.values().length];
		for (int x=0;x<width;x++){
			for (int y=0;y<height;y++){
				// Calculate the strengths of the edges in the four directions
				// In each case it is the absolute value of (the sum of the absolute difference of the two pixels to one side in that direction) minus (the sum of the difference of the two pixels to one side)  
				int currentvalue=GetValue(x,y,imagemap);
				strength[direction.valueOf("horizontal").ordinal()]=Math.abs(Math.abs(currentvalue-GetValue(x-2,y,imagemap))+Math.abs(currentvalue-GetValue(x-1,y,imagemap))-Math.abs(currentvalue-GetValue(x+2,y,imagemap))-Math.abs(currentvalue-GetValue(x-1,y,imagemap)));
				strength[direction.valueOf("vertical").ordinal()]=Math.abs(Math.abs(currentvalue-GetValue(x,y-2,imagemap))+Math.abs(currentvalue-GetValue(x,y-1,imagemap))-Math.abs(currentvalue-GetValue(x,y+2,imagemap))-Math.abs(currentvalue-GetValue(x,y+1,imagemap)));
				strength[direction.valueOf("diagonalrighttoptoleftbottom").ordinal()]=Math.abs(Math.abs(currentvalue-GetValue(x-2,y+2,imagemap))+Math.abs(currentvalue-GetValue(x-1,y+1,imagemap))-Math.abs(currentvalue-GetValue(x+2,y-2,imagemap))-Math.abs(currentvalue-GetValue(x+1,y-1,imagemap)));
				strength[direction.valueOf("diagonallefttoptorightbottom").ordinal()]=Math.abs(Math.abs(currentvalue-GetValue(x+2,y+2,imagemap))+Math.abs(currentvalue-GetValue(x+1,y+1,imagemap))-Math.abs(currentvalue-GetValue(x-2,y-2,imagemap))-Math.abs(currentvalue-GetValue(x-1,y-1,imagemap)));
				// Now find which is the maximum, half of this value is the strength value
				// The direction is the direction of the minimum strength
				int maxstrength=0;
				int dir=0;
				for (int i=0;i<strength.length;i++){
					if (strength[i]<strength[dir]) dir=i;
					if (strength[i]>maxstrength) maxstrength=strength[i];
				} // end for i
				// In theory the strength could take any of the 512 values between 0 and 255 in steps of 0.5
				// In practice we don't really care about that 1/2 step so it is ignored and the int converted to a byte and slotted into a byte array
				// We store the whole strengthmap as well as the thresholded one in case we need to refer to it later.
				maxstrength=maxstrength/2;
				strengthmap[x][y]=(byte)(maxstrength & 0xff);
				directionmap[x][y]=direction.values()[dir];
				if (maxstrength!=0) edgecount++;	
			} // end for y
		} // end for x
	}
	
	public EdgeExtraction2D clone(){
		EdgeExtraction2D returnvalue=new EdgeExtraction2D();
		returnvalue.height=height;
		returnvalue.width=width;
		returnvalue.strengthmap=new byte[width][height];
		returnvalue.directionmap=new direction[width][height];
		for (int x=0;x<width;x++) for (int y=0;y<height;y++){
			returnvalue.strengthmap[x][y]=strengthmap[x][y];
			returnvalue.directionmap[x][y]=directionmap[x][y];
		}
		returnvalue.edgecount=edgecount;
		returnvalue.threshold=threshold;
		return returnvalue;
	}
	public void NonMaximalLocalSuppressionAndThresholdStrengthMap(int newthreshold){
		threshold=newthreshold;
		byte[][] thresholdedstrengthmap=new byte[width][height];
		for (int x=0;x<width;x++){
			for (int y=0;y<height;y++){
				int edge=GetValue(x,y,strengthmap);
				// Look in the 3x3 neighbourhood and if it isn't the maximum, suppress it
				boolean suppress=false;
				for (int dx=-1;dx<=1;dx++){
					for (int dy=-1;dy<=1;dy++){
						if (!((dx==0) && (dy==0))) if (GetValue(x+dx,y+dy,strengthmap)>edge) suppress=true;
					} // end for dy
				} // end for dx
				if (edge<threshold) suppress=true;
				if (suppress) {
					if (GetValue(x,y,strengthmap)!=0) edgecount--;
					thresholdedstrengthmap[x][y]=(byte)(0 & 0xff);
					
				}
				else thresholdedstrengthmap[x][y]=strengthmap[x][y];
			} // end for y
		} // end for x
		strengthmap=thresholdedstrengthmap.clone();
	} // end method
	
	
	public byte[][] GetStrengthMap(){
		return strengthmap;
	}
	
	public int GetWidth(){
		return width;
	}
	public int GetHeight(){
		return height;
	}
	
	public int GetEdgeCount(){
		return edgecount;
	}
	
	// This basically returns the array row and column value for each edge point
	public Point2d[] GetEdgePoints(){
		return GetEdgePoints(new Point2d(0,0));
	}
	// This converts the array row and column value for each edge point into a 2d point based on the offset passed
	public Point2d[] GetEdgePoints(Point2d imageoffset){
		Point2d[] returnvalue=new Point2d[edgecount];
		int index=0;
		for (int x=0;x<width;x++){
			for (int y=0;y<height;y++){
				int edge=GetValue(x,y,strengthmap);
				if (edge!=0) {
					returnvalue[index]=new Point2d(x,y);
					returnvalue[index].minus(imageoffset);
					index++;
				} // end if
			} // end for y
		} // end for x
		return returnvalue;
	}
	
	public int GetEdgeStrength(int x, int y){
		return GetValue(x,y,strengthmap);
	}
	public int GetDirection(int x, int y){
		if (GetValue(x,y,strengthmap)==0) return -1;
		else return directionmap[x][y].ordinal();
	}
	
	public double GetResolution(){
		// If an edge is detected it may be detected on both the left and right of the line in which case the pixels may be up to 5 pixels away from each other
		// Simply due to the nature of the algorithm we are getting information about an edge from the 3x3 neighbourhood so an edge pixel within a distance of 5 pixels
		// shares overlapping pixels in their 3x3 neighbourhood.
		return 5; 
	}
	
	public void RemoveSpuriousPoints(){
		byte[][] returnvalue=new byte[width][height];
		int ignoreedgesoutto=4;
		for (int x=0;x<width;x++){
			for (int y=0;y<height;y++) if (GetValue(x,y,strengthmap)!=0){
				// If the point is at the edge of the image it will have been set as an edge, just ignore these points 
				if  ((x<ignoreedgesoutto) || (x>=(width-ignoreedgesoutto)) || (y<ignoreedgesoutto) || (y>=(height-ignoreedgesoutto))) {
					returnvalue[x][y]=(byte)(0 & 0xff);
					edgecount--;
				}
				else {
				// Ignore if the edge point is within 3 of the edge
				// Check within a 3x3 window to see if the point is isolated (no other edge points within a 3x3 window) or excessively connected.
				// Connected means there is another edge point <sqrt(2) away. For an excessively connected one, there are 3.  
					//boolean isolated=true;
					int excessivecount=0;
					for (int dx=-1;dx<=1;dx++){
						for (int dy=-1;dy<=1;dy++){
							if (!((dx==0) && (dy==0))){
								boolean edge=(GetValue(x+dx,y+dy,strengthmap)!=0);
								if (edge) {
									//isolated=false;
									// check if it is within sqrt(2) away
									if (((dx*dx)+(dy*dy))<2) excessivecount++;
								} // end if edge
							} // end if !(dx==0 and dy==0)
						} // end for dy
					} // end for dx
					//TODO remove or add back in the correct if statement(s)
					//if ((isolated) || (excessivecount>=3)) {	returnvalue[x][y]=(byte)(0 & 0xff); edgecount--;}
					//if (isolated) {returnvalue[x][y]=(byte)(0 & 0xff); edgecount--;}
					//else 
						if  (excessivecount>=3) 	{ returnvalue[x][y]=(byte)(0 & 0xff); edgecount--;}
					else 
						returnvalue[x][y]=strengthmap[x][y];
				} // end else
			} // end if strength!=0
		} // end for x
	strengthmap=returnvalue.clone();
	} // end of method
	
		public void LimitToEdgeRaysThatIntersectAVolumeOfInterest(AxisAlignedBoundingBox boundingvolume, AxisAlignedBoundingBox[] volumeofinterest, Matrix P, Point2d imageoffset){
		// Note that it is assumed that the bounding volume is a precalculated maximum volume that encompasses all of the volumes of interest.	
		//Precalculate the camera centre point and the psuedo-inverse of the camera matrix as they will be used for the constructed lines later
		Point3d C=new Point3d(new MatrixManipulations().GetRightNullSpace(P));
		Matrix Pplus=new MatrixManipulations().PseudoInverse(P); 
		// If the camera centre is in the volume of interest all the rays will obviously intersect so we don't need to continue
		boolean intersect=false;
		int i=0;
		if (boundingvolume.PointInside3DBoundingBox(C)){
			while ((!intersect) && (i<volumeofinterest.length)){
				intersect=volumeofinterest[i].PointInside3DBoundingBox(C);
				i++;
			} // end while 
		} // end if
		if (!intersect){
			// Go through each edge point and construct a line for it based on the camera matrix pseudoinverse and camera centre
			// Then see if that line intersects the volume of interest
			for (int x=0;x<width;x++){
				for (int y=0;y<height;y++){
					int edge=GetValue(x,y,strengthmap);
					if (edge!=0) {
						Point2d point=new Point2d(x,y);
						point.minus(imageoffset);
						//Line3d l=new Line3d(point,Pplus,C);
						Line3d l=new Line3d(C,Pplus,point);
						intersect=false;
						i=0;
						if (boundingvolume.Intersects(l)){
							while ((!intersect) && (i<volumeofinterest.length)){
								intersect=volumeofinterest[i].Intersects(l);
								i++;
							} // end while
						} // end if
						if (!intersect){
							strengthmap[x][y]=(byte)(0 & 0xff);
							edgecount--;
						} // end if not intersect
					} // end if edge!=0
				} // end for y
			} // end for x
		} // end if C not inside the volumes of interest
	}
	
	public void ApplyMask(boolean[][] mask){
		// TODO make sure mask is same size as edgemap
		for (int x=0;x<width;x++)
			for (int y=0;y<height;y++) if (GetValue(x,y,strengthmap)!=0){
				if (!mask[x][y]) {
					strengthmap[x][y]=(byte)(0 & 0xff);
					edgecount--;
				} // end if !mask
			} // end if strengthmap!=0
	} // end ApplyMask method
	
	public void BlankEdgePixel(int x,int y){
		if (GetValue(x,y,strengthmap)!=0){
			strengthmap[x][y]=(byte)(0 & 0xff);
			edgecount--;
		} // end if strengthmap!=0
	}
	
	public int GetThreshold(){
		return threshold;
	}
	
		
	
	
	/******************************************************************************************************************************************
	 * 
	 * Private methods from here on down
	 * 
	 *********************************************************************************************************************************************/
	
	// This is used to retrieve a greyscale value from a byte array. It is assumed the byte array has the same dimensions as the image in the constructor
	private int GetValue(int x, int y, byte[][] bytearray){
		if ((x>=0) && (x<width) && (y>=0) && (y<height))return (int)(bytearray[x][y] & 0xff);
		else return 0;
	} // end of method
	
	
	
	
} // end of class
