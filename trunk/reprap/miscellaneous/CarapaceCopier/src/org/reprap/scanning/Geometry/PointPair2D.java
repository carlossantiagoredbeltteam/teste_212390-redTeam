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
 * Last modified by Reece Arnott 9th Feburary 2010
 *
 *
 ******************************************************************************/
 package org.reprap.scanning.Geometry;

import org.reprap.scanning.DataStructures.QuickSortByDistanceTo2DPoints;

public class PointPair2D {
	public Point2d pointone; 
	public Point2d pointtwo;
	//constructor
	public PointPair2D(){
		pointone=new Point2d(0,0);
		pointtwo=new Point2d(0,0);
	} // end constructor
	
	
	public PointPair2D clone(){
		PointPair2D temp=new PointPair2D();
		temp.pointone=pointone.clone();
		temp.pointtwo=pointtwo.clone();
		return temp;
	}
	// This estimates the second point of a point pair based on barycentric coordinate translation using of a complete array of pointpairs
	public boolean EstimateSecondPoint(PointPair2D[] pointpairs){
		return EstimateSecondPoint(pointpairs,pointpairs.length);
	}
	
	
	// This estimates the second point of a point pair based on barycentric coordinate translation using of an incomplete array of pointpairs
	public boolean EstimateSecondPoint(PointPair2D[] pointpairs, int length){
		boolean collinear=true;
		boolean returnvalue=true;
		//Sort the known points based on their distance to the first point so we can choose the closest to get the most accurate local barycentric translation
		PointPair2D[] points=new PointPair2D[length];
		QuickSortByDistanceTo2DPoints qsort=new QuickSortByDistanceTo2DPoints(pointpairs,length,true);
		int[] indexes=qsort.Sort(pointone);
		// If there is an exact match 
		if (pointpairs[indexes[0]].pointone.isEqual(pointone)) pointtwo=pointpairs[indexes[0]].pointtwo.clone();
		else {
		// reorder the points based on the quicksort	
		for (int x=0;x<indexes.length;x++) points[x]=pointpairs[indexes[x]].clone();
		while (collinear && (points.length>=3)){
			
			// Test for collinearity between this point and pairs of the first 3 points
			// If this is the case, just use those two points and exit the while loop (as length will now be 2)
			if (pointone.isCollinear(points[0].pointone,points[2].pointone)){
				PointPair2D[] temp=new PointPair2D[2];
				temp[0]=points[0].clone();
				temp[1]=points[2].clone();
				points=temp.clone();
			}
			else if (pointone.isCollinear(points[1].pointone,points[2].pointone)){
				PointPair2D[] temp=new PointPair2D[2];
				temp[0]=points[1].clone();
				temp[1]=points[2].clone();
				points=temp.clone();
			}
			else {
			//Test for collinearity between the first 3 points
			collinear=points[0].pointone.isCollinear(points[1].pointone,points[2].pointone);
			if (collinear) { //take the 3rd point out and shuffle the array down one if they are collinear
				PointPair2D[] temp=new PointPair2D[points.length-1];
				temp[0]=points[0].clone();
				temp[1]=points[1].clone();
				for (int j=3;j<points.length;j++) temp[j-1]=points[j].clone();
				points=temp.clone();
			} // end if collinear
			} // end else
		} // end while collinear and length >=3
		if (points.length>=3){ 
			// There are at least 3 points and the first 3 have been tested not to be collinear, so we can use barycentric coordinates to estimate the point
			// Taking into account the scaling factors
				Coordinates temp=new Coordinates(3);
				temp.pixel=pointone.clone();
				Point2d[] corners=new Point2d[3];
				for (int j=0;j<3;j++) {
					corners[j]=points[j].pointone.clone();
				}
				temp.calculatebary(corners);
				// Now replace the corners with the other point of the pair.
				// Note that as there are only 3 corners we will use the standard barycentric coordinate method so we don't need to order the corners
				// and we can find a point outside of the trangle they make.
				for (int j=0;j<3;j++) {
					corners[j]=points[j].pointtwo.clone();
				}
				temp.CalculatePixelCoordinate(corners);
				pointtwo=temp.pixel.clone();
		} // end if indexes.length>=3
			else if ((points.length==2) && (pointone.isCollinear(points[0].pointone,points[1].pointone))){
			// There are only 2 known points. We can estimate the point in the case where it is collinear with these two points (in which case we can use barycentric coordinates again)
					Coordinates temp=new Coordinates(2);
					temp.pixel=pointone.clone();
					Point2d[] corners=new Point2d[2];
					for (int j=0;j<2;j++) corners[j]=points[j].pointone.clone();
					temp.calculatebary(corners);
					for (int j=0;j<2;j++) {
						corners[j]=points[j].pointtwo.clone();
					}
					temp.CalculatePixelCoordinate(corners);
					pointtwo=temp.pixel.clone();
			} // end else if
			else { // we can't easily estimate the point
				returnvalue=false;
			}
		}
		return returnvalue;
		} // end method
	
	
}
