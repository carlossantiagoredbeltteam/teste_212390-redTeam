package org.reprap.scanning.DataStructures;

import org.reprap.scanning.Geometry.Point3d;

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
 * Last modified by Reece Arnott 25th Feburary 2010
 * 
 ****************************************************************************************/

public class QuickSortPoints3D {
	private Point3d[] pointsarray;
	private int[] indexarray;
	private Point3d n;
	private Point3d pointonplane;
	//Constructors
	public QuickSortPoints3D(Point3d array[]){
		pointsarray=new Point3d[array.length];
		for (int i=0;i<pointsarray.length;i++)	pointsarray[i]=array[i].clone();
		n=new Point3d();
		pointonplane=new Point3d();
	}
	
	public int[] Sortby(char coordinate,int[] subsetofindexes){
		return Sort(subsetofindexes,coordinate);
	}
	
	public int[] SortbyX(int[] subsetofindexes){
		return Sort(subsetofindexes,'x');
	}
	public int[] SortbyY(int[] subsetofindexes){
		return Sort(subsetofindexes,'y');
	}
	
	public int[] SortbyZ(int[] subsetofindexes){
		return Sort(subsetofindexes,'z');
	}
	
	
	
	/**************************************************************************************************************************
	 * 
	 * Private methods from here on down
	 * 
	 * *************************************************************************************************************************/
	
	
	
	// This sorts an array of indexes that are assumed to be a subset of the point array.
	// based on the x, y, or z coordinates of the original points, or the distance to the plane - which is determined by the boolean variables

	// if coordinate is 'p' the distance to the plane is evaluated.
//	 if coordinate is 'z' sort on z coordinate
//	 if coordinate is 'y' sort on y coordinate
//	 if coordinate is 'x' sort on x coordinate

	
	private int[] Sort(int intarray[],char coordinate){
		// Create the indexarray, making sure the indexes are within range
		int maxlength=0;
		for (int i=0;i<intarray.length;i++) if ((intarray[i]<pointsarray.length) && (intarray[i]>=0)) maxlength++;
		indexarray=new int[maxlength];
		int i=0;
		for (int j=0;j<maxlength;j++) if ((intarray[j]<pointsarray.length) && (intarray[j]>=0)) {
			indexarray[i]=intarray[j];
			i++;
		}
		// Do the quick sort on this subset of the points
		if (indexarray.length>1) QuickSort(0,indexarray.length-1,coordinate);
		// return the indexes
		return indexarray;
	}

	
	
	//	 Java Implementation of recursive QuickSort pulled off the internet and modified
	
	private void QuickSort(int left, int right, char coordinate){
	    	int index = partition(left, right,coordinate);
	        if (left < index - 1)
	              QuickSort( left, index - 1,coordinate);
	        if (index < right)
	              QuickSort( index, right,coordinate);
		  } // end QuickSort recursive method

		  // This is a method that is only called from QuickSort
		   private int partition( int left, int right, char coordinate)
		  {
		        int i = left, j = right;
		        int tmp;
		        double pivot = get(pointsarray[indexarray[(left + right) / 2]],coordinate);
		        while (i <= j) {
		              while (get(pointsarray[indexarray[i]],coordinate) < pivot)
		                    i++;
		              while (get(pointsarray[indexarray[j]],coordinate) > pivot)
		                    j--;
		              if (i <= j) {
		                    tmp = indexarray[i];
		                    indexarray[i] = indexarray[j];
		                    indexarray[j] = tmp;
		                    i++;
		                    j--;
		              }
		        };
		        return i;
		  } // end partition method
		  // Just used by the above method to get the target sort value of a 3d point
		  private double get(Point3d p, char coordinate){
			  double returnvalue=0;
			  switch(coordinate) {
			  	case 'x':returnvalue = p.x;break;
				case 'y':returnvalue = p.y;break;
				case 'z':returnvalue = p.z;break;
				case 'p':returnvalue=Math.abs(n.dot(p.minus(pointonplane)));break;   // distance from a plane is n.(P-V) where n is the normal to the plane of unit length, V is a point on the plane and P is the point
				default: System.out.println("Wrong coordinate character feed to method. Valid characters are x,y,z, and p");
			  }
			  return returnvalue;
		  }
	
}
