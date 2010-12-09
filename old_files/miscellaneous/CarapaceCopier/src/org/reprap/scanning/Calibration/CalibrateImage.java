package org.reprap.scanning.Calibration;
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
 * Last modified by Reece Arnott 6th December 2010
 * 
 *   	
 *   
 *******************************************************************************/
import Jama.*;

import org.reprap.scanning.DataStructures.MatrixManipulations;
import org.reprap.scanning.Geometry.*;



public class CalibrateImage {

 private PointPair2D[] matchedpoints;
 private Matrix Rotation=new Matrix(3,3);
 private Matrix translation=new Matrix(3,1);
 private Matrix Homography=new Matrix(3,3);
 private double zscalefactor; // used to change the scale of the world z axis (defined to be the same as - or the average of- the x and y axes which are based on the pixels of the calibration sheet) to the arbitrary z scale used by the Camera, rotation and translation matrices derived by Zhangs method
 private boolean setRotationAndTranslation;
 
 boolean print=false; // only for testing purposes
 boolean printDLT=false; // only for testing purposes
 
 // Constructor
public CalibrateImage(PointPair2D[] pp){	 
	 matchedpoints=new PointPair2D[pp.length];
	 for (int i=0;i<pp.length;i++) {
		 matchedpoints[i]=pp[i].clone();
		 // It is assumed that the point pair is currently set with the first point being the calibration point and the second point the image
		 }
	 setHomographyusingAllPoints();
	 setRotationAndTranslation=false;
	 zscalefactor=1;
 }
 public CalibrateImage(){	 
	 matchedpoints=new PointPair2D[0];
	setRotationAndTranslation=false;
	 zscalefactor=1;
 }
 // clone method
 public CalibrateImage clone(){
	 CalibrateImage returnvalue=new CalibrateImage();
	 returnvalue.matchedpoints=new PointPair2D[matchedpoints.length];
	 for (int i=0;i<matchedpoints.length;i++) returnvalue.matchedpoints[i]=matchedpoints[i].clone();
	 returnvalue.Rotation=Rotation.copy();
	 returnvalue.Homography=Homography.copy();
	 returnvalue.translation=translation.copy();
	 returnvalue.setRotationAndTranslation=setRotationAndTranslation;
	 returnvalue.zscalefactor=zscalefactor;
	 return returnvalue;
 }
 
 public void setHomographyusingAllPoints(){
//	 Calculate the homography using all point pairs
		Point2d[] PointsInImageOne=new Point2d[matchedpoints.length];
		Point2d[] PointsInImageTwo=new Point2d[matchedpoints.length];
		for (int i=0;i<matchedpoints.length;i++){
			PointsInImageOne[i]=matchedpoints[i].pointone.clone();
			PointsInImageTwo[i]=matchedpoints[i].pointtwo.clone();
		}
		Matrix H=setHomography(PointsInImageOne, PointsInImageTwo);
		// Now do Bundle adjustment on this estimated homography to get a closer match
		CalibrationBundleAdjustment adjust=new CalibrationBundleAdjustment();
		adjust.BundleAdjustment(100, PointsInImageOne, PointsInImageTwo,H);
		Homography=H.copy();
 }
// This uses the RANSAC algorithm to calculate a homography based on a subset of the matched points and returns the number of inliers for this homography
public int setHomograhyusingRANSAC(double tsquared){ // t is the transfer error distance threshold to determine inliers and outliers 
	Matrix H=new Matrix(3,3);
	boolean novalidsolution=false;
	double currentmaxinliersvar=0;
	int maxinliers=0;
	boolean[] MaxInliersMask=new boolean[matchedpoints.length];
	for (int i=0;i<MaxInliersMask.length;i++) MaxInliersMask[i]=false; 
	int N=Integer.MAX_VALUE; // How many times we need to go round the loop initally set to be maximum as it will be re-evaluated down as we find inliers
	double p=0.99; // Probability we want of having at least one sample free of outliers if we go around the loop N times.
	int samplecount=0; // Number of times we've gone around the loop
	double outliers=1; // worst case proportion of the total that are outliers (1=100%)
	while ((N>samplecount) && (!novalidsolution)){
		samplecount++;
		// Choose a sample set of 4 point pairs and calculate the Homography
		// Note that we need look out for degenerate samples where any 3 of the 4 points are collinear.
		// TODO We should also try and choose points that are spatially distributed.
		int[] pointpairindexes=new int[4];
		boolean[] tested=new boolean[matchedpoints.length];
		for (int i=0;i<matchedpoints.length;i++) tested[i]=false;
		int randomindex=0;
		
		for (int i=0;i<4;i++){
			boolean repeat=true;
			// This will not work if all points in either image are collinear 
			while (repeat){
				randomindex=(int)Math.round(Math.random()*(matchedpoints.length-1));
				repeat=false;
				// Check we haven't already tested this point pair
				repeat=tested[randomindex];

				// Check this point pair isn't collinear in either frame
				if ((i>=2) && !repeat) {
					repeat=matchedpoints[randomindex].pointone.isCollinear(matchedpoints[pointpairindexes[0]].pointone,matchedpoints[pointpairindexes[1]].pointone);
					repeat=repeat || matchedpoints[randomindex].pointtwo.isCollinear(matchedpoints[pointpairindexes[0]].pointtwo,matchedpoints[pointpairindexes[1]].pointtwo);
					if (i>2){
						repeat=repeat || matchedpoints[randomindex].pointone.isCollinear(matchedpoints[pointpairindexes[1]].pointone,matchedpoints[pointpairindexes[2]].pointone);
						repeat=repeat || matchedpoints[randomindex].pointtwo.isCollinear(matchedpoints[pointpairindexes[1]].pointtwo,matchedpoints[pointpairindexes[2]].pointtwo);
						repeat=repeat || matchedpoints[randomindex].pointone.isCollinear(matchedpoints[pointpairindexes[0]].pointone,matchedpoints[pointpairindexes[2]].pointone);
						repeat=repeat || matchedpoints[randomindex].pointtwo.isCollinear(matchedpoints[pointpairindexes[0]].pointtwo,matchedpoints[pointpairindexes[2]].pointtwo);
					}
				} // end if
				tested[randomindex]=true;
				// Exit the loop if we have tested all the points and still not found a valid additional point
				int count=0;
				for (int j=0;j<matchedpoints.length;j++) if (tested[j]) count++;
				if (count==matchedpoints.length) {repeat=false; novalidsolution=true;}
			} // end while
			if (novalidsolution) i=4; // exit for loop prematurely
			else pointpairindexes[i]=randomindex;
		} // end for
		if (!novalidsolution){
			// Calculate the homography using these 4 point pairs
			Point2d[] PointsInImageOne=new Point2d[4];
			Point2d[] PointsInImageTwo=new Point2d[4];
			for (int i=0;i<4;i++){
				PointsInImageOne[i]=matchedpoints[pointpairindexes[i]].pointone.clone();
				PointsInImageTwo[i]=matchedpoints[pointpairindexes[i]].pointtwo.clone();
			}
			H=setHomography(PointsInImageOne, PointsInImageTwo);
			// Count the number of inliers for this homography
			int inliers=0;
			boolean[] inlier=new boolean[matchedpoints.length];
			double[] dsquared=new double[matchedpoints.length];
			double dsquaredsum=0;
			for (int i=0;i<matchedpoints.length;i++){
			
				// Find symetric transfer error squared and compare it to the t squared distance threshold
				dsquared[i]=new MatrixManipulations().TransferError(matchedpoints[i],H);
				dsquaredsum=+dsquared[i];
				inlier[i]=(dsquared[i]<tsquared);
				if (inlier[i]) inliers++;
			} // end for
			// Calculate variance (square of standard deviation) of inliers - only used if need to test to see if need to replace current contender with this one
			double variance=0;
			if (inliers==maxinliers){
				for (int i=0;i<matchedpoints.length;i++)if (inlier[i]) variance=+Math.pow(dsquared[i]-(dsquaredsum/inliers),2);
				variance=variance/inliers;
			}
			// Set the updated estimate percentage of the number of outliers, new N, and the new inlier count threshold if need be 
			if ((inliers>maxinliers) || ((inliers==maxinliers) && (variance<currentmaxinliersvar))){
				maxinliers=inliers;
				currentmaxinliersvar=variance;
				MaxInliersMask=inlier.clone();
				outliers=(1-(double)inliers/(double)matchedpoints.length);
				// This equation is a rearrangement of a simple sampling probability equation
				// We need to find the the number of samples (N) we need to take of size 4, to ensure that at least one of them contains no outliers
				// with a probability of p. 
				// Then we solve the equation (1-x)^N=1-p or rearranging N=log(1-p)/log(1-x)
				// where x is the probability all data points are inliers. The probability a selected data point is an inlier is 1-(1-outliers) and there are 4 of them so we multiple this number
				// by itself 4 times to find the probability of any one sample being free from outliers
				N=(int)(Math.log(1-p)/Math.log(1-Math.pow(1-outliers,4)));
			} // end if
		} // end if there is a valid solution
		} // end while
	if (!novalidsolution){
		// Re-estimate the Homography using all the inliers of the largest consensus set
		Point2d[] PointsInImageOne=new Point2d[maxinliers];
		Point2d[] PointsInImageTwo=new Point2d[maxinliers];
		int count=0;
		for (int i=0;i<matchedpoints.length;i++){
			if (MaxInliersMask[i]){
				PointsInImageOne[count]=matchedpoints[i].pointone.clone();
				PointsInImageTwo[count]=matchedpoints[i].pointtwo.clone();
				count++;
			} // end if
		} // end for
		H=setHomography(PointsInImageOne, PointsInImageTwo);
		if (print) {
			System.out.println("Used "+maxinliers+" of the point pairs to come up with homography");
			//H.print(10,20);		
		}
		//Now do Bundle adjustment on this estimated homography to get a closer match
		CalibrationBundleAdjustment adjust=new CalibrationBundleAdjustment();
		adjust.BundleAdjustment(100, PointsInImageOne, PointsInImageTwo,H);
		//if (print) {
		//	System.out.println("Adjusted homography");
		//	H.print(10,20);		
		//}
		Homography=H.copy();
	}
	else maxinliers=0;
	return maxinliers;
}

public double FindMaximumTransferErrorSquared(){
	double maxerrorsquared=0;
	for (int i=0;i<matchedpoints.length;i++){
		double errorsquared=new MatrixManipulations().TransferError(matchedpoints[i],Homography);
		if (errorsquared>maxerrorsquared) maxerrorsquared=errorsquared;
	}
	return maxerrorsquared;
}



 // If the point pair contains the calibration sheet as pointone and the image coordinates as pointtwo (which is the normal case)
 // Then the Homography returned can be used as is to change calibration sheet coordinates into image coordinates
 // i.e. image=Hcalibration or image=Hreal for real world z=0 (i.e. on the calibration sheet)
// Note that this is a planar homography and only gives the correct answer for points on the same plane as the calibration sheet i.e. z=0
 
public Matrix getHomography(){
		return Homography;
 }
 
 // if the translation and rotation matrices are set return them
 // otherwise return a zero translation vector and the identity matrix for rotation.
 public Matrix getTranslation(){
	if (setRotationAndTranslation) return translation;
	else return new Matrix (3,1);
	 }
 
  public Matrix getRotation(){
		if (setRotationAndTranslation) return Rotation;
		else {
			Matrix returnvalue=new Matrix(3,3);
			returnvalue.set(0,0,1);
			returnvalue.set(1,1,1);
			returnvalue.set(2,2,1);
			return returnvalue;
		}
	 }
  
  // The z scale factor gives a consistent z scale across multiple images
  public double getZscalefactor(){
		 return zscalefactor;
	 }

 public Matrix getZscaleMatrix(){
	 Matrix returnvalue=new Matrix(4,4);
	 returnvalue.set(0,0,1);
	 returnvalue.set(1,1,1);
	 returnvalue.set(2,2,zscalefactor);
	 returnvalue.set(3,3,1);
	 return returnvalue;
 }
 
 public void setRotationandTranslation(Matrix R, Matrix t){
	 Rotation=R.copy();
	 translation=t.copy();
	 setRotationAndTranslation=true;
	 
	 
 }

//This follows the algorithm laid down in the paper (and Microsoft Technical report of the same name) "A flexible new technique for camera calibration"
//by Z. Zhang in Vol 22, issue 11 of IEEE Transactions on Pattern Analysis and Machine Intelligence (2000)
//Note that there have been mistakes in formulas found in the original paper that have been corrected in the online version of the Microsoft Technical report
//The updated technical report with the mistakes corrected can be downloaded from ftp://ftp.research.microsoft.com/pub/tr/tr-98-71.pdf 
// The actual camera calibration part of the algorithm is left out. This is done in the CalibrateCamera class.
public void CalculateTranslationandRotation(Matrix CameraCalibrationMatrix){
	// Get the homography
	Matrix H=getHomography();
	// Split the homography matrix into 3 column matrices for easier handling
	Matrix h1=H.getMatrix(0,2,0,0);
	Matrix h2=H.getMatrix(0,2,1,1);
	Matrix h3=H.getMatrix(0,2,2,2);
	// Get the estimated rotation matrix and the translation vector (with a arbitrary z value)
	
	// First calculate lambda, a relatively arbitrary scaling factor.
	// These lambda values are essentially the scaling needed to fit the homography in the image x and y axis directions.
	// i.e. if you take an outline of the calibration sheet backprojected using the homography and overlay it with the same outline backprojected using the combination of the camera, rotation and translation matrices you will find that the left and right edges will closely line up if you used lambda1, and the top and bottom line up if you use lambda2.  
	Matrix temp=CameraCalibrationMatrix.inverse().times(h1);
	double oneoverlambda1=new MatrixManipulations().DistanceFromOriginof3x1Vector(temp);
	temp=CameraCalibrationMatrix.inverse().times(h2);
	double oneoverlambda2=new MatrixManipulations().DistanceFromOriginof3x1Vector(temp);
	// Note that with perfect camera calibration, lamba1 and lambda2 should be equal but if we assume the camera calibration isn't perfect then we should take the average of the two.
	double lambda=2/(oneoverlambda1+oneoverlambda2);
	if ((oneoverlambda1!=oneoverlambda2) && (print)) {
		// Only print this out if the difference isn't in the region of a rounding error
		if (Math.abs((oneoverlambda1/oneoverlambda2)-1)>0.001) System.out.println("Error TandR 1/lambda1="+oneoverlambda1+" and 1/lambda2="+oneoverlambda2+" They should be the same but are out by "+Math.abs((oneoverlambda1/oneoverlambda2)-1)*100+"%");
	}
		
	Matrix r1=CameraCalibrationMatrix.inverse().times(h1);
	r1.timesEquals(lambda);
	Matrix r2=CameraCalibrationMatrix.inverse().times(h2);
	r2.timesEquals(lambda);
	
	// r3 is the cross product of r1 with r2
	Matrix r3=new MatrixManipulations().getCrossProductMatrixof3x1Vector(r1).times(r2);
	
	
	Matrix EstimatedRotation=new Matrix(3,3);
	EstimatedRotation.setMatrix(0,2,0,0,r1);
	EstimatedRotation.setMatrix(0,2,1,1,r2);
	EstimatedRotation.setMatrix(0,2,2,2,r3);
	
	translation=(CameraCalibrationMatrix.inverse().times(h3));
	translation.timesEquals(lambda);
	
	// Use the estimated rotation matrix to create a "real" rotation matrix.
	
	// The easiest way to translate this arbitrary matrix into a rotation matrix is to get the SVD and recreate
	// the new rotation matrix as UV^T but note that the Rotation matrix may be the reflection of the desired rotation matrix if it's determinant is -1 and we use the standard SVD solutiuon of R=UV^T. 
	// Therefore we can construct a diagonal matrix (1,1,det(UV^T)) and add it into the mix to fix this 
	SingularValueDecomposition svd=EstimatedRotation.svd();
	double det=svd.getU().times(svd.getV().transpose()).det();
	Matrix diagonal=new Matrix (3,3);
	diagonal.set(0,0,1);
	diagonal.set(1,1,1);
	diagonal.set(2,2,Math.round(det));// The determinant should only be +/-1 but because of the way it is calculated there may be rounding errors!
	Rotation=svd.getU().times(diagonal.times(svd.getV().transpose()));
	setRotationAndTranslation=true;

}
public void setZscalefactor(double s){
	zscalefactor=s;
}
public void setZscalefactor(Point2d originforimage, Matrix CameraCalibrationMatrix){
	// Set the translation z vector scale
	// This gives a consistent z scale across multiple images and if we have metadata that measures pixels per inch etc. in the calibration sheet we can then translate this into real world coordinates.

	// Currently the internal z scale is arbitrarily set but is a scaled version of the world z coordinate 
	// The world coordinate scale in x and y by definition come from the calibration sheet pixels. If it is assumed that the pixels are square these are the same and the z scale can then be defined to be the same as for the x and y.
	// If we assume the calibration pixels are square then we can use a unit vector in either x or y to scale z but to be on the safe side we don't assume that and scale by using the average of x and y unit vector scales.
	
	// Note that we also need to take into account the movement of the origin in the image coordinate frame. 
	
	if (!setRotationAndTranslation) CalculateTranslationandRotation(CameraCalibrationMatrix);
	
	Matrix Identity=new Matrix(4,4);
	Identity.set(0,0,1);
	Identity.set(1,1,1);
	Identity.set(2,2,1);
	Identity.set(3,3,1);
	
	Matrix point=new Matrix(4,1);
	point.set(3,0,1);
	
	Matrix origin=new MatrixManipulations().WorldToImageTransform(point,CameraCalibrationMatrix,getRotation(),getTranslation(),Identity,originforimage);// transfer the world origin to image homogeneous coordinates
	Point2d origin2d=new Point2d(origin); // the 2d image plane representation of the world origin point
	point.set(0,0,1);
//	 transfer the world coordinate 1,0,0 to image homogeneous coordinates and take it away from the transferred origin to give a transferred x unit vector
	Matrix xunitvector=new MatrixManipulations().WorldToImageTransform(point,CameraCalibrationMatrix,getRotation(),getTranslation(),Identity,originforimage); 
	xunitvector=xunitvector.minus(origin); // The unit vector is the unit point taken away from the origin point
	
	
	point.set(0,0,0);
	point.set(1,0,1);
//	 transfer the world coordinate 0,1,0 to image homogeneous coordinates and take it away from the transferred origin to give a transferred y unit vector
	Matrix yunitvector=new MatrixManipulations().WorldToImageTransform(point,CameraCalibrationMatrix,getRotation(),getTranslation(),Identity,originforimage);
	yunitvector=yunitvector.minus(origin); // The unit vector is the unit point taken away from the origin point
	
	point.set(1,0,0);
	point.set(2,0,1);
//	 transfer the world coordinate 0,0,1 to image homogeneous coordinates and take it away from the transferred origin to give a transferred z unit vector
	Matrix zunitvector=new MatrixManipulations().WorldToImageTransform(point,CameraCalibrationMatrix,getRotation(),getTranslation(),Identity,originforimage);
	Point2d positivez2d=new Point2d(zunitvector); // the 2d image plane representation of the positive z point
	zunitvector=zunitvector.minus(origin); // The unit vector is the unit point taken away from the origin point
	//transfer the world coordinate 0,0,-1 to image homogeneous coordinates and take it away from the transferred origin to give a transferred z negative unit vector	
	point.set(2,0,-1);
	Matrix negativezunitvector=new MatrixManipulations().WorldToImageTransform(point,CameraCalibrationMatrix,getRotation(),getTranslation(),Identity,originforimage);
	Point2d negativez2d=new Point2d(negativezunitvector); // the 2d image plane representation of the negative z point
	
	double lengthx=Math.sqrt(Math.pow(xunitvector.get(0,0),2)+Math.pow(xunitvector.get(1,0),2)+Math.pow(xunitvector.get(2,0),2));
	double lengthy=Math.sqrt(Math.pow(yunitvector.get(0,0),2)+Math.pow(yunitvector.get(1,0),2)+Math.pow(yunitvector.get(2,0),2));
	double lengthz=Math.sqrt(Math.pow(zunitvector.get(0,0),2)+Math.pow(zunitvector.get(1,0),2)+Math.pow(zunitvector.get(2,0),2));
	double lengthscalefactor=(lengthx+lengthy)/(2*lengthz);
	zscalefactor=lengthscalefactor;
	// Note that this scale factor may actually have the wrong sign as all the lengths are positive values by definition and the arbitrary internal z scale may be reversed to the real world coordinates. 
	// So, if we assume the camera is placed in the positive z then we can compare the projected 2d image points of the origin, positive z, and negative z 
	// and make a decision based on the length of the vector between postivez and orgin vs. length of vector between negative z and origin 
	if (origin2d.CalculateDistanceSquared(positivez2d)<origin2d.CalculateDistanceSquared(negativez2d)) zscalefactor=zscalefactor*-1;
	
}
/***********************************************************************************************************************************
 * 
 * Private methods from here on down
 *
 ************************************************************************************************************************************/


// Use the matched points to calculate the homography - this is currently called via the RANSAC estimation which tries to dispose of outlier matched points to give the best fit homography
//see Hartley and Zisserman "Multiple View Geometry in computer vision" 4.1 DLT algorithm and 4.4.4 Normalization as well as 4.5 Iteration methods for the Gold standard algorithm
//This is essentially what is suggested in the Appendix A of Zhang in "A flexible new technique for camera calibration"
//This uses 4 or more point matches to estimate the homography using the normalised DLT (Direct Linear Transformation) algorithm and then refine it
private Matrix setHomography(Point2d[] PointsInImageOne, Point2d[] PointsInImageTwo){
	Matrix H=new Matrix(3,3);
	int length=PointsInImageOne.length;
	//Calculate the Normalisation matrices for each image.
	Matrix Normalisation1=new MatrixManipulations().CalculateNormalisationMatrix(PointsInImageOne);
	Matrix Normalisation2=new MatrixManipulations().CalculateNormalisationMatrix(PointsInImageTwo);
	//Apply the normalisation matrices to each set of points
	for (int i=0;i<length;i++){
		boolean success=PointsInImageOne[i].ApplyTransform(Normalisation1);
		if (!success) System.out.println("Error trying to apply transform to points in image one");
		success=PointsInImageTwo[i].ApplyTransform(Normalisation2);
		if (!success) System.out.println("Error trying to apply transform to points in image two");
	}
	
	//Use these normalised point pairs to find H - assuming there are enough independent point pairs
	// This matrix is made up of sets of 2 rows:
	// 0,0,0, -w'x, -w'y, -w'w, y'x, y'y, y'w
	// w'x, w'y, w'w, 0,0,0, -x'x, -x'y, -x'w
	// Where (x,y,w) and (x',y',w') are the normalised homogeneous 2d points
	// In our case w and w' are both 1 so we end up with the following matrix rows
	Matrix A=new Matrix(length*2,9);
	Matrix h=new Matrix(9,1);
	for (int i=0;i<length;i++){
		A.set(i*2,3,-PointsInImageOne[i].x);
		A.set(i*2,4,-PointsInImageOne[i].y);
		A.set(i*2,5,-1);
		A.set(i*2,6,PointsInImageTwo[i].y*PointsInImageOne[i].x);
		A.set(i*2,7,PointsInImageTwo[i].y*PointsInImageOne[i].y);
		A.set(i*2,8,PointsInImageTwo[i].y);
		A.set((i*2)+1,0,PointsInImageOne[i].x);
		A.set((i*2)+1,1,PointsInImageOne[i].y);
		A.set((i*2)+1,2,1);
		A.set((i*2)+1,6,-PointsInImageTwo[i].x*PointsInImageOne[i].x);
		A.set((i*2)+1,7,-PointsInImageTwo[i].x*PointsInImageOne[i].y);
		A.set((i*2)+1,8,-PointsInImageTwo[i].x);
		
	}
	
	
	if ((A.rank()==8) || (A.rank()==9)){ // There is either an exact solution or there is noise etc. so we need to find the least squares soluton to Ah=0. 
		//Either way the answer is the last column of V of an SVD decompostion
		// i.e. A=USV^T
		// This minimises ||Ah|| subject to the condition that ||h||=1
		
		// If there are less than 9 rows (there should be at least 8), bulk it up with rows of zeros
		if (A.getRowDimension()<9) {
			Matrix temp=new Matrix(9,9);
			temp.setMatrix(0,A.getRowDimension()-1,0,8,A);
			A=temp.copy();
		}
		
		h=A.svd().getV().getMatrix(0,8,8,8);
	}
//	 Turn this 9x1 vector into the 3x3 matrix H. Initially use the exact numbers and just rearrange them into a 3x3 matrix temp rather than 9x1 vector h
	Matrix temp=new Matrix(3,3);
	temp.set(0,0,h.get(0,0));
	temp.set(0,1,h.get(1,0));
	temp.set(0,2,h.get(2,0));
	temp.set(1,0,h.get(3,0));
	temp.set(1,1,h.get(4,0));
	temp.set(1,2,h.get(5,0));
	temp.set(2,0,h.get(6,0));
	temp.set(2,1,h.get(7,0));
	temp.set(2,2,h.get(8,0));
	
	
	// Now denormalise to give a first estimate of H
	H=Normalisation2.inverse().times(temp.times(Normalisation1));
	
	if (printDLT) {
		System.out.println("Matrix A=");
		A.print(10,20);
		System.out.println("Unnormalised H");
		temp.print(10,20);
		System.out.println("A times h vector");
		Matrix test=A.times(h);
		test.print(10,20);
		double count=0;
		for (int i=0;i<test.getRowDimension();i++) count=count+test.get(i,0);
		System.out.println();
		System.out.println(count);
		
		System.out.println("Normalisation1");
		Normalisation1.print(10,20);
		System.out.println("Normalisation2 inverted");
		Normalisation2.inverse().print(10,20);
		System.out.println("H matrix=");
		H.print(10,20);
		
		}
	return H;
} // end of method



} // end of class
