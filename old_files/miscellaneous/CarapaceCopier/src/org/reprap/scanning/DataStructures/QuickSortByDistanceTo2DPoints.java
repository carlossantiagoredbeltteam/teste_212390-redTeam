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
 * Last modified by Reece Arnott 9th Feburary 2010
 * 
 ****************************************************************************************/
import org.reprap.scanning.Geometry.Point2d;	
import org.reprap.scanning.Geometry.PointPair2D;

public class QuickSortByDistanceTo2DPoints {
	private Point2d[] vectorarray;
	private int[] indexarray;
	
	//Constructors
	public QuickSortByDistanceTo2DPoints(Point2d array[]){
		vectorarray=new Point2d[array.length];
		for (int i=0;i<vectorarray.length;i++)	vectorarray[i]=array[i].clone();
	}

	// This takes a subset of point pairs and prepares to sort the first n, based on distance to point one or point two.
	public QuickSortByDistanceTo2DPoints(PointPair2D array[], int arraylength, boolean usepointone){
		vectorarray=new Point2d[arraylength];
		for (int i=0;i<vectorarray.length;i++)	
			if (usepointone) vectorarray[i]=array[i].pointone.clone();
			else vectorarray[i]=array[i].pointtwo.clone();
	}
	
	// This sorts an array of indexes that are assumed to be a subset of the vector array.
	public int[] Sort(int intarray[], Point2d compare){
		// Create the indexarray, making sure the indexes are within range
		int maxlength=0;
		for (int i=0;i<intarray.length;i++) if ((intarray[i]<vectorarray.length) && (intarray[i]>=0)) maxlength++;
		indexarray=new int[maxlength];
		int i=0;
		for (int j=0;j<maxlength;j++) if ((intarray[j]<vectorarray.length) && (intarray[j]>=0)) {
			indexarray[i]=intarray[j];
			i++;
		}
		// Do the quick sort on this subset of the vectors
		if (indexarray.length>1) QuickSort(0,indexarray.length-1,compare);
		// return the indexes
		return indexarray;
	}
//	 This sorts the entire vector array.
	public int[] Sort(Point2d compare){
		// Create the indexarray
		indexarray=new int[vectorarray.length];
		for (int i=0;i<indexarray.length;i++) indexarray[i]=i;
		// Do the quick sort on this
		if (indexarray.length>1) QuickSort(0,indexarray.length-1,compare);
		// return the indexes
		return indexarray;
	}
//	 This sorts the entire vector array and returns the sorted version.
	public Point2d[] SortAndReturn(Point2d compare){
		// Create the indexarray
		indexarray=Sort(compare);
		Point2d[] returnvalue=new Point2d[indexarray.length];
		for (int i=0;i<indexarray.length;i++) returnvalue[i]=vectorarray[indexarray[i]].clone();
		return returnvalue;
	}
//	 Java Implementation of recursive QuickSort pulled off the internet and modified
//	 so that it will sort based on the distancesquared to the comparison point
	private void QuickSort(int left, int right, Point2d compare){
	    	int index = partition(left, right, compare);
	        if (left < index - 1)
	              QuickSort( left, index - 1, compare);
	        if (index < right)
	              QuickSort( index, right, compare);
		  } // end QuickSort recursive method

		  // This is a method that is only called from QuickSort
		  private int partition( int left, int right, Point2d compare)
			  {
			        int i = left, j = right;
			        int tmp;
			        double pivot = compare.CalculateDistanceSquared(vectorarray[indexarray[(left + right) / 2]]);
			        while (i <= j) {
			              while (compare.CalculateDistanceSquared(vectorarray[indexarray[i]]) < pivot)
			                    i++;
			              while (compare.CalculateDistanceSquared(vectorarray[indexarray[j]]) > pivot)
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
			  

	
	
}
