package org.reprap.scanning.FileIO;
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
* Last modified by Reece Arnott 11th October 2010
*  
*************************************************************************************/
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.color.ColorSpace;
import java.awt.image.BufferedImage;
import java.awt.image.BufferedImageOp;
import java.awt.image.ColorConvertOp;
import java.awt.image.ConvolveOp;
import java.awt.image.Kernel;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import org.reprap.scanning.DataStructures.PixelColour;

public class ImageFile {
	private static final int bufferedimageformat=BufferedImage.TYPE_INT_RGB; // this is the colour format the internal representation of the image is in.
	private String filename;
	public int width;
	public int height;
	public ImageFile(String name){
		filename=name;
	}
	
	
	// This reads in an image, potentially blurs it, and returns one channel of colour
	public PixelColour[][] ReadImageFromFile(float[] filter){
		BufferedImage image=null;
		PixelColour[][] imagemap=new PixelColour[0][0];
		width=0;
		height=0;
			try{
				Image img=Toolkit.getDefaultToolkit().getImage(filename);
				ImageIcon icon=new ImageIcon(img); // just a way of actually loading the image
				width=img.getWidth(null);
				height=img.getHeight(null);
				image = new BufferedImage(width,height,bufferedimageformat);
				// Copy image from disk to memory structure
				Graphics G= image.createGraphics();
				G.drawImage(img, 0, 0, null); // Paint the image onto the buffered image
				G.dispose();
				
				// Apply the filter - if it isn't null
				if (filter.length!=0){
					// It is assumed the filter represents a nxn blurring mask incorporating the neighbouring pixels where n is an odd number and the pixel to apply the mask to is the centre of the mask.
					int n=(int)(Math.sqrt(filter.length));
					BufferedImageOp blur = new ConvolveOp( new Kernel(n,n,filter));
					image=blur.filter(image,null);
				}
				// Convert the BufferedImage to a 2D PixelColour array - note that by doing this y is the same direction as the initial buffered image i.e. 0 at top increasing down the image
				imagemap=new PixelColour[width][height];
				int temp[]= new int[width*height];
				temp=image.getRGB(0,0,width,height,temp,0,width); //read the pixels into the int array
				// This is the easiest native method to do this but we want to read the pixels into a 2d array with the colour channels seperated and the greyscale value pre-calculated
				for(int y=0;y<height;y++)
					for(int x=0;x<width;x++)
						imagemap[x][y]=new PixelColour(temp[(y*width)+x]);
			}
		catch (Exception e) {
				System.out.println("Error reading in file "+filename);
				System.out.println(e);
				}
		return imagemap;
	} // end of ReadImageFromFile

	// This saves a displayed image (i.e. y coordinates flipped) with RGB colour values 
	public void Save3ChannelDisplayImage(byte[] GLimage){
	int tempindex,index;
	int numcolours=3;
	try{
		BufferedImage input=new BufferedImage(width,height,BufferedImage.TYPE_3BYTE_BGR);
		for (int y=0;y<height;y++){
			tempindex=(height-y-1)*width*numcolours;
			// Flip the y coordinate
			for (int x=0;x<width;x++){
				int pixelvalue=0;
				index=tempindex+(x*numcolours);
				for (int colours=0;colours<numcolours;colours++)
					pixelvalue=pixelvalue+(int)((int)(GLimage[index+colours] & 0xff)*(int)(Math.pow(256,(numcolours-colours-1)))); // This assumes the GLImage array of bytes are stored as RGB
				input.setRGB(x,y,pixelvalue);
			}
		}
		
		File outputFile = new File(filename);
		ImageIO.write(input, "jpg", outputFile);
	}
	catch (IOException e) {
		System.out.println("Error saving file "+filename);
		System.out.println(e);
		}
	} // end method
	
	public boolean IsInvalid(){
		 Image img=Toolkit.getDefaultToolkit().getImage(filename);
    	 ImageIcon icon=new ImageIcon(img); // just a way of actually loading the image
    	 int width=img.getWidth(null);
    	 int height=img.getHeight(null);
	
    	 return ((width==-1) && (height==-1));
	}
	
}
