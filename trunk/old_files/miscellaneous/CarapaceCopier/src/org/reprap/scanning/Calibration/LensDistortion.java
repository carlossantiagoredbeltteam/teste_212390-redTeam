package org.reprap.scanning.Calibration;

import org.reprap.scanning.DataStructures.MatrixManipulations;
import org.reprap.scanning.Geometry.Point2d;
import org.reprap.scanning.Geometry.PointPair2D;
import org.reprap.scanning.Geometry.SignedRadiiPairs;
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
 * Last modified by Reece Arnott 22th May 2010
 * 
 * This includes the option of having recursive calls to undo additional layers of lens distortion
 * If this is used be sure you get the layering correct as applying the undistortion function/matrices in the wrong order
 * will give the wrong results
 *   
 *******************************************************************************/
public class LensDistortion {
	private Point2d[] distortedpoints;
	private Point2d[] undistortedpoints;
	private Point2d[] calibrationpoints;
	private Point2d e; // centre of distortion for matrix calculation
	private int maximumdx;
	private int maximumdy;
	private double maxradiussquared;
	private boolean UseDistortionMatrix;
	private double UnDistortk1=0; 
	private Point2d centerofdistortion; //center of distortion for polynomial calculation
	private boolean AdditionalLayersofDistortion;
	private LensDistortion AdditionalDistortion; // not set except by specific SetLowerLayersOfDistortion method
	private Point2d adjustedcenter; // this is the centre of distortion adjusted for the additional layers of lens distortion
	
	 boolean printdistortion=false;// only for testing purposes
	 
	 // Constructor - just used to create a zero distortion class.
	 public LensDistortion(){
		 distortedpoints=new Point2d[0];
		 undistortedpoints=new Point2d[0];
		 calibrationpoints=new Point2d[0];
		 maximumdx=0;
		 maximumdy=0;
		 maxradiussquared=0;
		 UseDistortionMatrix=true;
		 UnDistortk1=0;
		 e=new Point2d(0,0);
		 centerofdistortion=new Point2d(0,0);
		 AdditionalLayersofDistortion=false;
		 adjustedcenter=new Point2d(0,0);
		 }
	 
	 // Constructor
public LensDistortion(int maxdx, int maxdy, Matrix KnownMatrixTransformation, PointPair2D[] matchedpoints, boolean imagefirst, double maximumradiussquared){
	maximumdx=maxdx;
	maximumdy=maxdy;
	maxradiussquared=maximumradiussquared;
	UnDistortk1=0;
	centerofdistortion=new Point2d(0,0);
	AdditionalLayersofDistortion=false;
	 adjustedcenter=new Point2d(0,0);
	 // Split the point pairs into Point2d arrays of calibration points and distorted points
	distortedpoints=new Point2d[matchedpoints.length];
	calibrationpoints=new Point2d[matchedpoints.length];
	UseDistortionMatrix=false;
	e=new Point2d(0,0);
	for (int i=0;i<matchedpoints.length;i++){
		if (imagefirst) {
			calibrationpoints[i]=matchedpoints[i].pointtwo.clone();
			distortedpoints[i]=matchedpoints[i].pointone.clone();
		}
		else {
			calibrationpoints[i]=matchedpoints[i].pointone.clone();
			distortedpoints[i]=matchedpoints[i].pointtwo.clone();
		}
	} // end for
	// Use the known camera matrix transformation to convert the calibration points to undistorted points
	undistortedpoints=new Point2d[matchedpoints.length];
	for (int i=0;i<matchedpoints.length;i++){
		Matrix point=new Matrix(4,1);
		point.set(0,0,calibrationpoints[i].x);
		point.set(1,0,calibrationpoints[i].y);
		point.set(3,0,1);
		point=KnownMatrixTransformation.times(point);
		undistortedpoints[i]=new Point2d(point);
	}
	
}
//clone method
public LensDistortion clone(){
	 LensDistortion returnvalue=new LensDistortion();
	 returnvalue.distortedpoints=distortedpoints.clone();
	 returnvalue.undistortedpoints=undistortedpoints.clone();
	 returnvalue.calibrationpoints=calibrationpoints.clone();
	 returnvalue.maximumdx=maximumdx;
	 returnvalue.maximumdy=maximumdy;
	 returnvalue.maxradiussquared=maxradiussquared;
	 returnvalue.UnDistortk1=UnDistortk1;
	  returnvalue.UseDistortionMatrix=UseDistortionMatrix;
	 returnvalue.e=e.clone();
	 returnvalue.centerofdistortion=centerofdistortion.clone();
	 returnvalue.adjustedcenter=adjustedcenter.clone();
	 returnvalue.AdditionalLayersofDistortion=AdditionalLayersofDistortion;
	 // note the recursive call to the clone method here
	 if (AdditionalLayersofDistortion) returnvalue.AdditionalDistortion=AdditionalDistortion.clone();
	 return returnvalue;
}
// TODO uncomment when distortion matrix working properly
public void CalculateDistortion(){
	//UseDistortionMatrix=CalculateDistortionMatrix();
	UseDistortionMatrix=false;
	//if (!UseDistortionMatrix) {
		CalculateDistortionCoefficients();
	//}
}
//This will only give a valid answer if the center of distortion is accurately approximated by the designated center of the image i.e. origin (0,0). This is not normally exactly right but is normally not a problem except for large distortion
//The assumption that the distortion is approximated by a polynomial breaks down with fish-eye lenses. 

public void SetDistortionCoefficient(double k1, Point2d center){
	UnDistortk1=k1;
	centerofdistortion=center.clone();
	SetAdjustedCenter();
}

//This will only give a valid answer if the center of distortion is accurately approximated by the designated center of the image i.e. origin (0,0). This is not normally exactly right but is normally not a problem except for large distortion
//The assumption that the distortion is approximated by a polynomial breaks down with fish-eye lenses. 
private void CalculateDistortionCoefficients(){
	// If we assume the standard relationship between distorted and undistorted radii (rd and ru) of a polynominal approximation of the form
	// ru=rd(1+k1rd^2+k2rd^4...)
	// Going back to Tsai 1987 ("A versatile camera calibration technique for high-accuracy 3D machine vision metrology using off-the-shelf TV Cameras and Lenses") 
	// it is assumed that only the first coefficient needs to be calculated, k1.
	// So we can rearrange this, put into matrices and solve.
	// ru/rd-1=k1rd^2. 
	// In this case that means A is composed of the r^2 terms, B is the ru/rd-1 and we are solving to find k1
	
	// We also need to add the maximum radius which is defined to have ru=rd
	
	Matrix A=new Matrix((distortedpoints.length+1),1);
	Matrix B=new Matrix((undistortedpoints.length+1),1);
	for (int i=0;i<distortedpoints.length;i++){
		double distortedradius=Math.sqrt(distortedpoints[i].lengthSquared());
		double undistortedradius=Math.sqrt(undistortedpoints[i].lengthSquared());
		
		A.set(i,0,Math.pow(distortedradius,2));
		B.set(i,0,(undistortedradius/distortedradius)-1);
		
	}
//	 We also need to add the maximum radius which is defined to have ru=rd
	A.set(distortedpoints.length,0,maxradiussquared);
	B.set(undistortedpoints.length,0,0);
	
	// Now solve to get the coefficient
	UnDistortk1=A.solve(B).get(0,0); // Note that if A and B are both nx1 and Ak=B then k is a 1x1 matrix 
	}

public void SetLowerLayersOfDistortion(LensDistortion lowerlayer){
	AdditionalLayersofDistortion=true;
	AdditionalDistortion=lowerlayer.clone();
	SetAdjustedCenter();
}
private void SetAdjustedCenter(){
	if (AdditionalLayersofDistortion) adjustedcenter=AdditionalDistortion.UndoDistortion(centerofdistortion);
	else adjustedcenter=centerofdistortion.clone();
}

public Point2d UndoDistortion(Point2d distorted){
	return UndoDistortion(distorted,true);
}
public Point2d UndoThisLayerOfDistortion(Point2d distorted){
	return UndoDistortion(distorted,false);
}


private Point2d UndoDistortion(Point2d distorted, boolean recurse){
	Point2d returnvalue=distorted.clone();
	Point2d centreofdistortion=centerofdistortion.clone();
	if ((recurse) && (AdditionalLayersofDistortion)){
		returnvalue=AdditionalDistortion.UndoDistortion(returnvalue);
		centreofdistortion=adjustedcenter;
	}
	//if (!UseDistortionMatrix){
		// First shift the origin to be at the center of distortion
		returnvalue.minus(centreofdistortion);
		// Use the one term approximation to undo distortion
		double radius=Math.sqrt(returnvalue.lengthSquared());
		returnvalue.scale(1+(Math.pow(radius,2)*UnDistortk1));
		// Now shift the origin back to the original
		returnvalue.plus(centreofdistortion);
	//	}
	return returnvalue;

}

public double getDistortionCoefficient(){
	return UnDistortk1;
}

public boolean UseDistortionFunction(){
	return !UseDistortionMatrix;
}
//	 This follows the algorithm laid down in the paper (and Microsoft Technical report of the same name) "Parameter-free Radial Distortion Correction with Centre of Distrortion Estimation"
//	 by Richard Hartley and Sing Bang Kang in Vol 28, issue 8 of IEEE Transactions on Pattern Analysis and Machine Intelligence (2007)
	// TODO test this and uncomment the code below and test that as well.
	public boolean CalculateDistortionMatrix(){
		// Calculate the fundamental matrix of the distorted and undistorted points so we can find the centre of distortion
		boolean success=true;
		MatrixManipulations temp=new MatrixManipulations();
		success=temp.SetF(undistortedpoints,distortedpoints);
		if (success){
			Matrix F=temp.getF();
			e=CalculateDistortionCenter(F);
			//What about when there is little or no distortion?? This algorithm breaks down so first do a sanity check
			// Sanity check: Is the estimated distortion center within a distance of the origin (assumed to be the calculated principal point
			// The above method will give a rather arbitrary distortion center if there is no distortion
			success=success && (Math.abs(e.x)<=maximumdx) && (Math.abs(e.y)<=maximumdy);
		if (success){
					
			if (printdistortion) System.out.println("Seems to have a valid distortion center");
			Matrix H=new Matrix(3,3);
			
			// Compute the first two rows of H from F
			// H is the final distortion matrix which can only be applied once the coordinate system has the distortion centre at the origin
			// As the distortion centre is at the origin we can easily calculate some of its coordinates from the known F
			
			// The first row of H is the second column of F
			H.set(0,0,F.get(0,1));
			H.set(0,1,F.get(1,1));
			H.set(0,2,F.get(2,1));
			// The second row of H is the negative of the first column of F
			H.set(1,0,F.get(0,0)*-1);
			H.set(1,1,F.get(1,0)*-1);
			H.set(1,2,F.get(2,0)*-1);
			
			// Using this incomplete matrix we now map the calibratrion coordinates to the image coordinate system to give us an array of undistorted points
			// Use the 2x3 H multipled by the 3x1 homogeneous representation of the coordinates to get a 2x1 inhomogeneous representation
			
			// We want to fill in the matrix to minimise the difference between the distorted and undistorted points
			// by calculating the last row H - from now on called the vector v
			//   We have two explicit assumptions:
			// 1. The distortion is circularly symmetric. Thus, the radial distortion of an image point depends
			//   only on its distance from the centre of distortion. This will only hold if the pixels are square
			// 2. An ordering, or monotonicity condition: the radial distance of points from the radial centre
			//     after distortion is a monotonic function of their distance before distortion. This is an essential property of any camera

			// We want to construct Av and minimise ||Av|| subject to the constraint that either ||v||=1 or that the most distant points have the same radius in both image and calibration views (distorted and undistorted views)
			// A is constructed using the radii of neighbouring undistorted points once they're ordered by the distorted radii.
			// Note that the radii can have a sign that is positive or negative where the positive radial direction for an undistorted point is oriented towards the distorted point.

			// create temporary point pair array to only be used to calculate the radii pairs
			PointPair2D[] temppoints=new PointPair2D[distortedpoints.length];
			for (int i=0;i<temppoints.length;i++){
				temppoints[i]=new PointPair2D();
				temppoints[i].pointone=distortedpoints[i].clone();
				temppoints[i].pointtwo=undistortedpoints[i].clone();
				//transform the coordinates so that the center of distortion is at the origin
				temppoints[i].pointone.minus(e);
				temppoints[i].pointtwo.minus(e);
			}
			// create signed radii pairs from the distorted and undistorted points using the origin as the centre in each case
			SignedRadiiPairs radiipairs=new SignedRadiiPairs(temppoints,new Point2d(0,0),new Point2d(0,0));
			// and quick sort them based on the unsigned radii of the distorted image(getting the indexes because we'll need to relate them to the original point pairs 
			int[] indexes=radiipairs.SortIndexes(true,true);
			
			
			// There are n-1 rows for A with each row consisting of 3 columns
			// each entry for a single row is the same except for the coordinate of the corresponding calibration coordinate point it contains (x,y, or 1)
			// each entry is the difference in neighbouring radii multipled by one of the calibration point coordinates 
			// See the papers referenced at the top of this method for an explanation of why this is (derived from equation 4). 
			Matrix A=new Matrix (indexes.length-1,3);
			for (int i=0;i<(indexes.length-1);i++){
				double diff=radiipairs.getValue(false,false,indexes[i+1])-radiipairs.getValue(false,false,indexes[i]);
				A.set(i,0,(diff*calibrationpoints[indexes[i]].x));
				A.set(i,1,(diff*calibrationpoints[indexes[i]].y));
				A.set(i,2,diff);
			}
			// Now we can find the least squares solution by simply taking the last column of V from from an SVD decomposition of A
			// This minimises ||Av|| subject to ||v||=1
			Matrix v=A.svd().getV().getMatrix(0,2,2,2);
			
			if (printdistortion){
				System.out.println("A=");
				A.print(10,5);
				System.out.println("v=");
				v.print(10,5);
			}
			
			
			// Add the calculated v as the last row of H
			H.set(2,0,v.get(0,0));
			H.set(2,1,v.get(1,0));
			H.set(2,2,v.get(2,0));
			
			if (printdistortion){
				System.out.println("H=");
				H.print(10,20);
			}
			
			// 
			// Now we have H we can calculate the Fundamental matrix of distortion that relates distorted image points to calibration points.
			// xdFxc=0 where xd is the distorted point and xc is the calibration point
			// F=[e]xH where [e]x is the skew-symmetric 3 × 3 matrix representing the cross product	
			/* in the case of the epipole e which is a 3x1 vector (e1,e2,e3)^T:
			*			  0,-e3, e2
			*	[e]x=	 e3, 0 ,-e1
			*			-e2, e1, 0
			*/
			
			/*
			Matrix ex=new MatrixManipulations().getSkewSymetricCrossProductof3x1Vector(e);
			
			Matrix F=ex.times(H);
			
			System.out.println("F=");
			F.print(10,20);
			
		// If we assume the calibration sheet lies on z=1
		// Then we can translate image coordinates into calibration sheet coordinates
		// l=F^Tx is the line in calibration coordinates matching the point x in the image
			for (int i=0;i<matchedpoints.length;i++){
				Point2d imagepoint=matchedpoints[i].pointtwo.clone();
				Point2d calibrationpoint=matchedpoints[i].pointone.clone();
					
				System.out.print("Original Image point=");
				imagepoint.print();
				System.out.print(" Calibration point=");
				calibrationpoint.print();
				
				Matrix x=new Matrix(3,1);
				x.set(0,0,imagepoint.x);
				x.set(1,0,imagepoint.y);
				x.set(2,0,1);
				
				Matrix l=F.transpose().times(x);
				Point2d calculatedpoint=new Point2d(0,0);
				calculatedpoint.ApplyTransform(l);
				System.out.print(" Calculated point=");
				l.print(10,20);
				calculatedpoint.print();
				System.out.println();
			}
			*/
		}
		}
		
		return success;
	} // end of method


//	 This gives an essentially arbitrary answer if there is no/little distortion due to the Fundamental matrix being calculated being just one of a 2 parameter family of similar matrices.
	private Point2d CalculateDistortionCenter(Matrix FundamentalMatrix){
		// centre of distortion is one of the epipoles computed from F such that Fe=0 or F^Te=0 depending on which way round we have the images
		// If we simply use the solve method to do this we will always find that e=0 but we don't want that answer, we want the left or right nullspace of F.
		// This assumes that the matchedpoints we have are of the image and calibration sheet i.e not two images, in which the epipoles will be the camera centre of one in the image of the other.
		
		Point2d returnvalue=new Point2d(0,0);
		
		// As the Fundamental matrix was calculated to give pointtwo^TFpointone=0 
		// then we want the right epipole as secondpoint is the distorted image points 
		Matrix DistortionCenter=MatrixManipulations.GetRightNullSpace(FundamentalMatrix);
		if (printdistortion){
			Matrix e;
			Matrix edash;
			edash=MatrixManipulations.GetRightNullSpace(FundamentalMatrix);
			e=MatrixManipulations.GetLeftNullSpace(FundamentalMatrix);
			System.out.println("Epipole e=");
			e.print(10,20);
			Point2d temp=new Point2d(0,0);
			temp.ApplyTransform(e);
			temp.print();
			System.out.println();
			System.out.println("Testing Fe=0 to one part in one a thousand");
			Matrix pointmatch=FundamentalMatrix.times(e);
			//pointmatch=FundamentalMatrix.transpose().times(e);
			boolean match=(Math.abs(pointmatch.get(0,0))<0.001);
			match=match && (Math.abs(pointmatch.get(1,0))<0.001);
			match=match && (Math.abs(pointmatch.get(2,0))<0.001);
			if (match) System.out.println("Close enough");
			else {
				System.out.println("Not Close enough");
				pointmatch.print(10,20);
			}
			
			
			System.out.println("Epipole e' (returned as the center of distortion)=");
			edash.print(10,20);
			temp=new Point2d(0,0);
			temp.ApplyTransform(edash);
			temp.print();
			System.out.println();
			System.out.println("Testing F^Te'=0 to one part in one a thousand");
			pointmatch=FundamentalMatrix.transpose().times(edash);
			pointmatch=FundamentalMatrix.times(edash);
			match=(Math.abs(pointmatch.get(0,0))<0.001);
			match=match && (Math.abs(pointmatch.get(1,0))<0.001);
			match=match && (Math.abs(pointmatch.get(2,0))<0.001);
			if (match) System.out.println("Close enough");
			else {
				System.out.println("Not Close enough");
				pointmatch.print(10,20);
			}
		} // end if print
		returnvalue.ApplyTransform(DistortionCenter);
		return (returnvalue);
	}



	
	 
	 
}
