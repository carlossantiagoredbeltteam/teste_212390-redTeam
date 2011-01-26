package org.reprap.scanning.GUI;
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
 * Last modified by Reece Arnott 8th December 2010
 * 
 * The code commented out needs the JOGL OS dependent libraries. If this code is to be used
 * the libraries need to be added. They can be downloaded from: https://jogl.dev.java.net/servlets/ProjectDocumentList?folderID=9260&expandFolder=9260&folderID=8798
 *  This was to be used in the Main class for debugging purposes only.
 *
 * Note that some formulae that traditionally use pi have been replaced to use tau where tau is defined as 2*pi. For an explanation of why this may make things clearer see That Tau Manifesto available at http://tauday.com/
 *  
*************************************************************************************/
import javax.swing.JFrame;
//import java.awt.GraphicsEnvironment;
//import java.awt.event.KeyAdapter;
//import java.awt.event.KeyEvent;
//import java.awt.event.MouseEvent;
//import java.awt.event.MouseListener;
//import java.nio.ByteBuffer;

//Need jogl.jar as a referenced library to import the below
//import javax.media.opengl.*;
//import javax.media.opengl.glu.*;
//import com.sun.opengl.util.Animator;

import org.reprap.scanning.DataStructures.Image;
import org.reprap.scanning.DataStructures.PixelColour;
import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.FileIO.ImageFile;

import Jama.Matrix;


public class GraphicsFeedback {
	private final static double tau=Math.PI*2;
	
	/* These first parameters are the default number of colour channels and format we are using - currently 3 in the format RGB 
	 *
	 * The JOGLcolourformat is a number recognised by the JOGL GL.glDrawPixels method as its third parameter.
	 * 
	 * Note that it is assumed that the colours are 8 bit values by a number of different methods
	 * and that if you want to change this it is possible but is currently hard-coded in.
	 */
	private static final int numcolours=3;
	
	//private static final int displayfudgefactorY=24;
	//private static final int displayfudgefactorX=8;
	/*These are used for the initial display area size (set in the constructor). The problem is setting the display window size using the FrameSize method
	 sets the outside boundary of the window but that includes the title bar and any surrounding window edges so they have to be added
	 to the image size parameters to get the frame size.
	*/
	//private int displayx=0;
	//private int displayy=0;
	/* These variables are used to display the image.
	 displayx and displayy are the coordinates of the image displayed in the lower left corner of the window (both set to 0 by the constructor).
	 and are changed by the arrow keys in the keyPress method of the JOGL derived class OpenGLRenderer.
	 
	 The imageheight and imagewidth parameters are read at the time the image is read by the three methods ShowImage, ShowGLimage, or ConverttoWorld
	*/
	private int imageheight, imagewidth;
	// image display stuff 
	//private GLU glu= new GLU();	
	//private Animator animator;
	//private static final int JOGLcolourformat=GL.GL_RGB; // this is the colour format to display them in.
	private byte[] GLimage; // image displayed via OpenGL calls
	
	public String savedimagefilename=""; // Used by the OverwriteImage method which calls the SaveImage method if it isn't blank. OverwriteImage is called if the 's' key is pressed. 
	// The variable needs to be set outside of this if it is to be used or by an external call to SaveImage
	
	public JFrame frame;
	public boolean print; // Show where mouse clicked if have image with user interaction (currently commented out) true and message when 
	
	public GraphicsFeedback(boolean printtrue){
		print=printtrue;
	}
	public GraphicsFeedback(){
		print=false;
	}
	
	
	public void ShowImage(Image givenimage){
		imageheight=givenimage.height;
		imagewidth=givenimage.width;
		GLimage=givenimage.ConvertImageForDisplay(numcolours);
	}
	public void ShowGLimage(byte[] image, int w, int h){
		GLimage=image.clone();
		imagewidth=w;
		imageheight=h;
	}
	public void ShowBinaryimage(boolean[][] image, int w, int h){
		GLimage=new byte[(h+1)*(w+1)*numcolours];
		imagewidth=w;
		imageheight=h;
		int tempindex,index;
		// 	Read pixels in a row at a time taking care to flip the image at the same time
		for (int y=0;y<h; y++)
		{
			tempindex=(h-y-1)*w*numcolours;
			// if the y coordinate is already stored internally as inverted then don't worry about flipping it for display
			for (int x=0;x<w;x++){
				index=tempindex+(x*numcolours);
				byte colour;
				if (image[x][y]) colour=(byte)255; else colour=(byte)0;
				for (int colours=0;colours<numcolours;colours++) GLimage[index+colours]=colour;
			} // end for x
		} // end for y
		
	}
	public void ShowGreyscaleimage(byte[][] image, int w, int h){
		GLimage=new byte[(h+1)*(w+1)*numcolours];
		imagewidth=w;
		imageheight=h;
		int tempindex,index;
		// 	Read pixels in a row at a time taking care to flip the image at the same time
		for (int y=0;y<h; y++)
		{
			tempindex=(h-y-1)*w*numcolours;
			// if the y coordinate is already stored internally as inverted then don't worry about flipping it for display
			for (int x=0;x<w;x++){
				index=tempindex+(x*numcolours);
				for (int colours=0;colours<numcolours;colours++) GLimage[index+colours]=image[x][y];
			} // end for x
		} // end for y
	}
	public void ShowPixelColourArray(PixelColour[][] map, int w, int h){
		GLimage=new byte[(h+1)*(w+1)*numcolours];
			imagewidth=w;
			imageheight=h;
			int tempindex,index;
			// 	Read pixels in a row at a time taking care to flip the image at the same time
			for (int y=0;y<h; y++)
			{
				tempindex=(h-y-1)*w*numcolours;
				// if the y coordinate is already stored internally as inverted then don't worry about flipping it for display
				for (int x=0;x<w;x++){
					index=tempindex+(x*numcolours);
					for (int colours=0;colours<numcolours;colours++) {
						switch(colours){
						case 0:GLimage[index+colours]=map[x][y].getRed();break;
						case 1:GLimage[index+colours]=map[x][y].getGreen();break;
						case 2:GLimage[index+colours]=map[x][y].getBlue();break;
						}
					}
				} // end for x
			} // end for y
			
	}
		public void PrintEllipse(Ellipse originalellipse, PixelColour colour,Point2d offset){
		Ellipse ellipse=originalellipse.clone();
		ellipse.OffsetCenter(offset);
		AxisAlignedBoundingBox box=ellipse.GetAxisAlignedBoundingRectangle();
		// Output solid ellipse
		for (int y=(int)(box.miny-1);y<(box.maxy+1);y++)
			for (int x=(int)(box.minx-1);x<(box.maxx+1);x++)
					if (ellipse.PointInsideEllipse(new Point2d(x,y))) Print(x,y,colour,0,0);
	}
	
	public void OutlineEllipse(Ellipse originalellipse,PixelColour colour,Point2d offset){
		Ellipse ellipse=originalellipse.clone();
		ellipse.OffsetCenter(offset);
		for (int t=0;t<360;t++){
			double tradians=((double)t/(double)360)*tau;
			Point2d edge=ellipse.GetEllipseEdgePointParametric(tradians);
			Print((int)edge.x,(int)edge.y,colour,0,0);
		}
	}
	public void OutlinePolygon(BoundingPolygon2D polygon,PixelColour colour){OutlinePolygon(polygon,colour,2,2);}
	public void OutlinePolygon(BoundingPolygon2D polygon,PixelColour colour,int w,int h){
		LineSegment2D[] lines=polygon.GetUnorderedBounding2DLineSegments();
		for (int i=0;i<lines.length;i++) PrintLineSegment(lines[i],colour,w,h);
	}
	
	public void PrintLineSegment(LineSegment2D line,PixelColour colour){ PrintLineSegment(line,colour,2,2);}
	public void PrintLineSegment(LineSegment2D line,PixelColour colour,int w, int h){ PrintLineSegment(line,colour,1000,w,h);}
	public void PrintLineSegment(LineSegment2D line,PixelColour colour, int numberofsteps,int w,int h){
		for (int i=0;i<=numberofsteps;i++){
				Point2d newpoint=line.GetPointOnLine((double)((double)i/(double)numberofsteps));
				Print(newpoint.x,newpoint.y,colour,0,0);
			}	
	}
	
	public void PrintLineSegment(Line3d line,PixelColour colour, Image image){ PrintLineSegment(new LineSegment2D(image.getWorldtoImageTransform(line.P.ConvertPointTo4x1Matrix()),image.getWorldtoImageTransform(line.GetPointonLine(1).ConvertPointTo4x1Matrix())),colour);}
	
	
	public void PrintSurfaceSubVoxels(Voxel rootvoxel, Image givenimage, PixelColour colour){
		int max=rootvoxel.getSubVoxelArraySize();
		for (int i=0;i<max;i++){
			for (int j=0;j<max;j++){
				for (int k=0;k<max;k++){
					if (rootvoxel.SubVoxel[i][j][k].isSurface()){
						AxisAlignedBoundingBox temp=rootvoxel.getSubVoxel(i,j,k);
						Matrix center=temp.GetMidpointof3DBoundingBox().ConvertPointTo4x1Matrix();
						Point2d point=givenimage.getWorldtoImageTransform(center);
						PrintPoint(point.x,point.y,colour);
					}
				}
			}
		}
	} // end of print surface subvoxels
	
	public void PrintInsideSubVoxels(Voxel rootvoxel, Image givenimage, PixelColour colour){
		int max=rootvoxel.getSubVoxelArraySize();
		for (int i=0;i<max;i++){
			for (int j=0;j<max;j++){
				for (int k=0;k<max;k++){
					if (rootvoxel.SubVoxel[i][j][k].isInside()){
						AxisAlignedBoundingBox temp=rootvoxel.getSubVoxel(i,j,k);
						Matrix center=temp.GetMidpointof3DBoundingBox().ConvertPointTo4x1Matrix();
						Point2d point=givenimage.getWorldtoImageTransform(center);
						PrintPoint(point.x,point.y,colour);
					}
				}
			}
		}
	} // end of print inside subvoxels
	
	public void PrintOutsideSubVoxels(Voxel rootvoxel, Image givenimage, PixelColour colour){
		int max=rootvoxel.getSubVoxelArraySize();
		for (int i=0;i<max;i++){
			for (int j=0;j<max;j++){
				for (int k=0;k<max;k++){
					if (rootvoxel.SubVoxel[i][j][k].isOutside()){
						AxisAlignedBoundingBox temp=rootvoxel.getSubVoxel(i,j,k);
						Matrix center=temp.GetMidpointof3DBoundingBox().ConvertPointTo4x1Matrix();
						Point2d point=givenimage.getWorldtoImageTransform(center);
						PrintPoint(point.x,point.y,colour);
					}
				}
			}
		}
	} // end of print outside subvoxels
	
	// We can only assume the image is at z=0 as we have lost any z value information
	public Point2d TransformCurrentImageUsingWorldToImageTransform(Image image, Point2d originaloffset){
		AxisAlignedBoundingBox size=new AxisAlignedBoundingBox();
		size.minx=originaloffset.x;
		size.miny=originaloffset.y;
		size.maxx=imagewidth+originaloffset.x;
		size.maxy=imageheight+originaloffset.y;
		Point2d[] corners=size.GetCornersof2DBoundingBox();
		for (int i=0;i<corners.length;i++){
			Matrix point=new Matrix(4,1);
			point.set(0,0,corners[i].x);
			point.set(1,0,corners[i].y);
			point.set(2,0,0);
			point.set(3,0,1);
			Point2d corner=image.getWorldtoImageTransform(point);
			if (i==0){
				size.minx=corner.x;
				size.miny=corner.y;
				size.maxx=corner.x;
				size.maxy=corner.y;
			}
			else size.Expand2DBoundingBox(corner);
			
		}
		int oldwidth=imagewidth;
		int oldheight=imageheight;
		imagewidth=(int)(size.maxx-size.minx+1);
		imageheight=(int)(size.maxy-size.miny+1);
		Point2d newoffset=new Point2d(size.minx,size.miny);
		byte[] newGLimage=new byte[(imageheight+1)*(imagewidth+1)*numcolours];
		
//		Calculate the transformed map by transforming each pixel in the old image and smearing it in the transformed map (currently over a 3x3 square)
		// Faster but less pretty. The more accurate way is to go through each pixel in the new image and using the inverse transformation interpolate its value from the nearest old image pixels  
		int smear=1;
		for (int y=0;y<oldheight;y++){
			int tempindex=(oldheight-y-1)*oldwidth*numcolours;
			for (int x=0;x<oldwidth;x++){
				byte[] colour=new byte[numcolours];
				int	index=tempindex+(x*numcolours);
				for (int i=0;i<numcolours;i++){
					colour[i]=GLimage[index+i];
				}
				// transform point
				Matrix point=new Matrix(4,1);
				point.set(0,0,x+originaloffset.x);
				point.set(1,0,y+originaloffset.y);
				point.set(2,0,0);
				point.set(3,0,1);
				Point2d newpoint=image.getWorldtoImageTransform(point);
				newpoint.minus(newoffset);
				// Smear point over a square
				for (int dx=-smear;dx<=smear;dx++){
					for (int dy=-smear;dy<=smear;dy++){
						int pixelx=(int)(newpoint.x+dx);
						int pixely=(int)(newpoint.y+dy);
						if ((pixelx>=0) && (pixelx<imagewidth) && (pixely>=0) && (pixely<imageheight)) {
							index=((imageheight-pixely-1)*imagewidth*numcolours)+(pixelx*numcolours);
							for (int i=0;i<numcolours;i++) newGLimage[index+i]=colour[i];
						} // end if
					} // end for dy
				} // end for dx
			} // end for y
		} // end for x
		GLimage=newGLimage.clone();
		return newoffset;
		} // end method
	
public void InvertImage(){
	byte[] newGLimage=new byte[(imageheight+1)*(imagewidth+1)*numcolours];
	int oldyindex,newyindex,newindex,oldindex;
	// 	Read pixels in a row at a time taking care to flip the image at the same time
	for (int y=0;y<imageheight; y++)
	{
		newyindex=(imageheight-y-1)*imagewidth*numcolours;
		oldyindex=y*imagewidth*numcolours;
		// if the y coordinate is already stored internally as inverted then don't worry about flipping it for display
		for (int x=0;x<imagewidth;x++){
			newindex=newyindex+(x*numcolours);
			oldindex=oldyindex+(x*numcolours);
			for (int colours=0;colours<numcolours;colours++) newGLimage[newindex+colours]=GLimage[oldindex+colours];
		} // end for x
	} // end for y
	GLimage=newGLimage.clone();

}
	
	
	
	
	public void SaveImage(String filename){
		savedimagefilename=filename;
		ImageFile imagefile=new ImageFile(filename);
		imagefile.width=imagewidth;
		imagefile.height=imageheight;
		if (numcolours==3) imagefile.Save3ChannelDisplayImage(GLimage);
		if (print) System.out.println("Saved "+filename);	
	}
	/*
	public void initGraphics(){ 
	    frame = new JFrame();
	    frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
	    GLDrawableFactory factory = GLDrawableFactory.getFactory();
	    GLCapabilities capabilities = new GLCapabilities();
	    GLCanvas drawable = new GLCanvas(capabilities);
	    drawable.addGLEventListener(new OpenGLRenderer());
	    frame.add(drawable);
	    int framesizex, framesizey;
	    int screenwidth,screenheight;
	    //screenheight=Toolkit.getDefaultToolkit().getScreenSize().height; 
	    //screenwidth=Toolkit.getDefaultToolkit().getScreenSize().width;
	    // The above getScreenSize is supposed to return the resolution of the primary display on multi-display setups but it seems to
	    // return the combined display resolution instead. Not good. Therefore use the alternative method below
	    screenwidth = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice().getDefaultConfiguration().getBounds().width;
	    screenheight = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice().getDefaultConfiguration().getBounds().height;
	    
	    // the additional pixels are for the title bar and window edges which are included in the setSize method for the frame we are about to create
	    framesizex=imagewidth+displayfudgefactorX; 
	    framesizey=imageheight+displayfudgefactorY;
	    if ((screenheight<framesizey) || (screenwidth<framesizex)) { 
	    	if (screenwidth<framesizex) framesizex=screenwidth;
	    	if (screenheight<framesizey) framesizey=screenheight;  
	    	System.out.println("The image cannot all be displayed but you can use the arrow keys to navigate around it.");
	    	System.out.println();
	      }

	    
	    
	    frame.setSize(framesizex,framesizey);
	    animator = new Animator(drawable);
	    frame.setVisible(true);
		drawable.requestFocus();
		animator.start();	
		drawable.repaint();

	} // end of initGraphics method
	private void OverwriteImage(){
		if (savedimagefilename!="") SaveImage(savedimagefilename);
		}
*/

	
	public void Print(double xpoint,double ypoint, PixelColour colour,int width, int height){
		for (int y=(int)(ypoint-height);y<=(int)(ypoint+height);y++){
			int tempindex=(imageheight-y-1)*imagewidth*numcolours;
			for (int x=(int)(xpoint-width);x<=(int)(xpoint+width);x++){
				if ((x>=0) && (x<imagewidth) && (y>=0) && (y<imageheight)){
					int index=tempindex+(x*numcolours);
					for (int colours=0;colours<numcolours;colours++) {
						switch(colours){
						case 0:GLimage[index+colours]=colour.getRed();break;
						case 1:GLimage[index+colours]=colour.getGreen();break;
						case 2:GLimage[index+colours]=colour.getBlue();break;
						} // end switch
					} // end for colours
					} // end if
			} // end for x
		} // end for y
		
	}
	
public void PrintPoint(double xpoint,double ypoint, PixelColour colour){
		int square=2; // point will be output as a nxn square where this determines n (actually n=square*2+1)
		Print(xpoint,ypoint,colour,square,square);
} // end PrintPoint method



public byte[] GetPointColour(int x,int y){
	int tempindex=(imageheight-y-1)*imagewidth*numcolours;
	int index=tempindex+(x*numcolours);
	byte[] colourarray=new byte[numcolours];
	for (int colours=0;colours<colourarray.length;colours++)
		colourarray[colours]=GLimage[index+colours];
return colourarray;
}



/*********************************************************
 * 
 * JOGL OpenGL Listener class and methods
 *
 *********************************************************/


/*
class OpenGLRenderer implements GLEventListener, MouseListener {

	
	// OpenGL Initialisation
	public void init(GLAutoDrawable drawable) { 
       GL gl=drawable.getGL();
        gl.glClearColor (0, 0, 0, 0);
        gl.glRasterPos2i(0, 0);
    	gl.glShadeModel(GL.GL_FLAT);
	   	gl.glPixelStorei(GL.GL_UNPACK_ALIGNMENT, 1);
	    drawable.addKeyListener(new KeyAdapter() {
	        public void keyPressed(KeyEvent e) {
	          dispatchKey(e.getKeyCode(), e.getKeyChar());
	        }
	      });
		   	drawable.addMouseListener(this);
	 } // end init method

	
	// What happens when you press certain keys
	private void dispatchKey(int keyCode, char k) {
	    int dx=0;
	    int dy=0;
	    int jumpfraction=8; // the bigger the number, the smaller the displacement produced by pressing the arrow keys.
	    switch (keyCode) {
	   		case KeyEvent.VK_ESCAPE: // escape key pressed - end this now!
	   			exit();
	   			break;
	   		case KeyEvent.VK_LEFT : // Arrow key left is pressed
     		case KeyEvent.VK_KP_LEFT : // or left arrow on keypad
	            dx=frame.getWidth()/jumpfraction;
	          break;
	        case KeyEvent.VK_RIGHT :    // Arrow key right is pressed
	        case KeyEvent.VK_KP_RIGHT : // or right arrow on keypad
	        	dx=-(frame.getWidth()/jumpfraction);
	        	break;
	        case KeyEvent.VK_UP :	// Arrow key up is pressed
	        case KeyEvent.VK_KP_UP :	// or up arrow key on keypad
		            dy=-(frame.getHeight()/jumpfraction);
		      break;
	        case KeyEvent.VK_DOWN :    // Arrow key down is pressed
	        case KeyEvent.VK_KP_DOWN :	// or down arrow key on keypad
			    	dy=frame.getHeight()/jumpfraction;
			   break;   
	        
			   
		    } // end switch
	   switch(k) {
  		case 's' : //Save image image
  		case 'S' :
  			OverwriteImage();
			break;
  	   }

	   if (imagewidth>frame.getWidth()){ // don't do anything if the picture fits
		   // if it doesn't fit, make sure you don't go off the edge of it
			if ((displayx+dx)>0) displayx=0;
			else if ((displayx+dx)<(frame.getWidth()-imagewidth)) displayx=frame.getWidth()-imagewidth;
			else displayx=displayx+dx;
		}
	   else displayx=0;
		if (imageheight>frame.getHeight()){ // don't do anything if the picture fits 
			// if it doesn't fit, make sure you don't go off the edge of it
			if ((displayy+dy)>0) displayy=0;
			else if ((displayy+dy)<(frame.getHeight()-imageheight)) displayy=frame.getHeight()-imageheight;
			else displayy=displayy+dy;
		}
		else displayy=0;
	 } // end dispatchKey

	
	/* OpenGL Display method. Note that we shift the left bottom of the window 
	 * to 0,0 initially (displayx and displayy initially set to 0)
	 * as the window is initially drawn with 0,0 centered and the image
	 * is drawn such that it's bottom left corner is there.
	 *
	 * After that the 'visible' part of the image is determined by the values of displayx and displayy (changed through use of arrow keys 
	 * in the dispatchKey method above) although we actually 'draw' the entire image each time.
	 *
	 * Also be aware that if the image is bigger than the screen width or height it will show as much of it as it can but
	 * selection via the mouse click method is more complicated due to y=0 being at the top of the image
	 * 
	 * Note the use of the global variable GLimage withing the gl.DrawPixels call.
	 * 
	 */
/*
	// OpenGL display function
	public void display(GLAutoDrawable drawable) {
       	GL gl = drawable.getGL();
    	gl.glClear(GL.GL_COLOR_BUFFER_BIT);
    	gl.glWindowPos2d(displayx,displayy); // show the portion of the image we are interested in
    	gl.glDrawPixels(imagewidth, imageheight, JOGLcolourformat, GL.GL_UNSIGNED_BYTE, ByteBuffer.wrap(GLimage)); // draw
    	gl.glPixelZoom(1,1);
    	gl.glFlush();
   } // end of display method

    public void mouseClicked(MouseEvent e) {
    	// Note that if the picture fits within the window, displayx and displayy will be zero
    	int x=(int)(frame.getMousePosition(true).getX()-displayx);
    	int y=(int)(frame.getMousePosition(true).getY()+imageheight-(frame.getHeight()-displayy));;
    	if (print) System.out.print("clicked: ("+x+","+y+") ");
   	    // find the closest detected corner point and highlight it and its set of intersecting corners(after deselecting the current one)
   	   }// end mouseclicked

    
    // Unused routines
    public void reshape(GLAutoDrawable drawable, int x, int y, int width, int height) {}
    public void displayChanged(GLAutoDrawable drawable, boolean modeChanged, boolean deviceChanged) {System.out.println("Display Changed");}
	// See http://java.sun.com/docs/books/tutorial/uiswing/events/mouselistener.html for mouse listener examples
		public void mousePressed(MouseEvent e) {}
    public void mouseReleased(MouseEvent e) {}
    public void mouseEntered(MouseEvent e) {}
    public void mouseExited(MouseEvent e) {}
    public void mouseDragged(MouseEvent e) {}
    public void mouseMoved(MouseEvent e) {}
} // end Listener class

public void exit(){

	animator.stop();
	frame.dispose();   
}
*/

}
