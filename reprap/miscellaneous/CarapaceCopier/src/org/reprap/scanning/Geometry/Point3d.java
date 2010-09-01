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
* Last modified by Reece Arnott 24th Feburary 2010
*
* Most of this can be done with a 3x1 or 4x1 matrix with the exception of the count and the boolean skip variable (used in the DeWall triangularation).
**********************************************************************************/
import Jama.Matrix;
public class Point3d {

	public double x,y,z;
	// Constructors
	public Point3d(){x=0; y=0; z=0; }
	public Point3d(double newx,double newy,double newz){x=newx; y=newy; z=newz;}
	public Point3d(Matrix p){
		if (p.getColumnDimension()==1){
			if ((p.getRowDimension()==3) || (p.getRowDimension()==4)){
				x=p.get(0,0);
				y=p.get(1,0);
				z=p.get(2,0);
				if (p.getRowDimension()==4) {
					x=x/p.get(3,0);
					y=y/p.get(3,0);
					z=z/p.get(3,0);
				} // end if 4 rows
			} // end if 3 or 4 rows
		} // end if one column
		}
	
	public Point3d clone(){
			return (new Point3d(x,y,z));
	}
	
	
	public boolean ApproxEqual(Point3d p){
		return ((Math.abs(x-p.x)<0.000001) && (Math.abs(y-p.y)<0.000001) && (Math.abs(z-p.z)<0.000001));
	}
	public	double  lengthSquared()
	{ return ((x*x) + (y*y) + (z*z)); }
	public Point3d  crossProduct(Point3d v)
	{ 
		Point3d returnvalue=new Point3d();
		returnvalue.x=(y*v.z)-(z*v.y);
		returnvalue.y=(z*v.x)-(x*v.z);
		returnvalue.z=(x*v.y)-(y*v.x);
		return returnvalue;
		}
	public double dot(Point3d v){
		return ((x*v.x)+(y*v.y)+(z*v.z));
	}
	public Point3d minus(Point3d v)
	{
		Point3d returnvalue=new Point3d();
		returnvalue.x=x-v.x;
		returnvalue.y=y-v.y;
		returnvalue.z=z-v.z; 
		return returnvalue;	
	}
	public Point3d plus(Point3d v)
	{
		Point3d returnvalue=new Point3d();
		returnvalue.x=x+v.x;
		returnvalue.y=y+v.y;
		returnvalue.z=z+v.z; 
		return returnvalue;	
	}
	public void minusEquals(Point3d v)
	{
		x=x-v.x;
		y=y-v.y;
		z=z-v.z; 
	}
	public void plusEquals(Point3d v)
	{
		x=x+v.x;
		y=y+v.y;
		z=z+v.z; 
	}
	public Point3d times(double t){
		Point3d returnvalue=new Point3d();
		returnvalue.x=x*t;
		returnvalue.y=y*t;
		returnvalue.z=z*t; 
		return returnvalue;
	}
	public void Print(){
		System.out.print("("+x+","+y+","+z+")");
	}
	public double CalculateDistanceSquared(Point3d other){
		return (((x-other.x)*(x-other.x))+((y-other.y)*(y-other.y))+((z-other.z)*(z-other.z)));
	}
	
}
