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
* Last modified by Reece Arnott 30th March 2010
*
* This is a simple class to create a 1D accumulator (i.e. a histograph)
* 	
***********************************************************************************/

public class Accumulator1D {
	private double minimum;
	private double maximum;
	private double step;
	private int[] accumulator;
	private int totalattempts;
	boolean empty;
	public Accumulator1D(double min, double max, double stepsize){
		minimum=min;
		maximum=max;
		step=stepsize;
		accumulator=new int[(int)((max-min)/stepsize)+1];
		resetAccumulatorCount();
	}
	
	public void resetAccumulatorCount(){
		for (int i=0;i<accumulator.length;i++) accumulator[i]=0; 
		empty=true;
		totalattempts=0;
	}
	public boolean increment(double a){
		totalattempts++;
		boolean returnvalue=(a<=maximum) && (a>=minimum);
		if (returnvalue){
			accumulator[(int)((a-minimum)/step)]++;
			empty=false;
		}
		return returnvalue;
	}
	public int GetCount(double a){
		if ((a<=maximum) && (a>=minimum))
			return	accumulator[(int)((a-minimum)/step)];
		else return 0;
	}
	public double GetPercentage(double a){
		if (totalattempts==0) return 0;
		else return (GetCount(a)/(double)(totalattempts))*100;
	}
	public double GetVotedMax(){
		int max=0;
		int maxindex=0;
		for (int i=0;i<accumulator.length;i++) 
			if (max<accumulator[i]) {
				max=accumulator[i];
				maxindex=i;
			}
		return((maxindex*step)+minimum+(step/2));
	}
	public boolean isEmpty(){
		return empty;
	}
	public int GetTotalAttempts(){
		return totalattempts;
	}
	
}