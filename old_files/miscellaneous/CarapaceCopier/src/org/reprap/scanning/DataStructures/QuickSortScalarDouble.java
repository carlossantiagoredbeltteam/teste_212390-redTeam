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
 * Last modified by Reece Arnott 23rd April 2010
 * 
 ****************************************************************************************/
public class QuickSortScalarDouble {
	private double[] valuearray;
	private int[] indexarray;
	
	//Constructors
	public QuickSortScalarDouble(double array[]){
		valuearray=new double[array.length];
		for (int i=0;i<valuearray.length;i++)	valuearray[i]=array[i];
	}
	// special constructor for sorting 3 numbers
	public QuickSortScalarDouble(double a, double b, double c){
		valuearray=new double[3];
		valuearray[0]=a;
		valuearray[1]=b;
		valuearray[2]=c;
	}
	

	//	 This sorts the entire value array and returns the indexes
	public int[] Sort(){
		// Create the indexarray
		indexarray=new int[valuearray.length];
		for (int i=0;i<indexarray.length;i++) indexarray[i]=i;
		// Do the quick sort on this
		if (indexarray.length>1) QSort(0,indexarray.length-1);
		// return the indexes
		return indexarray;
	}
//	 This sorts the entire vector array and returns the sorted version.
	public double[] SortAndReturn(){
		// Create the indexarray
		indexarray=Sort();
		double[] returnvalue=new double[indexarray.length];
		for (int i=0;i<indexarray.length;i++) returnvalue[i]=valuearray[indexarray[i]];
		return returnvalue;
	}
//	 Java Implementation of recursive QuickSort pulled off the internet
	private void QSort(int left, int right){
	    	int index = partition(left, right);
	        if (left < index - 1)
	              QSort( left, index - 1);
	        if (index < right)
	              QSort( index, right);
		  } // end QuickSort recursive method

		  // This is a method that is only called from QuickSort
		  private int partition( int left, int right)
			  {
			        int i = left, j = right;
			        int tmp;
			        double pivot = valuearray[indexarray[(left + right) / 2]];
			        while (i <= j) {
			              while (valuearray[indexarray[i]] < pivot)
			                    i++;
			              while (valuearray[indexarray[j]] > pivot)
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
