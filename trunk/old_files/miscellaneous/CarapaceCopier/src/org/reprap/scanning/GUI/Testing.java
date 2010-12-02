package org.reprap.scanning.GUI;
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
 * Last modified by Reece Arnott 11th October 2010
 * 
 * This is test code used to test the success of the combinatorial approach to point matching on different combinations/permutations of found points on a calibration sheet
 *
 * One way to use this would be to add the following to the appropriate point in Main.java
 *
 * 								PointPairMatch match=new PointPairMatch(ellipsecenters);
		  						bar.setValue(bar.getMinimum());
  								while (bar.getValue()<bar.getMaximum()) bar=match.MatchCircles(calibrationcirclecenters);
		  						Testing test=new Testing(match.getMatchedPoints(),calibrationcirclecenters, calibrationwidth, calibrationheight);
		  						test.printcorrect=false;
		  						test.printincorrect=false;
		  						test.printsummary=true;
		  						test.outputfailedimage=false;
		  						test.printblankifincorrect=false;
		  						test.comparemethods=true;
		  						images[j-1].skipprocessing=true;
		  						test.image=images[j-1].clone();
		  						images[j-1].skipprocessing=false;
		  						test.outputCorrectMatches();
		  						test.Combinations();
		  						test.Permutations(1000);
 * 
 * 
 *******************************************************************************/  
import org.reprap.scanning.Calibration.CalibrateImage;
import org.reprap.scanning.DataStructures.Image;
import org.reprap.scanning.DataStructures.PixelColour;
import org.reprap.scanning.FeatureExtraction.PointPairMatch;
import org.reprap.scanning.Geometry.*;
import javax.swing.JProgressBar;

import Jama.Matrix;
public class Testing {
	private PointPair2D[] correct;
	private Point2d[] calibrationcirclecenters;
	private double calibrationwidth,calibrationheight;
	private int correctcount;
	public boolean printcorrect=false;
	public boolean printincorrect=false;
	public boolean printsummary=false;
	public boolean outputfailedimage=false;
	public boolean printblankifincorrect=false;
	public boolean comparemethods=false;
	public String outputimageprefix="/home/cshome/r/rarnott/Desktop/images/testimage";
	private int count; // just used for the filename of the output images
	private int samecount,oldcountcorrect,oldcountincorrect,newcountcorrect,newcountincorrect;
	public Image image;
	public Testing(PointPair2D[] correctmatches, Point2d[] calibrationpoints, double calibrationsheetwidth, double calibrationsheetheight){
		correct=correctmatches.clone();
		calibrationwidth=calibrationsheetwidth;
		calibrationheight=calibrationsheetheight;
		calibrationcirclecenters=calibrationpoints.clone();
		count=0;
		
	}
	
	public void outputCorrectMatches(){
//		 Output these matches
			for (int i=0;i<correct.length;i++){
				System.out.print(i+" ");
				correct[i].pointone.print();
				correct[i].pointtwo.print();
				System.out.println();
			}
	}
	
	public void Permutations(int repeatnumberoftimes){
		for (int n=4;n<=correct.length;n++){
			correctcount=0;
			
			for (int x=0;x<repeatnumberoftimes;x++){
				Point2d[] subsetofcentres=new Point2d[n];
				for (int i=0;i<n;i++){
					boolean repeat=true;
					while (repeat){
						int index=(int)Math.round((Math.random()*8)+0.4);
						subsetofcentres[i]=correct[index].pointtwo.clone();
						repeat=false;
						for (int k=0;k<i;k++) if (subsetofcentres[i].isEqual(subsetofcentres[k])) repeat=true;
					} // end repeat
				} // end for i
				CalculateMatches(subsetofcentres, n);	
			} // end for x 
			if (printsummary) System.out.println("for "+n+" correct = "+correctcount+" of "+repeatnumberoftimes+" or as a percentage: "+(((double)correctcount/(double)repeatnumberoftimes)*100));
			else System.out.println();
		} // end for n
	} // end method
	
	public void Combinations(){
		for (int n=4;n<=correct.length;n++){
			correctcount=0;
			samecount=0;
			oldcountcorrect=0;
			oldcountincorrect=0;
			newcountcorrect=0;
			newcountincorrect=0;
			int[] combinationarray=new int[n];
			for (int i=0;i<(combinationarray.length);i++) combinationarray[i]=i; 
			combinationarray[n-1]--;
			boolean finish=false;
			int count=0;
			while (!finish){
				combinationarray[n-1]++;
				for (int i=(combinationarray.length-1);i>=0;i--){
					if (combinationarray[i]>=(correct.length-(combinationarray.length-i-1))) {
						if (i==0) finish=true;
						else {
							combinationarray[i-1]++;
							for (int k=i;k<combinationarray.length;k++) combinationarray[k]=combinationarray[k-1]+1;
						} // end else i==0
					} // end if combination>n
				} // end for
				Point2d[] subsetofcentres=new Point2d[n];
			if (!finish) {// take the combination array and produce a subset from it
				for (int i=0;i<subsetofcentres.length;i++) {
					subsetofcentres[i]=correct[combinationarray[i]].pointtwo.clone();
				}
				count++;
				CalculateMatches(subsetofcentres, n);
			} // end if !finish
		} // end while !finish
			if (comparemethods) System.out.println("for "+n+" same="+samecount+" incorrect in old only="+oldcountincorrect+" incorrect in new only="+newcountincorrect);
			if (printsummary) System.out.println("for "+n+" correct = "+correctcount+" of "+count+" or as a percentage: "+(((double)correctcount/(double)count)*100));
			else System.out.println();
		} // end for n
	} // end method


	// Wrapper to call the below to give just the initial estimation of the calibration sheet using the first 3 point pair matches.  
	public void CalculateBarycentricTransformedCalibrationsheet(int pixelswide, int pixelshigh, String filename){CalculateBarycentricTransformedCalibrationsheet(pixelswide,pixelshigh,filename,false);}
		
		
	
//	 Note this assumes the global variable image has been initialised with the source image
	// This has been hastily changed to output colour images rather than greyscale. It is not efficient and if it to be used extensively should be rewritten
	public void CalculateBarycentricTransformedCalibrationsheet(int pixelswide, int pixelshigh, String filename, boolean useallpointpairs){
		PointPair2D[] basepairs;
		if (useallpointpairs) {
			//Use the best 3 to get the estimated greyscale values of the pixel for the calibration sheet
			basepairs=new PointPair2D[correct.length];
			for (int i=0;i<correct.length;i++) basepairs[i]=correct[i].clone();
		}
		else{
			//Use only the first 3 to get the estimated greyscale values of the entire calibration sheet
			basepairs=new PointPair2D[3];
			for (int i=0;i<3;i++) basepairs[i]=correct[i].clone();
		}		
		
		Point2d offset=new Point2d((double)calibrationwidth/2,(double)calibrationheight/2);
		PixelColour[][] newimage=new PixelColour[pixelswide][pixelshigh];
		for (int x=0;x<pixelswide;x++){
			for (int y=0;y<pixelshigh;y++){
				// calculate the point pair for each pixel of the calibration sheet and get the colour value
				Point2d point=new Point2d(x*(calibrationwidth/pixelswide),y*(calibrationheight/pixelshigh));
				point.minus(offset);
				PointPair2D pair=new PointPair2D();
				pair.pointone=point.clone();
				boolean success=pair.EstimateSecondPoint(basepairs);
				if (success) newimage[x][y]=image.InterpolatePixelColour(pair.pointtwo);
				else newimage[x][y]=new PixelColour();
			}
			if (x%100==0) System.out.print(".");
		}
		// Overwrite the pixels that are the centers of the circles with white
		for (int i=0;i<correct.length;i++){
			Point2d point=correct[i].pointone.clone();
			point.plus(offset);
			int x=(int)(point.x*(pixelswide/calibrationwidth));
			int y=(int)(point.y*(pixelshigh/calibrationheight));
			for (int dx=-(int)pixelswide/200;dx<pixelswide/200;dx++){
				for (int dy=-(int)pixelshigh/200;dy<pixelshigh/200;dy++){
					if ((x+dx>=0) && (x+dx<pixelswide) && (y+dy>=0) && (y+dy<=pixelshigh)) newimage[x+dx][y+dy]=new PixelColour((byte)255);
				}
			}
		}
		
		GraphicsFeedback graphics=new GraphicsFeedback(false);
		graphics.ShowPixelColourArray(newimage,pixelswide,pixelshigh);
		graphics.SaveImage(filename);
	}// Note this assumes the global variable image has been initialised with the source image
	
	public void CalculateMatches(Point2d[] subsetofcentres, int n){
			long starttime=System.currentTimeMillis();
			PointPairMatch circles=new PointPairMatch(subsetofcentres);
			JProgressBar bar=new JProgressBar(0,1);
			bar.setValue(bar.getMinimum());
			while (bar.getValue()<bar.getMaximum()) bar=circles.MatchCircles(calibrationcirclecenters);
			
			// Create planar homography
			PointPair2D[] pp=circles.getMatchedPoints();
			CalibrateImage calibrate=new CalibrateImage(pp);
			Matrix H=calibrate.getHomography();
			
			String prefix=""+(System.currentTimeMillis()-starttime)+" "+n+" ";

			// convert the four corners of the calibration sheet if the pairing up was correct
			int count=0;
			for (int index=0;index<pp.length;index++){
				int index2=0;
				while(index2<correct.length){
					if ((pp[index].pointone.isApproxEqual(correct[index2].pointone,0.0001)) && (pp[index].pointtwo.isApproxEqual(correct[index2].pointtwo,0.0001))) {
						count++;
						index2=correct.length;
					}
					else index2++;
				} // end while
			} // end for
			if (comparemethods){
				PointPairMatch oldcircles=new PointPairMatch(subsetofcentres);
				bar.setValue(bar.getMinimum());
				while (bar.getValue()<bar.getMaximum()) bar=oldcircles.OldMatchCircles(calibrationcirclecenters);
				PointPair2D[] pp2=oldcircles.getMatchedPoints();
				int count2=0;
				for (int index=0;index<pp2.length;index++){
					int index2=0;
					while(index2<correct.length){
						if ((pp2[index].pointone.isApproxEqual(correct[index2].pointone,0.0001)) && (pp2[index].pointtwo.isApproxEqual(correct[index2].pointtwo,0.0001))) {
							count2++;
							index2=correct.length;
						}
						else index2++;
					} // end while
				} // end for
				//System.out.println(count+" "+count2+" "+n);
				if ((count==n)==(count2==n)){ // both the same	
					samecount++;
				}
				else{ // one is different
					if (count==n) {
						newcountcorrect++;
						oldcountincorrect++;
					}
					else {
						oldcountcorrect++;
						newcountincorrect++;
					}
				}
			} // end comparemethods

			
			
			if (count==n){
				correctcount++;
				if (printcorrect){
					System.out.print(prefix);
					Point2d imagepoint=Planartransform(H, new Point2d(-calibrationwidth/2,-calibrationheight/2));
					imagepoint.print();
					imagepoint=Planartransform(H, new Point2d(calibrationwidth/2,-calibrationheight/2));
					imagepoint.print();
					imagepoint=Planartransform(H, new Point2d(-calibrationwidth/2,calibrationheight/2));
					imagepoint.print();
					imagepoint=Planartransform(H, new Point2d(calibrationwidth/2,calibrationheight/2));
					imagepoint.print();
					System.out.println();
				} // end if printcorrect
			} // end if count
			
			else {
				if (outputfailedimage) ShowImage(H,subsetofcentres);
				if (printincorrect){ 
				System.out.print(prefix);
				// Output the actual matches
				int[] one=new int[pp.length];
				int[] two=new int[pp.length];
				for (int index=0;index<pp.length;index++){
					for (int index2=0;index2<correct.length;index2++){
						if (pp[index].pointone.isApproxEqual(correct[index2].pointone,0.0001)) one[index]=index2;
						if (pp[index].pointtwo.isApproxEqual(correct[index2].pointtwo,0.0001)) two[index]=index2;
						}
				} // end for
				for (int index=0;index<pp.length;index++) System.out.print(one[index]+"="+two[index]+" ");
				System.out.println();
				} // end if printcorrect
				else if (printblankifincorrect) System.out.println(prefix);	
			} // end else
			
	} // end of calculatematches method
	
	// This assumes the global public variable image has already been assigned
	// This shows the image overlaid with an outline of where the edges of the calibration sheet are assuming the point matching was successful using a planar transform based on said point pairs.
	private void ShowImage(Matrix H, Point2d[] points){
		
		GraphicsFeedback graphics=new GraphicsFeedback(false);
		graphics.ShowImage(image); // Show original image
		byte[] colour=new byte[3];
		 
		 // Show the matched points (image frame) in red
			colour[0]=(byte)255; colour[1]=(byte)0;colour[2]=(byte)0;
			for (int i=0;i<points.length;i++) {
				graphics.PrintPoint(points[i].x,points[i].y,colour);
			} // end of for loop
			
			for (int x=(int)(-calibrationwidth/2);x<(calibrationwidth/2);x++){
					//convert from calibration coordinates to image coordinates and draw top
					double y=(calibrationheight/2);
					// project point to image plane (world inhomogeneous coordinates)
					Point2d temp;
					temp=Planartransform(H, new Point2d(x,y));
					graphics.PrintPoint(temp.x,temp.y,colour);
					
					//convert from calibration coordinates to image coordinates and draw bottom
					// project point to image plane (world inhomogeneous coordinates)
					temp=Planartransform(H, new Point2d(x,-y));
					graphics.PrintPoint(temp.x,temp.y,colour);
				} // end for x

			for (int y=(int)(-calibrationheight/2);y<(calibrationheight/2);y++){
					//convert from calibration coordinates to image coordinates and draw right
					double x=(calibrationwidth/2);
					// project point to image plane (world inhomogeneous coordinates)
					Point2d temp;
					temp=Planartransform(H, new Point2d(x,y));
					graphics.PrintPoint(temp.x,temp.y,colour);
					// project point to image plane (world inhomogeneous coordinates)
					temp=Planartransform(H, new Point2d(-x,y));
					graphics.PrintPoint(temp.x,temp.y,colour);
			} // end for y

		//graphics.initGraphics();	
		String filename=outputimageprefix+String.valueOf(count)+".jpg";
		graphics.SaveImage(filename);
		System.out.println("Saved "+filename);
		count++;
	} // end of showimage method
	
	private Point2d Planartransform(Matrix H, Point2d p){
		Matrix newpoint=new Matrix(3,1);
		newpoint.set(0,0,p.x);
		newpoint.set(1,0,p.y);
		newpoint.set(2,0,1);
		Point2d imagepoint=new Point2d(H.times(newpoint));
		return imagepoint;
	}
}
