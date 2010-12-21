package org.reprap.scanning.DataStructures;
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
 * Last modified by Reece Arnott 24th August 2010
 * 
 * This is simply a dual array with points in one and triangles in the other.
 * The triangles are defined by three indices that relate to the points array. This is used so that two triangles that share an edge i.e. two vertices will not have a problem with rounding errors
 * leading to the two common vertices not being exactly the same points.
 * 
 ********************************************************************************/  
import org.reprap.scanning.Geometry.Point3d;
import org.reprap.scanning.Geometry.TriangularFaceOf3DTetrahedrons;


public class TrianglePlusVertexArray {

	private Point3d[] vertices;
	private TriangularFaceOf3DTetrahedrons[] triangles;
	
	
	// Constructors
	public TrianglePlusVertexArray(Point3d[] points){
		vertices=new Point3d[points.length];
		for (int i=0;i<points.length;i++) vertices[i]=points[i].clone();
		triangles=new TriangularFaceOf3DTetrahedrons[0];
	}
	public TrianglePlusVertexArray(Point3d[] points,TriangularFaceOf3DTetrahedrons[] triangle ){
		vertices=new Point3d[points.length];
		for (int i=0;i<points.length;i++) vertices[i]=points[i].clone();
		triangles=new TriangularFaceOf3DTetrahedrons[triangle.length];
		for (int i=0;i<triangles.length;i++) triangles[i]=triangle[i].clone();
	}
	public TrianglePlusVertexArray clone(){
		return new TrianglePlusVertexArray(vertices,triangles);
	}
	
	public Point3d[] GetVertexArray(){
		return vertices;
	}
	public TriangularFaceOf3DTetrahedrons[] GetTriangleArray(){
		return triangles;
	}
	public boolean AddTriangle(TriangularFaceOf3DTetrahedrons add){
		boolean returnvalue=true;
		// Sanity check to make sure the triangle contains valid indices 
		int[] indices=add.GetFace();
		for (int i=0;i<indices.length;i++) returnvalue=returnvalue && (indices[i]<vertices.length) && (indices[i]>=0);
		if (returnvalue){ // add the triangle
			TriangularFaceOf3DTetrahedrons[] newtriangles=new TriangularFaceOf3DTetrahedrons[triangles.length+1];
			for (int i=0;i<triangles.length;i++) newtriangles[i]=triangles[i].clone();
			newtriangles[triangles.length]=add.clone();
			triangles=newtriangles.clone();
		}
		return returnvalue;
	}
	//Purge the vertices in the array and only keep those for which triangles have been added
	public void PurgeIrreleventVertices(){
		// initialise the mapping between old and new indices
		int[] map=new int[vertices.length];
		for (int i=0;i<map.length;i++) map[i]=-1;
		// set up the mapping 
		int count=0;
		for (int i=0;i<triangles.length;i++){
			int[] tri=triangles[i].GetFace();
			for (int j=0;j<tri.length;j++) if (map[tri[j]]==-1) {map[tri[j]]=count; count++;} 
		} // end for i
		// apply the mapping to the vertices
		Point3d[] newpoints=new Point3d[count];
		for (int i=0;i<vertices.length;i++) if (map[i]!=-1){
			newpoints[map[i]]=vertices[i].clone();
		}
		vertices=newpoints.clone();
		//apply the mapping to the triangles
		for (int i=0;i<triangles.length;i++){
			int[] old=triangles[i].GetFace();
			triangles[i].ChangeTriangle(map[old[0]],map[old[1]],map[old[2]]);
			triangles[i].SetHash(triangles.length);
		}
		
	}
	public TrianglePlusVertexArray MergeAndReturn(TrianglePlusVertexArray other){
		// Merge the vertices
		Point3d[] newvertices=new Point3d[vertices.length+other.vertices.length];
		for (int i=0;i<vertices.length;i++) newvertices[i]=vertices[i].clone();
		for (int i=0;i<other.vertices.length;i++) newvertices[i+vertices.length]=other.vertices[i].clone();
		// set up the return value vertices
		TrianglePlusVertexArray returnvalue=new TrianglePlusVertexArray(newvertices);
		
		// merge the first set of triangles (no change)
		TriangularFaceOf3DTetrahedrons[] newtriangles=new TriangularFaceOf3DTetrahedrons[triangles.length+other.triangles.length];
		for (int i=0;i<triangles.length;i++) newtriangles[i]=triangles[i].clone();
		// Now add the second set of triangles and for each change the indices of the 3 vertices
		for (int i=0;i<other.triangles.length;i++) {
			TriangularFaceOf3DTetrahedrons tri=other.triangles[i].clone();
			int[] old=tri.GetFace();
			tri.ChangeTriangle(old[0]+vertices.length,old[1]+vertices.length,old[2]+vertices.length);
			tri.SetHash(triangles.length);
			newtriangles[i+triangles.length]=tri.clone();
		}
		// set the return value triangles
		returnvalue.triangles=newtriangles.clone();
		return returnvalue;
	}
	
	public int GetTriangleArrayLength(){
		return triangles.length;
	}
}
