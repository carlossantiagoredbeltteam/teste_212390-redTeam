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
 * Last modified by Reece Arnott 25th November 2010
 * 
 *  Steps to do 3D edge detection:
 *  	- Construct fundamental matrix and from that get image rectification homographies (y coordinates are lined up for corresponding 3d points)
 *  	- search rectangle created around epipolar line to find the closest match. With the above step this is simply searching a small strip (i.e. all x coordinates but only a small subset of y) of the rectified image for the closest y coordinate
 *  	- Adjust the points so they exactly solve x'^TFx=0
 *  	- Set the 3d edge point using these adjusted points
 *		- another criteria is distance from camera, use the first match as the others would be occluded TODO
 *		- Check against already found 3d edge points and either perturb them or add another point. TODO
 *
 ********************************************************************************/  
import Jama.*;

import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.DataStructures.Image;
import org.reprap.scanning.DataStructures.MatrixManipulations;
import org.reprap.scanning.DataStructures.QuickSortPoints2D;
// No real error checking to make sure the array is not full! Just used for in the EdgeExtraction3D class to make things tidier
class EstimatedPoint{
	private int maximumpoints;
	private int currentpoints;
	private Point2d[] points;
	private Matrix[] P;
	private boolean[] sourcecameras;
	private Point3d estimatedpoint;
	boolean skip;
	public EstimatedPoint(int maxpoints,int maxcameras){
		maximumpoints=maxpoints;
		currentpoints=0;
		points=new Point2d[maximumpoints];
		sourcecameras=new boolean[maxcameras];
		for (int i=0;i<maxcameras;i++) sourcecameras[i]=false;
		P=new Matrix[maximumpoints];
		skip=false;
	}
	public boolean AddPoint(Point2d point,Matrix newP,int cameranumber){
		boolean returnvalue=(currentpoints<maximumpoints);
		if (returnvalue){
			points[currentpoints]=point.clone();
			P[currentpoints]=newP.copy();
			sourcecameras[cameranumber]=true;
			currentpoints++;
		}
		return returnvalue;
	}
	public void Estimate3dPoint(){
		estimatedpoint=new Point3d(new MatrixManipulations().Find3dPoint(points, P,currentpoints));
	}
	public void SetSkip(boolean value){
		skip=value;
	}
	public boolean[] GetSourceCameras(){
		return sourcecameras;
	}
	public Point3d GetEstimated3dPoint(){
		return estimatedpoint;
	}
	public boolean skip(int minnumberofpoints){
		if (minnumberofpoints<points.length) return (currentpoints<minnumberofpoints);
		else return (currentpoints==points.length);
	}
	public boolean skip(){
		return skip;
	}
}



public class EdgeExtraction3D {

	private Point2d[][] edges;
	private EstimatedPoint[][] estimated;
	private int[] numberofedges;
	private AxisAlignedBoundingBox[] visibleimage;
	private Matrix[] P;
	public AxisAlignedBoundingBox volumeofinterest;
	private int TotalPoints;
	
	//Constructor
	public EdgeExtraction3D(Image images[],AxisAlignedBoundingBox[] voxels){
		for (int i=0;i<voxels.length;i++) {
			if (i==0) volumeofinterest=voxels[i].clone();
			else volumeofinterest.Expand3DBoundingBox(voxels[i]);
		}
		numberofedges=new int[images.length];
		visibleimage=new AxisAlignedBoundingBox[images.length];
		P=new Matrix[images.length];
		int maxedges=0;
		for (int i=0;i<images.length;i++){
			images[i].LimitEdgesToRaysThatIntersectAVolumeOfInterest(volumeofinterest,voxels);
			numberofedges[i]=images[i].GetNumberofEdgePoints();
			if (numberofedges[i]>maxedges) maxedges=numberofedges[i];
			visibleimage[i]=new AxisAlignedBoundingBox();
			visibleimage[i].minz=0;
			visibleimage[i].maxz=0;
			visibleimage[i].minx=0-images[i].originofimagecoordinates.x;
			visibleimage[i].miny=0-images[i].originofimagecoordinates.y;
			visibleimage[i].maxx=images[i].width-images[i].originofimagecoordinates.x;
			visibleimage[i].maxy=images[i].height-images[i].originofimagecoordinates.y;
			P[i]=images[i].getWorldtoImageTransformMatrix().copy();
		}
		edges=new Point2d[images.length][maxedges];
		estimated=new EstimatedPoint[images.length][maxedges];
		for (int i=0;i<images.length;i++){
			Point2d[] edge=images[i].GetEdgePoints();
			for (int j=0;j<edge.length;j++){
				edges[i][j]=edge[j].clone();
				estimated[i][j]=new EstimatedPoint((images.length-1)*2,images.length);
			}
		}
	}
	
	public void CollectTriangulationInformationForEdgePoints(){
		for (int image1=0;image1<(visibleimage.length-1);image1++)
			  for (int image2=(image1+1);image2<visibleimage.length;image2++){
				  boolean[] skip=new boolean[numberofedges[image2]];
				  for (int i=0;i<skip.length;i++) skip[i]=false;
				  // First get the homographies to use to rectify the images
				  MatrixManipulations matrices=new MatrixManipulations();
				  // 	Calculate the fundamental matrix for these two images
				  matrices.SetF(P[image1],P[image2]);
				  // calculate the rectification homographies for each image taking into account not just the viewing planes but the visible portion of each plane 
				  Matrix[] Homographies=matrices.CalculateImageRectificationHomographies(visibleimage[image1],visibleimage[image2]);
				  Matrix H=Homographies[0].copy();
				  Matrix Hdash=Homographies[1].copy();
				  
				  // Create new arrays of 2d points transformed to the rectified coordinate system  
				  Point2d[] point1rectified=new Point2d[numberofedges[image1]];
				  Point2d[] point2rectified=new Point2d[numberofedges[image2]];
				  for (int i=0;i<point1rectified.length;i++){
					  point1rectified[i]=edges[image1][i].clone();
					  point1rectified[i].ApplyTransform(H);
				  }
				  for (int i=0;i<point2rectified.length;i++){
					  point2rectified[i]=edges[image2][i].clone();
					  point2rectified[i].ApplyTransform(Hdash);
				  }
		
				  //Process point1rectified in y order
				  QuickSortPoints2D qsort=new QuickSortPoints2D(point1rectified);
				  int[] indexes=qsort.SortbyY();
				  for (int ind=0;ind<indexes.length;ind++){
					  int i=indexes[ind];
					  // Only worry about those points with near identical y coordinates i.e. those that are nearly on the epipolar line
					  double ymax=point1rectified[i].y+0.1;
					  double ymin=point1rectified[i].y-0.1;
					  int match=-1;
					  double minydistance=ymax-ymin;
					  // Find the closest y correspondence within the search area
					  for (int j=0;j<point2rectified.length;j++){
						  if (!skip[j]) if ((point2rectified[j].y>=ymin) && (point2rectified[j].y<=ymax)){
							  if (Math.abs(point2rectified[j].y-point1rectified[i].y)<minydistance) {
								  minydistance=Math.abs(point2rectified[j].y-point1rectified[i].y);
								  match=j;
							  } // end if closer match
						  } // end if within search area
					  } // end for j
					  // If there was a match, deal with it
					  if (match!=-1) {
						  //Given a pair of points and the camera matrices we can estimate the 3d point but first we need to estimate the best points that exactly solve x'Fx=0
						  // See Algorithm 12.1 in Multiple View Geometery in Computer Vision, 2nd Edition by Richard Hartley and Andrew Zisserman 2003 for the optimal solution
						  // in first re-estimating the point pair.
						  Point2d point1=edges[image1][i].clone();
						  Point2d point2=edges[image2][match].clone();
						  // First create translations so the points are each at the origin in their respective frames and change the Fundamental matrix to reflect this 
						  Matrix T=new Matrix(3,3);
						  Matrix Tdash=new Matrix(3,3);
						  T.set(0,0,1);
						  T.set(1,1,1);
						  T.set(2,2,1);
						  T.set(0,2,-point1.x);
						  T.set(1,2,-point1.y);
						  Tdash.set(0,0,1);
						  Tdash.set(1,1,1);
						  Tdash.set(2,2,1);
						  Tdash.set(0,2,-point2.x);
						  Tdash.set(1,2,-point2.y);
						  Matrix F=Tdash.inverse().transpose().times(matrices.getF().times(T.inverse()));
						  // Find the epipoles and normalise them  i.e. e1^2+e2^2=1 where e=(e1,e2,e3) and e'1^2+e'2^2=1 where e'=(e'1,e'2,e'3)
						  // Use these to form rotation matrices and apply them to the Fundamental matrix
						  Matrix e=new MatrixManipulations().GetRightNullSpace(F);
						  Matrix edash=new MatrixManipulations().GetLeftNullSpace(F);
						  double escale=(e.get(0,0)*e.get(0,0))+(e.get(1,0)*e.get(1,0));
						  double edashscale=(edash.get(0,0)*edash.get(0,0))+(edash.get(1,0)*edash.get(1,0));
						  e.times(1/escale);
						  edash.times(1/edashscale);
					
						  Matrix R=new Matrix(3,3);
						  Matrix Rdash=new Matrix(3,3);
						  R.set(0,0,e.get(0,0));
						  R.set(0,1,e.get(1,0));
						  R.set(1,0,-e.get(1,0));
						  R.set(1,1,e.get(0,0));
						  R.set(2,2,1);
						  Rdash.set(0,0,edash.get(0,0));
						  Rdash.set(0,1,edash.get(1,0));
						  Rdash.set(1,0,-edash.get(1,0));
						  Rdash.set(1,1,edash.get(0,0));
						  Rdash.set(2,2,1);
						  F=Rdash.times(F.times(R.transpose()));
					

					// We want the minimal total squared distance error which now us given by the formula: (t^2/(1+f^2t^2))+(((ct+d)^2)/((at+b)^2+f'^2(ct+d)^2))
					// where we know a,b,c,d from F and f, and f' from e and e' and we want to find the minimum t value.
					// This is at one of the roots of the derivative i.e. 0=t((at+b)^2+f'^2(ct+d)^2)^2-(ad-bc)(1+f^2t^2)^2(at+b)(ct+d)
					// This is a sixth order polynomial which when expanded out has the following coefficients (C[n] is the coefficient for t^n)
					// C[0]=bd(bc-ad)
					// C[1]=(b^2+d^2f'^2)+(bc-ad)(bc+ad)
					// C[2]=2(b^2+d^2f'^2)(2ab+2cdf'^2)+(bc-ad)(bc+ad)
					// C[3]=2(a^2+c^2f'^2)(b^2+d^2f'^2)+(2ab+2cdf'^2)^2+(bc-ad)(ac+2bdf^2)
					// C[4]=2(2ab+2cdf'^2)(a^2+c^2f'^2)+(bc-ad)(bdf^4+2acf^2)
					// C[5]=(a^2+c^2f'^2)^2+(bc-ad)(bcf^4+adf^4)
					// C[6]=-(ad-bc)(acf^4)
					double a=F.get(1,1);
					double b=F.get(1,2);
					double c=F.get(2,1);
					double d=F.get(2,2);
					double f=e.get(2,0);
					double fdash=edash.get(2,0);
					// simple combinations to make the formulae easier:
					double bcminusad=(b*c)-(a*d);
					double bcplusad=(b*c)+(a*d);
					double bcadbcad=bcminusad*bcplusad;
					double bdfdash=(b*b)+(d*d*fdash*fdash);
					double acfdash=(a*a)+(c*c*fdash*fdash);
					double abcdfdash2=(2*a*b)+(2*c*d*fdash*fdash);
					double f4=f*f*f*f;
					double[] C=new double[7];
					C[0]=bcminusad*b*d;
					C[1]=bdfdash+bcadbcad;
					C[2]=(2*bdfdash*abcdfdash2)+(bcminusad*((a*c)+(2*b*d*f*f)));
					C[3]=(2*acfdash*bdfdash)+(abcdfdash2*abcdfdash2)+(bcadbcad*2*f*f);
					C[4]=(2*abcdfdash2*acfdash)+(bcminusad*((b*d*f4)+(2*a*c*f*f)));
					C[5]=(acfdash*acfdash)+(bcadbcad*f4);
					C[6]=bcminusad*a*c*f4;
					
					// Find the roots
					double[] roots=new MatrixManipulations().FindPolynomialRoots(C);
					// Find the one that has the minimal cost (including evaluating t=infinity i.e 1/f^2+c^2/(a^2+f'^2c^2))
					double tmin=Double.MAX_VALUE;
					double mincost=(1/(f*f))+((c*c)/((a*a)+(fdash*fdash*c*c)));
					for (int r=0;r<roots.length;r++){
						double t=roots[r];
						double ctdsquared=(c*t)+d;
						ctdsquared=ctdsquared*ctdsquared;
						double atbsquared=(a*t)+b;
						atbsquared=atbsquared*atbsquared;
						double cost=((t*t)/(1+(f*f*t*t)))+(ctdsquared/(atbsquared+(fdash*fdash*ctdsquared)));
						if (cost<mincost){
							mincost=cost;
							tmin=t;
						}
					}
					// evaluate the two lines l and l' at this tmin and find x and x' as the closest points on these lines to the origin
					//l=(tf,1,-t) and l'=F(0,t,1)^T or l'=(-f'(ct+d),at+b,ct+d)
					// if a line is (l1,l2,l3) the closest point to the origin is at (-l1l3,-l2l3,l1^2+l2^2)
					// so
					double l1=tmin*f;
					double l2=1;
					double l3=-1*tmin;
					Matrix x=new Matrix(3,1);
					x.set(0,0,-1*l1*l3);
					x.set(1,0,-1*l2*l3);
					x.set(2,0,-(l1*l1)+(l2*l2));
					l1=-1*fdash*((c*tmin)+d);
					l2=(a*tmin)+b;
					l3=(c*tmin)+d;
					Matrix xdash=new Matrix(3,1);
					xdash.set(0,0,-1*l1*l3);
					xdash.set(1,0,-1*l2*l3);
					xdash.set(2,0,-(l1*l1)+(l2*l2));
					
					// transfer back to original coordinates
					point1=new Point2d(T.inverse().times(R.transpose().times(x)));
					point2=new Point2d(Tdash.inverse().times(Rdash.transpose().times(xdash)));
					
					// Add these points to the array for estimating the 3d points
					estimated[image1][i].AddPoint(point1,P[image1],image1);
					estimated[image1][i].AddPoint(point2,P[image2],image2);
					skip[match]=true;
			} // end if match!=-1
		} // end for i
	} // end for image2
	} // end method
	
	// This calculates all the edge points and sets the skip variable if they are invalid.
	public void CalculateValid3DEdges(Image[] images, int minnumberofintersectingraypairs){
		TotalPoints=0;
		for (int index=0;index<images.length;index++){
		for (int i=0;i<numberofedges[index];i++){
			boolean valid=(!estimated[index][i].skip(minnumberofintersectingraypairs*2));
			if (valid) { // If there is any point to estimate, do so	
				estimated[index][i].Estimate3dPoint();
				Point3d value=estimated[index][i].GetEstimated3dPoint();
				// Make sure the point is inside the volume of interest
				valid=volumeofinterest.PointInside3DBoundingBox(value);
				// Check the point is designated as part of the object for each image
				for (int j=0; j<images.length;j++)  if (!images[j].skipprocessing) if (valid) valid=images[j].PointIsPartOfObject(value);
				if (valid) TotalPoints++; 
			}
			estimated[index][i].SetSkip(!valid);
		}
		}
	}
	
	public Point3d[] GetEstimatedPoints(){
		Point3d[] values=new Point3d[TotalPoints];
		int count=0;
		for (int index=0;index<numberofedges.length;index++)
			for (int i=0;i<numberofedges[index];i++){
				if (!estimated[index][i].skip()){
					values[count]=estimated[index][i].GetEstimated3dPoint();
					count++;
				}
			}
		return values;
	}
	public boolean[][] GetSourceCamerasForPoints(){
		boolean[][] values=new boolean[TotalPoints][numberofedges.length];
		int count=0;
		for (int index=0;index<numberofedges.length;index++)
			for (int i=0;i<numberofedges[index];i++){
				if (!estimated[index][i].skip()){
					boolean[] temp=estimated[index][i].GetSourceCameras();
					for (int j=0;j<temp.length;j++) values[count][j]=temp[j];
					count++;
				}
			}
		return values;
	}
	public int GetNumberOfValidPoints(){
		return TotalPoints;
	}
	
	
}
