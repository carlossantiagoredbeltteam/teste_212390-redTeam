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
 * Last modified by Reece Arnott 27th July 2010
 *
 *****************************************************************************/
package org.reprap.scanning.FileIO;

import java.io.File;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.text.DecimalFormat;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StreamTokenizer;



import org.reprap.scanning.Geometry.*;



public class PointsFile {

	private String filename;
	
	
// Constructors
    public PointsFile(String filepathandname) {
    	filename=filepathandname;
	}
	
	
// This method loads the Points. 
	public Point3d[] load() throws IOException{
		
		Point3d[] returnvalue=new Point3d[0];
		
		File file = new File(filename);
		// Open it if it exists and extract the numbers
		if (file.exists()) {
			Reader r = new BufferedReader(new FileReader(filename));
		    StreamTokenizer stok = new StreamTokenizer(r);
		    stok.parseNumbers();
		    stok.nextToken();
		    if (stok.ttype == StreamTokenizer.TT_NUMBER) returnvalue=new Point3d[(int)stok.nval];
		    int i=-1;
		    int j=-1;
		    while ((stok.ttype != StreamTokenizer.TT_EOF) && (i<returnvalue.length)) {
		      if (stok.ttype == StreamTokenizer.TT_NUMBER){
		    	  switch (j){
		    	  case 2: // set the z value and increment the index counter
		    		  returnvalue[i].z=stok.nval;
	    			  j=0;
	    			  i++;
	    			  break;
		    	  case 1: //set the y value
		    		  returnvalue[i].y=stok.nval;
	    			  j++;
	    			  break;
		    	  case 0: // create a new point and set the x value
		    		  returnvalue[i]=new Point3d();
		    		  returnvalue[i].x=stok.nval;
		    		  j++;
		    		  break;
		    	  case -1: // start of file should have a single number which is the number of points 
		    		  returnvalue=new Point3d[(int)stok.nval];
		    		  i=0;
		    		  j=0;
		    		  break;
		    	  } // end switch
		      } // end if
		      stok.nextToken();
		    } // end while
		    
		  } // end if file exists
	return returnvalue;
	}

	public void save(Point3d[] array)throws IOException {
		File file = new File(filename);
		if (!file.exists()) {
			File p = new File(file.getParent());
			if (!p.isDirectory()){
				// Create folder if necessary
				p.mkdirs();	
			}
		}	
		
		BufferedWriter out = new BufferedWriter(new FileWriter(filename));
		  DecimalFormat format = new DecimalFormat("0.000000");

		out.write(Integer.toString(array.length)+"\n\n");
      for (int i=0;i<array.length;i++){
    	  out.write(format.format(array[i].x)+" ");
    	  out.write(format.format(array[i].y)+" ");
    	  out.write(format.format(array[i].z)+"\n");
      }
      out.close(); 
			
	}
	

}
