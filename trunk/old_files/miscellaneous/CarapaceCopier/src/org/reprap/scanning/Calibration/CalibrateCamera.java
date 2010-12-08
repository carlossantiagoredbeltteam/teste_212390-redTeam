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
 * Last modified by Reece Arnott 7th December 2010
 * 
 *    
 *******************************************************************************/

import org.reprap.scanning.DataStructures.Image;

import Jama.*;


public class CalibrateCamera {
	private CalibrateImage[] imagecalibrationarray;
	 public String warnings;
	 
	 private boolean print=false; //just for testing purposes
	
	 //constructor
	 public CalibrateCamera(Image[] images, boolean[] use){
		int count=0;
		for (int j=0;j<use.length;j++) if (use[j]) count++;
		imagecalibrationarray=new CalibrateImage[count];
		count=0;
		for (int i=0;i<images.length;i++){
			if (use[i]){
				imagecalibrationarray[count]=images[i].calibration.clone();
				count++;
			}
		}
		warnings="";
	}
	 public CalibrateCamera(Image image){
			imagecalibrationarray=new CalibrateImage[1];
			imagecalibrationarray[0]=image.calibration.clone();
			warnings="";
		}
//	 This is just used in the CalculateCameraMatrix method to make the code tidier
// Note that the description of this matrix in the Zhang article has the rows and column sub-indices swapped so that columns are displayed first!
// It mentions this in a small one line statement above the formula but it took a week to track down what was going wrong!
	private Matrix getvtransposed(int i, int j, Matrix H){
		Matrix vij=new Matrix(1,6);
		vij.set(0,0,H.get(0,i)*H.get(0,j));
		vij.set(0,1,(H.get(0,i)*H.get(1,j))+(H.get(1,i)*H.get(0,j)));
		vij.set(0,2,H.get(1,i)*H.get(1,j));
		vij.set(0,3,(H.get(2,i)*H.get(0,j))+(H.get(0,i)*H.get(2,j)));
		vij.set(0,4,(H.get(2,i)*H.get(1,j))+(H.get(1,i)*H.get(2,j)));
		vij.set(0,5,H.get(2,i)*H.get(2,j));
		return vij;
	}
	 // This gets the camera matrix K using a calculation of the image of the absolute conic omega=(KK^T)^-1=((K^-1)^T)(K^-1) 
	 // where the image of the absolute conic is estimated based on the 2D plane homography between the calibration sheet and the image plane and 
	 // optionally some other assumptions about the internal parameters of the camera 
//	 see Hartley and Zisserman "Multiple View Geometry in computer vision" 8.8 Determining camera calibration K from a single view
//	 and the paper (and Microsoft Technical report of the same name) "A flexible new technique for camera calibration"
//		 by Z. Zhang in Vol 22, issue 11 of IEEE Transactions on Pattern Analysis and Machine Intelligence (2000)
//		 Note that there have been mistakes in formulas found in the original paper that have been corrected in the online version of the Microsoft Technical report
//		 The updated technical report with the mistakes corrected can be downloaded from ftp://ftp.research.microsoft.com/pub/tr/tr-98-71.pdf 

// Note also that if there is an error the returned matrix will be all zeros except for the right bottom element which will be an error code. Currently these error codes are:
	// -1 Homogrpahy matrix is not Semi-Positive Definite, indicates there is probably a mismatch in the point pairs it is based on.
	// 1 no error, the standard K matrix is presumably returned.

	 public Matrix getCameraMatrix(){
		int error=0;
		 //First calculate a homography relating the calibration sheet to the image.
		// This contains a combination of the camera calibration matrix, the rotation matrix, and the translation matrix which we will separate out.
		Matrix[] H=new Matrix[imagecalibrationarray.length];
		Matrix A=new Matrix(2*imagecalibrationarray.length,6);
		Matrix omega=new Matrix(6,1);
		Matrix Omega=new Matrix(3,3);
		Matrix K=new Matrix(3,3);
		boolean repeat=true;
		int repeatcount=0;
		double maxtransfererrorsquared=0;
		int maxrepeat=100;
		while (repeat){
			warnings="";
			A=new Matrix(2*imagecalibrationarray.length,6);
			for (int x=0;x<H.length;x++){
				H[x]=imagecalibrationarray[x].getHomography(); // get the homography transforming calibration coordinates to image coordinates
				
				if (print) {
					System.out.println("Homography matrix "+x+" is:");
					H[x].print(10,20);
					}
				
				
				// Construct a matrix with the constraints that describe the camera calibration matrix in it.
				A.setMatrix(x*2,x*2,0,5,getvtransposed(0,1,H[x]));
				A.setMatrix((x*2)+1,(x*2)+1,0,5,getvtransposed(0,0,H[x]).minus(getvtransposed(1,1,H[x])));
				
			}
			//Add in additional constraints if needed.
		 int rank=A.rank();
		 boolean principalpointatimagecenter=false;
		 boolean squarepixels=false;
		 boolean skewiszero=false;
		 if (rank<5){
			 if (rank==2) { skewiszero=true; principalpointatimagecenter=true;}
			 else if (rank==3)  squarepixels=true;
			 else if (rank==4) skewiszero=true;
		 }
		 
		 // If the principal point is assumed, add two rows 0,0,0,0,1,0 and 0,0,0,0,0,1 to zero out omega4 and omega5 
		 // This can only be easily done because the coordinate system was changed to make the asummed principal point (the image center) the (0,0) point before this class is instantiated and given the point pairs.
		 if (principalpointatimagecenter){
				Matrix a=new Matrix (A.getRowDimension()+2,6);
				a.setMatrix(0,(A.getRowDimension()-1),0,5,A);
				// Zero out the appropriate columns for hard assumption!
				//for (int i=0;i<A.getRowDimension();i++) {
				//	a.set(i,3,0);
				//	a.set(i,4,0);
				//}
				a.set(A.getRowDimension(),3,1);
				a.set(A.getRowDimension()+1,4,1);
				A=a.copy();
			}
		
		
		 
		 // If zero skew we have the constraint the omega2=0
		// So add row 0,1,0,0,0,0 to zero out omega2
		 if ((skewiszero) || (squarepixels)){
			Matrix a=new Matrix (A.getRowDimension()+1,6);
			a.setMatrix(0,(A.getRowDimension()-1),0,5,A);
			// Zero out the appropriate columns for hard assumption!
			//for (int i=0;i<A.getRowDimension();i++) {
			//	a.set(i,1,0);
			//}
			a.set(A.getRowDimension(),1,1);
			A=a.copy();
		}
		 
		 
		 // if square pixels we have omega1-omega3=0
		 // So add row 1,0,-1,0,0,0
		 if (squarepixels){
			 Matrix a=new Matrix (A.getRowDimension()+1,6);
			a.setMatrix(0,(A.getRowDimension()-1),0,5,A);
			// Average the appropriate columns for hard assumption 
			//for (int i=0;i<A.getRowDimension();i++) {
			//  a.set(i,0,(A.get(i,0)+omega.get(i,2))/2);
			//  a.set(i,2,(A.get(i,0)+omega.get(i,2))/2);
		 	//}
			a.set(A.getRowDimension(),0,1);
			a.set(A.getRowDimension(),2,-1);
			A=a.copy();
			
		}
		 
		 
		 if (squarepixels) warnings=warnings+"Warning: Assuming square pixels. This is probably a valid assumption.\n";
		 if (skewiszero) warnings=warnings+"Warning: Assuming image axes are perpendicular (zero skew) leading to square or rectangular pixels rather than a more general parallelogram.\n This is probably a valid assumption unless the camera is an extremely low quality one or you are taking a picture of a picture\n";
		 if (principalpointatimagecenter) warnings=warnings+"Warning: Assuming focal point is at the exact center of the image.\n This is probably out by a few pixels but may be able to be estimated later if there is enough lens distortion\n";
	 				 
		 // Solve Aomega=0 for omega using SVD 
		// If there are less than 6 rows (there should be at least 5), bulk it up with a row of zeros
		// It is assumed at this point that the rank of A is at least 5!
		if (A.getRowDimension()<6) {

				 Matrix temp=new Matrix(6,6);
				 temp.setMatrix(0,A.getRowDimension()-1,0,5,A);
				 A=temp.copy();
			 }
			omega=A.svd().getV().getMatrix(0,5,5,5);
			if (print){
				 // System.out.println("SVD decomposition:");
				 // System.out.println("V=");
				 // A.svd().getV().print(10,20);
				 // System.out.println("S=");
				 // A.svd().getS().print(10,20);
				 // System.out.println("U=");
				 // A.svd().getU().print(10,20);
				  
				  System.out.println(warnings);
				  System.out.println("A: Rank is "+A.rank());
				  A.print(10,20);
				  System.out.println("Vector omega");
				  omega.print(10,20);
				  System.out.println("Aomega=");
				  A.times(omega).print(10,20);
				  
				}
	
		// Due to rounding errors or the fact that these assumptions aren't quite right then we may need to reset some of these to zero
		// If these are commented out then they can be thought of as "soft" assumptions
		//	if (skewiszero) omega.set(1,0,0);
		//	if (principalpointatimagecenter){ omega.set(3,0,0);omega.set(4,0,0);}
		//	if (squarepixels) {double avg=(omega.get(0,0)+omega.get(2,0))/2;omega.set(0,0,avg);omega.set(2,0,avg);omega.set(1,0,0);}
			
		 
		 // We can now take the 6x1 vector and change into 3x3 matrix
			Omega=new Matrix (3,3);
			Omega.set(0,0,omega.get(0,0));
			Omega.set(1,0,omega.get(1,0));
			Omega.set(0,1,omega.get(1,0));
			Omega.set(1,1,omega.get(2,0));
			Omega.set(0,2,omega.get(3,0));
			Omega.set(2,0,omega.get(3,0));
			Omega.set(1,2,omega.get(4,0));
			Omega.set(2,1,omega.get(4,0));
			Omega.set(2,2,omega.get(5,0));
			
			// Omega should be a matrix that is Symmetric positive definite (up to scale)
			// but sometimes this isn't the case. Sometimes one of the diagonals is a different sign to the others. Normally this is caused by the homographies being overconstrained.
			// The below will fix the bug by recreating the Homographies based on the RANSAC algorithm that uses a subset of the points to create the homography.
			// If that doesn't initially work, use a tighter and tighter transfererror constraint on inlier selection
			// Note that this doesn't change the original homographies, just the copies used to calculate Omega
			// In some cases this still doesn't work either so after taking the homography based on the least number of inliers possible (4) go back to the original homography and take the SPD portion of it.
			repeat=(!(new CholeskyDecomposition(Omega).isSPD() || new CholeskyDecomposition(Omega.times(-1)).isSPD()));
			if (repeat) {
				if (repeatcount==0){
					// Set the maximum transfer error squared to be the maximum from the points using the original homography
					for (int x=0;x<H.length;x++){
						double transfererrorsquared=imagecalibrationarray[x].FindMaximumTransferErrorSquared();
						if 	(transfererrorsquared>maxtransfererrorsquared) maxtransfererrorsquared=transfererrorsquared;
						System.out.println("The Image of the Absolute Conic (IAC) seems to be wrongly constrained, probably due to a wrongly constrained planar homography, in turn probably due to being over-constrained with one or more mismatched point-pairs. Attempting to construct it with fewer points.");
					} // end for
				} // end if
				if (repeatcount<maxrepeat){ 
					double tsquared=(((double)maxrepeat-(double)repeatcount)/100)*maxtransfererrorsquared;
					for (int x=0;x<H.length;x++) {
						// Set tsquared to be a certain percentage of the maximum transfer error (squared) from the original all points homography
						// Starting at 100% and going to 0% to get increasingly less inliers and therefore potentially less accurate homography
						int numberofinliers=imagecalibrationarray[x].setHomograhyusingRANSAC(tsquared);
						if (numberofinliers<4) {repeatcount=maxrepeat;x=H.length;System.out.println("Planar homography cannot be estimated as using less than 4 points");}
						else System.out.println("Attempting camera calibration with planar homography estimated using a subset of "+numberofinliers+" points, attempt "+(repeatcount+1)+" of a possible "+maxrepeat);
					} // end for
				} // end if
				if (repeatcount>=maxrepeat) {
					// Not currently doing this as the problem probably can't be fixed by this
					//for (int x=0;x<H.length;x++) imagecalibrationarray[x].setHomographyusingAllPoints();
					// You can decompose a matrix into the SPD part and the rest (called polar decomposition)  using a variation of SVD, so we'll just get the SPD part. 
					//SingularValueDecomposition svd=new SingularValueDecomposition(Omega);
					//Omega=svd.getV().times(svd.getS().times(svd.getV().transpose()));
					repeat=false;
					String errormessage="Error: There are potentially a significant number of wrongly matched point pairs.\n";
					warnings=warnings+errormessage;
					System.out.print("IAC not Semi-positive definite, even after the maximum number of attempts at RANSAC adjustment.\n"+errormessage);
					error=-1;
				} // end if
				repeatcount++;
			} //end if repeat
			} // end while repeat loop
			if (error==0){
				if (print){
					System.out.println("Omega=");
					Omega.print(10,20);
				}
				// Note that there were errors in the original Zhang paper for these formulas that have been fixed in the later versions of the Microsoft Technical Report
				//The values of the above calculated 3x3 matrix relate to the values mentioned in the formulas in the referenced paper. 
				double B11=Omega.get(0,0);
				double B12=Omega.get(0,1);
				double B22=Omega.get(1,1);
				double B13=Omega.get(0,2);
				double B23=Omega.get(1,2);
				double B33=Omega.get(2,2);
				double numerator=(B12*B13)-(B11*B23);
				double denominator=(B11*B22)-(B12*B12);
				double v0=numerator/denominator;
				double lambda=B33-(((B13*B13)+(v0*numerator))/B11);
				double alpha=Math.sqrt(lambda/B11);
				double beta=Math.sqrt((lambda*B11)/denominator);
				double gamma=(-1*B12*alpha*alpha*beta)/lambda;
				double u0=((gamma*v0)/beta)-((B13*alpha*alpha)/lambda);
				if (print){
					System.out.println("v0="+v0);
					System.out.println("lambda="+lambda);
					System.out.println("alpha="+alpha);
					System.out.println("alpha^2="+(lambda/B11));
					System.out.println("beta="+beta);
					System.out.println("beta^2="+((lambda*B11)/((B11*B22)-(B12*B12))));
					System.out.println("gamma="+gamma);
					System.out.println("u0="+u0);
				}
				/* So the camera matrix  is:
				 * 
				 * alpha	 gamma	u0 
				 * 0		beta	v0
				 * 0		0		1
				 * 
				 */
				K=new Matrix(3,3);
				K.set(0,0,alpha);
				K.set(1,1,beta);
				K.set(0,1,gamma);
				K.set(0,2,u0);
				K.set(1,2,v0);
				K.set(2,2,1);
			} // end if no errors
			else {
				// Make the K matrix all zeros except for the right bottom which is the error code
				K=new Matrix(3,3);
				K.set(2,2,error);
			}
			if (print) {
				System.out.println("K=");
				K.print(10,20);
			}
			return K;
	 } // end of method
}
