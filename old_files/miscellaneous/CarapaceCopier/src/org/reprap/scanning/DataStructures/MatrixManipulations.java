package org.reprap.scanning.DataStructures;

import org.reprap.scanning.Geometry.AxisAlignedBoundingBox;
import org.reprap.scanning.Geometry.Point2d;
import org.reprap.scanning.Geometry.PointPair2D;

import ZS.Solve.LM;
import ZS.Solve.LMfunc;
import Jama.*;

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
* This is just a class with a few common matrix functions that are not in the Jama toolset.
*  (As well as some more uncommon ones that have proven useful in more than one place)
* 
*  Most of these are static methods but it also contains a couple of methods that do the heavy lifting in other classes such as the Fundamental Matrix calculation
*   and calculation of Image Rectification Homography matrices
*   
*******************************************************************************/
import org.reprap.scanning.Geometry.*;

public class MatrixManipulations {
	 private Matrix FundamentalMatrix=new Matrix(3,3); 
	 boolean printF=false;// only for testing purposes
	 boolean printrectification=false; //only for test purposes
	 
	 
	 public static Matrix getRotationplusTranslation(Matrix R, Matrix t){
		 Matrix RplusT=new Matrix(3,4);
		 RplusT.setMatrix(0,2,0,2,R);
		 RplusT.setMatrix(0,2,3,3,t);
		 return RplusT;
	 }
//TODO implement DistortionMatrix?
	 public static Matrix WorldToImageTransformMatrix(Matrix K, Matrix R, Matrix t, Matrix Z){
			return K.times(getRotationplusTranslation(R,t).times(Z));
	 }
//	This assumes the point given is a 4x1 matrix representing a 3d point in homogeneous coordinates
	 public static Matrix WorldToImageTransform(Matrix point, Matrix K, Matrix R, Matrix t, Matrix Z, Point2d imageorigin){
	 	Matrix P=WorldToImageTransformMatrix(K,R,t,Z);
		return WorldToImageTransform(point, imageorigin, P);
	 }
	
	public static Point2d TransformCalibrationSheetPointToImagePoint(Point2d calibrationsheetpoint, Point2d imageorigin, Matrix P){
		Matrix point=new Matrix(4,1);
		point.set(0,0,calibrationsheetpoint.x);
		point.set(1,0,calibrationsheetpoint.y);
		point.set(2,0,0);
		point.set(3,0,1);
		return new Point2d(WorldToImageTransform(point,imageorigin,P));
	}
	
	 public static Matrix WorldToImageTransform(Matrix point, Point2d imageorigin, Matrix P){
		Matrix imgpoint=P.times(point);
		Matrix imgorigin=new Matrix(3,1);
	 	imgorigin.set(0,0,imageorigin.x);
	 	imgorigin.set(1,0,imageorigin.y);
	 	imgorigin.set(2,0,0);
	 	imgorigin.timesEquals(imgpoint.get(2,0));
	 	imgpoint=imgpoint.plus(imgorigin);
	 	return imgpoint;
	 }
	 
	 public static double TransferError(PointPair2D pair, Matrix H){
		 Matrix p1=new Matrix(3,1);
			p1.set(0,0,pair.pointone.x);
			p1.set(1,0,pair.pointone.y);
			p1.set(2,0,1);
			Point2d calculatedpointtwo=new Point2d(H.times(p1));
			Matrix p2=new Matrix(3,1);
			p2.set(0,0,pair.pointtwo.x);
			p2.set(1,0,pair.pointtwo.y);
			p2.set(2,0,1);
			Point2d calculatedpointone=new Point2d(H.inverse().times(p2));
			return (pair.pointone.CalculateDistanceSquared(calculatedpointone)+pair.pointtwo.CalculateDistanceSquared(calculatedpointtwo));
	 }
	  
	 
	public static Matrix GetLeftNullSpace(Matrix M){
		// The left null space is x in the equation x^TM=0
		// Note the transpose there. This is so that we can say that the left null space is the same as the right null space for the transpose of the matrix
		// i.e. M^Tx=0 and just put a call through to that
		return (GetRightNullSpace(M.transpose()));
	}
	public static Matrix getZscaleMatrix(double zscalefactor){
		 Matrix returnvalue=new Matrix(4,4);
		 returnvalue.set(0,0,1);
		 returnvalue.set(1,1,1);
		 returnvalue.set(2,2,zscalefactor);
		 returnvalue.set(3,3,1);
		 return returnvalue;
	 }
	public static Matrix GetRightNullSpace(Matrix M){
		// The right null space is x in the equation Mx=0

		// take one off all the numbers as we'll be using them as array indexes which start at 0.
		int m=M.getRowDimension()-1;
		int n=M.getColumnDimension()-1;
		int r=M.rank()-1;
		// Now if we simply use the solve method it will find that x=0 but we can use SVD to find V and the nullspace will be the 
		// last n-r columns of this matrix (where r is the rank) 
		// We can't do this if the rank is same as (it should never be greater than) the number of columns or if there are more columns than rows
		// In the case where there are more columns than rows we can bulk up the matrix with additional rows of zeros
		if (r<n) {
			if (m<n){
				Matrix temp=new Matrix(n+1,n+1);
				temp.setMatrix(0,m,0,n,M);
				M=temp.copy();
				m=n;
			}
			return (M.svd().getV().getMatrix(0,m,r+1,n));
		}
		else return (M);
	}
	// This is not a generalised skew symetric Cross Product but is specifically for a 3x1 vector which is all we need at the moment.
	// In the future it may be generalised to include the 7x1 Vector (this is a valid operation for 3 and 7 dimensions only).
	public static Matrix getCrossProductMatrixof3x1Vector(Matrix e){
		 //[e]x is the skew-symmetric 3 × 3 matrix representing the cross product	
		 /* of a 3x1 vector e (e1,e2,e3)^T:
		  *			  0,-e3, e2
		  *	[e]x=	 e3, 0 ,-e1
		  *			-e2, e1, 0
		  */
		// By definition axb=[a]xb

		Matrix ex=new Matrix(3,3);
		if ((e.getRowDimension()==3) && (e.getColumnDimension()==1)){
			ex.set(0,0,0);
			ex.set(0,1,(e.get(2,0)*-1));
			ex.set(0,2,e.get(1,0));
			ex.set(1,0,e.get(2,0));
			ex.set(1,1,0);
			ex.set(1,2,(e.get(0,0)*-1));
			ex.set(2,0,(e.get(1,0)*-1));
			ex.set(2,1,e.get(0,0));
			ex.set(2,2,0);
		}
		return ex; 
	 }
	
	// Convert from axis/angle to the quarternion equivalent and then to the rotation matrix equivalent
	public static Matrix Calculate3x3RotationMatrixFor3DVectorUsingQuarternions(double angle,Point3d axisofrotation){
		Matrix matrix=new Matrix(3,3);
		// The following is an implementation of the formulae provided in answer to http://www.j3d.org/matrix_faq/matrfaq_latest.html#38
		double rcos=Math.cos(angle);
		double rsin=Math.sin(angle);
		// first we need to normalise the axis of rotation (the V vector)
		Point3d normalisedvector=axisofrotation.clone();
		normalisedvector=normalisedvector.times(1/Math.sqrt(normalisedvector.lengthSquared()));
		matrix.set(0,0,rcos + (normalisedvector.x*normalisedvector.x*(1-rcos)));
		matrix.set(1,0,(normalisedvector.z * rsin) + (normalisedvector.y*normalisedvector.x*(1-rcos)));
		matrix.set(1,0,(-normalisedvector.y * rsin) + (normalisedvector.z*normalisedvector.x*(1-rcos)));
		matrix.set(0,1,(-normalisedvector.z * rsin) + (normalisedvector.x*normalisedvector.y*(1-rcos)));
		matrix.set(1,1,rcos + (normalisedvector.y*normalisedvector.y*(1-rcos)));
		matrix.set(2,1,(normalisedvector.x * rsin) + (normalisedvector.z*normalisedvector.y*(1-rcos)));
		matrix.set(0,2,(normalisedvector.y * rsin) + (normalisedvector.x*normalisedvector.z*(1-rcos)));
		matrix.set(1,2,(-normalisedvector.x * rsin) + (normalisedvector.y*normalisedvector.z*(1-rcos)));
		matrix.set(2,2,rcos + (normalisedvector.z*normalisedvector.z*(1-rcos)));

		return matrix;
	}
	
	public static Point3d RotatePointCaroundLineAB(double angle,Point3d a, Point3d b, Point3d c){
		Point3d ab=b.minus(a);
		Point3d ac=c.minus(a);
		Matrix R=Calculate3x3RotationMatrixFor3DVectorUsingQuarternions(angle,ab);
		Point3d returnvalue=new Point3d(R.times(ac.ConvertPointTo3x1Matrix()));
		returnvalue=returnvalue.plus(a);
		return returnvalue;
	}
	
	public Matrix[] CalculateImageRectificationHomographies(AxisAlignedBoundingBox image1, AxisAlignedBoundingBox image2){
		// A rectification is the process of aligning the images so that any point in one image is projected 
		// to a horizontal line in the other image so that the process of searching for matches is reduced.
		
		// By definition we are trying to find H and H' such that F=H'^T[i]xH with i=1,0,0.
		// There are multiple solutions so we are trying to find the one that minimises distortion (up to scale)
		// It is assumed that the Fundamental Matrix has already been calculated
		// We further break this down into H=HsHrHp (and H'=H'sH'rH'p)
		// where Hp is a projective transform, Hr is a similarity transform, and Hs is a shearing transform
		// Finally a scaling is applied to preserve the sum of the image areas to make it more managable esp. if you want to display the rectified images.
		// Taken from MSR-TR-99-21 published as "Computing rectifying homographies for stereo vision" in Proceedings of the IEEE Computer Society Conference on Computer Vision and Pattern Recognition
		// 1999 Volume 1 pages 125-131
		// downloadable from ftp://ftp.research.microsoft.com/pub/tr/tr-99-21.pdf
		
		// Finding Hr and Hr'
		//-------------------
		// This is restricted to finding two 3x1 vectors w and w' where w=[e]xz and w'=Fz where z=(?,?,0).
		// As we can only find it up to scale we simply set z=(lambda,1,0)
		// so we need to minimise a 7th degree polynomial iteratively after taking an initial guess.
		// The initial guess is based on the average value of z with two minimisations z^TAz/z^TBz and z^TA'z/z^TB'z where A,A',B, and B' are
		// constructed from [e]x, F, and the width and height of the images.
		Matrix Hp=new Matrix(3,3);
		Hp.set(0,0,1);
		Hp.set(1,1,1);
		Hp.set(2,2,1);
		Matrix Hpdash=new Matrix(3,3);
		Hpdash.set(0,0,1);
		Hpdash.set(1,1,1);
		Hpdash.set(2,2,1);
		double image1width=image1.maxx-image1.minx;
		double image2width=image2.maxx-image2.minx;
		double image1height=image1.maxy-image1.miny;
		double image2height=image2.maxy-image2.miny;
		// The epipole e is the solution to Fe=0 i.e. the right null space
		Matrix e=GetRightNullSpace(FundamentalMatrix);
		Matrix ex=getCrossProductMatrixof3x1Vector(e);
		// construct A,A',B, and B' from Section 5.1 of the aforementioned Technical report/paper
		Matrix PPT=new Matrix(3,3);
		PPT.set(0,0,(image1width*image1width)-1);
		PPT.set(1,1,(image1height*image1height)-1);
		PPT.set(2,2,1);
		PPT.timesEquals((image1width*image1height)/12);
		
		Matrix PPTdash=new Matrix(3,3);
		PPTdash.set(0,0,(image2width*image2width)-1);
		PPTdash.set(1,1,(image2height*image2height)-1);
		PPTdash.set(2,2,1);
		PPTdash.timesEquals((image2width*image2height)/12);
		
		Matrix pcpcT=new Matrix(3,3);
		pcpcT.set(0,0,(image1width-1)*(image1width-1));
		pcpcT.set(0,1,(image1width-1)*(image1height-1));
		pcpcT.set(0,2,2*(image1width-1));
		pcpcT.set(1,0,(image1width-1)*(image1height-1));
		pcpcT.set(1,1,(image1height-1)*(image1height-1));
		pcpcT.set(1,2,2*(image1height-1));
		pcpcT.set(2,0,2*(image1width-1));
		pcpcT.set(2,1,2*(image1height-1));
		pcpcT.set(2,2,4);
		pcpcT.timesEquals(0.25);
		
		Matrix pcpcTdash=new Matrix(3,3);
		pcpcTdash.set(0,0,(image2width-1)*(image2width-1));
		pcpcTdash.set(0,1,(image2width-1)*(image2height-1));
		pcpcTdash.set(0,2,2*(image2width-1));
		pcpcTdash.set(1,0,(image2width-1)*(image2height-1));
		pcpcTdash.set(1,1,(image2height-1)*(image2height-1));
		pcpcTdash.set(1,2,2*(image2height-1));
		pcpcTdash.set(2,0,2*(image2width-1));
		pcpcTdash.set(2,1,2*(image2height-1));
		pcpcTdash.set(2,2,4);
		pcpcTdash.timesEquals(0.25);
		
		// Note that this is also truncating to 2x2 upper matrix from the 3x3 that is calculated  
		Matrix A=ex.transpose().times(PPT.times(ex)).getMatrix(0,1,0,1);
		Matrix B=ex.transpose().times(pcpcT.times(ex)).getMatrix(0,1,0,1);
		Matrix Adash=FundamentalMatrix.transpose().times(PPTdash.times(FundamentalMatrix)).getMatrix(0,1,0,1);
		Matrix Bdash=FundamentalMatrix.transpose().times(pcpcTdash.times(FundamentalMatrix)).getMatrix(0,1,0,1);
		
		
		// The solutions for z we want are D^-1y and D'^-1y' where y is the largest eigenvector of E=D^-TBD^-1 and E'=D'^-TB'D'^-1 when A and A' are deconstructed so that A=D^TD and A'=D'^TD'
		// Desconstruct A and A' to find D and D' and construct E and E'.
		Matrix D=A.chol().getL().transpose();
		Matrix Ddash=Adash.chol().getL().transpose();
		Matrix E=D.transpose().times(B.times(D.inverse()));
		Matrix Edash=Ddash.transpose().times(Bdash.times(Ddash.inverse()));
		// Find y and ydash as larger of the two eigenvectors of E and Edash
		Matrix eigenvectors=E.eig().getV();
		Matrix eigenvectorsdash=Edash.eig().getV();
		
		Matrix y=eigenvectors.getMatrix(0,1,0,0);
		Matrix temp=eigenvectors.getMatrix(0,1,1,1);
		if (new Point2d(y).lengthSquared()<new Point2d(temp).lengthSquared()) y=temp.copy();
		
		Matrix ydash=eigenvectorsdash.getMatrix(0,1,0,0);
		temp=eigenvectorsdash.getMatrix(0,1,1,1);
		if (new Point2d(ydash).lengthSquared()<new Point2d(temp).lengthSquared()) ydash=temp.copy();

		// Find z1 and z2 and therefore initial lambda
		Matrix z1=D.inverse().times(y);
		Matrix z2=Ddash.inverse().times(ydash);
		double[] lambda=new double[1];
		lambda[0]=0.5*((z1.get(0,0)/z1.get(1,0))+(z2.get(0,0)/z2.get(1,0)));
		// Iteratively minimise to find lambda
		// In using the LM algorihm implemented there are a number of irrelevencies as we are trying to minimise a simple function with scalar input and scalar output
		// without reference to input or output points (x and y values), and the one parameter obviously must be varied and scaled by 1
		// The LM minimisation minimises the sum of the square of difference in distance between the 2d points y[k] and f(x[k],a)) where x[1..k] and y[1..k] are the sets of input (scalars) and output (2d vector) and a is the set of changable variables
		// in this case we simply want a function g(lambda) to be as close to zero as possible, therefore we can set the length of x and y to be 1 and the actual x value is zero and y value is the origin
		// a is simply a one element set which contains lambda and the function f(x[k],a) returns a 2-vector with y value equal to 0.
		// so we are therefore minimising the square of the distance between the origin and f(0,lambda).x=g(lambda)
		
		boolean[] vary=new boolean[1];
		vary[0]=true;
		double[] scale=new double[1];
		scale[0]=1;
		double[][] nullx=new double[1][1];
		Point2d[] nully=new Point2d[1];
		nully[0]=new Point2d(0,0);
		
		// The private LMlambdaadjustment class below contains the val method called when evaluating the value of f(x[k],a) and does the actual work of evaluating the lambda value.
		LMlambdaadjustment adjust=new LMlambdaadjustment();
		// Rather than pass all the non-varying parameters in, we have them as public variables used in the val method 
		adjust.A=A.copy();
		adjust.B=B.copy();
		adjust.Adash=Adash.copy();
		adjust.Bdash=Bdash.copy();
		// Now finally do the bundle adjustment for a maximum of 100 iterations
		try {
	     // Note that the true means it will throw an exception when the hessian matrix is singular and it can't continue.
			LM.solve(nullx,lambda, nully, scale, vary, adjust, 10000, 0.000001, 100,-1,true);
	   }
		 catch(Exception exception) {
				// If the Matrix is singular that means we can't go any further so just ignore and move on
				if (exception.getMessage()!="Matrix is singular.") 
					System.err.println("Exception caught: " + exception.getMessage());
		    }
		 
		// Set w and w' (w=[e]xz and w'=Fz)
		Matrix z=new Matrix(3,1);
		z.set(0,0,lambda[0]);
		z.set(1,0,1);
		z.set(2,0,0);
		Matrix w=ex.times(z);
		Matrix wdash=FundamentalMatrix.times(z);
		// Set the rest of Hp and H'p
		Hp.set(2,0,w.get(0,0)/w.get(2,0));
		Hp.set(2,1,w.get(1,0)/w.get(2,0));
		Hpdash.set(2,0,wdash.get(0,0)/wdash.get(2,0));
		Hpdash.set(2,1,wdash.get(1,0)/wdash.get(2,0));
		
		// Finding Hr and H'r
		//---------------------
		Matrix Hr=new Matrix(3,3);
		Matrix Hrdash=new Matrix(3,3);
		//Once we've found Hp and H'p we can set most of Hr and H'r using them and F
		double F33=FundamentalMatrix.get(2,2);
		Hr.set(0,0,FundamentalMatrix.get(2,1)-(Hp.get(2,1)*F33));
		Hr.set(1,0,FundamentalMatrix.get(2,0)-(Hp.get(2,0)*F33));
		Hr.set(0,1,(Hp.get(2,0)*F33)-FundamentalMatrix.get(2,0));
		Hr.set(1,1,Hr.get(0,0));
		Hr.set(2,2,1);
		
		Hrdash.set(0,0,(Hpdash.get(2,1)*F33)-FundamentalMatrix.get(1,2));
		Hrdash.set(1,0,(Hpdash.get(2,0)*F33)-FundamentalMatrix.get(0,2));
		Hrdash.set(0,1,FundamentalMatrix.get(0,2)-(Hpdash.get(2,0)*F33));
		Hrdash.set(1,1,Hrdash.get(0,0));
		Hrdash.set(2,2,1);
		// We are then left to find the final terms Hr23 and Hr'23. In Hr it is F33+v' and simply v' in H'r where v' is found so that the minimum v coordinate in either image is zero.
		
		// For the temporary transformation we can set Hr23 to be F33 so we don't have to do it inline
		Hr.set(1,2,F33);
		double offset=image1.GetTransformedAxisAligned2DBoundingBox(Hr.times(Hp)).miny;
		double vdash=image2.GetTransformedAxisAligned2DBoundingBox(Hrdash.times(Hpdash)).miny;
		if (vdash<offset) offset=vdash;
		offset=offset*-1;
		// put into Hr and H'r
		Hr.set(1,2,F33+offset);
		Hrdash.set(1,2,offset);
		// Multiply HrHp and H'rH'p for an intermediary H and Hdash for use in calculating Hs and H's
		Matrix tempH=Hr.times(Hp);
		Matrix tempHdash=Hrdash.times(Hpdash);
		
		// Finding Hs and H's
		//---------------------
		// Do independently for each image
		// Initially two terms a and b are calculated up to sign based on width and height of each image and HrHp or H'rH'p (intermediary H and H')
		Matrix Hs=new Matrix(3,3);
		Matrix Hsdash=new Matrix(3,3);
		Hs.set(1,1,1);
		Hs.set(2,2,1);
		Hsdash.set(1,1,1);
		Hsdash.set(2,2,1);
		
		// Calculate the first two terms for Hs
		Point2d ahat=new Point2d((image1width-1)/2,0);
		ahat.ApplyTransform(tempH);
		Point2d chatminusahat=new Point2d((image1width-1)/2,image1height-1);
		chatminusahat.ApplyTransform(tempH);
		chatminusahat.minus(ahat);
		
		Point2d dhat=new Point2d(0,(image1height-1)/2);
		dhat.ApplyTransform(tempH);
		Point2d bhatminusdhat=new Point2d(image1width-1,(image1height-1)/2);
		bhatminusdhat.ApplyTransform(tempH);
		bhatminusdhat.minus(dhat);
		double xu=bhatminusdhat.x;
		double xv=bhatminusdhat.y;
		double yu=chatminusahat.x;
		double yv=chatminusahat.y;
		
		
		double a=((image1height*image1height*xv*xv)+(image1width*image1width*yv*yv))/(image1height*image1width*((xv*yu)-(xu*yv)));
		double b=((image1height*image1height*xu*xv)+(image1width*image1width*yu*yv))/(image1height*image1width*((xu*yv)-(xv*yu)));
		// We have the choice of having a and b as positive or negative, we choose the option where a is positive
		if (a<0) {
			a=a*-1;
			b=b*-1;
		}
		Hs.set(0,0,a);
		Hs.set(0,1,b);
		
		
		// Calculate the first two terms for Hsdash
		ahat=new Point2d((image2width-1)/2,0);
		ahat.ApplyTransform(tempHdash);
		chatminusahat=new Point2d((image2width-1)/2,image2height-1);
		chatminusahat.ApplyTransform(tempHdash);
		chatminusahat.minus(ahat);
		
		dhat=new Point2d(0,(image2height-1)/2);
		dhat.ApplyTransform(tempHdash);
		bhatminusdhat=new Point2d(image2width-1,(image2height-1)/2);
		bhatminusdhat.ApplyTransform(tempHdash);
		bhatminusdhat.minus(dhat);
		xu=bhatminusdhat.x;
		xv=bhatminusdhat.y;
		yu=chatminusahat.x;
		yv=chatminusahat.y;
		
		
		a=((image2height*image2height*xv*xv)+(image2width*image2width*yv*yv))/(image2height*image2width*((xv*yu)-(xu*yv)));
		b=((image2height*image2height*xu*xv)+(image2width*image2width*yu*yv))/(image2height*image2width*((xu*yv)-(xv*yu)));
		if (a<0) {
			a=a*-1;
			b=b*-1;
		}
		Hsdash.set(0,0,a);
		Hsdash.set(0,1,b);
		
		
		// Calculate the third term for Hs and Hsdash which is uniform translation in u so that min pixel coordinate has u=0
		//offset=image1.GetTransformedAxisAligned2DBoundingBox(Hs.times(Hr.times(Hp))).minx;
		//double udash=image2.GetTransformedAxisAligned2DBoundingBox(Hsdash.times(Hrdash.times(Hpdash))).minx;
		//if (udash<offset) offset=udash;
		//offset=offset*-1;
		offset=image1.GetTransformedAxisAligned2DBoundingBox(Hs.times(Hr.times(Hp))).minx;
		offset=offset*-1;
		Hs.set(0,2,offset);
		offset=image2.GetTransformedAxisAligned2DBoundingBox(Hsdash.times(Hrdash.times(Hpdash))).minx;
		offset=offset*-1;
		Hsdash.set(0,2,offset);
		// As the homography is only up to scale, calculate a scaling factor so that the sum of image areas is preserved for convienence
		double desiredsum=(image1width*image1height)+(image2width*image2height);
		// Find the four corners in each transformed image
		Point2d[] image1corners=image1.GetTransformedCornersof2DBoundingBox(Hs.times(Hr.times(Hp)));
		Point2d[] image2corners=image2.GetTransformedCornersof2DBoundingBox(Hsdash.times(Hrdash.times(Hpdash)));
		// Note that the corner pairs 0+3, and 1+2 are on diagonally opposite corners
		// So the area=01*02 i.e. the length of the side between corners 0 and 1 multipled by the length of the side between corners 0 and 2
		double newimage1area=Math.sqrt(image1corners[0].CalculateDistanceSquared(image1corners[1])*image1corners[0].CalculateDistanceSquared(image1corners[2]));
		double newimage2area=Math.sqrt(image2corners[0].CalculateDistanceSquared(image2corners[1])*image2corners[0].CalculateDistanceSquared(image2corners[2]));
		// Therefore the scaling matrix is
		double scalefactor=Math.sqrt((newimage1area+newimage2area)/desiredsum);
		Matrix scaling=new Matrix(3,3);
		scaling.set(0,0,1);
		scaling.set(1,1,1);
		scaling.set(2,2,scalefactor);
		// Calculate the final H and H'
		Matrix[] returnvalue=new Matrix[2];
		returnvalue[0]=scaling.times(Hs.times(Hr.times(Hp)));
		returnvalue[1]=scaling.times(Hsdash.times(Hrdash.times(Hpdash)));
		
		// Print out for test purposes
		if (printrectification){
			System.out.println("Scaling factor="+scalefactor);
			System.out.println("Desired Area Sum="+desiredsum);
			System.out.println("Hs=");
			Hs.print(10,20);
			System.out.println("Hr=");
			Hr.print(10,20);
			System.out.println("Hp=");
			Hp.print(10,20);
			System.out.println("Hs'=");
			Hsdash.print(10,20);
			System.out.println("Hr'=");
			Hrdash.print(10,20);
			System.out.println("Hp'=");
			Hpdash.print(10,20);
			System.out.println("Corners for image 1");
			Point2d[] tempcorners=image1.GetTransformedCornersof2DBoundingBox(returnvalue[0]);
			for (int i=0;i<tempcorners.length;i++) tempcorners[i].print();
			System.out.println();
			System.out.println("New Area for image1="+Math.sqrt(tempcorners[0].CalculateDistanceSquared(tempcorners[1])*tempcorners[0].CalculateDistanceSquared(tempcorners[2])));
			System.out.println("Corners for image 2");
			tempcorners=image2.GetTransformedCornersof2DBoundingBox(returnvalue[1]);
			for (int i=0;i<tempcorners.length;i++) tempcorners[i].print();
			System.out.println();
			System.out.println("New Area for image2="+Math.sqrt(tempcorners[0].CalculateDistanceSquared(tempcorners[1])*tempcorners[0].CalculateDistanceSquared(tempcorners[2])));
			System.out.println("Corners for image 1 without scaling factor");
			tempcorners=image1.GetTransformedCornersof2DBoundingBox(Hs.times(Hr.times(Hp)));
			for (int i=0;i<tempcorners.length;i++) tempcorners[i].print();
			System.out.println();
			System.out.println("Corners for image 2 without scaling factor");
			tempcorners=image2.GetTransformedCornersof2DBoundingBox(Hsdash.times(Hrdash.times(Hpdash)));
			for (int i=0;i<tempcorners.length;i++) tempcorners[i].print();
			System.out.println();
			System.out.println("Corners for image 1 without scaling factor or skew");
			tempcorners=image1.GetTransformedCornersof2DBoundingBox(Hr.times(Hp));
			for (int i=0;i<tempcorners.length;i++) tempcorners[i].print();
			System.out.println();
			System.out.println("Corners for image 2 without scaling factor or skew");
			tempcorners=image2.GetTransformedCornersof2DBoundingBox(Hrdash.times(Hpdash));
			for (int i=0;i<tempcorners.length;i++) tempcorners[i].print();
			System.out.println();
		}
		
		return returnvalue;
		
	}

	public static double DistanceFromOriginof3x1Vector(Matrix temp){
		return Math.sqrt(Math.pow(temp.get(0,0),2)+Math.pow(temp.get(1,0),2)+Math.pow(temp.get(2,0),2));
	}
	//	 This returns the normalisation matrix calculated from a set of 2D points and a hardcoded average distance sqrt(2) 
	public static Matrix CalculateNormalisationMatrix(Point2d[] pointsarray){
			return CalculateNormalisationMatrix(pointsarray,Math.sqrt(2));
	}
//	This returns the normalisation matrix calculated from a set of 2D points with a specified average distance between them
	public static Matrix CalculateNormalisationMatrix(Point2d[] pointsarray, double newaveragedistance){
	Matrix T=new Matrix(3,3); // construct a 3x3 matrix of zeros

//	find centroid
	Point2d centroid=CalculateCentroid(pointsarray);
//	create translation matrix
	Matrix move=new Matrix(3,3);
	move.set(0,2,-centroid.x);
	move.set(1,2,-centroid.y);
	move.set(0,0,1);
	move.set(1,1,1);
	move.set(2,2,1);
//	find mean square distance between centroid and points
	double avgdistance=0;
	for (int i=0;i<pointsarray.length;i++){
		avgdistance=avgdistance+Math.sqrt(centroid.CalculateDistanceSquared(pointsarray[i]));
	}
	avgdistance=avgdistance/pointsarray.length;	
//	calculate scale factor to make average distance equal to the required one
	double scalefactor=newaveragedistance/avgdistance;
//	create scaling matrix
	Matrix scale=new Matrix (3,3);
	scale.set(0,0,scalefactor);
	scale.set(1,1,scalefactor);
	scale.set(2,2,1);

//	build up T matrix from translation and scaling matrices
//	This could be done as one matrix but I think it is clearer if it is a combination of two.
	T=scale.times(move);
	return T;
} // end of method CalculateNormalisationMatrix

// This takes two already found camera matrices and calculates the Fundamental matrix relating the two
	public boolean SetF(Matrix P, Matrix Pdash){
		// F=[e']xP'P+ where P+ is the psuedo inverse of P i.e. PP+=I and e'=P'C with PC=0
		Matrix C=GetRightNullSpace(P);
		Matrix edash=Pdash.times(C);
		Matrix edashx=getCrossProductMatrixof3x1Vector(edash);
		Matrix Pplus=PseudoInverse(P);
		
		
		FundamentalMatrix=edashx.times(Pdash.times(Pplus));
		
		return true;
	}
	//Note that the Matrix class has an inverse function that tries to get the pseudoinverse through QR decomposition if the matrix is not square but this can fail with an error "Matrix is rank deficient"
	// so here is another of doing it without this problem
	public static Matrix PseudoInverse(Matrix A){
		// Given a square diagonal matrix D we define the psuedo inverse D+ to be a square diagonal matrix with values of 1/d where d is the corresponding element from D except when d=0, in which case we set the element to be 0
		// In the general case, a matrix A can be decomposed via SVD into A=USV^T and so A+ is defined as VS+U^T

		// First bulk up A if need be as SVD needs rows>=columns
		
		// take one off all the numbers as we'll be using them as array indexes which start at 0.
		int m=A.getRowDimension()-1;
		int n=A.getColumnDimension()-1;
		// In the case where there are more columns than rows we can bulk up the matrix with additional rows of zeros
		if (m<n) {
				Matrix temp=new Matrix(n+1,n+1);
				temp.setMatrix(0,m,0,n,A);
				A=temp.copy();
		}
		SingularValueDecomposition SVD=A.svd();
		Matrix U=SVD.getU();
		Matrix S=SVD.getS();
		Matrix V=SVD.getV();
		Matrix Splus=S.copy();
		for (int i=0;i<Splus.getColumnDimension();i++){
			if (Splus.get(i,i)!=0) Splus.set(i,i,1/Splus.get(i,i));
		}
		
		Matrix Aplus=V.times(Splus.times(U.transpose()));
		if (m<n) return Aplus.getMatrix(0,n,0,m); // remember to strip off the rows of zeros, which are now columns
		else return Aplus;
	}
	
//	This takes an array of point pairs and calculates the Fundamental matrix for the two images if possible using the normalised 8 point algorithm
//	which needs at least eight point pairs to work. The Fundamental matrix encodes all the information needed to transform one image into the other. 
	public boolean SetF(Point2d[] One, Point2d[] Two){
	int length=One.length;
	boolean returnvalue=((One.length==Two.length) && (length>=8));
	if (returnvalue){
		// Clone the arrays (so the manipulations don't propogate back to the original arrays
		Point2d[] PointsInImageOne=new Point2d[length];
		Point2d[] PointsInImageTwo=new Point2d[length];
		for (int i=0; i<length;i++){
			PointsInImageOne[i]=One[i].clone();
			PointsInImageTwo[i]=Two[i].clone();
		}
		//Calculate the Normalisation matrices for each image.
		Matrix Normalisation1=CalculateNormalisationMatrix(PointsInImageOne);
		Matrix Normalisation2=CalculateNormalisationMatrix(PointsInImageTwo);

		//Apply the normalisation matrices to each set of points
		for (int i=0;i<length;i++){
			boolean success=PointsInImageOne[i].ApplyTransform(Normalisation1);
			if (!success) System.out.println("Error trying to apply transform to points in image one");
			returnvalue=(returnvalue && success);
			success=PointsInImageTwo[i].ApplyTransform(Normalisation2);
			if (!success) System.out.println("Error trying to apply transform to points in image two");
			returnvalue=(returnvalue && success);
		}

		//Use these normalised point pairs to find initial F - assuming there are enough independent point pairs
		Matrix A=new Matrix(length,9);
		for (int i=0;i<length;i++){
			A.set(i,0,(double)(PointsInImageTwo[i].x*PointsInImageOne[i].x));
			A.set(i,1,(double)(PointsInImageTwo[i].x*PointsInImageOne[i].y));
			A.set(i,2,PointsInImageTwo[i].x);
			A.set(i,3,(double)(PointsInImageTwo[i].y*PointsInImageOne[i].x));
			A.set(i,4,(double)(PointsInImageTwo[i].y*PointsInImageOne[i].y));
			A.set(i,5,PointsInImageTwo[i].y);
			A.set(i,6,PointsInImageOne[i].x);
			A.set(i,7,PointsInImageOne[i].y);
			A.set(i,8,1);
		}
		
		//returnvalue=(returnvalue && (A.rank()>=8));
		if (returnvalue){
			Matrix f=new Matrix(9,1);
			if ((A.rank()==8) || (A.rank()==9)){ // There is either an exact solution or there is noise etc. so we need to find the least squares soluton to Af=0.
				// Either way this is the last column of V of an SVD decompostion
				// i.e. A=USV^T
				// This minimises ||Af|| subject to the condition that ||f||=1
				f=A.svd().getV().getMatrix(0,8,8,8);
			}
			// TODO This is not currently implemented. Is it worth it?
			//else if (A.rank()==7){ //this is the minimum case and we can solve to get either 1 or 3 fundamental matrices
				// We can use the 2-dimensional null space and the fact that the det(F) will equal 0 to construct a cubic
				// i.e. F=aplhaF1+(1-alpha)F2 so det(f)=det(alphaF1+(1-alpha)F2)=0 which is a cubic equation in alpha  
			//}
			// Turn this 9x1 vector into the 3x3 matrix F. Initially use the exact numbers and just rearrange them into a 3x3 matrix temp rather than 9x1 vector f
			Matrix temp=new Matrix(3,3);
			temp.set(0,0,f.get(0,0));
			temp.set(0,1,f.get(1,0));
			temp.set(0,2,f.get(2,0));
			temp.set(1,0,f.get(3,0));
			temp.set(1,1,f.get(4,0));
			temp.set(1,2,f.get(5,0));
			temp.set(2,0,f.get(6,0));
			temp.set(2,1,f.get(7,0));
			temp.set(2,2,f.get(8,0));
			// Take temp and find the matrix closest to it (call it F) with the constraint that det F=0 and minimise Frobenius norm 
			// This can be done by using SVD to deconstruct temp i.e. temp=USV^T and then constructing F from the results i.e. F=Udiag(r,s,0)V^T
			// where U and V are from temp and r,s,t are the diagonal values are from the matrix S where r>=s>=t. Setting t=0 means that the detF=0
			Matrix U=temp.svd().getU();
			Matrix V=temp.svd().getV();
			Matrix S=temp.svd().getS();
			S.set(2,2,0);
			Matrix F=U.times(S.times(V.transpose()));
			// De-normalise F and set the global variable that holds it
			FundamentalMatrix=Normalisation2.transpose().times(F.times(Normalisation1));
			if (printF){
				System.out.println("A is of rank "+A.rank());
				System.out.println("A=");
				A.print(10,5);
				System.out.println("f=");
				f.print(10,5);
				System.out.println("F is of rank="+F.rank());
				System.out.println("det F="+F.det()); // If F is a 3x3 matrix and is of rank 2 then det(F) should be 0!
				System.out.println("manual calculation of det F="+((F.get(0,0)*(F.get(1,1)*F.get(2,2)-F.get(1,2)*F.get(2,1))) + (F.get(0,1)*(F.get(1,2)*F.get(2,0)-F.get(1,0)*F.get(2,2))) +(F.get(0,2)*(F.get(1,0)*F.get(2,1)-F.get(1,1)*F.get(2,0)))));
				//det(F)=a(ei-fh) + b(fg-di) +c(dh-eg)
				F.print(10,5);
				System.out.println("det S="+S.det());
				System.out.println("det U="+U.det());
				System.out.println("det V="+V.det());
				//det(F) should be = det(U)*det(S)*det(V) but in this case it may not be exactly due to the way it is calculated and floating point rounding errors etc.
				System.out.println("det(F)=det(U)*det(S)*det(V)="+(U.det()*S.det()*V.det()));
				System.out.println();
				System.out.println("det Normalisation1="+Normalisation1.det());
				System.out.println("Normalisation1 rank="+Normalisation1.rank());
				Normalisation1.print(10,5);
				System.out.println("det Normalisation2="+Normalisation2.det());
				System.out.println("Normalisation2 rank="+Normalisation1.rank());
				Normalisation2.print(10,5);
				System.out.println("FundamentalMatrix is of rank="+FundamentalMatrix.rank());	
				System.out.println("det FundamentalMatrix="+FundamentalMatrix.det());
				FundamentalMatrix.print(10,5);
			} // end if print
		} // end if returnvalue 
	} // end if returnvalue
		return returnvalue;
	} // end of Set F method
	
//	This retrieves a previously calculated Fundamental Matrix for a set of point pairs.
//	The Fundamental Matrix can be used to:
//	- calculate an epipolar line in one image that corresponds to a point in the other i.e.  l'=Fx and l=F^Tx' where the 3 numbers generated are a,b and c in the formula ax+by+c=0
//	- find the epipoles using the null matrices of F i.e. Fe=0 and F^Te'=0
//	- a point correspondence is defined as x'^TFx=0
//	- and can also be used to compute the two camera matrices (a little too complicated to go into here)

	public Matrix getF(){
		return FundamentalMatrix;
	}

//	 The rotation matrix should have 3 dof and they can be represented as a 3x1 vector using the Rodrigues rotation formula
	public static Matrix getRodriguesRotationVector(Matrix R){
		Matrix r=new Matrix (3,1);
		// Unit vector r is the solution to (R-I)r=0
		// In this case: (temp)r=0
		Matrix I=new Matrix(3,3);
		I.set(0,0,1);
		I.set(1,1,1);
		I.set(2,2,1);
		Matrix temp=R.minus(I);
		// The answer is the last column of V of an SVD decompostion
		r=temp.svd().getV().getMatrix(0,2,2,2); // This is by definition a vector of length 1.
		
		Matrix rdash=new Matrix (3,1);
		rdash.set(0,0,R.get(2,1)-R.get(1,2));
		rdash.set(1,0,R.get(0,2)-R.get(2,0));
		rdash.set(2,0,R.get(1,0)-R.get(0,1));
		
		
		// Now we need to find the angle/length of r which we can do using the 2 argument arctan function and the knowledge that:
		//2cos(angle)=trace(R)-1), R is the 3x3 Rotation Matrix
		//2sin(angle)=r^Tr' where r and r' are the unit vector we just calculated and the combination of R we just set as rdash
		double cos=((R.trace()-1)/2);
		double sin=r.transpose().times(rdash).get(0,0)/2;
		double length=Math.atan2(sin,cos);
		r.timesEquals(length);
		//This is a simpler way of doing it but is not numerically accurate (out by parts in a thousand but this is enough to make it unstable) and fails when angle is 180 degrees
		//double length=Math.abs(Math.acos(((R.trace()-1)/2))); 
		//r.set(0,0,R.get(2,1)-R.get(1,2));
		//r.set(1,0,R.get(0,2)-R.get(2,0));
		//r.set(2,0,R.get(1,0)-R.get(0,1));
		//r.timesEquals(length/(2*Math.sin(length)));
	return r;
	}
	
	public static Matrix getRotationMatrixFromRodriguesRotationVector(Matrix r){
		Matrix R=new Matrix(3,3);
		double length=DistanceFromOriginof3x1Vector(r);
		// Set up an Identity matrix
		Matrix I=new Matrix (3,3);
		I.set(0,0,1);
		I.set(1,1,1);
		I.set(2,2,1);
		Matrix rx=getCrossProductMatrixof3x1Vector(r.times(1/length));
		// This is a bit complicated so split it into 3 terms
		Matrix firstterm=I;
		Matrix secondterm=rx.times(Math.sin(length));
		Matrix thirdterm=rx.times(rx);
		thirdterm.timesEquals(((1-Math.cos(length))));
		R=firstterm.plus(secondterm).plus(thirdterm);
		return R;
	}
	public Matrix Find3dPoint(Point2d point1, Point2d point2, Matrix P1, Matrix P2){
		// This is just a wrapper to the generic 3d point estimation from any number of images
		Point2d[] point=new Point2d[2];
		point[0]=point1.clone();
		point[1]=point2.clone();
		Matrix[] P=new Matrix[2];
		P[0]=P1.copy();
		P[1]=P2.copy();
		return Find3dPoint(point,P,2);
	}
	// This takes a number of points in images, each point defines a ray in space when given the corresponfing camera matrix.
	// This method finds an estimate of where the rays intersect to give a point in object/real space.
	public static Matrix Find3dPoint(Point2d point[], Matrix P[], int length){
//		 This is simply the Homogeneous Linear triangulation method, an extension of the DLT method
		//To find the point X we solve the equation AX=0 where X is not 0 and A is constructed from the points and camera matrices provided
		Matrix A=new Matrix (length*2,4);
		for (int i=0;i<length;i++){
				A.setMatrix(i*2,i*2,0,3,P[i].getMatrix(2,2,0,3).timesEquals(point[i].x).minusEquals(P[i].getMatrix(0,0,0,3)));
				A.setMatrix((i*2)+1,(i*2)+1,0,3,P[i].getMatrix(2,2,0,3).timesEquals(point[i].y).minusEquals(P[i].getMatrix(1,1,0,3)));
		}
		// Note that we want to normalise each row of A to have Euclidean length of 1 called the L2-norm
		for (int i=0;i<A.getRowDimension();i++){
			double dsquared=0;
			for (int j=0;j<4;j++) dsquared=dsquared+Math.pow(A.get(i,j),2);
			A.setMatrix(i,i,0,3,A.getMatrix(i,i,0,3).times(1/Math.sqrt(dsquared)));
		}
		// The solution is the last column of V of an SVD decompostion
		// i.e. A=USV^T
		// This minimises ||Ax|| subject to the condition that ||x||=1
		Matrix Point=A.svd().getV().getMatrix(0,3,3,3);
		return Point;
	}
	
	public static double[] FindPolynomialRoots(double c[]){
		//From the polynomial coefficients construct a companion matrix. Note that this is only for a monic polynomial\
		//so we need to divide all the coefficients by the highest power coefficient first
		int n=c.length-1;
		for (int i=0;i<n;i++) c[i]=c[i]/c[n];
		// A companion matrix is a square matrix made up such that the last column is the negative of the coefficients (without the 1 for the highest power) 
		// and there is a diagonal of 1's starting at the first column of the second row and continuing down to the second last column of the last row.
		Matrix Companion=new Matrix(n,n);
		for (int i=0;i<n;i++){
			Companion.set(i,n-1,-c[i]);
			if (i!=0) Companion.set(i,i-1,1);
		}
		// The roots are found as the real Eigenvalues of this companion matrix
		// In a lot of cases these eigenvalues will have a real and imaginary part but at the moment we are only interested in the real part of the roots
		
		return Companion.eig().getRealEigenvalues();
		}
	
	
	/***********************************************************************************************************************************************************
	 * 
	 * Nested class for LM minimisation in CalculateImageRectificationHomographies
	 * 
	 *
	 *************************************************************************************************************************************************************/
	class LMlambdaadjustment implements LMfunc
	  {
	   public Matrix A,Adash,B,Bdash;
	   
		public double[] initial(){return (null);} // Not called
	   public Object[] testdata() { return (null);} // Not called
	   public Point2d adjust(Point2d y, double[] a) { return y;} // No adjustments need to be made to y 
	   /**
	    * x is a single point, but domain may be mulidimensional
	    * 
	    * In this case x is irrelevent, a is a single scalar value and the value returned is a scalar that is the solution to equation 11 in the 
	    * paper "Computing rectifying homographies for stereo vision" in Proceedings of the IEEE Computer Society Conference on Computer Vision and Pattern Recognition
		* 1999 Volume 1 pages 125-131
		* downloadable from ftp://ftp.research.microsoft.com/pub/tr/tr-99-21.pdf
	    *
	    * i.e. the distortion criteria we want to minimise
	    * 
	    * The value is returned as the x value of the 2d vector and y is set to zero
	    * 
	    * Note that the Matrices A,Adash,B and Bdash are assumed to be set before calling this.
	    *
	    */
	   public Point2d val(double[] x, double[] a)
	    {
		   Matrix z=new Matrix(2,1);
		   z.set(0,0,a[0]);
		   z.set(1,0,1);
		   
		   Matrix numerator1=z.transpose().times(A.times(z));
		   Matrix denominator1=z.transpose().times(B.times(z));
		   Matrix numerator2=z.transpose().times(Adash.times(z));
		   Matrix denominator2=z.transpose().times(Bdash.times(z));
		   double value=(numerator1.get(0,0)/denominator1.get(0,0))+(numerator2.get(0,0)/denominator2.get(0,0));
		   
		   return new Point2d(value,0);
	    } //val
	  

	  } //end of nested class 

	
	
	
	/**************************************************************************************************************************************************************
	 * 
	 * Private methods from here on down
	 * 
	 **************************************************************************************************************************************************************/ 
	private static Point2d CalculateCentroid(Point2d[] pointsarray){
		Point2d centroid=new Point2d(0,0);
			for (int i=0;i<pointsarray.length;i++){
				centroid.x=centroid.x+pointsarray[i].x;
				centroid.y=centroid.y+pointsarray[i].y;
			} // end for
		centroid.x=centroid.x/pointsarray.length;
		centroid.y=centroid.y/pointsarray.length;
		return centroid;
	}
	
}
