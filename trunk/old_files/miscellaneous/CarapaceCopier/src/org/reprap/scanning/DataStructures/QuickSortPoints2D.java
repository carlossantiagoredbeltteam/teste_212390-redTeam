package org.reprap.scanning.DataStructures;

import org.reprap.scanning.Geometry.Point2d;

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
 * Last modified by Reece Arnott 14th May 2010
 * 
 ****************************************************************************************/

public class QuickSortPoints2D {
	private Point2d[] pointsarray;
	private int[] indexarray;
	//Constructors
	public QuickSortPoints2D(Point2d array[]){
		pointsarray=new Point2d[array.length];
		for (int i=0;i<pointsarray.length;i++)	pointsarray[i]=array[i].clone();
	}
	
	public int[] SortbyX(int[] subsetofindexes){
		return Sort(subsetofindexes,false);
	}
	public int[] SortbyY(int[] subsetofindexes){
		return Sort(subsetofindexes,true);
	}
	public int[] SortbyX(){
		indexarray=new int[pointsarray.length];
		for (int i=0;i<indexarray.length;i++) indexarray[i]=i;
		// Do the quick sort on this
		if (indexarray.length>1) QuickSort(0,indexarray.length-1,true);
		// return the indexes
		return indexarray;
	}
	public int[] SortbyY(){
		indexarray=new int[pointsarray.length];
		for (int i=0;i<indexarray.length;i++) indexarray[i]=i;
		// Do the quick sort on this
		if (indexarray.length>1) QuickSort(0,indexarray.length-1,false);
		// return the indexes
		return indexarray;
	}
	
	
	
	/**************************************************************************************************************************
	 * 
	 * Private methods from here on down
	 * 
	 * *************************************************************************************************************************/
	
	
	
	// This sorts an array of indexes that are assumed to be a subset of the point array.
	// based on the x or y value of the original points- which is determined by the boolean variable

	//	 if X=true sort on x coordinate, else sort on Y
 

	
	private int[] Sort(int intarray[], boolean X){
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
		if (indexarray.length>1) QuickSort(0,indexarray.length-1,X);
		// return the indexes
		return indexarray;
	}

	
	
	//	 Java Implementation of recursive QuickSort pulled off the internet and modified
	
	private void QuickSort(int left, int right, boolean X){
	    	int index = partition(left, right, X);
	        if (left < index - 1)
	              QuickSort( left, index - 1, X);
	        if (index < right)
	              QuickSort( index, right, X);
		  } // end QuickSort recursive method

		  // This is a method that is only called from QuickSort
		   private int partition( int left, int right, boolean X)
		  {
		        int i = left, j = right;
		        int tmp;
		        double pivot = get(pointsarray[indexarray[(left + right) / 2]],X);
		        while (i <= j) {
		              while (get(pointsarray[indexarray[i]],X) < pivot)
		                    i++;
		              while (get(pointsarray[indexarray[j]],X) > pivot)
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
		  private double get(Point2d p, boolean X){
			  double returnvalue;
			  if (X) returnvalue=p.x;
			  else returnvalue=p.y;
			  return returnvalue;
		  }
	
}
