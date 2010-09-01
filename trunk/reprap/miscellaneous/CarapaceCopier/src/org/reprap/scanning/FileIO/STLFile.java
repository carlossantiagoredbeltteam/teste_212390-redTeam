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
 * Last modified by Reece Arnott 7th July 2010
 *  
*************************************************************************************/
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.swing.JProgressBar;

import org.reprap.scanning.Geometry.*;
public class STLFile {
	  
	private String filename;
	
	public STLFile(String file){
		filename=file;
	}
	
	public String Write(JProgressBar bar, TriangularFace[] surfacetriangles,Point3d[] surfacepoints,String objectname){
	  String error="";
		bar.setMinimum(0);
	  bar.setMaximum(surfacetriangles.length);
	  bar.setValue(0);
	  try{
			File file = new File(filename);
		if (!file.exists()) {
			File p = new File(file.getParent());
			if (!p.isDirectory()){
				// Create folder if necessary
				p.mkdirs();	
			}
			
		}	
		DataOutputStream   dos = new DataOutputStream(new FileOutputStream(file));
		// write header information
		dos.writeBytes("solid "+objectname+"\n"); // Note the solid object name can be anything but it must be the same in the header and footer
		
		for (int i=0;i<surfacetriangles.length;i++){
			//write the normal to file
			dos.writeBytes("facet normal "+surfacetriangles[i].normal.x+" "+surfacetriangles[i].normal.y+" "+surfacetriangles[i].normal.z+"\n");
			// write the start of the vertex loop
			dos.writeBytes("  outer loop\n");
			// write each vertex of the triangle to a file
			int[] indexes=surfacetriangles[i].GetFace();
			// some software ignores the facet normal values and automatically calculate a normal based on the order of the triangle vertices using the 'right hand rule'
			// so for portability the vertices need to be ordered to come up with the same answer
			Plane plane=new Plane(surfacepoints[indexes[0]],surfacepoints[indexes[1]],surfacepoints[indexes[2]]);
			if (plane.getNormal().plus(surfacetriangles[i].normal).lengthSquared()<1){// Adding the two normals together should get a zero vector if they are in opposite directions so...
				// swap around point b and c
				int temp=indexes[1];
				indexes[1]=indexes[2];
				indexes[2]=temp;
			}
			for (int vertex=0;vertex<3;vertex++){
				dos.writeBytes("    vertex "+surfacepoints[indexes[vertex]].x+" "+surfacepoints[indexes[vertex]].y+" "+surfacepoints[indexes[vertex]].z+"\n");
			}
			// write the end of the triangle endloop and endfacet footers
			dos.writeBytes("  endloop\n");
			dos.writeBytes("endfacet\n");
			// update the progressbar
			bar.setValue(i);
		} // end for i
  		// write object footer
		dos.writeBytes("endsolid "+objectname+"\n");
		  dos.close();
		}
		catch (IOException ex) {
		   error="Error writing STL file"; 
		}
		return error;
	}
}
