package org.reprap.scanning.FileIO;
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
* Last modified by Reece Arnott 1st October 2010
*  
*************************************************************************************/

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.util.Properties;

import org.reprap.scanning.Geometry.Ellipse;
import org.reprap.scanning.Geometry.Point2d;

public class CalibrationSheetProperties {
	public int width;
	public int height;
	public double circleradius;
	public Ellipse[] calibrationcircles;
	private String filename;
	
	 public CalibrationSheetProperties(String file) {
	    	width=0;
	    	height=0;
	    	circleradius=0;
	    	calibrationcircles=new Ellipse[0];
	    	filename=file;
	    }
	public void load() throws IOException{
		File file = new File(filename);
		URL url = file.toURI().toURL();
		// Open it if it exists and extract the preferences
		// Note that this will throw an error if the file doesn't exist
			Properties temp = new Properties();
			temp.load(url.openStream());
			int numberofcircles=0;
			if (temp.getProperty("Width")!=null) try {width=Integer.valueOf(temp.getProperty("Width"));}catch (Exception e) {System.out.println("Error loading Calibration Sheet Width - leaving as default: "+e);}
			if (temp.getProperty("Height")!=null) try {height=Integer.valueOf(temp.getProperty("Height"));}catch (Exception e) {System.out.println("Error loading Calibration Sheet Height - leaving as default: "+e);}
			if (temp.getProperty("CircleRadius")!=null) try {circleradius=Double.valueOf(temp.getProperty("CircleRadius"));}catch (Exception e) {System.out.println("Error loading Calibration Sheet Circle Radius - leaving as default: "+e);}
			if (temp.getProperty("NumberOfCircles")!=null) try {numberofcircles=Integer.valueOf(temp.getProperty("NumberOfCircles"));}catch (Exception e) {System.out.println("Error loading Number of Circles - leaving as default: "+e);}
			calibrationcircles=new Ellipse[numberofcircles];
			for (int i=0;i<calibrationcircles.length;i++){
				Point2d circlecenter=new Point2d(0,0);
				if (temp.getProperty("Circle"+i+"CenterX")!=null) try {circlecenter.x=Double.valueOf(temp.getProperty("Circle"+i+"CenterX"));}catch (Exception e) {System.out.println("Error loading Calibration Sheet Circle "+i+" Center X coordinate - leaving as default: "+e);}
				if (temp.getProperty("Circle"+i+"CenterY")!=null) try {circlecenter.y=Double.valueOf(temp.getProperty("Circle"+i+"CenterY"));}catch (Exception e) {System.out.println("Error loading Calibration Sheet Circle "+i+" Center Y coordinate - leaving as default: "+e);}
				calibrationcircles[i]=new Ellipse(circlecenter,circleradius,circleradius,0);
			} // end for
			
	} // end of load method
	
	public void save()throws IOException {
		File file = new File(filename);
		if (!file.exists()) {
			File p = new File(file.getParent());
			if (!p.isDirectory()){
				// Create folder if necessary
				p.mkdirs();	
			}
		}	
		OutputStream output = new FileOutputStream(file);
		Properties temp = new Properties();
		 temp.setProperty("Width",String.valueOf(width));
		 temp.setProperty("Height",String.valueOf(height));
		 temp.setProperty("CircleRadius",String.valueOf(circleradius));
		 temp.setProperty("NumberOfCircles",String.valueOf(calibrationcircles.length));
		 for (int i=0;i<calibrationcircles.length;i++){
			 temp.setProperty("Circle"+i+"CenterX",String.valueOf(calibrationcircles[i].GetCenter().x));
			 temp.setProperty("Circle"+i+"CenterY",String.valueOf(calibrationcircles[i].GetCenter().y));
		 }
		 // Write to file with headers.
			String comments = "Reprap 3D Scanning Calibration Sheet properties http://reprap.org/ - can be edited by hand but not recommended as elements may be reordered by the program\n";
		    temp.store(output, comments);
	} // end save method	
}
