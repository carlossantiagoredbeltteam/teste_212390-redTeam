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
 * Last modified by Reece Arnott 17th December 2010
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
import java.io.File;

import org.reprap.scanning.Calibration.CalibrateImage;
import org.reprap.scanning.FeatureExtraction.PointPairMatch;
import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.DataStructures.*;
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
	public Testing(){
		}
	
	public void TemporaryTestMethod(){
		Point2d[] points=new Point2d[11];
		points[0]=new Point2d(34.97812500000012,-2.723437499999962);
		points[1]=new Point2d(34.67812500000012,-2.723437499999962);
		points[2]=new Point2d(34.378125000000125,-2.723437499999962);
		points[3]=new Point2d(34.67812500000012,-2.423437499999962);
		points[4]=new Point2d(30.77812500000014,-2.1234374999999623);
		points[5]=new Point2d(23.578125000000124,0.5765625000000378);
		points[6]=new Point2d(23.278125000000124,0.5765625000000378);
		points[7]=new Point2d(23.278125000000124,0.8765625000000379);
		points[8]=new Point2d(23.278125000000124,1.176562500000038);
		points[9]=new Point2d(22.37812500000012,3.576562500000037);
		points[10]=new Point2d(21.47812500000012,3.8765625000000368);
		BoundingPolygon2D poly=new BoundingPolygon2D(points);
		
		int size=1000;
		PixelColour[][] colour=new PixelColour[size][size];
		for (int i=0;i<size;i++)
			for (int j=0;j<size;j++)
				colour[i][j]=new PixelColour(PixelColour.StandardColours.White);
		GraphicsFeedback graphics=new GraphicsFeedback(true);
		graphics.ShowPixelColourArray(colour,size,size);
		BoundingPolygon2D polygon=poly.clone();
		// Need to reset the origin and re-scale this before displaying it
		polygon.ResetOrigin(new Point2d(20,-5));
		polygon.scale(50);
		Point2d[] point=polygon.GetAllPointsWithinPolygon();
		LineSegment2D[] lines=polygon.Get2DLineSegments();
		AxisAlignedBoundingBox aabb=polygon.GetAxisAlignedBoundingBox();
		for (int j=0;j<point.length;j++) 
			graphics.PrintPoint(point[j].x,point[j].y,new PixelColour(PixelColour.StandardColours.Red));
		Point2d[] temp=polygon.GetOrderedVertices();
		graphics.PrintPoint(temp[0].x,temp[0].y,new PixelColour(PixelColour.StandardColours.Green));
		graphics.OutlinePolygon(polygon,new PixelColour(PixelColour.StandardColours.Blue),0,0);
		if (lines.length>0) graphics.PrintLineSegment(lines[0],new PixelColour(PixelColour.StandardColours.Green));
		
		graphics.PrintPoint(aabb.minx-1,aabb.miny-1,new PixelColour(PixelColour.StandardColours.Green));
		
		graphics.PrintLineSegment(new LineSegment2D(new Point2d(aabb.minx,aabb.miny),new Point2d(aabb.minx,aabb.maxy)),new PixelColour(PixelColour.StandardColours.Purple));
		graphics.PrintLineSegment(new LineSegment2D(new Point2d(aabb.maxx,aabb.miny),new Point2d(aabb.maxx,aabb.maxy)),new PixelColour(PixelColour.StandardColours.Purple));
		graphics.PrintLineSegment(new LineSegment2D(new Point2d(aabb.minx,aabb.miny),new Point2d(aabb.maxx,aabb.miny)),new PixelColour(PixelColour.StandardColours.Purple));
		graphics.PrintLineSegment(new LineSegment2D(new Point2d(aabb.minx,aabb.maxy),new Point2d(aabb.maxx,aabb.maxy)),new PixelColour(PixelColour.StandardColours.Purple));
		
		String filename="/home/cshome/r/rarnott/Desktop/images/test.jpg";
		graphics.InvertImage();
		graphics.SaveImage(filename);
		/*
		for (int i=0;i<point.length;i++){
			graphics.ShowPixelColourArray(colour,size,size);
				
			Point2d[] newpoints=new Point2d[i+1];
			for (int j=0;j<newpoints.length;j++) newpoints[j]=point[j].clone();
			BoundingPolygon2D newpolygon=new BoundingPolygon2D(newpoints);
			LineSegment2D[] lines=newpolygon.Get2DLineSegments();
			
			for (int j=0;j<point.length;j++) 
				graphics.PrintPoint(point[j].x,point[j].y,new PixelColour(PixelColour.StandardColours.Red));
			Point2d[] temp=newpolygon.GetOrderedVertices();
			graphics.PrintPoint(temp[0].x,temp[0].y,new PixelColour(PixelColour.StandardColours.Green));
			graphics.OutlinePolygon(newpolygon,new PixelColour(PixelColour.StandardColours.Blue),0,0);
			if (lines.length>0) graphics.PrintLineSegment(lines[0],new PixelColour(PixelColour.StandardColours.Green));
			String filename="/home/cshome/r/rarnott/Desktop/images/test"+i+".jpg";
			graphics.SaveImage(filename);
		}
		for (int i=0;i<point.length;i++)
			if (polygon.PointIsOutside(point[i])) System.out.println("Point "+i+" detected as outside");
		
		/*
		graphics.OutlinePolygon(polygon,new PixelColour(PixelColour.StandardColours.Blue),0,0);
		String filename="/home/cshome/r/rarnott/Desktop/images/test.jpg";
		graphics.SaveImage(filename);
		TrianglePlusVertexArray triplusvertices=polygon.ConvertToTrianglesOnZplane(0,true);
		Point3d[] vertices=triplusvertices.GetVertexArray();
		TriangularFace[] triangle=triplusvertices.GetTriangleArray();
		*/
		/*
		for (int i=0;i<triangle.length;i++){
			int[] v=triangle[i].GetFace();
			Point2d a=new Point2d(vertices[v[0]].x,vertices[v[0]].y);
			Point2d b=new Point2d(vertices[v[1]].x,vertices[v[1]].y);
			Point2d c=new Point2d(vertices[v[2]].x,vertices[v[2]].y);
			LineSegment2D AB=new LineSegment2D(a,b);
			LineSegment2D AC=new LineSegment2D(a,c);
			LineSegment2D BC=new LineSegment2D(b,c);
			graphics.PrintLineSegment(AB,new PixelColour(PixelColour.StandardColours.Red),2,2);
			graphics.PrintLineSegment(AC,new PixelColour(PixelColour.StandardColours.Red),2,2);
			graphics.PrintLineSegment(BC,new PixelColour(PixelColour.StandardColours.Red),2,2);
			String file="/home/cshome/r/rarnott/Desktop/images/test"+i+".jpg";
			graphics.SaveImage(file);
			graphics.PrintLineSegment(AB,new PixelColour(PixelColour.StandardColours.Green),2,2);
			graphics.PrintLineSegment(AC,new PixelColour(PixelColour.StandardColours.Green),2,2);
			graphics.PrintLineSegment(BC,new PixelColour(PixelColour.StandardColours.Green),2,2);
		}
		*/
		System.out.println("Finished");	
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
		PixelColour colour=new PixelColour(PixelColour.StandardColours.Red);
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
