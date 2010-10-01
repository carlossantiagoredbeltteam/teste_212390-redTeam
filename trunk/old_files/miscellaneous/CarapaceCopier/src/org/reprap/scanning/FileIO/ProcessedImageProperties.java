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

import org.reprap.scanning.Geometry.Point2d;
import Jama.Matrix;

public class ProcessedImageProperties {
	public Point2d originofimagecoordinates;
	public Matrix WorldToImageTransform;
	public boolean skipprocessing;
	private String filename;
	
	 public ProcessedImageProperties(String file) {
		 originofimagecoordinates=new Point2d(0,0);
		 WorldToImageTransform=new Matrix(3,4);
		 filename=file;
		 skipprocessing=true;
	    }
	public void loadProperties() throws IOException{
		File file = new File(filename);
		URL url = file.toURI().toURL();
		// Open it if it exists and extract the preferences
		// Note that this will throw an error if the file doesn't exist
			Properties temp = new Properties();
			temp.load(url.openStream());
			
			if (temp.getProperty("OriginOfImageCoordinatesX")!=null) try {originofimagecoordinates.x=Double.valueOf(temp.getProperty("OriginOfImageCoordinatesX"));}catch (Exception e) {System.out.println("Error loading OriginOfImageCoordinatesX - leaving as default: "+e);}
			if (temp.getProperty("OriginOfImageCoordinatesY")!=null) try {originofimagecoordinates.y=Double.valueOf(temp.getProperty("OriginOfImageCoordinatesY"));}catch (Exception e) {System.out.println("Error loading OriginOfImageCoordinatesY - leaving as default: "+e);}
			if (temp.getProperty("SkipProcessing")!=null) skipprocessing = temp.getProperty("SkipProcessing").equals("true");

			for (int i=0;i<3;i++)
				for (int j=0;j<4;j++){
					try {WorldToImageTransform.set(i,j,Double.valueOf(temp.getProperty("WorldToImageTransformMatrixRow"+i+"Column"+j)));}catch (Exception e) {System.out.println("Error loading WorldToImageTransformMatrixRow"+i+"Column"+j+" - leaving as default: "+e);}
				}
	} // end of load method
	
	public void saveProperties()throws IOException {
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
		temp.setProperty("OriginOfImageCoordinatesX",String.valueOf(originofimagecoordinates.x));
		temp.setProperty("OriginOfImageCoordinatesY",String.valueOf(originofimagecoordinates.y));
		temp.setProperty("SkipProcessing", String.valueOf(skipprocessing));
		for (int i=0;i<3;i++)
			for (int j=0;j<4;j++){
				temp.setProperty("WorldToImageTransformMatrixRow"+i+"Column"+j+"",String.valueOf(WorldToImageTransform.get(i,j)));
			}
	 // Write to file with headers.
			String comments = "Reprap 3D Scanning processed image properties http://reprap.org/ - can be edited by hand but not recommended as elements may be reordered by the program\n";
		    temp.store(output, comments);
	} // end save method	
}
