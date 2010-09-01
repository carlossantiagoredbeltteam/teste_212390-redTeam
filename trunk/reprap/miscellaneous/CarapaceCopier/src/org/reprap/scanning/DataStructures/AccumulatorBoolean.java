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
* Last modified by Reece Arnott 7th April 2010
*
* This is a slightly different version of an accumulator. Rather than doing a simple histogram, 
* it sets and counts how many of a finite number of boolean elements have been set to true
* 	
***********************************************************************************/

public class AccumulatorBoolean {
	private double minimum;
	private double maximum;
	private double step;
	private boolean[][] accumulator;
	private int totalbooleanelements;
	private int length;
	private int totalattempts;
	boolean empty;
	public AccumulatorBoolean(double min, double max, int numberofbooleanelements, double stepsize){
		minimum=min;
		maximum=max;
		step=stepsize;
		totalbooleanelements=numberofbooleanelements;
		length=(int)((max-min)/stepsize)+1;
		accumulator=new boolean[length][totalbooleanelements];
		resetAccumulator();
	}
	
	public void resetAccumulator(){
		for (int i=0;i<accumulator.length;i++) 
			for (int j=0;j<totalbooleanelements;j++)
				accumulator[i][j]=false; 
		empty=true;
		totalattempts=0;
	}
	public boolean Set(double a, int b, boolean value){
		totalattempts++;
		boolean returnvalue=(a<=maximum) && (a>=minimum) && (b>=0) && (b<totalbooleanelements);
		if (returnvalue){
			accumulator[(int)((a-minimum)/step)][b]=value;
			empty=false;
		}
		return returnvalue;
	}
	public int GetNumberOfTrue(double a){
		int count=0;
		if ((a<=maximum) && (a>=minimum)){
			int index=(int)((a-minimum)/step);
			for (int i=0;i<totalbooleanelements;i++) if (accumulator[index][i]) count++;
		}
		return count;
	}
	
	public boolean isEmpty(){
		return empty;
	}
	public int GetTotalAttempts(){
		return totalattempts;
	}
	
}