package org.reprap.scanning.Geometry;

import Jama.Matrix;
import org.reprap.scanning.DataStructures.TrianglePlusVertexArray;
import org.reprap.scanning.DataStructures.MatrixManipulations;

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
* Last modified by Reece Arnott 16th December 2010
*
* This class is simply a number of values that can be used to describe a 3d cube where the faces of the cube align with the x,y,z axes.
* It can also be used to describe a bounding rectangle in 2d space by ignoring the z values
*	
***********************************************************************************/


public class AxisAlignedBoundingBox{
	public double minx,miny,minz,maxx,maxy,maxz;
	
	public AxisAlignedBoundingBox clone(){
		AxisAlignedBoundingBox returnvalue=new AxisAlignedBoundingBox();
		returnvalue.minx=minx;
		returnvalue.miny=miny;
		returnvalue.minz=minz;
		returnvalue.maxx=maxx;
		returnvalue.maxy=maxy;
		returnvalue.maxz=maxz;
		return returnvalue;
	}
	
	public void TruncateIfExceedsBounds(AxisAlignedBoundingBox master){
		if (minx<master.minx) minx=master.minx;
		if (miny<master.miny) miny=master.miny;
		if (minz<master.minz) minz=master.minz;
		if (maxx>master.maxx) maxx=master.maxx;
		if (maxy>master.maxy) maxy=master.maxy;
		if (maxz>master.maxz) maxz=master.maxz;
	}
	public void SetTransformedAxisAligned2DBoundingBox(Matrix M){
		Point2d[] corners=GetTransformedCornersof2DBoundingBox(M);
		minx=corners[0].x;
		miny=corners[0].y;
		maxx=corners[0].x;
		maxy=corners[0].y;
		minz=0;
		maxz=0;
		for (int i=1;i<corners.length;i++){
			if (corners[i].x<minx) minx=corners[i].x;
			if (corners[i].x>maxx) maxx=corners[i].x;
			if (corners[i].y<miny) miny=corners[i].y;
			if (corners[i].y>maxy) maxy=corners[i].y;
		}
	}
	
	public AxisAlignedBoundingBox GetTransformedAxisAligned2DBoundingBox(Matrix M){
		AxisAlignedBoundingBox returnvalue=new AxisAlignedBoundingBox();
		returnvalue.minx=minx;
		returnvalue.miny=miny;
		returnvalue.minz=minz;
		returnvalue.maxx=maxx;
		returnvalue.maxy=maxy;
		returnvalue.maxz=maxz;
		returnvalue.SetTransformedAxisAligned2DBoundingBox(M);
		return returnvalue;
		
	}
	
	
	public Point2d[] GetTransformedCornersof2DBoundingBox(Matrix M){
		Point2d[] returnvalue=GetCornersof2DBoundingBox();
		for (int i=0;i<4;i++) returnvalue[i].ApplyTransform(M);
		return returnvalue;
	}
	public Point2d[] GetImageProjectionOfCornersof3DBoundingBox(Point2d imageorigin, Matrix P){
		Point3d[] points=GetCornersof3DBoundingBox();
		Point2d[] returnvalue=new Point2d[8];
		for (int i=0;i<8;i++) returnvalue[i]=new Point2d(MatrixManipulations.WorldToImageTransform(points[i].ConvertPointTo4x1Matrix(),imageorigin,P));
		return returnvalue;
	}
	
	public Point2d[] GetCornersof2DBoundingBox(){
		Point2d[] returnvalue=new Point2d[4];
		returnvalue[0]=new Point2d(minx,miny);
		returnvalue[1]=new Point2d(minx,maxy);
		returnvalue[2]=new Point2d(maxx,maxy);
		returnvalue[3]=new Point2d(maxx,miny);
		return returnvalue;
	}
	
	public Point3d[] GetCornersof3DBoundingBox(){
		Point3d[] returnvalue=new Point3d[8];
		returnvalue[0]=new Point3d(minx,miny,minz);
		returnvalue[1]=new Point3d(minx,maxy,minz);
		returnvalue[2]=new Point3d(maxx,maxy,minz);
		returnvalue[3]=new Point3d(maxx,miny,minz);
		returnvalue[4]=new Point3d(minx,miny,maxz);
		returnvalue[5]=new Point3d(minx,maxy,maxz);
		returnvalue[6]=new Point3d(maxx,maxy,maxz);
		returnvalue[7]=new Point3d(maxx,miny,maxz);
		
	return returnvalue;
	}
	
	public int[][] GetPointPairIndicesFor3DWireFrameLines(){
		int[][] returnvalue=new int[12][2];
		for (int i=0;i<5;i=i+4){ // the upper and lower square
			returnvalue[i+0][0]=i+0;returnvalue[i+0][1]=i+1;
			returnvalue[i+1][0]=i+0;returnvalue[i+1][1]=i+3;
			returnvalue[i+2][0]=i+1;returnvalue[i+2][1]=i+2;
			returnvalue[i+3][0]=i+3;returnvalue[i+3][1]=i+2;
			}
		for (int i=8;i<12;i++) { // the connecting lines between the upper and lower square
			returnvalue[i][0]=i-8;returnvalue[i][1]=i-4;
		}
	return returnvalue;
	}
	public int[][] GetPointPairIndicesFor2DWireFrameLines(){
		int[][] returnvalue=new int[4][2];
		returnvalue[0][0]=0;returnvalue[0][1]=1;
		returnvalue[1][0]=0;returnvalue[1][1]=3;
		returnvalue[2][0]=1;returnvalue[2][1]=2;
		returnvalue[3][0]=3;returnvalue[3][1]=2;
		
	return returnvalue;
	}
	
	public TrianglePlusVertexArray GetTrianglesMakingUpFaces(){
		Point3d[] corners=GetCornersof3DBoundingBox();
		TrianglePlusVertexArray returnvalue=new TrianglePlusVertexArray(corners);
		int[][] quads=GetPointQuadIndicesForBuildingFaces();
		Point3d center= GetMidpointof3DBoundingBox();
		for (int i=0;i<6;i++){
			TriangularFace tri1=new TriangularFace(quads[i][0],quads[i][1],quads[i][2]);
			TriangularFace tri2=new TriangularFace(quads[i][0],quads[i][2],quads[i][3]);
			tri1.CalculateNormalAwayFromPoint(corners,center);
			tri2.CalculateNormalAwayFromPoint(corners,center);
			returnvalue.AddTriangle(tri1);
			returnvalue.AddTriangle(tri2);
		}
		return returnvalue;
	}
	
	
	public int[][] GetPointQuadIndicesForBuildingFaces(){
		int[][] f=new int[6][4];
		// Bottom face 0,1,2,3
		f[0][0]=0;
		f[0][1]=1;
		f[0][2]=2;
		f[0][3]=3;
		// Top face 4,5,6,7
		f[1][0]=4;
		f[1][1]=5;
		f[1][2]=6;
		f[1][3]=7;
		// Left face 0,1,4,5
		f[2][0]=0;
		f[2][1]=4;
		f[2][2]=5;
		f[2][3]=1;
		// Right face 2,3,6,7
		f[3][0]=3;
		f[3][1]=7;
		f[3][2]=6;
		f[3][3]=2;
		// Front face 0,3,4,7
		f[4][0]=0;
		f[4][1]=4;
		f[4][2]=7;
		f[4][3]=3;
		// Back face 1,2,5,6
		f[5][0]=1;
		f[5][1]=5;
		f[5][2]=6;
		f[5][3]=2;
		
		return f;
	}
	
	public boolean isEqual(AxisAlignedBoundingBox other){
		boolean returnvalue=true;
		if (returnvalue) returnvalue=minx==other.minx;
		if (returnvalue) returnvalue=miny==other.miny;
		if (returnvalue) returnvalue=minz==other.minz;
		if (returnvalue) returnvalue=maxx==other.maxx;
		if (returnvalue) returnvalue=maxy==other.maxy;
		if (returnvalue) returnvalue=maxz==other.maxz;
		return returnvalue;
	}
	
	public Line3d[] Get3DWireframeLines(){
		Point3d[] vertices=GetCornersof3DBoundingBox();
		int[][] pairs=GetPointPairIndicesFor3DWireFrameLines();
		Line3d[] lines=new Line3d[12];
		for (int i=0;i<12;i++)
			lines[i]=new Line3d(vertices[pairs[i][0]],vertices[pairs[i][1]]);
		return lines;
	}
	public LineSegment2D[] Get2DWireframeLines(){
		Point2d[] vertices=GetCornersof2DBoundingBox();
		int[][] pairs=GetPointPairIndicesFor2DWireFrameLines();
		LineSegment2D[] lines=new LineSegment2D[4];
		for (int i=0;i<4;i++)
			lines[i]=new LineSegment2D(vertices[pairs[i][0]],vertices[pairs[i][1]]);
		return lines;
	}
	
	
	public Point2d GetMidpointof2DBoundingBox(){
		return new Point2d((maxx+minx)/2,(maxy+miny)/2);
	}
	public Point3d GetMidpointof3DBoundingBox(){
		return new Point3d((maxx+minx)/2,(maxy+miny)/2,(maxz+minz)/2);
	}
	public void scale(double s){
		minx=minx*s;
		miny=miny*s;
		minz=minz*s;
		maxx=maxx*s;
		maxy=maxy*s;
		maxz=maxz*s;
	}
	public void ResetOrigin(Point3d neworigin){
		minx=minx-neworigin.x;
		miny=miny-neworigin.y;
		minz=minz-neworigin.z;
		maxx=maxx-neworigin.x;
		maxy=maxy-neworigin.y;
		maxz=maxz-neworigin.z;
	}
	public void Expand2DBoundingBox(Point2d point){
		if (point.x<minx) minx=point.x;
		if (point.x>maxx) maxx=point.x;
		if (point.y<miny) miny=point.y;
		if (point.y>maxy) maxy=point.y;
	}
	public void Expand3DBoundingBox(Point3d point){
		if (point.x<minx) minx=point.x;
		if (point.x>maxx) maxx=point.x;
		if (point.y<miny) miny=point.y;
		if (point.y>maxy) maxy=point.y;
		if (point.z<minz) minz=point.z;
		if (point.z>maxz) maxz=point.z;
	}
	public void Expand3DBoundingBox(AxisAlignedBoundingBox box){
		if (box.minx<minx) minx=box.minx;
		if (box.miny<miny) miny=box.miny;
		if (box.minz<minz) minz=box.minz;
		if (box.maxx>maxx) maxx=box.maxx;
		if (box.maxy>maxy) maxy=box.maxy;
		if (box.maxz>maxz) maxz=box.maxz;
	}
		
	public boolean PointInside2DBoundingBox(Point2d point){
		return  ((point.x>=minx) && (point.x<=maxx) && (point.y>=miny) && (point.y<=maxy));
	}
	public boolean PointInside3DBoundingBox(Point3d point){
		return  ((point.x>=minx) && (point.x<=maxx) && (point.y>=miny) && (point.y<=maxy) && (point.z>=minz) && (point.z<=maxz));
	}
	
	public boolean Intersects(Line3d l){
		/* This is the standard slab test. It is not the most efficient way of doing this.
		 * If an improvement is needed it can be got by implementing either of the following which have C or C++ source code available for them
		 * 1. "Fast Ray-Axis Aligned Bounding Box Overlap Tests with Plücker Coordinates" by Jeffrey Mahovsky and Brian Wyvill Journal of Graphics Tools 2004 Vol 9, Issue 1, pg 35-46 Source code available from http://jgt.akpeters.com/papers/Mahovskywyvill04/
		 * 2. "Fast Ray/Axis-Aligned Bounding Box Overlap Tests using Ray Slopes" by Martin Eisemann, Marcus Magnor, Thorsten Grosch, Stefan Müller Journal of Graphics Tools 2007 Vol 12, Issue 4, pg 35-46 Source code available from http://www.cg.cs.tu-bs.de/people/eisemann/rayslope/rayslope.zip
		 * The second is apparently faster but has 27 cases to deal with (including the degenerate one of the line vector having being all 0's) whereas the first only has 8 but uses Plucker coordinates (advisible to have the wikipedia page on Plucker coordinates open when reading the paper if you don't understand them).
		 * 
		 *  
		 * This code is based on the test code made available by Jeffrey Mahovsky and Brian Wyvill and used for algorithm comparision.
		 * 
		 * A slab is the space between two parallel planes. We look at the intersection of each pair of planes with the line and find the near and far intersection for each pair.
		 * If the overall largest tnear value (intersection with the near slab) is greater than the smallest tfar value (intersection with the far slab) then the line misses, else it hits the volume.
		 * 
		 * 
		 */
		// First is the source point inside the bounding box? if so we can stop now as obviously the line intersects.
		boolean intersect=PointInside3DBoundingBox(l.P);
		if (!intersect){ // test against min and max x 
			double tnearmax=Double.MIN_VALUE;
			double tfarmin=Double.MAX_VALUE;
			
			//assuming two multiplies and one division are faster than two divisions
			double div=1/l.V.x;
			double tnear = (minx - l.P.x) * div;
			double tfar = (maxx - l.P.x) * div;
			if(tnear > tfar) // swap them
				{
				double temp = tnear;
				tnear = tfar;
				tfar = temp;
				}
			if(tnear > tnearmax) tnearmax = tnear;
			if(tfar < tfarmin) tfarmin=tfar;
			intersect=(tnearmax <= tfarmin);
			
			if (intersect){ // do the same but test against min and max y
				div=1/l.V.y;
				tnear = (miny - l.P.y) * div;
				tfar = (maxy - l.P.y) * div;
				if(tnear > tfar) // swap them
					{
					double temp = tnear;
					tnear = tfar;
					tfar = temp;
					}
				if(tnear > tnearmax) tnearmax = tnear;
				if(tfar < tfarmin) tfarmin=tfar;
				intersect=(tnearmax <= tfarmin);
			} //end if intersect
			if (intersect){ // do the same but test against min and max z
				div=1/l.V.z;
				tnear = (minz - l.P.z) * div;
				tfar = (maxz - l.P.z) * div;
				if(tnear > tfar) // swap them
					{
					double temp = tnear;
					tnear = tfar;
					tfar = temp;
					}
				if(tnear > tnearmax) tnearmax = tnear;
				if(tfar < tfarmin) tfarmin=tfar;
				intersect=(tnearmax <= tfarmin);
			} //end if intersect
		} // end if not intersect
		return intersect;
	} // end of intersect line method
}

