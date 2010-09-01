package org.reprap.scanning.Geometry;
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
* Last modified by Reece Arnott 11th June 2010
* 
* Note that this is *not* an extentsion to the native java.awt.geom.Ellipse2D class but is totally different
* The native class is simply defined by a bounding rectangle.
* There is also the org.eclipse.tptp.platform.report.igc.util.internal.Ellipse class which has additional functionality not used by this.
*		
***********************************************************************************/
import org.reprap.scanning.DataStructures.Image;
import org.reprap.scanning.DataStructures.MatrixManipulations;

import Jama.Matrix;

public class Ellipse {
	Point2d center;
	double a,b; // The minor and major semi-axis lengths
	// Note that due to the symmetrical nature of the ellipse the angle may be out by 180 degrees (pi radians)
	double orientationangle; // This is the angle made between the long axis a and the x axis (in radians)
	// These are points calculated by the constructor
	Point2d f1;
	Point2d f2;
	
	//Constructor
	public Ellipse(Point2d centre, double onesemiaxis, double othersemiaxis, double longaxisanglewithxaxis){
		center=centre.clone();
		a=onesemiaxis;
		b=othersemiaxis;
		// rearrange a and b if need be
		if (a<b){ a=othersemiaxis; b=onesemiaxis;}
		orientationangle=longaxisanglewithxaxis%(Math.PI/2); // the angle can only be -90-90 degrees 
		Calculatefocalpoints();
	} // end constructor
	
	
	//TODO replace with actual transformed ellipse equation if can figure out how to do it.
	// Should be able to get b:a ratio and orientationangle from angle between circle center and camera center
	// from ratio can get a and b lengths if transform 2 points on circumference and find distance between them
	// Question is there a better way to get ellipse center?
	// This creates an ellipse which is an image of the ellipse on a plane when viewed from an angle 
	public Ellipse(Matrix P, Point2d neworigin,Ellipse ellipse, int numberofsteps){
		
		MatrixManipulations manipulate=new MatrixManipulations();
		manipulate.SetWorldToImageTransform(P);
		// Now find the centre of the transformed ellipse. In general it won't be the circle center transformed
		// So we need to take some points on the circumference, transform them and find their center.
		// The easiest way to do this is to put a bounding box around them and find the mid-point of the 2d bounding box
		
		// We can not simply find the mid-point of 2 transformed points 180 degrees apart
		// as angles are not preserved
		double stepsize=(Math.PI*2)/(double)numberofsteps;
    	AxisAlignedBoundingBox box=new AxisAlignedBoundingBox();
		Point2d[] newpoint=new Point2d[numberofsteps];
    	for (int i=0;i<numberofsteps;i++){
  			// Go round the circumference and find the transformed point
  			//Point2d oldpoint=GetEllipseEdgePointParametric((double)i*stepsize);
  			Point2d oldpoint=ellipse.GetEllipseEdgePointPolar((double)i*stepsize);
  			newpoint[i]=manipulate.TransformCalibrationSheetPointToImagePoint(oldpoint,neworigin);
    		
      		if (i==0){
				box.minx=newpoint[i].x;
				box.miny=newpoint[i].y;
				box.maxx=newpoint[i].x;
				box.maxy=newpoint[i].y;
			}
			else box.Expand2DBoundingBox(newpoint[i]); 
      	}
		center=box.GetMidpointof2DBoundingBox();
		// Now we need to find the long axis angle and the length of a and b.
		int maxaindex=0;
		double asquared=0;
		double bsquared=Double.MAX_VALUE;
		for (int i=0;i<numberofsteps;i++){
	  	  		double distancesquared=newpoint[i].CalculateDistanceSquared(center);
				if (distancesquared<bsquared) bsquared=distancesquared;
				else if (distancesquared>asquared) {
					asquared=distancesquared;
					maxaindex=i;
				}
		} // end for i
		a=Math.sqrt(asquared);
		b=Math.sqrt(bsquared);
  		// Remember orientation angle can only be -90-90 degrees
		orientationangle=center.GetAngleMeasuredClockwiseFromPositiveX(newpoint[maxaindex]);
		if (orientationangle>(Math.PI*1.5)) orientationangle=0-((Math.PI*2)-orientationangle);
  		else if ((orientationangle<=(Math.PI) && (orientationangle>(Math.PI/2)))) orientationangle=0-(Math.PI-orientationangle);
  		else if ((orientationangle>(Math.PI))  && (orientationangle<=(Math.PI*1.5))) orientationangle=orientationangle-Math.PI;
		//orientationangle=orientationangle%Math.PI;
  		//if (orientationangle>(Math.PI/2)) orientationangle=orientationangle-Math.PI; 
  		
  		Calculatefocalpoints();
	} // end constructor
	
	
	// clone method
	public Ellipse clone(){
		return new Ellipse(center,a,b,orientationangle);
	}
	
	public Point2d GetCenter(){
		return center;
	}
	public void ResetCenter(Point2d newcenter){
		center=newcenter.clone();
		Calculatefocalpoints();
	}
	
	public double GetMajorSemiAxisLength(){
		return a;
	}
	public double GetMinorSemiAxisLength(){
		return b;
	}
	public double GetOrientationAngleinRadians(){
		return orientationangle;
	}
	public void OffsetCenter(Point2d offset){
		center.minus(offset);
	}
	
	// Returns angle (in radians) needed for the ellipse to be rotated to be seen as a circle 
	// This can be calculated from the ratio of major and minor axes.
	// If the plane of the ellipse is the x-y plane the angle is the angle of rotation around the z axis to turn the ellipse into a circle (0-90 degrees only).
	// Given the symmetrical nature of the ellipse this can be either positive or negative but by convention it only returns the positive value
	public double CalculateAngleOffsetFromVertical(){
		//double esquared=1-((b/a)*(b/a)); // get eccentricity
		//double alpha=Math.asin(Math.sqrt(esquared)); // from eccentricity get angle in radians
		// This gives the same result as the above due to relationship between sine and cosine functions. 
		return Math.acos(b/a);
	}
	public double GetEccentricitySquared(){
		return (((a*a)-(b*b))/(a*a));
	}
	public boolean PointInsideEllipse(Point2d point){
		// A point is inside the ellipse if the sum of the distances to the two focal points is less than 2a
		return (Math.sqrt(point.CalculateDistanceSquared(f1))+Math.sqrt(point.CalculateDistanceSquared(f2))<(2*a));
	}

	// Note that t is not the angle with the x axis, it is the eccentric anomaly
	public Point2d GetEllipseEdgePointParametric(double t){
		// The parametric equation for the edge of an ellipse is
	    // X=Xc + a*cos(t)*cos(orientationangle) - b*sin(t)*sin(orientationangle)
	    // Y=Yc + a*cos(t)*sin(orientationangle) + b*sin(t)*cos(orientationangle)
		// where Xc,Yc is the center of the ellipse, a and b are the semi-axes, and phi is the angle of the long axis with respect to the x axis
		double x=center.x+(a*Math.cos(t)*Math.cos(orientationangle))-(b*Math.sin(t)*Math.sin(orientationangle));
		double y=center.y+(a*Math.cos(t)*Math.sin(orientationangle))+(b*Math.sin(t)*Math.cos(orientationangle));
		return new Point2d(x,y);
	}
	// Note that theta is the angle measured from the major axis
	public Point2d GetEllipseEdgePointPolar(double theta){
		// In polar form, relative to the centre, r= ab/sqrt((b*cos(theta))^2+(a*sin(theta))^2)
		double r=(a*b)/Math.sqrt(Math.pow(b*Math.cos(theta),2)+Math.pow(a*Math.sin(theta),2));
		// Using the angle and radius we can find the point.
		return center.GetOtherPoint(theta,r);
	}
	
	
	public boolean Overlap(Ellipse e){
		boolean returnvalue;
		// First check if they are within range to overlap i.e. the distance between their centres is less than the sum of their major semi-axis lengths
		returnvalue=center.CalculateDistanceSquared(e.center)<=((a+e.a)*(a+e.a));
		if (returnvalue){
			// Find the closest point of one ellipse to the center of the other
			// 1. Find the angle between the two centers relative to each center and the x axis
			double anglefromthisellipse=center.GetAngleMeasuredClockwiseFromPositiveX(e.center);
			double angletothisellipse=e.center.GetAngleMeasuredClockwiseFromPositiveX(center);
			// 2. Use this to angle to calculate the point on the edge of the ellipse
			// The standard polar parameter theta is not the angle from x axis but the angle from the long axis so adjust before calculating the points
			Point2d pointonthisellipse=GetEllipseEdgePointPolar(anglefromthisellipse-orientationangle);
			Point2d pointonotherellipse=e.GetEllipseEdgePointPolar(angletothisellipse-e.orientationangle);
			// Test to see if these points are inside the other ellipse
			returnvalue=PointInsideEllipse(pointonotherellipse) || e.PointInsideEllipse(pointonthisellipse);
		}
		return returnvalue;
	}
	
	// brightnessdifferencethreshold is a value between 0 and 255. It describes the amount of difference needed before saying two brightness values are different.
	// Note that the actual value is not used, rather a percentage equivalent to the gap between the whitest and blackest pixels found such that it is the actual value if whitest and blackest are 255 and 0 respectively
	// e.g. if the brightnessdifferencethreshold=20 and the difference between white and black is 100 (out of a possible 255) then the actual threshold is 100*(20/255) or  7.8
	//public byte[][] IsBlackEllipseOnWhiteBackground(CalibratedImage image, int brightnessdifferencethreshold, double distancethreshold, byte[][] input){
	
	// The validity threshold is the minimum percentage of how many outside pixels should be white and inside pixels black.
	public boolean IsBlackEllipseOnWhiteBackground(Image image, int brightnessdifferencethreshold, double validitythreshold){
		boolean returnvalue=true;
		int white=0;
		int black=255;
		//Point2d whitestpixel=new Point2d(0,0);
		// Create a rectangle around the ellipse and get the whitest and blackest pixel values within this.
		AxisAlignedBoundingBox boundingrectangle=GetAxisAlignedBoundingRectangle();
		for (int x=(int)(boundingrectangle.minx-1);x<=(boundingrectangle.maxx+1);x++){
			for (int y=(int)(boundingrectangle.miny-1);y<=(boundingrectangle.maxy+1);y++){
				int value=(int)(image.InterpolatePixelBrightness(new Point2d(x,y)) & 0xff);
				if (value<black) black=value;
				if (value>white) white=value; //whitestpixel=new Point2d(x,y);}
			}
		}
		returnvalue=((white-black)>brightnessdifferencethreshold); //&& (!PointInsideEllipse(whitestpixel));
		if (returnvalue){
			double brightnessthreshold=(double)(white-black)*((double)brightnessdifferencethreshold/255);
			// Now go through and make sure those pixels outside the ellipse are white, those inside are black, and ignore those within a certain distance of the ellipse edge
			int totaloutside=0;
			int totalinside=0;
			int whiteoutside=0;
			int blackinside=0;
			for (int x=(int)(boundingrectangle.minx-1);x<=(boundingrectangle.maxx+1);x++){
				for (int y=(int)(boundingrectangle.miny-1);y<=(boundingrectangle.maxy+1);y++){
					Point2d point=new Point2d(x,y);
					int value=(int)(image.InterpolatePixelBrightness(point) & 0xff);
					if (PointInsideEllipse(point)){
						totalinside++;
						if ((value-black)<brightnessthreshold) blackinside++;
					}
					else {
						totaloutside++;
						if ((white-value)<brightnessthreshold) whiteoutside++;
					}
				}
			}
		
			double percentwhiteoutside=((double)(whiteoutside)/(double)(totaloutside))*100;
			double percentblackinside=((double)(blackinside)/(double)(totalinside))*100;
			returnvalue=(percentwhiteoutside>validitythreshold) || (percentblackinside>validitythreshold);
		}
		return returnvalue;
		
	}
	public AxisAlignedBoundingBox GetAxisAlignedBoundingRectangle(){
		AxisAlignedBoundingBox returnvalue=new AxisAlignedBoundingBox();
		// A bounding Box is a 3d object so for the 2d bounding rectangle we ignore the z values. 
		returnvalue.minz=0;
		returnvalue.maxz=0;
		// And set the x and y coordinates to the center
		returnvalue.minx=center.x;
		returnvalue.miny=center.y;
		returnvalue.maxx=center.x;
		returnvalue.maxy=center.y;
		
		//Now go around the ellipse and increase the bounding box if need be at each point
		for (int t=0;t<360;t++){
			double tradians=((double)t/(double)180)*Math.PI;
			Point2d edge=GetEllipseEdgePointParametric(tradians);
			returnvalue.Expand2DBoundingBox(edge);
		}
		return returnvalue;
	}
	
	public Point2d GetCentreOfGravity(Image image,int threshold){
		AxisAlignedBoundingBox boundingbox=GetAxisAlignedBoundingRectangle();
			int count=0;
			double COGx=0;
			double COGy=0;
			for (int x=(int)(boundingbox.minx-1);x<(boundingbox.maxx+1);x++){
				for (int y=(int)(boundingbox.miny-1);y<(boundingbox.maxy+1);y++){
					Point2d ellipsepoint=new Point2d(x,y);
					//if (PointInsideEllipse(ellipsepoint)){
						if (image.CompareBrightness(ellipsepoint,center,threshold)){
							COGx=COGx+(x-center.x);
							COGy=COGy+(y-center.y);
							count++;
						} // if black
					//} // if inside ellipse
				} // end for y
			} // end for x
			// return the centre of gravity
		return new Point2d((COGx/count)+center.x,(COGy/count)+center.y);
	}
	// Only called by constructors to pre-calculate the focal points
	private void Calculatefocalpoints(){
		// The focal points lie along the major axis and are distance c away from the center where c^2=a^2-b^2=ae (as e=eccentricity=sqrt((a^2-b^2)/a^2)) so c^2=a^2e^2
		double ae=Math.sqrt((a*a)-(b*b));
		// so we follow the y=mx+c line out from the center by +/- ae. This line can be constructed from the center point and orientationangle.
		// But the method to do so assumes the distance is positive so adjust the angle by 180 degrees to do the negative one.
		f1=center.GetOtherPoint(orientationangle,ae);
		f2=center.GetOtherPoint(orientationangle+Math.PI,ae);	
	}
	
}