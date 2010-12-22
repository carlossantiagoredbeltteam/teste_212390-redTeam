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
* Last modified by Reece Arnott 22nd December 2010
*
*	This class stores a single triangle where the points a,b,c are simple indexes to a Point2d array.
* 
*	
* 
***********************************************************************************/
public class Triangle2D {
	private LineSegment2DIndices linesegment;
	private int c;
	
	//Constructor
	public Triangle2D(LineSegment2DIndices line, int pointc,Point2d[] pointslist){
		linesegment=line.clone();
		linesegment.CalculateNormalAwayFromPoint(pointslist,pointslist[pointc]);
		c=pointc;
	}
	public Triangle2D(){
		linesegment=new LineSegment2DIndices();
		c=-1;
	}
	
	public Triangle2D clone(){
		Triangle2D returnvalue=new Triangle2D();
		returnvalue.linesegment=linesegment.clone();
		returnvalue.c=c;
		return returnvalue;
	}
	public boolean isNull(){return c==-1;}
	
	public LineSegment2DIndices[] GetFaces(Point2d[] p){
		LineSegment2DIndices[] returnvalue=new LineSegment2DIndices[3];
			int[] ab=linesegment.GetStartAndEndPointIndices();
			int a=ab[0];
			int b=ab[1];
			
			if (c>=0) { // only do this if there is a triangle
				// Based on those returned by C DeWall BuildTetra
				returnvalue[0]=new LineSegment2DIndices(a,b,p); returnvalue[0].CalculateNormalAwayFromPoint(p, p[c]);
				// This returns faces so that a normal calculated for each face will all point out of original triangle
				returnvalue[1]=new LineSegment2DIndices(a,c,p);returnvalue[1].CalculateNormalAwayFromPoint(p, p[b]);
				returnvalue[2]=new LineSegment2DIndices(b,c,p);returnvalue[2].CalculateNormalAwayFromPoint(p, p[a]);
				
			}
			else returnvalue=new LineSegment2DIndices[0];
		return returnvalue;
		}
	public LineSegment2D[] GetLineSegmentFaces(Point2d[] p){
		LineSegment2DIndices[] lines=GetFaces(p);
		LineSegment2D[] returnvalue=new LineSegment2D[lines.length];
		for (int i=0;i<lines.length;i++) returnvalue[i]=lines[i].ConvertToLineSegment(p);
		
		return returnvalue;
	}
	public int[] GetVertices(){
		// Note that the order of the vertices is such that each vertex returned is the one not used in triangle returned by the GetFaces method for the same array index
		int[] returnvalue=new int[3];
		if (c>=0) {
			int[] abc=linesegment.GetStartAndEndPointIndices();
			int a=abc[0];
			int b=abc[1];
			returnvalue[0]=c;
			returnvalue[1]=b;
			returnvalue[2]=a;
		}
		else returnvalue=new int[0];
		return returnvalue;
	}
	
	public LineSegment2DIndices GetLineSegment(){
		return linesegment;
	}
	
	
//		 Only used in the DeWall CTC check
		public boolean isEquivalent(Triangle2D triangle){
			int[] othervertices=triangle.GetVertices();
			int[] thisvertices=GetVertices();
			boolean returnvalue=true;
			for (int j=0;j<othervertices.length;j++) if (returnvalue){
				int i=othervertices[j];
				returnvalue=((thisvertices[0]==i) || (thisvertices[1]==i) || (thisvertices[2]==i));
			}
			return returnvalue;
		}
		public void print(){
			System.out.print("c="+c+" ");linesegment.print();
		}
}
