package org.reprap.scanning.FeatureExtraction;

import javax.swing.JProgressBar;

import org.reprap.scanning.DataStructures.QuickSortByDistanceTo2DPoints;
import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.Calibration.CalibrateImage;


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
* Last modified by Reece Arnott 4th Feburary 2010
*
* This matches two sets of points which are assumed to be circle centers in the calibration sheet and ellipse centers found in the image
* and returns them as a PointPair with pointone being the calibration sheet and pointtwo the image coordinates 
*
****************************************************************************************************************************/
import Jama.Matrix;
public class PointPairMatch {
	private PointPair2D[] foundpointpairs;
	private double smallesterror;
	private Point2d[] ellipsecentresinimage;
	
	private JProgressBar progressbar;
	private int firstindex,secondindex,thirdindex,fourthindex;
	private boolean print=false; // set this to true to get information useful for debugging 
	private int total; // just used for print output
		
	private int index1,index2; // used as the indexes for the circle array for the first two indices for the permutations. Only needed to be kept track of so we can give progress bar output
	// otherwise these could just be a couple of local for loops in SetPoints
	
	// constructor
	public PointPairMatch(Point2d[] ellipsecentres){
		foundpointpairs=new PointPair2D[0];
		ellipsecentresinimage=new Point2d[ellipsecentres.length];
		for (int i=0;i<ellipsecentres.length;i++) ellipsecentresinimage[i]=ellipsecentres[i].clone();
		progressbar=new JProgressBar(0,1);
		progressbar.setValue(0);
		total=0;
		smallesterror=Double.MAX_VALUE;
}


public int getNumberofPointPairs(){
	return foundpointpairs.length;
}
public PointPair2D[] getMatchedPoints(){
	return foundpointpairs;
}
private void SetPointPairs(Point2d[] circlearray){
boolean skip;
	skip=(index1==index2);
		if (!skip) for (int k=0;k<circlearray.length;k++){
			skip=((index1==k) || (index2==k)); // the three image points need to be different
			if (!skip){
				total++;
				
				PointPair2D[] foundcentroids;
				if (ellipsecentresinimage.length<circlearray.length) foundcentroids=new PointPair2D[ellipsecentresinimage.length];
				else foundcentroids=new PointPair2D[circlearray.length];
				//Initialise circlefound and ellipsefound to be false for all
				boolean[] circlefound=new boolean[circlearray.length];
				for (int x=0;x<circlefound.length;x++) circlefound[x]=false;
				boolean[] ellipsefound=new boolean[ellipsecentresinimage.length];
				for (int x=0;x<ellipsefound.length;x++) ellipsefound[x]=false;
				
				
				// Initialise the found centroids, circlefound, ellipse found arrays with the first three point pairs 
				foundcentroids[0]=new PointPair2D();
				foundcentroids[0].pointone=circlearray[index1].clone();
				foundcentroids[0].pointtwo=ellipsecentresinimage[firstindex].clone();
				ellipsefound[firstindex]=true;
				circlefound[index1]=true;

				foundcentroids[1]=new PointPair2D();
				foundcentroids[1].pointone=circlearray[index2].clone();
				foundcentroids[1].pointtwo=ellipsecentresinimage[secondindex].clone();
				ellipsefound[secondindex]=true;
				circlefound[index2]=true;

				foundcentroids[2]=new PointPair2D();
				foundcentroids[2].pointone=circlearray[k].clone();
				foundcentroids[2].pointtwo=ellipsecentresinimage[thirdindex].clone();
				ellipsefound[thirdindex]=true;
				circlefound[k]=true;


				// Go through a while loop to fill in the rest of the found centroids array
				boolean breakout=false;
				int index=3;
				double totalerrordistancesquared=0;
				
				while (!breakout){
					int nextcircleindex=0;
					int nextellipseindex=0;
					double mindistancesquared=Double.MAX_VALUE;
					PointPair2D nextpointpair=new PointPair2D();
					// Find the estimated image point for the next of the remaining non-paired calibration points
					for (int i=0;i<circlearray.length;i++){
						if (!circlefound[i]){
							PointPair2D potentialpointpair=new PointPair2D();
							potentialpointpair.pointone=circlearray[i].clone();
							// Attempt to find the image coordinate using barycentric coordinate translations with the closest points if possible
							boolean success=potentialpointpair.EstimateSecondPoint(foundcentroids,index);
							// If that succeeded find the closest non-paired image point and remember it if it is closer than the current closest match.
							if (success) {
								QuickSortByDistanceTo2DPoints qsort=new QuickSortByDistanceTo2DPoints(ellipsecentresinimage);
								int[] indexes=qsort.Sort(potentialpointpair.pointtwo);
								int next=-1;
								boolean exit=false;
								// loop through the image ellipses to find the first one that is not already paired up
								while (!exit){
									next++;
									if (next>=indexes.length) exit=true;
									else if  (!ellipsefound[indexes[next]]) exit=true;
								}
								if (next<indexes.length){
									double distancesquared=potentialpointpair.pointtwo.CalculateDistanceSquared(ellipsecentresinimage[indexes[next]]);
									if (distancesquared<mindistancesquared){
										mindistancesquared=distancesquared;
										nextellipseindex=indexes[next];
										nextcircleindex=i;
										nextpointpair.pointone=circlearray[nextcircleindex].clone();
										nextpointpair.pointtwo=ellipsecentresinimage[nextellipseindex].clone();
									} // end if distance<min
								} // end if next<length
							} // end if success
						} // end if !circlefound
					} // end for
					// Add the closest point match and keep a running total of the error
					if (index<foundcentroids.length){
						foundcentroids[index]=nextpointpair.clone();
						totalerrordistancesquared=totalerrordistancesquared+mindistancesquared;
						circlefound[nextcircleindex]=true;
						ellipsefound[nextellipseindex]=true;
						index++;
					}
					breakout=((index>=foundcentroids.length)  || (totalerrordistancesquared>smallesterror));
				} // end while !breakout
				// If this configuration is better than the last one we have, use it instead
				if ((totalerrordistancesquared<smallesterror) && (index>=foundpointpairs.length)){
					// Now we need to add in the error from the original 3 anchor points
					for (int i=0;i<3;i++){
						PointPair2D potentialpointpair=new PointPair2D();
						potentialpointpair.pointone=foundcentroids[i].pointone.clone();
						// Create a point pair array with all but that point pair in it
						PointPair2D[] allothercentroids=new PointPair2D[index-1];
						for (int j=0;j<index;j++){
							if (j<i) allothercentroids[j]=foundcentroids[j].clone();
							if (j>i) allothercentroids[j-1]=foundcentroids[j].clone();
						} // end for j
						//Find the image coordinate using barycentric coordinate translations with the closest of the other points
						potentialpointpair.EstimateSecondPoint(allothercentroids);
						totalerrordistancesquared=totalerrordistancesquared+potentialpointpair.pointtwo.CalculateDistanceSquared(foundcentroids[i].pointtwo);
					} // end for i
				if (totalerrordistancesquared<smallesterror){
						foundpointpairs=new PointPair2D[index];
						for (int x=0;x<index;x++) foundpointpairs[x]=foundcentroids[x].clone();	
						smallesterror=totalerrordistancesquared;
					}
				} // end if
				if (print) {
					System.out.println(foundcentroids.length+" "+foundpointpairs.length+" "+smallesterror);			
					if (foundpointpairs.length!=0) for (int x=0;x<index;x++){
							foundpointpairs[x].pointone.print();
							foundpointpairs[x].pointtwo.print();
						}
					System.out.println();	
					} // end for x
				} // end if not skip
			} // end for k
		index2++;
		// This would be easier if it were just nested for loops but we do it this way so we can run part of the loop and then exit with an updated progress bar
		if (index2>=circlearray.length){
			index1++;
			index2=0;
		}
} // end of method


private void SetPointPairsUsingHomography(Point2d[] circlearray){
	boolean skip;
		skip=(index1==index2);
			if (!skip) for (int k=0;k<circlearray.length;k++) {
				skip=((index1==k) || (index2==k)); // the image points need to be different
				if (!skip) for (int l=0;l<circlearray.length;l++){
					skip=((index1==l) || (index2==l) || (k==l)); // the 4 image points need to be different
					if (!skip){
						total++;
					PointPair2D[] foundcentroids;
					if (ellipsecentresinimage.length<circlearray.length) foundcentroids=new PointPair2D[ellipsecentresinimage.length];
					else foundcentroids=new PointPair2D[circlearray.length];
					//Initialise circlefound and ellipsefound to be false for all
					boolean[] circlefound=new boolean[circlearray.length];
					for (int x=0;x<circlefound.length;x++) circlefound[x]=false;
					boolean[] ellipsefound=new boolean[ellipsecentresinimage.length];
					for (int x=0;x<ellipsefound.length;x++) ellipsefound[x]=false;
					
					
					// Initialise the found centroids, circlefound, ellipse found arrays with the first 4 point pairs 
					foundcentroids[0]=new PointPair2D();
					foundcentroids[0].pointone=circlearray[index1].clone();
					foundcentroids[0].pointtwo=ellipsecentresinimage[firstindex].clone();
					ellipsefound[firstindex]=true;
					circlefound[index1]=true;

					foundcentroids[1]=new PointPair2D();
					foundcentroids[1].pointone=circlearray[index2].clone();
					foundcentroids[1].pointtwo=ellipsecentresinimage[secondindex].clone();
					ellipsefound[secondindex]=true;
					circlefound[index2]=true;

					foundcentroids[2]=new PointPair2D();
					foundcentroids[2].pointone=circlearray[k].clone();
					foundcentroids[2].pointtwo=ellipsecentresinimage[thirdindex].clone();
					ellipsefound[thirdindex]=true;
					circlefound[k]=true;
					
					foundcentroids[3]=new PointPair2D();
					foundcentroids[3].pointone=circlearray[l].clone();
					foundcentroids[3].pointtwo=ellipsecentresinimage[fourthindex].clone();
					ellipsefound[fourthindex]=true;
					circlefound[l]=true;

					// Create a Homography based on these 4 point pairs
					PointPair2D[] pairs=new PointPair2D[4];
					for (int i=0;i<4;i++) pairs[i]=foundcentroids[i].clone();
					
					CalibrateImage temp=new CalibrateImage(pairs,0);
					Matrix H=temp.getHomography();
					
					// Go through a while loop to fill in the rest of the found centroids array based on the homography made from the homography just made
					boolean breakout=false;
					int index=4;
					double totalerrordistancesquared=0;
					
					while (!breakout){
						int nextcircleindex=0;
						int nextellipseindex=0;
						double mindistancesquared=Double.MAX_VALUE;
						PointPair2D nextpointpair=new PointPair2D();
						// Find the estimated image point for the next of the remaining non-paired calibration points
						for (int i=0;i<circlearray.length;i++){
							if (!circlefound[i]){
								PointPair2D potentialpointpair=new PointPair2D();
								potentialpointpair.pointone=circlearray[i].clone();
								// Attempt to find the image coordinate using Homography
								potentialpointpair.pointtwo=potentialpointpair.pointone.clone();
								boolean success=potentialpointpair.pointtwo.ApplyTransform(H);
								
								//find the closest non-paired image point and remember it if it is closer than the current closest match.
								if (success) {
									QuickSortByDistanceTo2DPoints qsort=new QuickSortByDistanceTo2DPoints(ellipsecentresinimage);
									int[] indexes=qsort.Sort(potentialpointpair.pointtwo);
									int next=-1;
									boolean exit=false;
									// loop through the image ellipses to find the first one that is not already paired up
									while (!exit){
										next++;
										if (next>=indexes.length) exit=true;
										else if  (!ellipsefound[indexes[next]]) exit=true;
									}
									if (next<indexes.length){
										double distancesquared=potentialpointpair.pointtwo.CalculateDistanceSquared(ellipsecentresinimage[indexes[next]]);
										if (distancesquared<mindistancesquared){
											mindistancesquared=distancesquared;
											nextellipseindex=indexes[next];
											nextcircleindex=i;
											nextpointpair.pointone=circlearray[nextcircleindex].clone();
											nextpointpair.pointtwo=ellipsecentresinimage[nextellipseindex].clone();
										} // end if distance<min
									} // end if next<length
								} // end if success
							} // end if !circlefound
						} // end for i
						// Add the closest point match and keep a running total of the error
						if (index<foundcentroids.length){
							foundcentroids[index]=nextpointpair.clone();
							totalerrordistancesquared=totalerrordistancesquared+mindistancesquared;
							circlefound[nextcircleindex]=true;
							ellipsefound[nextellipseindex]=true;
							index++;
						}
						breakout=((index>=foundcentroids.length)  || (totalerrordistancesquared>smallesterror));
					} // end while !breakout
					// If this configuration is better than the last one we have, use it instead
					if ((totalerrordistancesquared<smallesterror) && (index>=foundpointpairs.length)){
						// Now we need to add in the error from the original 4 anchor points
						for (int i=0;i<4;i++){
							PointPair2D potentialpointpair=new PointPair2D();
							potentialpointpair.pointone=foundcentroids[i].pointone.clone();
							potentialpointpair.pointtwo=potentialpointpair.pointone.clone();
							boolean success=potentialpointpair.pointtwo.ApplyTransform(H);
							totalerrordistancesquared=totalerrordistancesquared+potentialpointpair.pointtwo.CalculateDistanceSquared(foundcentroids[i].pointtwo);
						} // end for i
					if (totalerrordistancesquared<smallesterror){
							foundpointpairs=new PointPair2D[index];
							for (int x=0;x<index;x++) foundpointpairs[x]=foundcentroids[x].clone();	
							smallesterror=totalerrordistancesquared;
						}
					} // end if
					if (print) {
						System.out.println(foundcentroids.length+" "+foundpointpairs.length+" "+smallesterror);			
						if (foundpointpairs.length!=0) for (int x=0;x<index;x++){
								foundpointpairs[x].pointone.print();
								foundpointpairs[x].pointtwo.print();
							}
						System.out.println();	
						} // end for x
					} // end if not skip
				} // end if not skip for l
				
				} // end if not skip for k
			index2++;
			// This would be easier if it were just nested for loops but we do it this way so we can run part of the loop and then exit with an updated progress bar
			if (index2>=circlearray.length){
				index1++;
				index2=0;
			}
	} // end of method


/*************************************************************
 * 
 * The new approach. Faster but sometimes less accurate when there are occluded circles on opposite sides of the calibration sheet
 * 
 * 
 ***************************************************************/
///*
// Note that this does not do all the permutations at once as it is also giving GUI feedback
//Ultimately it needs to be called from within a while progressbar.value<progressbar.getmax type loop
public JProgressBar MatchCircles(Point2d[] circlearray){
	if(progressbar.getValue()==progressbar.getMinimum()){
		// set the progressbar and the initial conditions
		progressbar=new JProgressBar(0,(circlearray.length*circlearray.length)-1);
		progressbar.setValue(0);
		index1=0; index2=1;
		// Find the combination of the image points that creates a triangle with the largest Euclidean area.
		double maxdoublearea=0;
		for (int a=0;a<(ellipsecentresinimage.length-2);a++){
			for (int b=(a+1);b<(ellipsecentresinimage.length-1);b++){
				for (int c=(b+1);c<ellipsecentresinimage.length;c++){
					// calculate the area 
					Point2d ab=ellipsecentresinimage[b].clone();
					ab.minus(ellipsecentresinimage[a]);
					Point2d ac=ellipsecentresinimage[c].clone();
					ac.minus(ellipsecentresinimage[a]);
					// area = 1/2|ab x ac|
					// we don't need to halve this as we are just wanting to find the largest and the crosslength method already gives us the absolute value so...
					double doublearea=ab.crossLength(ac);
					if (doublearea>maxdoublearea){
						maxdoublearea=doublearea;
						firstindex=a;
						secondindex=b;
						thirdindex=c;
					} // end if
				} // end for c
			} // end for b
		} // end for a
		if ((ellipsecentresinimage.length==0) || (circlearray.length==0)) progressbar.setValue(progressbar.getMaximum());
		
	} // end if progress bar is minimum
	if (progressbar.getValue()!=progressbar.getMaximum()) {
		SetPointPairs(circlearray);
		progressbar.setValue(progressbar.getValue()+1);
		if (index1>=circlearray.length) progressbar.setValue(progressbar.getMaximum());
	} // end if progressbar is not max
	return progressbar;
	
}
/*************************************************************
* 
* The newest approach. Faster but sometimes less accurate when there are occluded circles on opposite sides of the calibration sheet
* 
* 
***************************************************************/
///*
//Note that this does not do all the permutations at once as it is also giving GUI feedback
//Ultimately it needs to be called from within a while progressbar.value<progressbar.getmax type loop
public JProgressBar NewMatchCircles(Point2d[] circlearray){
	if(progressbar.getValue()==progressbar.getMinimum()){
		// set the progressbar and the initial conditions
		progressbar=new JProgressBar(0,(circlearray.length*circlearray.length)-1);
		progressbar.setValue(0);
		index1=0; index2=1;
		// Find the combination of the image points that creates the quadralateral with the largest Euclidean area.
		double maxdoublearea=0;
		for (int a=0;a<(ellipsecentresinimage.length-2);a++){
			for (int b=(a+1);b<(ellipsecentresinimage.length-1);b++){
				for (int c=(b+1);c<ellipsecentresinimage.length;c++){
					for (int d=(c+1);d<ellipsecentresinimage.length;d++){
					
					// First we have to figure out which the correct order for the four points so that we can make 2 non-intersecting triangles (abd, bcd) forming the quadralateral 	
					Point2d[] vertices=new Point2d[4];
					vertices[0]=ellipsecentresinimage[a];
					vertices[1]=ellipsecentresinimage[b];
					vertices[2]=ellipsecentresinimage[c];
					vertices[3]=ellipsecentresinimage[d];
					BoundingPolygon2D polygon=new BoundingPolygon2D(vertices);
					Point2d[] ordered=polygon.GetOrderedVertices();
					// calculate the area (assuming none of the points is within a triangle made by the others)
					double doublearea=0;
					if (ordered.length==3){
						Point2d ab=ordered[1].minusEquals(ordered[0]);
						Point2d ac=ordered[2].minusEquals(ordered[0]);
						// area = 1/2|ab x ac|
						// we don't need to halve this as we are just wanting to find the largest and the crosslength method already gives us the absolute value so...
						doublearea=ab.crossLength(ac);
					} // end if length==3
					else if (ordered.length==4){
						Point2d ab=ordered[1].minusEquals(ordered[0]);
						Point2d ad=ordered[3].minusEquals(ordered[0]);
						Point2d bc=ordered[2].minusEquals(ordered[1]);
						Point2d bd=ordered[3].minusEquals(ordered[1]);
						// area = 1/2|ab x ad|+ 1/2|bc x bd|
						// we don't need to halve this as we are just wanting to find the largest and the crosslength method already gives us the absolute value so...
						doublearea=ab.crossLength(ad)+bc.crossLength(bd);
					} // end if length==4
					if (doublearea>maxdoublearea){
						maxdoublearea=doublearea;
						firstindex=a;
						secondindex=b;
						thirdindex=c;
						fourthindex=d;
					} // end if >max
					
					} // end for d
				} // end for c
			} // end for b
		} // end for a
		if ((ellipsecentresinimage.length==0) || (circlearray.length==0)) progressbar.setValue(progressbar.getMaximum());
	} // end if progress bar is minimum
	if (progressbar.getValue()!=progressbar.getMaximum()) {
		SetPointPairsUsingHomography(circlearray);
		progressbar.setValue(progressbar.getValue()+1);
		if (index1>=circlearray.length) progressbar.setValue(progressbar.getMaximum());
	} // end if progressbar is not max
	return progressbar;
	
}


/***************************************************
 * 
 * The old approach - TODO delete this eventually,
 * It is currently only called from within the testing class.
 * 
 ******************************************************/


// Note that this does not do all the combinations at once as it is also giving GUI feedback
//Ultimately it needs to be called from within a while progressbar.value<progressbar.getmax type loop
public JProgressBar OldMatchCircles(Point2d[] circlearray){
	
	if(progressbar.getValue()==progressbar.getMinimum()){
		// set the progressbar and the initial conditions
		progressbar=new JProgressBar(0,((ellipsecentresinimage.length*(ellipsecentresinimage.length-1)*(ellipsecentresinimage.length-2))/6)+1);
		progressbar.setValue(0);
		firstindex=0;
		secondindex=1;
		thirdindex=2;
		// Comment this out when want to run. Uncomment when testing previous parts
		//progressbar.setValue(progressbar.getMaximum());
		if ((ellipsecentresinimage.length==0) || (circlearray.length==0)) progressbar.setValue(progressbar.getMaximum());
		
	}
	if (progressbar.getValue()!=progressbar.getMaximum()){
		SetPointPairs(circlearray);
		if (index1>=circlearray.length){
			index1=0;
			index2=1;
			thirdindex++;
			
			// Note that we don't have to do every permutation as, because of the way the SetPointPairs is done, 1,2,3 is the same as 2,3,1 or 3,2,1 etc.
			// So we only have to do the various combinations which can easily be done by having the thirdindex go from the secondindex+1->the end, secondindex go from firstindex+1->end-1, and first index from 1->end-2
			// If we work out the if statements in the right order we don't have to find when the first or second index need to finish we can just test whether the thirdindex has overrun the end of the array.
			
			if (thirdindex>=ellipsecentresinimage.length){
				secondindex++;
				thirdindex=secondindex+1;
			}
			if (thirdindex>=ellipsecentresinimage.length){
				firstindex++;
				secondindex=firstindex+1;
				thirdindex=secondindex+1;
			}
			if ((thirdindex>=ellipsecentresinimage.length) || (progressbar.getValue()==progressbar.getMaximum())) progressbar.setValue(progressbar.getMaximum());
			else progressbar.setValue(progressbar.getValue()+1);
		}
	}
	return progressbar;
}

} // end of class
