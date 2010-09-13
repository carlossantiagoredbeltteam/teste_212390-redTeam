package org.reprap.scanning.FeatureExtraction;

import javax.swing.JProgressBar;

import org.reprap.scanning.DataStructures.Accumulator1D;
import org.reprap.scanning.DataStructures.AccumulatorBoolean;
import org.reprap.scanning.Geometry.Point2d;
import org.reprap.scanning.Geometry.Ellipse;
import org.reprap.scanning.Geometry.AxisAlignedBoundingBox;
import org.reprap.scanning.FeatureExtraction.EdgeExtraction2D.direction; // This is the internal enum structure used for the direction. 
// The actual values are only used in the constructor and the ConvexDirectionsWithinLimits method (which also relies on the order of this enum).

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
* Last modified by Reece Arnott 26th April 2010
*  
* A brief outline of the steps involved in finding ellipses  
*	1. Read the pre-processed edge and direction information into arrays containging the edge point, the tangent direction, and, currently commented out, the direction at right angles to the tangent (left or right) pointing to the supposed centre - constructor
*	2. Find the ellipses that may have been circles imaged at an angle within the limits described by the lowest angle, and the max and min longest axis - ExtractEllipses
*
* The second step uses the technique described in "A new efficient ellipse detection method" by Xie, Y. and Ji, Q. in Proceedings of the 16th International Conference on Pattern Recognition
* 2002 available for download from http://doi.ieeecomputersociety.org/10.1109/ICPR.2002.1048464
* But with additional checks and balances because of the assoicated convexity direction and tangential direction. It also has the idea of using a bounding rectangle based on the max long axis length to restrict the combinations that need to be checked (optionally set by a boolean parameter passed into the constructor)
* 
* 	
***********************************************************************************/

public class FindEllipses {

	boolean[] skipped;
	private final Point2d[] edge; //populated by the constructor
	//private final convexity[] convexdirection;// populated by the constructor. This needs to be combined with the tangent direction to give meaningful answers except that if the convexdirection is skip then obviously this edge is to be skipped.
	// Convexity is currently commented out as the subdivision into left and right did not work correctly.
	private final direction[] tangentdirection; // populated by the constructor. 
	private final int width;// populated by the constructor. 
	private final int height; // populated by the constructor. 
	private final double minimumaxislength; // populated by constructor based on the edge detector used
	private final double originalbovera; //populated by the constructor using the passed in value
	private final AxisAlignedBoundingBox imagebounds; // populated by constructor, just used to set the 2d outer boundary on other bounding boxes created
	private Ellipse[] ellipses;
	private JProgressBar progressbar;
	private final int[][] edgeindices; // populated by the constructor. Used to make the routinues faster at the expense of additional memory structures
	// Each entry corresponds to a cell in the edgemap which in turn is a pixel in the image. -1 means there is no edge with any other number being the index to use for the relevent edge
	// in the edge, skipped, and direction arrays. In testing use of this structure in conjunction with a bounding rectangle to search shaved a few seconds off ellipse detection
	// for images but significantly increased the time for finding the calibration circles. If the bounding rectangle is too large it can slow things down but when the bounding rectangle is
	// small it limits the number of combinations of edge points to check.
	
	// It is assumed that the y coordinate 0 is at the bottom of the image
	// horizontal is assumed to be right to left, vertical is assumed to be bottom to top 
	//enum convexity {left,skip,right}; // when combined with direction this gives 8 possible valid directions for convexity. 
// the ConvexDirectionWithinLimits uses the ordinal values of left and right so don't change the order
	public FindEllipses(EdgeExtraction2D edges, double origbovera){
		edge=new Point2d[edges.GetEdgeCount()];
		originalbovera=origbovera;
		//convexdirection=new convexity[edges.GetEdgeCount()];
		tangentdirection=new direction[edges.GetEdgeCount()];
		minimumaxislength=edges.GetResolution()*2;
		progressbar=new JProgressBar(0,1);
		progressbar.setValue(0);
		ellipses=new Ellipse[0];
		width=edges.GetWidth();
		height=edges.GetHeight();
		edgeindices=new int[width][height];
		imagebounds=new AxisAlignedBoundingBox();
		imagebounds.minx=0;
		imagebounds.miny=0;
		imagebounds.minz=0;
		imagebounds.maxx=width-1;
		imagebounds.maxy=height-1;
		imagebounds.maxz=0;
		// Read the edges into the 1D arrays we have created and set the edgeindices memory structure as well
		
		// Go through the edge strength array, check to see if the edge strength is zero and if it isn't calculate the convexdirection
		// then add the edge, tangentdirection and convexdirection to the 1D arrays
			int index=0;
			for (int x=0;x<width;x++){
				for (int y=0;y<height;y++){
					int leftcount=0;
					int leftedgestrength=0;
					int rightcount=0;
					int rightedgestrength=0;
					// If the point is not an edge ignore
					if (edges.GetEdgeStrength(x,y)!=0){
						int dir=edges.GetDirection(x,y);
						// Check within a 5x5 window and count the number of edge points on either side of the direction line 
						for (int dx=-2;dx<=2;dx++){
							for (int dy=-2;dy<=2;dy++){
								if (!((dx==0) && (dy==0))){
									int edgestrength=edges.GetEdgeStrength(x+dx,y+dy);
									if (edgestrength!=0){
										// categorise which side of the line it is on
										boolean left;
										if (dir==direction.valueOf("vertical").ordinal()) left=(dx<0); // assuming looking at line pointing up, in this case left of the line is left in the picture in all other cases this is not so. 
										else if (dir==direction.valueOf("horizontal").ordinal()) left=(dy<0); // assuming looking at line pointing left, so left is down and right is up in the picture
										else if (dir==direction.valueOf("diagonalrighttoptoleftbottom").ordinal()) left=(dx<dy); 
										else left=(dx<(dy*-1));
										// now add the edge to the count and the sum of strengths
										if (left) {
											leftcount++;
											leftedgestrength+=edgestrength;
										}
										else {
											rightcount++;
											rightedgestrength+=edgestrength;
										}
									} // end if 
								} // end if !(dx==0 and dy==0)
							} // end for dy
						} // end for dx
						// Add the calculated convexdirection and extracted edge and direction to 1D arrays and the correct index to the edgeindices array
						edge[index]=new Point2d(x,y);
						tangentdirection[index]=direction.values()[dir];
						edgeindices[x][y]=index;
						// Can we estimate convexity based on the direction line and the strengths of the local edges on either side of the direction line?
				//		boolean skip=(leftedgestrength==rightedgestrength); //|| (leftcount==rightcount); // Do we need the count?
						// No difference in strengths so can't determine convexity so skip it
				//		if (skip) {
				//			convexdirection[index]=convexity.valueOf("skip");
				//		}
						// The convex direction is the direction pointing towards the centre of the convexity and
						// is offset from the direction line by 90 degrees but in which direction? use the left and right edge strengths to find out.
						// If there is more edge strength to the left it is in that direction that the convexity lies.
				//		else if (leftedgestrength>rightedgestrength) convexdirection[index]=convexity.valueOf("left");
				//		else convexdirection[index]=convexity.valueOf("right");
						index++;
					} // end if EdgeStrength==0
					else edgeindices[x][y]=-1;
				} // end for y
			} // end for x
			} // end of method

	
	// Using the technique described in "A new efficient ellipse detection method" FindEllipsesby Xie, Y. and Ji, Q. in Proceedings of the 16th International Conference on Pattern Recognition
	// 2002 available for download from http://doi.ieeecomputersociety.org/10.1109/ICPR.2002.1048464
	// Have added in additional checks and balances based on the fact that we have a known direction for an edge which for an edge of an ellipse would be a tangential direction.
	
//	 Note that this does not do all the permutations at once as it is also giving GUI feedback
//	Ultimately it needs to be called from within a while progressbar.value<progressbar.getmax type loop

	public JProgressBar ExtractEllipses(double MinLongAxisSquared, double MaxLongAxisSquared, double lowestangle, double accumulatorquantumsize){	
	 if (progressbar.getValue()==progressbar.getMinimum()){
		 progressbar=new JProgressBar(0,edge.length-1);
		 skipped=new boolean[edge.length];
			// set all skipped to be false
			for (int i=0;i<edge.length;i++) skipped[i]=false;
			
	 }
		if (MinLongAxisSquared<(minimumaxislength*minimumaxislength)) MinLongAxisSquared=(minimumaxislength*minimumaxislength);
		if (MaxLongAxisSquared>((width*width)+(height*height))) MaxLongAxisSquared=(width*width)+(height*height);
		if (MaxLongAxisSquared<MinLongAxisSquared) MaxLongAxisSquared=MinLongAxisSquared;
		if (lowestangle>(Math.PI/2)) lowestangle=Math.PI/2;
		
		// Try and speed up using the bounding box if it may make a difference
		boolean useboundingbox=edge.length>(MaxLongAxisSquared);
		
		// Take the lowest angle provided (in radians) and convert it into the smallest ratio of minor to major axis (b/a)
		double minbovera=CalculateMinorToMajorSemiAxisAspectRatio(lowestangle)*originalbovera;
		// Go through each combination of the current edge point and each of the other edge points and find appropriate pairs
		int i=progressbar.getValue(); // Used to be a for loop before modifiying to show progress bar 
			if (!skipped[i]) {
				// Find the bounding box around this point and search it for any other edge points
				double max2a=Math.sqrt(MaxLongAxisSquared);
				AxisAlignedBoundingBox boundingbox=new AxisAlignedBoundingBox();
				boundingbox.minx=edge[i].x-max2a-1;
				boundingbox.miny=edge[i].y-max2a-1;
				boundingbox.maxx=edge[i].x+max2a+1;
				boundingbox.maxy=edge[i].y+max2a+1;
				boundingbox.TruncateIfExceedsBounds(imagebounds);
				int x=(int)boundingbox.minx-1;
				int y=(int)boundingbox.miny;
				int j=i;
				boolean exitloop=false;
				while (!exitloop){
					
					// Set the next j
					if (useboundingbox){
						// This is finding all combinations of 2 edge points within a bounding rectangle area.
						// the equivalent of:
						//for(int x=boundingbox.minx;x<boundingbox.maxx;x++)
						//	for(int y=boundingbox.miny;y<boundingbox.maxy;y++){
						//			if (edgeindices[x][y]>i){
						//				int	j=edgeindices[x][y];
						j=-1;
						while ((j<=i) && (!exitloop)){ // while j<=i accomplishes the task of ignoring all non-edge cells as well as those where the combination of the 2 will have been previously tested
							x++;
							if (x>=boundingbox.maxx){ x=(int)boundingbox.minx; y++;}
							exitloop=(y>=boundingbox.maxy);
							if (!exitloop) j=edgeindices[x][y];
						} // end while
					} // end if
					else {
						// This is the equivalent of for(int j=i+1;j<edge.length;j++) i.e. finding all combinations of 2 edge points 
						j++;
						exitloop=(j>=edge.length);
					} // end else
					if (!exitloop){
					// These checks are hopefully ordered so that those that need the least processing and cut out the most are done first
						boolean continueprocessing=((j!=-1) &&(i!=j)); // check that there is in fact an edge there (but not the same as the i one).	
						// check that the edge hasn't already been used as part of another ellipse
						if (continueprocessing) continueprocessing=!skipped[j];
						 // check that both directions are the same
						if (continueprocessing) continueprocessing=(tangentdirection[i]==tangentdirection[j]);
						// Check that neither is to be skipped
						//if (continueprocessing) continueprocessing=((convexdirection[i]!=convexity.valueOf("skip"))) && (convexdirection[j]!=convexity.valueOf("skip"));
						 // check that one is left and the other right
						//if (continueprocessing) continueprocessing=(convexdirection[i]!=convexdirection[j]);
						// check that the distance between the edges is within the max and min limits
						
						if (continueprocessing) {
							double distancesquared=edge[i].CalculateDistanceSquared(edge[j]);
							continueprocessing=((distancesquared>=MinLongAxisSquared) && (distancesquared<=MaxLongAxisSquared));
						}
						// check that the one on the left is actually to the left of the one on the right
						//if (continueprocessing) {
						//	double angle;
							//if (convexdirection[i]==convexity.valueOf("left")) angle=edge[i].GetAngleMeasuredClockwiseFromPositiveX(edge[j]);
						//	if (convexdirection[i]==convexity.valueOf("right")) angle=edge[i].GetAngleMeasuredClockwiseFromPositiveX(edge[j]);
						//	else angle=edge[j].GetAngleMeasuredClockwiseFromPositiveX(edge[i]);
						//	angle=(angle+(Math.PI/8))%Math.PI; // offset by pi/8 (22.5 degrees) mod pi radians to make the comparison easier: rather than testing if between -22.5 or 337.5 degrees to 155.5 degrees simply test if <=180 degrees (pi radians)
						//	continueprocessing=(Math.abs(angle)<=Math.PI);
						//}
						// TODO uncomment if can get to work
						//Check that the angle between the two is appropriate - more or less superceded by the checking that the left is actually to the left of the right one.
						//if (continueprocessing) {
						//	double angle=edge[i].GetAngleMeasuredClockwiseFromPositiveX(edge[j]);
						//		continueprocessing=ConvexDirectionWithinLimits(angle,convexdirection[j],tangentdirection[j]);
						//}
						
					// If these two points are compatible, assume they are opposite sides of the long axis
					// and use these two points to calculate the centre point, the orientation, and length of the long axis.
						Point2d center=new Point2d(0,0);
						if (continueprocessing){
							center=new Point2d((edge[i].x+edge[j].x)/2,(edge[i].y+edge[j].y)/2);
							// check the center isn't within an already found ellipse
							int ind=0;
							while ((continueprocessing) && (ind<ellipses.length)) {continueprocessing=!ellipses[ind].PointInsideEllipse(center); ind++;} 
						}
						if (continueprocessing){
							double a=Math.sqrt(edge[i].CalculateDistanceSquared(edge[j]))/2;
							double asquared=a*a;
							double orientationangle;
							if ((int)edge[i].x==(int)edge[j].x) orientationangle=Math.PI/2; // The below formula won't work when the long axis is on the y axis
							else orientationangle=Math.atan((edge[j].y-edge[i].y)/(edge[j].x-edge[i].x)); // atan returns the angle with -pi/2 - pi/2 i.e. -90 - 90 degrees 
					
							// Then use these values to calculate the short axis length for each of the remaining edge points and put them into an accumulator to get the best result
							// The accumulator will measure the b axis within limits of a calculated minimum and a in steps
								double minb=minbovera*a;
							if (minb<(minimumaxislength/2)) minb=minimumaxislength/2;
							Accumulator1D accumulator=new Accumulator1D(minb,a,accumulatorquantumsize);
							AccumulatorBoolean octants=new AccumulatorBoolean(minb,a,8,accumulatorquantumsize);
							// Set up a boolean accumulator to mark when there is an edge point in each of eight arcs around the ellipse
//							 Find the bounding box around the center point and search it for any other edge points
							AxisAlignedBoundingBox newboundingbox=new AxisAlignedBoundingBox();
							newboundingbox.minx=center.x-a-1;
							newboundingbox.miny=center.y-a-1;
							newboundingbox.maxx=center.x+a+1;
							newboundingbox.maxy=center.y+a+1;
							newboundingbox.TruncateIfExceedsBounds(imagebounds);
							int xx=(int)newboundingbox.minx-1;
							int yy=(int)newboundingbox.miny;
							int k=-1;
							boolean exitloop2=false;
							while (!exitloop2){
								
								// Set the next j
								if (useboundingbox){
									// This finds the next edge within the bounding rectangle
									k=-1;
									while ((k==-1) && (!exitloop2)){
										xx++;
										if (xx>=newboundingbox.maxx){ xx=(int)newboundingbox.minx; yy++;}
										exitloop2=(yy>=newboundingbox.maxy);
										if (!exitloop2) k=edgeindices[xx][yy];
									}
								} // end if
								else {
									k++;
									exitloop2=(k>=edge.length);
								}
								if (!exitloop2){
									if (!skipped[k]) if ((k!=i) && (k!=j) ){//&& (convexdirection[k]!=convexity.valueOf("skip"))){
									double distsquared=center.CalculateDistanceSquared(edge[k]);
									if (distsquared<=(a*a)){ // if within the correct distance
										// check if within the correct angle
											//direction directiontangent=directionmap[(int)edge[k].x][(int)edge[k].y];
											//if 	(ConvexDirectionWithinLimits(center.GetAngleMeasuredClockwiseFromPositiveX(edge[k]),convexdirection[k],directiontangent)){
											// calculate the short axis b length using formulae 5 and 6 from the referenced paper
											// First calculate the intermediary numbers needed:
											double dsquared=center.CalculateDistanceSquared(edge[k]);
											double fsquared=edge[j].CalculateDistanceSquared(edge[k]);
											//could use edge[i] instead if it were closer but doesn't really matter?
											//double fdashsquared=edge[i].CalculateDistanceSquared(edge[k]);
											//if (fdashsquared<fsquared)fsquared=fdashsquared;
								
											// tau is the angle at the center between the lines from the center to the second point and the third point
											// Note that by definition this is between 0-180 degrees or 0-pi radians so don't have to worry about acos function mapping tau to the wrong angle
											//From the cosine rule:
											//cosine rule: b^2=a^2+c^2-2ac*cosB or CosB=(a^2+c^2-b^2)/2ac
											double cosinetau=(asquared+dsquared-fsquared)/Math.sqrt(4*asquared*dsquared);
											double tau=Math.acos(cosinetau);// acos will get the tau within 0-pi 0-180 degrees
											double sinetau=Math.sin(tau);
											double bsquared=(asquared*dsquared*sinetau*sinetau)/(asquared-(dsquared*cosinetau*cosinetau));
											double b=Math.sqrt(bsquared);
											//double angle=center.GetAngleMeasuredClockwiseFromPositiveX(edge[k]);
											//int oct=(int)Math.floor((angle/Math.PI)*4)%8;
											int oct=center.GetOctant(edge[k]);
											// Set the accumulators
											accumulator.increment(b); 
											octants.Set(b,oct,true); // Set the boolean variable for this octant to true
											
											//} // end if direction within limits
									} // end if within the correct distance
								} // end if skip k
							} // end if !exitloop2
							} // end while !exitloop2
							// Now is the maximal b one that is contructed with points from all 8 octants around the center and has more than 50% of the vote 
							double max=accumulator.GetVotedMax();
							double maxpercent=accumulator.GetPercentage(max);
							//int maxcount=accumulator.GetCount(max);
							int octcount=octants.GetNumberOfTrue(max);
							if ((octcount==6) || (octcount==7)) {
								// Add in the octant of the initial two anchor points if it may make a difference between accepting and rejecting the ellipse
								//double angle=center.GetAngleMeasuredClockwiseFromPositiveX(edge[i]);
								//int oct=(int)Math.floor((angle/Math.PI)*4)%8;
								int oct=center.GetOctant(edge[i]);
								octants.Set(max,oct,true);
								//angle=center.GetAngleMeasuredClockwiseFromPositiveX(edge[j]);
								//oct=(int)Math.floor((angle/Math.PI)*4)%8;
								oct=center.GetOctant(edge[j]);
								octants.Set(max,oct,true);
								octcount=octants.GetNumberOfTrue(max);
							}
							// Find those ellipses with edge points in all eight of the sections around the ellipse and which have more than agreement on the b length of 50% or more. 
							if ((maxpercent>50) && (octcount==8)){
								Ellipse e=new Ellipse(center,a,max,orientationangle);
								// Check that this ellipse doesn't overlap with any of the others found
								boolean skip=false;
								int index=0;
								while ((!skip) && (index<ellipses.length)){
									skip=e.Overlap(ellipses[index]);
									index++;
								}
								if (!skip){
									// Add ellipse to array of ellipses
									Ellipse[] newarray=new Ellipse[ellipses.length+1];
									for (int ind=0;ind<ellipses.length;ind++) newarray[ind]=ellipses[ind].clone();
									newarray[ellipses.length]=e.clone();
									ellipses=newarray.clone();
									// set any edgepoints that are inside the ellipse to be skipped
									for (int ind=0;ind<edge.length;ind++) if (!skipped[ind]) skipped[ind]=e.PointInsideEllipse(edge[ind]);
									//assuming that an edge point is only part of one ellipse we can exit the loop early
									j=edge.length;
								} // end if !skip
								
							} // end if
						} // end if continueprocessing
			} // end if !skipped
					} // end if !exitloop
				} // end while !exitloop
			
		progressbar.setValue(i+1);
		return progressbar;
	} // end method FindEllipses
	
	public Ellipse[] getEllipses(){
		return ellipses;
	}

		
	/*****************************************************************************************************************************************************
	 * 
	 * 		Private methods from here on down
	 * 
	 ******************************************************************************************************************************************************/
	
	
	
// This is not currently used as the convexity direction is unreliable
	/*
	private boolean ConvexDirectionWithinLimits(double angle, convexity convexdirection, direction directiontangent){
		// Checks that the angle is appropriate
		// i.e if the angle is +/- pi/8 radians (22.5 degrees) from the mid angle for this particular opposite
		//	e.g. if two points have a vertical tangent direction then the angle between them must be within +/- 22.5 degrees of horizontal
		// if one is set to left then the angle measured clockwise from the positive x axis must be within +/- 22.5 degrees
		// but if the convexity is to the right then the angle must be 180 degrees +/- 22.5.
		angle=Math.abs(angle%(Math.PI*2));
		boolean returnvalue;
		// Note that there is a special case for the direction tangent being vertical and the convexity to the right so check that first 
		if ((convexdirection==convexity.valueOf("right")) && (directiontangent==direction.valueOf("vertical"))) returnvalue=((angle<=(Math.PI/8)) || (angle>=(Math.PI*15/8)));
		else {
			double anglemin=((directiontangent.ordinal()*(Math.PI/4))+(convexdirection.ordinal()*(Math.PI/2))+(Math.PI/8))%(2*Math.PI); 
			// The anglemin is +22.5 (45/2) degrees +45 degrees for each additional direction and 180 degrees if the first convexdirection is right  
			returnvalue=((angle>=anglemin) && (angle<(anglemin+(Math.PI/4))));
		}
		return returnvalue;
		
	}
*/
	
	
	// This calculates the minor to major axis ratio (b/a) given that the ellipse detected is a circle 
	// viewed from the lowest angle (in radians) off the vertical axis. 
	// 0 is viewed from "above" so b/a=1 and pi/2 or 90 degrees is viewed from the side with b/a at infinity at this point.
	private double CalculateMinorToMajorSemiAxisAspectRatio(double lowestangle){
		double returnvalue=1;
		lowestangle=Math.abs(lowestangle%(Math.PI/2)); // Makes sure the angle is between 0-pi/2 radians i.e. 0-90 degrees
		// From "Eccentricity in Ellipses" by L. A. Kenna in Mathematics Magazine, Vol. 32, No. 3 (Jan. - Feb., 1959), pp. 133-135
		// downloadable from http://www.jstor.org/stable/3029496
		// if we assume that the ellipse is made from intersecting a plane with a cylinder, the eccentricity of an ellipse is the sine of the angle between the normal 
		// of the cylinder and the cutting plane i.e. e=sin(alpha)
		// The standard definition of eccentricity in terms of major and minor axes is e^2=(a^2-b^2)/a^2=1-(b/a)^2
		// so rearranging for b/a we have b/a=sqrt(1-sin(alpha)^2) so
		//returnvalue=Math.sqrt(1-Math.pow(Math.sin(lowestangle),2));
		// but is this the same as the cosine of the angle just becuase of the trig relationship between sine and cosine
		returnvalue=Math.cos(lowestangle);

		return returnvalue;
	}
}
