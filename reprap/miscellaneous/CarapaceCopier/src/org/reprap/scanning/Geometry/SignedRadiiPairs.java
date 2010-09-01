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
 * Last modified by Reece Arnott 16th October 2009
 *  Used by the LensDistortion class for calculation of the distortion matrix.
 *
 *TODO - Add in provision for non-square pixels??
 *
 ******************************************************************************/

public class SignedRadiiPairs {

	public double[] radiione;
	public double[] radiitwo;
	public boolean[] positive;
	public int[] indexarray;
	
	// Constructor
public SignedRadiiPairs (PointPair2D[] pointpairs, Point2d centerforone, Point2d centerfortwo){
	radiione=new double[pointpairs.length];
	radiitwo=new double[pointpairs.length];
	positive=new boolean[pointpairs.length];
	indexarray=new int[pointpairs.length];
	for (int i=0;i<pointpairs.length;i++){
		// Calculate radii from the point pairs 
		radiione[i]=Math.sqrt(pointpairs[i].pointone.CalculateDistanceSquared(centerforone));
		radiitwo[i]=Math.sqrt(pointpairs[i].pointtwo.CalculateDistanceSquared(centerfortwo));
		// Calculate sign from the point pairs
		// Defined as the sign of the dot product of the two points
		positive[i]=(pointpairs[i].pointone.dot(pointpairs[i].pointtwo)>0);
		// Initialise the indexarray
		indexarray[i]=i;
	} // end for loop
	
} // end of constructor

// Sort the indexes based either on one of the two radii arrays with the option of whether it should be signed or unsigned
public int[] SortIndexes(boolean unsigned, boolean useradiione){
	if (indexarray.length>1) QuickSort(0,indexarray.length-1,unsigned, useradiione);
	// return the indexes
	return indexarray;
}
// This sorts the entire array and returns the sorted version of one of them
public double[] SortAndReturn(boolean unsignedsort, boolean useradiionetosort, boolean unsignedreturn, boolean returnradiione){
	// Create the indexarray
	indexarray=SortIndexes(unsignedsort,useradiionetosort);
	double[] returnvalue=new double[indexarray.length];
	for (int i=0;i<indexarray.length;i++) {
		if (returnradiione) returnvalue[i]=radiione[indexarray[i]];
		else returnvalue[i]=radiitwo[indexarray[i]];
		if ((!unsignedreturn) && (!positive[indexarray[i]])) returnvalue[i]=0-returnvalue[i];
	}
	return returnvalue;
}

// Java Implementation of recursive QuickSort pulled off the internet and modified
// so that it will sort based on the correct value (radiione or two, signed or unsigned)
private void QuickSort(int left, int right, boolean unsigned, boolean useradiione){
    	int index = partition(left, right, unsigned, useradiione);
        if (left < index - 1)
              QuickSort( left, index - 1, unsigned, useradiione);
        if (index < right)
              QuickSort( index, right, unsigned, useradiione);
	  } // end QuickSort recursive method

	  // This is a method that is only called from QuickSort
	  private int partition( int left, int right, boolean unsigned, boolean useradiione)
		  {
		        int i = left, j = right;
		        int tmp;
		        double pivot=getValue(unsigned,useradiione,indexarray[(left + right) / 2]);
		        while (i <= j) {
		              while (getValue(unsigned,useradiione,indexarray[i]) < pivot)
		                    i++;
		              while (getValue(unsigned,useradiione,indexarray[j]) > pivot)
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
		  

public double getValue(boolean unsigned, boolean useradiione, int index){
	double value;
	if (useradiione) value=radiione[index];
	else value=radiitwo[index];
	if ((!unsigned) && (!positive[index])) value=0-value;
	return value;
}

	
} // end class
