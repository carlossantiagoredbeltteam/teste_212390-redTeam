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
 * Last modified by Reece Arnott 22nd April 2010
 * 
 * This 4 state cell map is designed to find the calibration sheet using a series of flood fills and comparisions of expected brightness value if the pixel is part of the calibration sheet compared to actual where each cell corresponds to a pixel in a specific image
 * The initial state of each cell is unknown unless it is part of the edgemap passed to the constructor
 * 
 * This continues until no changes occur at which point you have the calibrationsheet state representing all of the calibration sheet directly connected to the initial blobs. 
 * Now the 4 state CA can be converted to a boolean array identifying the calibration sheet as true and the other states as false. 
 * This boolean array is to be used in the 3d object recognition calculations to test whether a 3d point is inside or outside the object 
 * i.e. if it backprojects to an image that registers that pixel as part of the calibration sheet then it is obviously outside the object.
 * 
 * Note that the segmentation is conservative in that if it says something is part of the calibration sheet it is, but if it says it isn't it may still in fact be part of the calibration sheet.
 * 
 * Note that some formulae that traditionally use pi have been replaced to use tau where tau is defined as 2*pi. For an explanation of why this may make things clearer see That Tau Manifesto available at http://tauday.com/
 *******************************************************************************/  


import org.reprap.scanning.DataStructures.Image;
import org.reprap.scanning.GUI.GraphicsFeedback;
import org.reprap.scanning.Geometry.*;

import javax.swing.JProgressBar;

// Just to tidy things up
class PointBrightnessArray{
	Point2d[] points;
	double[] values;
	
	public PointBrightnessArray(int n){
		points=new Point2d[n];
		values=new double[n];
	}
	public PointBrightnessArray clone(){
		PointBrightnessArray returnvalue=new PointBrightnessArray(points.length);
		for (int i=0;i<points.length;i++){
			returnvalue.points[i]=points[i].clone();
			returnvalue.values[i]=values[i];
		}
		return returnvalue;
	}
}

public class ImageSegmentation {
	private final static double tau=Math.PI*2;
	private enum states {unknown, calibrationsheet, edge, other};
	private states[][] currentstate;
	private states[][] nextstate;
	public static int width; // Set in constructor, imported from edge map
	public static int height; //Set in constructor, imported from edge map
	public static int threshold; // Set in constructor, imported from edge map
	private JProgressBar progressbar;
	private PointBrightnessArray knowncalibrationsheetpointbrightnessvalues;
	private double edgeresolutionthreshold;
		// Constructors
	public ImageSegmentation(EdgeExtraction2D edges,Point2d[] calibrationsheetcorners){
	width=edges.GetWidth();
	height=edges.GetHeight();
	threshold=edges.GetThreshold();
	progressbar=new JProgressBar(0,1);
	progressbar.setValue(0);
	knowncalibrationsheetpointbrightnessvalues=new PointBrightnessArray(0);
	currentstate=new states[width][height];
	nextstate=new states[width][height];
	edgeresolutionthreshold=edges.GetResolution();
	double resolutiondistancesquared=edgeresolutionthreshold*edgeresolutionthreshold;
	byte[][] map=edges.GetStrengthMap();
	
	// put the corners into two groups of 3. Note that this assumes there are 4 corners and they are in order so that the pairs 0,2 and 1,3 are diagonals
	Point2d[] calibrationsheettriangle1=new Point2d[3];
	Point2d[] calibrationsheettriangle2=new Point2d[3];
	calibrationsheettriangle1[0]=calibrationsheetcorners[0].clone();
	calibrationsheettriangle2[0]=calibrationsheetcorners[0].clone();
	calibrationsheettriangle1[1]=calibrationsheetcorners[1].clone();
	calibrationsheettriangle2[1]=calibrationsheetcorners[2].clone();
	calibrationsheettriangle1[2]=calibrationsheetcorners[2].clone();
	calibrationsheettriangle2[2]=calibrationsheetcorners[3].clone();
	// Go through and set the state to be unknown if it is within the bounds of the calibration sheet, or other if it is outside
	for (int x=0;x<width;x++)
		for (int y=0;y<height;y++){
			// Check whether the pixel is within the calibration sheet based on two barycentric coordinate tests
			Coordinates pixel=new Coordinates();
			pixel.pixel=new Point2d(x,y);
			pixel.calculatebary(calibrationsheettriangle1);
			boolean out1=pixel.isOutside();
			pixel.calculatebary(calibrationsheettriangle2);
			if ((out1) && (pixel.isOutside())){
					currentstate[x][y]=states.valueOf("other");
					nextstate[x][y]=states.valueOf("other");
			}
			else
			{
				currentstate[x][y]=states.valueOf("unknown");
				nextstate[x][y]=states.valueOf("unknown");
			}
		}
	
	
	// Go through and set unknown to edge if is an edge within the resolution threshold
///*
	for (int x=0;x<width;x++)
		for (int y=0;y<height;y++)
			if ((map[x][y]!=(byte)0))
				for (int dx=(int)(-edgeresolutionthreshold-1);dx<(edgeresolutionthreshold+1);dx++)
					for (int dy=(int)(-edgeresolutionthreshold-1);dy<(edgeresolutionthreshold+1);dy++)
						if (((x+dx)>0) && ((x+dx)<width) && ((y+dy)>0) && ((y+dy)<height))
							if (currentstate[x+dx][y+dy]==states.valueOf("unknown")) 
								if (((dx*dx)+(dy*dy))<resolutiondistancesquared) 
								{
									currentstate[x+dx][y+dy]=states.valueOf("edge");
									nextstate[x+dx][y+dy]=states.valueOf("edge");
								} // end if
	//*/		
} // end constructor

	public ImageSegmentation(int w,int h, int t){
		width=w;
		height=h;
		threshold=t;
		currentstate=new states[w][h];
		nextstate=new states[w][h];
		progressbar=new JProgressBar(0,1);
		progressbar.setValue(0);
		knowncalibrationsheetpointbrightnessvalues=new PointBrightnessArray(0);
		edgeresolutionthreshold=1;
	}
	
public ImageSegmentation clone(){
	ImageSegmentation returnvalue=new ImageSegmentation(width,height,threshold);
	for (int x=0;x<width;x++) for (int y=0;y<height;y++){
		returnvalue.currentstate[x][y]=currentstate[x][y];
		returnvalue.nextstate[x][y]=nextstate[x][y];
	}
	returnvalue.progressbar=new JProgressBar(progressbar.getMinimum(),progressbar.getMaximum());
	returnvalue.progressbar.setValue(progressbar.getValue());
	returnvalue.knowncalibrationsheetpointbrightnessvalues=knowncalibrationsheetpointbrightnessvalues;
	returnvalue.edgeresolutionthreshold=edgeresolutionthreshold;
	return returnvalue;
}

	
	public boolean[][] GetCalibrationSheet(){
		return GetBoolean(states.valueOf("calibrationsheet"));
	}
	public boolean[][] GetUnknown(){
		return GetBoolean(states.valueOf("unknown"));
	}
	public boolean[][] GetEdges(){
		return GetBoolean(states.valueOf("edge"));
	}
	public boolean[][] GetOther(){
		return GetBoolean(states.valueOf("other"));
	}
	public boolean IsCalibrationSheet(int x,int y){
		return GetBoolean(x,y,states.valueOf("calibrationsheet"));
	}
	public boolean IsUnknown(int x,int y){
		return GetBoolean(x,y,states.valueOf("unknown"));
	}
	public boolean IsEdge(int x,int y){
		return GetBoolean(x,y,states.valueOf("edge"));
	}
	public boolean IsOther(int x,int y){
		return GetBoolean(x,y,states.valueOf("other"));
	}
	
	// This should be called from within a while loop
	public JProgressBar Segment(Ellipse[] ellipses,Image image){
		if(progressbar.getValue()==progressbar.getMinimum()){
			progressbar=new JProgressBar(0,3); // Divide the progress bar into a small number of steps, one of which is to completed each time this method is called
		}
		if (progressbar.getValue()!=progressbar.getMaximum()) {
			progressbar.setValue(progressbar.getValue()+1);
			// Case Statement for progress bar
			switch (progressbar.getValue()){
			case 1:
				SetEllipsesToCalibrationSheet(ellipses);// Go through the bounding rectangle and set any pixels inside the ellipses to be calibration sheet
				// TODO expand the ellipse by the edgeresolutionthreshold?
				// Now fill the attached edge points to also be part of the calibration sheet
				SweepFill(states.valueOf("edge"),states.valueOf("calibrationsheet"));
				// Note that if there is an overlap with the edges of the object we want to fill as few of them as we need to so we don't do a flood fill, just one iteration of a sweep fill
				//TODO fix this so we don't have to deal with this
				break;
			case 2:
				SetCalibrationSheetWeightedAverageWhitePixelsForEllipseCenters(ellipses, image);
				SetKnownNonCalibrationSheetByGreyscaleValue(image);
				break;
			case 3:
				FinalFloodFill();
				break;
			}
			NextTimeStep();
		}
		return progressbar;
	} // end of method
	
	// TODO delete when not needed for testing/debugging
	public void Display(String filename){
		int tempindex,index;
		int numcolours=3;
		byte[] GLimage=new byte[(height+1)*(width+1)*numcolours];
		// 	Read pixels in a row at a time taking care to flip the image at the same time
		for (int y=0; y < height; y++)
		{
				tempindex=(height-y-1)*width*numcolours;
			// if the y coordinate is already stored internally as inverted then don't worry about flipping it for display
			for (int x=0;x<width;x++){
				index=tempindex+(x*numcolours);
				for (int colours=0;colours<numcolours;colours++){
					if (currentstate[x][y]==states.valueOf("calibrationsheet")) GLimage[index+colours]=(byte)255; // white for the calibration sheet
					else if (currentstate[x][y]==states.valueOf("other")) GLimage[index+colours]=(byte)0; // black for other
					else if (currentstate[x][y]==states.valueOf("edge")) GLimage[index+colours]=(byte)192; // lightgrey for edge 
					else GLimage[index+colours]=(byte)64; // dark grey for unknown
				} // end for colours
			} // end for x
		} // end for y
		GraphicsFeedback graphics=new GraphicsFeedback(false);
		graphics.ShowGLimage(GLimage,width,height);
		//graphics.initGraphics();
		if (filename!="") graphics.SaveImage(filename);
		  	
}
	
	/********************************************************************************************************************************************************************
	 * 
	 * Private methods from here on down
	 * 
	 *
	 ********************************************************************************************************************************************************************/
	
	
	private void SetEllipsesToCalibrationSheet(Ellipse[] ellipses){
		for (int i=0;i<ellipses.length;i++){
			// Go through the bounding rectangle and set any pixels inside the ellipse to be calibration sheet
			AxisAlignedBoundingBox boundingrectangle=ellipses[i].GetAxisAlignedBoundingRectangle();
			for (int x=(int)(boundingrectangle.minx-1);x<=(boundingrectangle.maxx+1);x++){
				for (int y=(int)(boundingrectangle.miny-1);y<=(boundingrectangle.maxy+1);y++){
					if ((x>=0) && (x<width) && (y>=0) && (y<height)){ 
						if (ellipses[i].PointInsideEllipse(new Point2d(x,y)))	nextstate[x][y]=states.valueOf("calibrationsheet");
					} // end if
				} // end for y
			} // end for x
		} // end for i
	} // end of method
	
	private void SetCalibrationSheetWeightedAverageWhitePixelsForEllipseCenters(Ellipse[] ellipses, Image image){
		knowncalibrationsheetpointbrightnessvalues=new PointBrightnessArray(ellipses.length);
		for (int i=0;i<ellipses.length;i++){
			knowncalibrationsheetpointbrightnessvalues.points[i]=ellipses[i].GetCenter().clone();
			// use the center of the ellipse as a starting point and work the way out in all four directions until finding a point that isn't calibration sheet
			// take the brightness values of these four points and get the weighted average and use this as the value for the ellipse center
			// It is assumed that the ellipse center is black and any values detected within the threshold of this black value are to be ignored
			int blackvalue=(int)(image.InterpolatePixelColour(ellipses[i].GetCenter(),false).getGreyscale() & 0xff);
			PointBrightnessArray cardinalpoints=new PointBrightnessArray(8);
			double maxdsquared=0;
			for (int j=0;j<8;j++){
				cardinalpoints.points[j]=ellipses[i].GetCenter().clone();
				while (currentstate[(int)cardinalpoints.points[j].x][(int)cardinalpoints.points[j].y]==states.valueOf("calibrationsheet")) {
					// This could probably be done with a couple of simple formulas using mod on j but I can't think of them at the moment
					switch (j) {
					case 0:
						cardinalpoints.points[j].x--;
			   			break;
					case 1:
						cardinalpoints.points[j].x++;
			   			break;
					case 2:
						cardinalpoints.points[j].y--;
			   			break;
					case 3:
						cardinalpoints.points[j].y++;
			   			break;
					case 4:
						cardinalpoints.points[j].x--;
						cardinalpoints.points[j].y--;
			   			break;
					case 5:
						cardinalpoints.points[j].x--;
						cardinalpoints.points[j].y++;
			   			break;
					case 6:
						cardinalpoints.points[j].x++;
						cardinalpoints.points[j].y--;
			   			break;
					case 7:
						cardinalpoints.points[j].x++;
						cardinalpoints.points[j].y++;
			   			break;
					}
				} // end while
				double dsquared=cardinalpoints.points[j].CalculateDistanceSquared(ellipses[i].GetCenter());
				if (dsquared>maxdsquared) maxdsquared=dsquared;
			} // end for j
			// Set the cardinal points to be the same max distance away from the center of the ellipse and interpolate the pixel brightness
			double maxdistance=Math.sqrt(maxdsquared);
			for (int j=0;j<8;j++){
				cardinalpoints.points[j]=ellipses[i].GetCenter().GetOtherPoint(j*(tau/8),maxdistance);
				cardinalpoints.values[j]=(int)(image.InterpolatePixelColour(cardinalpoints.points[j],false).getGreyscale() & 0xff);
				
			}
			// Strip out those values that are too close to the blackvalue i.e. actually part of the black spot on the white calibration sheet
			// First how many are there
			int count=0;
			for (int j=0;j<8;j++) if (Math.abs(cardinalpoints.values[j]-blackvalue)>threshold) count++;
			if (count==8) knowncalibrationsheetpointbrightnessvalues.values[i]=GetAverageGreyscaleValueWeightedByInverseDistanceSquared(ellipses[i].GetCenter(), cardinalpoints.points,cardinalpoints.values);
			else {
				// Strip out the ones we don't want and use the rest.
				Point2d[] points=new Point2d[count];
				double[] values=new double[count];
				count=0;
				for (int j=0;j<8;j++){
					if (Math.abs(cardinalpoints.values[j]-blackvalue)>threshold) {
						points[count]=cardinalpoints.points[j].clone();
						values[count]=cardinalpoints.values[j];
						count++;
					} // end if
				} // end for j
				knowncalibrationsheetpointbrightnessvalues.values[i]=GetAverageGreyscaleValueWeightedByInverseDistanceSquared(ellipses[i].GetCenter(), points,values);
			} // end else
		} // end for i
	} // end method
	
	private void SetKnownNonCalibrationSheetByGreyscaleValue(Image image){
		for (int x=0;x<width;x++){
			for (int y=0;y<height;y++){
				if (currentstate[x][y]==states.valueOf("unknown")){
					// Find the brightness value of this pixel and compare it to the expected, if it is out by more than the threshold, set this unknown cell to other
					Point2d point=new Point2d(x,y);
					int expectedvalue=GetAverageGreyscaleValueWeightedByInverseDistanceSquared(point,knowncalibrationsheetpointbrightnessvalues.points,knowncalibrationsheetpointbrightnessvalues.values);
					if (!image.InterpolatePixelColour(point,false).CompareGreyscale(expectedvalue,threshold)) nextstate[x][y]=states.valueOf("other");
				} // end if
			} // end for y
		} // end for x
	}
	private void FinalFloodFill(){
		boolean end=false;
		while (!end){
			end=SweepFill(states.valueOf("unknown"),states.valueOf("calibrationsheet"));
			NextTimeStep();
		}
	}
	
	private void NextTimeStep(){
		for (int x=0;x<width;x++)
			for (int y=0;y<height;y++)
				currentstate[x][y]=nextstate[x][y];
	}
	
	
private boolean SweepFill(states from, states to){
	// Note that this is a "sweep fill" and will need to go around a while loop potentially once for each zigzag change in direction in the object we are trying to fill if we want it to emulate a flood-fill
	// The while loop can be exited when this returns true
	// TODO replace with a proper floodfill eg Quickfill?
boolean returnvalue=true;
//		 First go forward and down, then back and up
		for (int direction=1;direction>=-1;direction=direction-2){
			int x;
			int y;
			if (direction==-1)x=width-1;
			else x=0;
			while ((x<width) && (x>=0)){
				if (direction==-1) y=height-1;
				else y=0;
				while ((y<height) && (y>=0)){
							if (currentstate[x][y]==from){
								boolean set=false;
								// 	The cell becomes the to state in the next state if it has a nieghbouring cell in that state 
								for (int dx=-1;dx<=1;dx++){
									for (int dy=-1;dy<=1;dy++){
										// Is the neighbouring cell we're about to test a valid one?
										if (((x+dx)<width) && ((y+dy)<height) && ((x+dx)>=0) && ((y+dy)>=0) && !((dx==0) && (dy==0)))
											// If the neighbouring cell is the correct state set this one to be the same
											if (!set) set=(nextstate[x+dx][y+dy]==to);
									} // for dy
								} // end for dx
								// Now that we've done all the processing, set the state in the next time step
								if (set) {
									nextstate[x][y]=to;
									returnvalue=false;
								}
								else nextstate[x][y]=from; 
							} // end if currentstate is the from state
			y=y+direction;
			} // while y
				x=x+direction;
				
		} // end while x
		} // end for direction
		return returnvalue;
}

	// This takes as input an array of points and values for these points plus a target point and produces an expected value for the target point
	// by taking the weighted average of the values using the inverse of the distance squared to the target point to weight them.
	private int GetAverageGreyscaleValueWeightedByInverseDistanceSquared(Point2d target, Point2d[] points, double[] values){
		double oneoverdsquaredsum=0;
		double weightedsum=0;
		for (int i=0;i<points.length;i++){
			double oneoverdsquared=(1/target.CalculateDistanceSquared(points[i]));
			oneoverdsquaredsum=oneoverdsquaredsum+oneoverdsquared;
			weightedsum=weightedsum+(values[i]*oneoverdsquared);
		}
		return (int)(weightedsum/oneoverdsquaredsum);
	}
	
	private boolean[][] GetBoolean(states teststate){
		boolean[][] bool=new boolean[width][height];
		for (int x=0;x<width;x++)
			for (int y=0;y<height;y++)
				bool[x][y]=(currentstate[x][y]==teststate);
		return bool;
	} // end GetBoolean method 
	
	private boolean GetBoolean(int x, int y, states teststate){
		boolean returnvalue=false;
		if ((x>=0) && (x<width) && (y>=0) && (y<height)) returnvalue=(currentstate[x][y]==teststate);
		return returnvalue;
	}
	
} // end class
