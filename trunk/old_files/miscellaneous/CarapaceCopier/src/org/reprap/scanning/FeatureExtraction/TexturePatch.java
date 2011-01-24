package org.reprap.scanning.FeatureExtraction;
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
* Last modified by Reece Arnott 24th January 2011
*
*  TODO - should the pixel colours be stored as int and converted when needed?
*  		
* 	
* This samples a triangular patch using barycentric coordinates of the points on the plane made by the vertices to give 3d points that are back projected to 2d points in the image
* These can be displayed to show the samples filling the upper left triangle of a square grid.
* 
* Note that if you were to just backproject the vertices to the image and use a naive barycentric coordinate sampling based entirely in the image space  
* then comparing similarly sampled texture patches from different images may give differing results for the same patch as the barycentric coordinate transform is not the same as a perspective transform, it is just quite close to it.
* 
*  Doing the barycentric coordinate transform in 3d world coordinates and then doing a perspective transform on these points preserves the perspective transform and the barycentric coordinates are just used to get a good coverage of samples.
*
****************************************************************************************************************************/
import org.reprap.scanning.DataStructures.*;
import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.GUI.GraphicsFeedback;
public class TexturePatch {

	private PixelColour[] sampledtexturecolours; // Note that this is really a set of points in a 2d grid so could be a 2d array but as they form a triangle then half the array would be blank. Instead there is a private method to transform 2d coordinates into the array index 
	private int squarewidth; // Set by constructor
	
	// Constructors
	public TexturePatch(Image image, Point3d a, Point3d b, Point3d c, int squaresize){
		// Set up the sampled texture colours array and initialise to blank. Note that the number of sample points will be a little over 1/2 the square of the length of the 2d grid. i.e. 1+2+3+...+n or (n*(n+1))/2
		squarewidth=squaresize;
		Point3d[] samplepoints=Get3dSamplePoints(a,b,c,squarewidth);
		sampledtexturecolours=new PixelColour[samplepoints.length];
		for (int i=0;i<sampledtexturecolours.length;i++) sampledtexturecolours[i]=image.InterpolatePixelColour(image.getWorldtoImageTransform(samplepoints[i].ConvertPointTo4x1Matrix()));

	}
	public TexturePatch(int approxnumberofsamples, Image image, Point3d a, Point3d b, Point3d c){
		// Set up the sampled texture colours array and initialise to blank. Note that the number of sample points will be a little over 1/2 the square of the length of the 2d grid. i.e. 1+2+3+...+n or (n*(n+1))/2
		// using the quadratic formula we can work out n as we can rearrange n(n+1)/2=s to be
		// n^2+n-2s=0
		// so n=-1+/- sqrt(1+8s))/2, as we are only interested in the positive root and need to round to the nearest integer, this gives us
		squarewidth=(int)Math.round((Math.sqrt(1+(approxnumberofsamples*8))-1)*0.5);
		// Note that due to needing this to be a whole number the requested number of samples may not be quite what we end up with.
		Point3d[] samplepoints=Get3dSamplePoints(a,b,c,squarewidth);
		sampledtexturecolours=new PixelColour[samplepoints.length];
		for (int i=0;i<sampledtexturecolours.length;i++) sampledtexturecolours[i]=image.InterpolatePixelColour(image.getWorldtoImageTransform(samplepoints[i].ConvertPointTo4x1Matrix()));
	}
	public TexturePatch(){squarewidth=0;sampledtexturecolours=new PixelColour[0];}

	// Clone method
	public TexturePatch clone(){
		TexturePatch returnvalue=new TexturePatch();
		returnvalue.squarewidth=squarewidth;
		returnvalue.sampledtexturecolours=new PixelColour[sampledtexturecolours.length];
		for (int i=0;i<sampledtexturecolours.length;i++) returnvalue.sampledtexturecolours[i]=sampledtexturecolours[i].clone();
		return returnvalue;
	}
	
	public int GetSquareGridSize(){return squarewidth;}
	
	// For display purposes the samples will be in the upper half triangle of the square with the lower half being black
	public PixelColour[][] ConvertTextureToSquareArrayOfColoursForDisplay(){
		return ConvertTextureToSquareArrayOfColoursForDisplay(sampledtexturecolours,squarewidth);
	}
	
	public static double FindSimilarityMeasure(Image[] images, Point3d a, Point3d b, Point3d c, int squaresize, Point3d pointabovetriangleplane){
		double variancesum=0;
		// First filter out those images that do not have a camera centre above the plane defined by the triangle
		boolean[] skip=new boolean[images.length];
		int count=0;
		Plane plane=new Plane(a,b,c);
		for (int i=0;i<images.length;i++){
			Point3d C=new Point3d(MatrixManipulations.GetRightNullSpace(images[i].getWorldtoImageTransformMatrix()));
			skip[i]=plane.GetHalfspace(pointabovetriangleplane)!=plane.GetHalfspace(C);
			if (!skip[i]) count++;
			}
		if (count>1) {
			TexturePatch[] patch=new TexturePatch[count];
			count=0;
			// First get the 3d sample points
			Point3d[] samplepoints=Get3dSamplePoints(a,b,c,squaresize);
			// Now, for each image that we are not skipping use these sample points to create a patch
			for (int i=0;i<images.length;i++) if (!skip[i]){
				patch[count]=new TexturePatch();
				patch[count].squarewidth=squaresize;
				patch[count].sampledtexturecolours=new PixelColour[samplepoints.length];
				for (int j=0;j<patch[count].sampledtexturecolours.length;j++) patch[count].sampledtexturecolours[j]=images[i].InterpolatePixelColour(images[i].getWorldtoImageTransform(samplepoints[j].ConvertPointTo4x1Matrix()));
				count++;
				} // end for/if !skip
			// Now do a point similarity measure for each one and set the colour for the display patch
			for (int index=0;index<patch[0].sampledtexturecolours.length;index++){
				PixelColour[] colours=new PixelColour[patch.length];
				for (int i=0;i<patch.length;i++) colours[i]=patch[i].sampledtexturecolours[index].clone();
				double[] variance=new PixelColour().SetPixelToMeanColourAndReturnVariance(colours); // This gives variance for R,G,B, greyscale, and RGB in length 5 array
				variancesum=variancesum+variance[4];
			} // end for
		return variancesum/samplepoints.length;
		} // end if count>1
		else return Double.MAX_VALUE;
	}
	
	public static double SaveSimilarityPatch(Image[] images, Point3d a, Point3d b, Point3d c, int squaresize, Point3d pointabovetriangleplane, String displayfilename, double temppointsimilaritythreshold){
		// First filter out those images that do not have a camera centre above the plane defined by the triangle
		double variancesum=0;
		boolean[] skip=new boolean[images.length];
		int count=0;
		Plane plane=new Plane(a,b,c);
		for (int i=0;i<images.length;i++){
			Point3d C=new Point3d(MatrixManipulations.GetRightNullSpace(images[i].getWorldtoImageTransformMatrix()));
			skip[i]=plane.GetHalfspace(pointabovetriangleplane)!=plane.GetHalfspace(C);
			if (!skip[i]) count++;
			}
		if (count>1) {
			TexturePatch[] patch=new TexturePatch[count];
			count=0;
			// First get the 3d sample points
			Point3d[] samplepoints=Get3dSamplePoints(a,b,c,squaresize);
			// Now, for each image that we are not skipping use these sample points to create a patch
			for (int i=0;i<images.length;i++) if (!skip[i]){
				System.out.print(".");
				patch[count]=new TexturePatch();
				patch[count].squarewidth=squaresize;
				patch[count].sampledtexturecolours=new PixelColour[samplepoints.length];
				for (int j=0;j<patch[count].sampledtexturecolours.length;j++) patch[count].sampledtexturecolours[j]=images[i].InterpolatePixelColour(images[i].getWorldtoImageTransform(samplepoints[j].ConvertPointTo4x1Matrix()));
				count++;
				} // end for/if !skip
			System.out.println();
			// For display purposes create a pixel colour of the same size as the sampled patches
			PixelColour[] display=new PixelColour[patch[0].sampledtexturecolours.length];
			// Now do a point similarity measure for each one and set the colour for the display patch
			for (int index=0;index<display.length;index++){
				PixelColour[] colours=new PixelColour[patch.length];
				for (int i=0;i<patch.length;i++) colours[i]=patch[i].sampledtexturecolours[index].clone();
				PixelColour newcolour=new PixelColour();
				double[] variance=newcolour.SetPixelToMeanColourAndReturnVariance(colours); // This gives variance for R,G,B, greyscale, and RGB in length 5 array
				// 	if similar enough store the colour but currently not used for anything but displaying debug images
				if (variance[4]<temppointsimilaritythreshold)  display[index]=newcolour.clone();
				else display[index]=new PixelColour(PixelColour.StandardColours.Red);
				variancesum=variancesum+variance[4];
				
			} // end for
		
		// Now save the display image if filename is not null
		if (displayfilename!=null){
			GraphicsFeedback graphics=new GraphicsFeedback(true);
			graphics.ShowPixelColourArray(ConvertTextureToSquareArrayOfColoursForDisplay(display, squaresize), squaresize,squaresize);
			graphics.SaveImage(displayfilename);
		}
		return variancesum/samplepoints.length;
		} // end if count>1
		else return Double.MAX_VALUE;
	}
	
	/************************************************************************************************************************************************
	 * 
	 * Private methods from here on down
	 * 
	 ************************************************************************************************************************************************/
	

	private static Point3d[] Get3dSamplePoints(Point3d a, Point3d b, Point3d c, int squarewidth){
		Point3d[] returnvalue=new Point3d[(int)(squarewidth*(squarewidth+1)*0.5)];
		//		 Convert the 3d points to 2d parametric points on the plane they make
		Plane plane=new Plane(a,b,c);
		Point3d up=b.minus(a);
		Point2d[] triangularvertices;
		triangularvertices=new Point2d[3];
		triangularvertices[0]=plane.GetParametricCoordinatesFromPointOnPlane(up, a);
		triangularvertices[1]=plane.GetParametricCoordinatesFromPointOnPlane(up, b);
		triangularvertices[2]=plane.GetParametricCoordinatesFromPointOnPlane(up, c);
		
		Coordinates uvpoint=new Coordinates(3);
		
		// Collect the samples
		for (int y=0;y<squarewidth;y++){
			for (int x=0;x<(squarewidth-y);x++){
			  // calculate the barycentric coordinates for this point
				// The order of these doesn't matter as long as it is consistent so make it so that when displaying the 2d grid point 0 is upper left, point 1 is upper right, point 2 is lower left (increasing the x or y barycentric coordinates give a point closer to b or c respectively)
				// This just makes it relatively easy to test by simply giving a triangle with similar orientation. There is no inherent reason for choosing one orientation over another though.  
				uvpoint.barycoordinates[1]=(double)x/(double)squarewidth;
				uvpoint.barycoordinates[2]=(double)y/(double)squarewidth;
				uvpoint.barycoordinates[0]=1-uvpoint.barycoordinates[1]-uvpoint.barycoordinates[2];
				// Now convert this point back to a 3d point and insert it into the array
				uvpoint.CalculatePixelCoordinate(triangularvertices);
				returnvalue[ConvertToArrayCoordinates(x,y,squarewidth)]=plane.GetPointOnPlaneFromParametricCoordinates(up, uvpoint.pixel);;
				// Note that the ConvertToArrayCoordinates currently does the same as incrementing index would do within this loop but the calculation is farmed out so
				// can change the calculation if need be and still have set and get calls going to the same index within the 1d array.
			} // end for x
		} // end for y
		return returnvalue;
	}
	
	private static PixelColour[][] ConvertTextureToSquareArrayOfColoursForDisplay(PixelColour[] texturecolours,int width){
		PixelColour[][] returnvalue=new PixelColour[width][width];
		for (int x=0;x<width;x++)
			for (int y=0;y<width;y++)
				if ((width-x)>y) returnvalue[x][y]=texturecolours[ConvertToArrayCoordinates(x,y,width)].clone();
				else returnvalue[x][y]=new PixelColour();
		return returnvalue;
	}
	
	
	
	
	
	private static int ConvertToArrayCoordinates(int x, int y, int maxx){
		// Note this doesn't take into account if (x,y) is outside the upper (left) triangle of the 2d grid. Checks for this need to be made before calling this 
		if (y==0) return x;
		else return ((y*maxx)-(int)Math.round((y*(y-1)*0.5))+x); 	
	}
	
}
