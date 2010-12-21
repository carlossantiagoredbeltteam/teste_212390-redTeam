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
* Last modified by Reece Arnott 21st December 2010
*
*	This class stores a single tetrahedron where the points a,b,c,d are simple indexes to a Point3d array.
* 
*	
* 
***********************************************************************************/
public class Tetrahedron {
	private Triangle3D triangle;
	private int d;
	
	//Constructor
	public Tetrahedron(Triangle3D tri, int pointd,Point3d[] pointslist){
		triangle=tri.clone();
		triangle.CalculateNormalAwayFromPoint(pointslist,pointslist[pointd]);
		d=pointd;
	}
	public Tetrahedron(){
		triangle=new Triangle3D();
		d=-1;
	}
	
	public Tetrahedron clone(){
		Tetrahedron returnvalue=new Tetrahedron();
		returnvalue.triangle=triangle.clone();
		returnvalue.d=d;
		return returnvalue;
	}
	public boolean isNull(){return d==-1;}
	
	public Triangle3D[] GetFaces(Point3d[] p){
			Triangle3D[] returnvalue=new Triangle3D[4];
			int[] abc=triangle.GetFace();
			int a=abc[0];
			int b=abc[1];
			int c=abc[2];
			
			if (d>=0) { // only do this if there is a tetrahedron
				// Based on those returned by C DeWall BuildTetra
				returnvalue[0]=new Triangle3D(a,b,c,p); returnvalue[0].CalculateNormalAwayFromPoint(p, p[d]);
				// This returns faces so that a normal calculated from ABxAC for each face will all point in the same direction, either out or in relative to the original tetrahedron
				returnvalue[1]=new Triangle3D(a,d,c,p);returnvalue[1].CalculateNormalAwayFromPoint(p, p[b]);
				returnvalue[2]=new Triangle3D(c,d,b,p);returnvalue[2].CalculateNormalAwayFromPoint(p, p[a]);
				returnvalue[3]=new Triangle3D(b,d,a,p);returnvalue[3].CalculateNormalAwayFromPoint(p, p[c]);
				
			}
			else returnvalue=new Triangle3D[0];
		return returnvalue;
		}
	public int[] GetVertices(){
		// Note that the order of the vertices is such that each vertex returned is the one not used in triangle returned by the GetFaces method for the same array index
		int[] returnvalue=new int[4];
		if (d>=0) {
			int[] abc=triangle.GetFace();
			int a=abc[0];
			int b=abc[1];
			int c=abc[2];
			returnvalue[0]=d;
			returnvalue[1]=b;
			returnvalue[2]=a;
			returnvalue[3]=c;
			
		}
		else returnvalue=new int[0];
		return returnvalue;
	}
	
	public Triangle3D GetTriangle(){
		return triangle;
	}
	
	
//		 Only used in the DeWall CTC check
		public boolean isEquivalent(Tetrahedron tetra){
			int[] othervertices=tetra.GetVertices();
			int[] thisvertices=GetVertices();
			boolean returnvalue=true;
			for (int j=0;j<othervertices.length;j++) if (returnvalue){
				int i=othervertices[j];
				returnvalue=((thisvertices[0]==i) || (thisvertices[1]==i) || (thisvertices[2]==i) || (thisvertices[3]==i));
			}
			return returnvalue;
		}
		public void print(){
			System.out.print("d="+d+" ");triangle.print();
		}
}
