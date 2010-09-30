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
* Last modified by Reece Arnott 29th September 2010
* 
* This is a first step to processing colour images
*
************************************************************************************/

public class PixelColour {

	private byte greyscale;
	//TODO change/add to rgb
	// private byte r,g,b
	
	
	// Constructors
	public PixelColour(byte grey){
		greyscale=grey;
	}
	public PixelColour(){greyscale=(byte)0;}
	
	public PixelColour clone(){
		PixelColour returnvalue=new PixelColour(greyscale);
		return returnvalue;
	}
	
	public PixelColour WeightedAverageColour(double[] weights, PixelColour[] colours){
		double weightsum=0;
		double greysum=0;
		for (int i=0;i<colours.length;i++){
			if (i<weights.length){
				weightsum=weightsum+weights[i];
				greysum=greysum+((int)(colours[i].greyscale & 0xff)*weights[i]);
				// note the & 0xff of the signed bit as otherwise direct conversion to int assumes it -128..127 not 0..255 
				// can't just add 128 as it is 2's complement so -1<->255, -2<->254 .. -127<->128 etc.
			}
		}
		PixelColour returnvalue=new PixelColour();
		returnvalue.greyscale=(byte)((int)(greysum/weightsum));
		return returnvalue;
	}
	public PixelColour WeightedAverageColour(double[] weights, PixelColour[] colours, int truncate){
	PixelColour[] newcolours=colours.clone();
	double[] newweights=weights.clone();
		if (truncate<colours.length){
			newcolours=new PixelColour[truncate];
			for (int i=0;i<truncate;i++) newcolours[i]=colours[i].clone();
		}
		if (truncate<weights.length){
			newweights=new double[truncate];
			for (int i=0;i<truncate;i++) newweights[i]=weights[i];
		}
		return WeightedAverageColour(newweights,newcolours);
	}
	public byte getGreyscale(){
		return greyscale;
	}
	public byte getRed(){
		return greyscale;
	}
	public byte getGreen(){
		return greyscale;
	}
	public byte getBlue(){
		return greyscale;
	}
	public boolean CompareColours(PixelColour other, int threshold){
		int left=(int)greyscale & 0xff;
		int right=(int)other.greyscale& 0xff;
		return (Math.abs(right-left)<=threshold);
	}
	public boolean CompareGreyscale(int greyscalevalue, int threshold){
		return (Math.abs((int)(greyscale & 0xff)-greyscalevalue)<=threshold);
	}
	public boolean CompareGreyscale(byte greyscalevalue, int threshold){
		return CompareGreyscale((int)greyscalevalue & 0xff,threshold);
	}
	public boolean CompareGreyscale(PixelColour other, int threshold){
		return CompareGreyscale(other.greyscale,threshold);
	}
}
