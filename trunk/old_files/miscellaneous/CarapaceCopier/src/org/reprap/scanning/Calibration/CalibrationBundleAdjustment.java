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
* Last modified by Reece Arnott 9th December 2010
* 
* 
*   This converts the matrices to internal representations used for LM minimisation and then back to matrices
*******************************************************************************/
import Jama.Matrix;

import org.reprap.scanning.DataStructures.MatrixManipulations;
import org.reprap.scanning.Geometry.*;
import javax.swing.JProgressBar;
import ZS.Solve.*;

public class CalibrationBundleAdjustment {
	//public double circleradius;
	public Ellipse ellipse;
	public int stepsaroundcircle;
	// This is the Bundle Adjustment for the 2D planar homography, note we are assuming there are no measurement errors in the calibration sheet coordinates, just in the homography and the detected centres in image coordinates
	// TODO to do bundle adjustment as per Algorithm 4.3 in Multiple View Geometry book we need to have image 1 points adjusted as well as the homography entries.
	// a are the nine values for homography plus xhat the adjusted image 1 points (initially best computed as Sampson correction to image 1 points but can be passed directly for now)
	// comparison y values are calculated from H and xhat
	// Note that we want to minimise the sum of two distance squared measures but currently the LM class is only set up to do one so the easiest thing to do is to have y being all the points from both images
	// and having lookup arrays containing copies of the points set up specifically to figure out how to create the value function with the x values being 3 valued numbers used as indicators
	// The first value is 1 or 2 depending on whether it came from the first or second image
	// The second and third values are the array index numbers in a that correspond to the xhat x and y values to use. 
	// For the first image return xhat, for the second return Hxhat.
	public void BundleAdjustment(int iterations,Point2d[] PointsInImageOne, Point2d[] PointsInImageTwo, Matrix H){
	
		LMfunc f=new LMHomographyAdjustment();
		// m is the number of y points we are going to pass
		// n is the number of a parameters we are going to pass
		int m=(PointsInImageOne.length*2);
		int n=(PointsInImageOne.length*2)+9;
		//	 Set up the error scaling array - leave them so that each of the parameters has the same weighting
		double[] s = new double[m];
		for (int i=0;i<m;i++) s[i]=1;
		// Set up vary array - let all the parameters vary
		boolean[] vary=new boolean[n];
		for (int i=0;i<vary.length;i++) vary[i]=true;;
	
		//	 Feed in the initial guess for the 9 homography parameters, coming directly from the homography matrix
		double[] a=new double[n];
		a[0]=H.get(0,0);
		a[1]=H.get(0,1);
		a[2]=H.get(0,2);
		a[3]=H.get(1,0);
		a[4]=H.get(1,1);
		a[5]=H.get(1,2);
		a[6]=H.get(2,0);
		a[7]=H.get(2,1);
		a[8]=H.get(2,2);
		
		 // x values are 3 valued numbers used as indicators
		// The first value is 1 or 2 depending on whether it came from the first or second image
		// The second and third values are the array index numbers in a that correspond to the xhat x and y values to use. 
		// y will take the 2 dimensional points
		double[][] x= new double [m][3];
		Point2d[] y= new Point2d[m];
		for (int i=0;i<PointsInImageOne.length;i++){
			x[i][0]=1;
			x[i][1]=9+(i*2);
			x[i][2]=10+(i*2);
			a[(int)x[i][1]]=PointsInImageOne[i].x;
			a[(int)x[i][2]]=PointsInImageOne[i].y;
			y[i]=PointsInImageOne[i].clone();
		}
		int index=PointsInImageOne.length;
		for (int i=0;i<PointsInImageOne.length;i++){
			x[i+index][0]=2;
			x[i+index][1]=9+(i*2);
			x[i+index][2]=10+(i*2);
			y[i+index]=PointsInImageTwo[i].clone();
		}
		// Now do the bundle adjustment
		try {
			// Note the true indicates that it will throw an error if the hessian is singular so we need to ignore that and move on
			//System.out.print("Homography adjustment: ");
			LM.solve( x, a, y,s, vary, f,0.001, 0.01, iterations, -1,true);
			}
		catch(Exception ex) {
			// If the Matrix is singular that means we can't go any further so just ignore and move on
			if (ex.getMessage()!="Matrix is singular.") 
				System.err.println("Exception caught: " + ex.getMessage());
		}
		//System.out.println();
		//  Read out the final estimate for the parameters
		H.set(0,0,a[0]);
		H.set(0,1,a[1]);
		H.set(0,2,a[2]);
		H.set(1,0,a[3]);
		H.set(1,1,a[4]);
		H.set(1,2,a[5]);
		H.set(2,0,a[6]);
		H.set(2,1,a[7]);
		H.set(2,2,a[8]);
		
	}
	
	
	//TODO add in distortion matrix version
	// This is the Bundle Adjustment for the camera parameters for the world to image transform. Note that it is assumed the circle radius and steps around circle are set before this is run
	public void BundleAdjustment(int iterations,PointPair2D[] pointpairs, Matrix K, Matrix R, Matrix t, double zscalefactor, double k1, Point2d imageorigin,JProgressBar bar){
			LMfunc f = new LMCameraCalibrationAdjustment();

			// Set up the error scaling array - leave them so that each of the parameters has the same weighting
			double[] s = new double[pointpairs.length];
			for (int i=0;i<pointpairs.length;i++) s[i]=1;
			// Set up vary array - let all the parameters vary
			boolean[] vary=new boolean[15];
			for (int i=0;i<vary.length;i++) vary[i]=true;;
			
			// Feed in the initial guess for the 14 parameters
			// 5 for K, 3 for R, 3 for t, 1 for z scale factor, 1 for distortion, 2 for the image origin
			double[] a=new double[vary.length];
			// Add the camera matrix parameters
			a[0]=K.get(0,0);
			a[1]=K.get(1,1);
			a[2]=K.get(0,1);
			a[3]=K.get(0,2);
			a[4]=K.get(1,2);
			// Add the rotation matrix parameters (after converting to 3x1 Rodrigues rotation vector
			Matrix r=new MatrixManipulations().getRodriguesRotationVector(R);
			a[5]=r.get(0,0);
			a[6]=r.get(1,0);
			a[7]=r.get(2,0);
			// Add the translation vector
			a[8]=t.get(0,0);
			a[9]=t.get(1,0);
			a[10]=t.get(2,0);
			// Add the zscale component
			a[11]=zscalefactor;
			// Add the distortion coefficient
			a[12]=k1;
			// Add the image origin
			a[13]=imageorigin.x;
			a[14]=imageorigin.y;
		
			// Split the point pairs apart
			// x will take the 4 dimensional points of the calibration sheet - taken from pointone, the centre of the circle
			// The 3rd coordinate is always 0 and the 4th is always 1
			double[][] x= new double [pointpairs.length][2];
			for (int i=0;i<pointpairs.length;i++){
				x[i][0]=pointpairs[i].pointone.x;
				x[i][1]=pointpairs[i].pointone.y;
				
			}
			// y will take the 2 dimensional points of the image plane - taken from pointtwo, the centre of the ellipse
			Point2d[] y= new Point2d[pointpairs.length];
			for (int i=0;i<pointpairs.length;i++)
				y[i]=pointpairs[i].pointtwo.clone();
			
			// Now do the bundle adjustment
			try {
		    // Note the false indicates that it won't throw an error if the hessian is singular and will try and work around it with the pseudo-inverse
				LM.solve( x, a, y, s, vary, f, 0.001, 0.001, iterations,-1,false,bar);
			}
		   catch(Exception ex) {
			   //If the Matrix is singular that means we can't go any further so just ignore and move on
			//	if (ex.getMessage()!="Matrix is singular.") 
					System.err.println("Exception caught: " + ex.getMessage());
			}
			
		    // Read out the final estimate for the parameters
			// The camera matrix parameters
			K.set(0,0,a[0]);
			K.set(1,1,a[1]);
			K.set(0,1,a[2]);
			K.set(0,2,a[3]);
			K.set(1,2,a[4]);
			// The rotation matrix parameters
			r.set(0,0,a[5]);
			r.set(1,0,a[6]);
			r.set(2,0,a[7]);
			Matrix newR=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(r);
			// Use the set method so the new rotation matrix is passed back
			R.set(0,0,newR.get(0,0));
			R.set(1,0,newR.get(1,0));
			R.set(2,0,newR.get(2,0));
			R.set(0,1,newR.get(0,1));
			R.set(1,1,newR.get(1,1));
			R.set(2,1,newR.get(2,1));
			R.set(0,2,newR.get(0,2));
			R.set(1,2,newR.get(1,2));
			R.set(2,2,newR.get(2,2));
			// And the translation vector
			t.set(0,0,a[8]);
			t.set(1,0,a[9]);
			t.set(2,0,a[10]);
			// The zscalecofficient
			zscalefactor=a[11];
			// The distortion coefficient
			k1=a[12];
			// And the image origin
			imageorigin.x=a[13];
			imageorigin.y=a[14];
			
	} // end of method

	/***********************************************************************************************************************************************************
	 * 
	 * Nested classes that specify what we are trying to minimise 
	 * 
	 *
	 *************************************************************************************************************************************************************/
	
	class LMHomographyAdjustment implements LMfunc
	  {
	   public Point2d[] lookup;
		public double[] initial(){return (null);} // Not called
	   public Object[] testdata() { return (null);} // Not called
	   public Point2d adjust(Point2d y, double[] a) { return y;} // No adjustments need to be made to y 
	   /**
	    * x is a single point, but domain may be mulidimensional
	    * 
	    * In this case x will be a homogeneous 2d point (i.e. 3 dimensional) and the value returned is this point transformed to an inhomogeneous point on the image plane (i.e. a CVecotr2d).
	    *
	    *
	    */
	    
	   public Point2d val(double[] x, double[] a)
	    {
		   // if x[0] is 1 just return xhat
		   Point2d returnvalue=new Point2d(a[(int)x[1]],a[(int)x[2]]);
		   if (x[0]==2){
			   // if x[0] is 2 return Hxhat
			   Matrix point=new Matrix (3,1);
			   point.set(0,0,returnvalue.x);
			   point.set(1,0,returnvalue.y);
			   point.set(2,0,1);
			   Matrix H=new Matrix (3,3);
			   	H.set(0,0,a[0]);
				H.set(0,1,a[1]);
				H.set(0,2,a[2]);
				H.set(1,0,a[3]);
				H.set(1,1,a[4]);
				H.set(1,2,a[5]);
				H.set(2,0,a[6]);
				H.set(2,1,a[7]);
				H.set(2,2,a[8]);
				returnvalue=new Point2d(H.times(point));
		   }
		   return returnvalue;
	    } //val
	  

	  } //end of nested class 

	
	class LMCameraCalibrationAdjustment implements LMfunc
	  {
	   public double[] initial(){return (null);} // Not called
	   public Object[] testdata() { return (null);} // Not called
	    /***
	    * Adjust does any post adjustments to the y point using the parameters b
	    * For example polynomial radial distortion estimation is based on the distance between y and the image centre and is not easily expressible in terms of x (real world point to be transformed to image coordinates)
	    * So to compare apples to apples you use the adjust method to undo the radial distortion of an image and use the ordinary solve to transform a world point to an undistorted image point.
	    * 
	    * Note that this does not apply when talking about an invertible distortion matrix as it can be inverted and applied to the x vector
	    * 
	    * If there are no adjustments to do just return y
	    */
	   public Point2d adjust(Point2d y, double[] a) {
		LensDistortion undistort=new LensDistortion();
		//Set the distortion center
		 Point2d center=new Point2d(a[13],a[14]);
		 // Set the distortion coefficient
		 undistort.SetDistortionCoefficient(a[12],center);
		 // Get the undistorted point
		 return undistort.UndoDistortion(y);
	   }
	   
	   
	   
	   /**
	    * x is a single point, but domain may be mulidimensional
	    * 
	    * In this case x will be a homogeneous real world point (i.e. 4 dimensional) and the value returned is this point transformed to an inhomogeneous point on the image plane (i.e. a CVecotr2d).
	    *
	    *
	    */
	    
	   public Point2d val(double[] x, double[] a)
	    {
		   
		   // Set up the K, R, t and Z matrices from the a array
		   Matrix K=new Matrix(3,3);
		   K.set(0,0,a[0]);
		   K.set(1,1,a[1]);
		   K.set(0,1,a[2]);
		   K.set(0,2,a[3]);
		   K.set(1,2,a[4]);
		   K.set(2,2,1);
		   
		   // The rotation matrix parameters
		   Matrix r=new Matrix(3,1);
		   r.set(0,0,a[5]);
		   r.set(1,0,a[6]);
		   r.set(2,0,a[7]);
		   
		   Matrix R=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(r);
		   
		   // The translation vector
		   Matrix t=new Matrix(3,1);
		   t.set(0,0,a[8]);
		   t.set(1,0,a[9]);
		   t.set(2,0,a[10]);
		   
		   // The Z scale
		   Matrix Z=new Matrix (4,4);
		   Z.set(0,0,1);
		   Z.set(1,1,1);
		   Z.set(2,2,a[11]);
		   Z.set(3,3,1);
		   
		 // The image origin
		   Point2d origin=new Point2d(a[13],a[14]);
		   
		     
		   // Now combine them to give a World to image transform
		   Matrix P=new MatrixManipulations().WorldToImageTransformMatrix(K, R, t, Z);
		   
		   // It is assumed that the x array is 2 values: x and y coordinates on the calibration sheet (z=0)
		   // that are the centre of a circle (with radius of circleradius). We want to return the centre of the ellipse this circle is transformed to 
		   // Normally this will give an answer that is within a pixel of the centre of the circle anyway (unless viewed at very low angle to calibration sheet)
		   // TODO can we get rid of this estimation and speed up the algorithm significantly?
		   ellipse.ResetCenter(new Point2d(x[0],x[1]));
		   Ellipse newellipse=new Ellipse(P,origin,ellipse,stepsaroundcircle);
		   return newellipse.GetCenter();
		  
	    } //val
	  

	  } //end of nested class 

	
	
	} // end of class

