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
 * Last modified by Reece Arnott 25thAugust 2010
 * 
 * 
 * This is used in the FeatureExtraction classes to keep track of
 * feature corner points, and the pixel coordinates pairs, weightings for barycentric coordinates
 * and colours at said points.
 * 
 * Also the ConvertPixelCoordinateToWorld3dCoordinatesOnImagePlane method is used in 3d edge extraction to form rays from camera centre through pixels in 3d world space
 * 
 ******************************************************************************/

	
	
	public class Coordinates
	{
		public Point2d pixel;
		public double barycoordinates [];
		public byte greyscale;
		public int weight;
		
		
		// Constructors
		public Coordinates(int numCorners)
		{
			pixel=new Point2d(0,0);
			barycoordinates=new double[numCorners];
			greyscale=(byte)0;
			weight=0;
		}
		public Coordinates(){
			pixel=new Point2d(0,0);
			barycoordinates=new double[1];
			greyscale=(byte)0;
			weight=0;
		   }
		
// end of constructors
		
		// Clone method
		public Coordinates clone(){
			Coordinates temp=new Coordinates();
			temp.pixel=new Point2d(pixel.x,pixel.y);
			temp.barycoordinates=barycoordinates.clone();
			temp.weight=weight;
			temp.greyscale=greyscale;
			return temp;
		}

		

		//Calculate the pixel coordinate described using an array of corner points and weightings for them.
		// Note that this won't work properly if the barycentric weightings don't add up to 1.
		public void CalculatePixelCoordinate(Point2d corners[]){
			Point2d newpixel=new Point2d(0,0);
			double total=0;
			for(int i=0;i<corners.length;i++) {		
				newpixel=corners[i].timesEquals(barycoordinates[i]).plusEquals(newpixel);
				total=total+barycoordinates[i];
			}
		// Shouldn't need this as the total should add up to one but do need it due to rounding errors
			pixel=newpixel.timesEquals(total);
			
		}

//		 It is assumed that there are two or three world to image point pairs given to this method and that the 2d point to convert is already stored in pixel
		public Point3d ConvertPixelCoordinateToWorld3dCoordinatesOnImagePlane(Point2d imagepoints[], Point3d worldpoints[]){
			Point3d returnpoint=new Point3d(0,0,0);
			boolean success=calculatebary(imagepoints);
			if (success){
				double total=0;
				for(int i=0;i<worldpoints.length;i++) {	
					returnpoint=returnpoint.plus(worldpoints[i].times(barycoordinates[i]));
					total=total+barycoordinates[i];
				}
			// Shouldn't need this as the total should add up to one but do need it due to rounding errors
				returnpoint=returnpoint.times(total);
			}
			return returnpoint;
		}
		
public boolean isOutside(){
	boolean returnvalue=false;
	for (int i=0;i<barycoordinates.length;i++) if (barycoordinates[i]<0) returnvalue=true;
	return returnvalue;
}
		
	//	 This has the code to either re-calculate the barycentric coordinates
	// or rotate each of the barycentric coordinates (comment out whichever one isn't used).
	// Currently not used. Note that it does nothing to the pixel values of the feature itself


	public void RotateBaryCoordinates()
	{
		double[] temp=new double[barycoordinates.length];
		temp=barycoordinates.clone();
		for (int i=0;i<temp.length;i++) barycoordinates[(i+1)%(temp.length)]=temp[i];
	}// end RotateBaryCoordinates method
	

	
	
		
// This general method can be used with 3 points or with 2 points if the pixel we're looking at is collinear with them.
// But it it cannot scale to more than 3 points.
		public boolean calculatebary(Point2d cornerarray[]){
			// Can we handle this? If not pass it along to the Meyer method and assume the point to be calculated is inside the polygon (but the corners need to be recalculated
			boolean success=true;
			 
			if ((cornerarray.length==2) && pixel.isCollinear(cornerarray[0], cornerarray[1])){  // Do the calculations for 2 points if they are colliner
				barycoordinates=new double[2];
				barycoordinates[1]=(pixel.minusEquals(cornerarray[0]).x+pixel.minusEquals(cornerarray[0]).y)/(cornerarray[1].minusEquals(cornerarray[0]).x+(cornerarray[1].minusEquals(cornerarray[0]).y));
				barycoordinates[0]=1-barycoordinates[1];	
			}
			else if (cornerarray.length==3){
				double x=pixel.x;
				double y=pixel.y;
				int a=0;
				int b=1;
				int c=2;
				// zero out the barymetric coordinates
				barycoordinates=new double[cornerarray.length];
				for (int i=0;i<cornerarray.length;i++) barycoordinates[i]=0.f;
				// The following was taken and adjusted from http://www.blackpawn.com/texts/pointinpoly/default.html
			
				// Compute vectors        
				Point2d ca = cornerarray[c].minusEquals(cornerarray[a]); // C-A
				Point2d ba = cornerarray[b].minusEquals(cornerarray[a]); // B-A
				Point2d pa = new Point2d(x,y).minusEquals(cornerarray[a]); // P-A where P is the point (x,y)
			
				// Compute dot products
				double dotcaca = ca.dot(ca);
				double dotcaba = ca.dot(ba);
				double dotcapa = ca.dot(pa);
				double dotbaba = ba.dot(ba);
				double dotbapa = ba.dot(pa); 

				// Compute barycentric coordinates
				double invDenom = 1 / (dotcaca * dotbaba - dotcaba * dotcaba); // multiply by this below. 
				barycoordinates[c] = (dotbaba * dotcapa - dotcaba * dotbapa) * invDenom;
				barycoordinates[b] = (dotcaca * dotbapa - dotcaba * dotcapa) * invDenom;
				barycoordinates[a]=1-barycoordinates[b]-barycoordinates[c];		
			} // end else if
			else success=false;
			return success;			
		} // end of calculatebary method

		
	
	
	} // End of coordinates class
	
