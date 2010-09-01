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
 * Last modified by Reece Arnott 12th August 2010
 * 
 * This class  is commented out because it needs the JOGL OS dependent libraries. If this code is to be used
 * the libraries need to be added. They can be downloaded from: https://jogl.dev.java.net/servlets/ProjectDocumentList?folderID=9260&expandFolder=9260&folderID=8798
 *  This was to be used in the Main class for debugging purposes only.
 *  
*************************************************************************************/
/*

import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.DataStructures.*;


import javax.swing.JFrame;

import java.awt.GraphicsEnvironment;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;
import javax.media.opengl.GLCanvas;
import javax.media.opengl.GLCapabilities;
import javax.media.opengl.GLDrawableFactory;
import javax.media.opengl.GLEventListener;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.Animator;

import Jama.*;

public class Graphics3DFeedback {
	private static final int displayfudgefactorY=24;
	private static final int displayfudgefactorX=8;
	//These are used for the initial display area size (set in the constructor). The problem is setting the display window size using the FrameSize method
	// sets the outside boundary of the window but that includes the title bar and any surrounding window edges so they have to be added
	// to the image size parameters to get the frame size.
	
	// These are set in the constructor and used elsewhere
	private final Point3d initialeyepoint;
	private final double maxdistance,maxdistancesquared; // This max distance is the maximum distance from the origin we can navigate to
	// image display stuff 
	private GLU glu= new GLU();	
	private Animator animator;
	public JFrame frame;
	
	// The scene we want to show - set in constructor
	private final AxisAlignedBoundingBox volumeofinterest,boundingvolumeofobject;
	private final AxisAlignedBoundingBox[] surfacevoxels;
	private final Point2d[] calibrationcirclecenters;
	private final Ellipse calibrationellipse;
	private final Point3d[] cameracentre;
	private final Point3dArray[] points3d;
	// These are the things that we change to navigate our way around the scene
	private Point3d eyepoint,up,lookat;
	// The GL elements containing the scene that are actually used to display it
	private int calibrationsheet,cameras,volumeofinterestwireframe,objectboundingvolumewireframe,cameralines,bordervoxels;
	private int[] pointsfoundforeachcamera;
	private int[] linesfromcameratopoints;
	
	
	
	
	// Constructor
	public Graphics3DFeedback(AxisAlignedBoundingBox volofinterest, AxisAlignedBoundingBox objectboundingvolume,Point2d[] circlecenters, Ellipse standardcalibrationcircleonprintedsheet, Point3d[] cameracentres, AxisAlignedBoundingBox[] surfacevoxel, Point3dArray[] points){
		volumeofinterest=volofinterest.clone();
		boundingvolumeofobject=objectboundingvolume.clone();
		cameracentre=new Point3d[cameracentres.length];
		double initialz=0;
		for (int i=0;i<cameracentre.length;i++){
			cameracentre[i]=cameracentres[i].clone();
			if (cameracentre[i].z>initialz) initialz=cameracentre[i].z;
		}
		initialeyepoint=new Point3d(0,0,initialz);
		maxdistance=initialz;
		maxdistancesquared=maxdistance*maxdistance;
		// Set the initial eyepoint to look directly down on the origin, oriented with the positive y axis going up.
		eyepoint=initialeyepoint.clone();
		up=new Point3d(0,1,0);
		lookat=new Point3d(0,0,0);
		calibrationcirclecenters=new Point2d[circlecenters.length];
		for (int i=0;i<circlecenters.length;i++) calibrationcirclecenters[i]=circlecenters[i].clone();
		calibrationellipse=standardcalibrationcircleonprintedsheet.clone();
		surfacevoxels=new AxisAlignedBoundingBox[surfacevoxel.length];
		for (int i=0;i<surfacevoxels.length;i++) surfacevoxels[i]=surfacevoxel[i].clone();
		// Load up the points and the correct number of gl elements to handle them
		points3d=new Point3dArray[points.length];
		for (int i=0;i<points3d.length;i++)	points3d[i]=points[i].clone();
		pointsfoundforeachcamera=new int[points3d.length];
		linesfromcameratopoints=new int[points3d.length];
			
	}
	
	
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
	    // So we are setting the window to be intitally 1/4 the size of the primary screen in the middle of the screen
	    framesizex=(screenwidth/2)+displayfudgefactorX; 
	    framesizey=(screenheight/2)+displayfudgefactorY;
	    
	   frame.setSize(framesizex,framesizey);
	   frame.setLocation((screenwidth - framesizex) / 2, (screenheight - framesizey) / 2);
       
	    animator = new Animator(drawable);
	    frame.setVisible(true);
		drawable.requestFocus();
		animator.start();	
		drawable.repaint();

	} // end of initGraphics method
*/
	
	/*********************************************************
	 * 
	 * JOGL OpenGL Listener class and methods
	 *
	 *********************************************************/
	
/*
	class OpenGLRenderer implements GLEventListener, MouseListener, MouseMotionListener {
		private int prevMouseX, prevMouseY;
		// These are the various items that can be toggled on and off
		private boolean  showwireframe,showsurfacevoxels;
		 private boolean[] visiblepoints,visiblelines; 
		
		private boolean mouseRButtonDown = false;
		private boolean mouseLButtonDown =false;
		private boolean updownrotation = false; // This is set to true so long as the up or down arrow keys are held down
		// Note that as some systems alternatively throw keyPressed/keyReleased events when a key is held down, the only sure way to unset it is to have
		// additional lines in each key and mouse querying method to set it to false
		// i.e. it will stay true until the user presses another key or the mouse buttons.
		
		// The following are used when updownrotation is true and are set the first time the up or down arrow key is pressed down
		// because the rotation is calculated as an angle around the axis of rotation vector calculated as at right angles to the initial eyepoint-lookat vector and the initial up vector
		private double angle=0;  
		private Point3d axisofrotationvector=new Point3d(0,0,0);
		private Point3d eyevector=new Point3d(0,0,0);  
		private Point3d upvector=new Point3d(0,0,0);
		
		private int steps=360; // How many steps around a circle do we want to take when using triangle fans to approximate the circle?
			
		
		// OpenGL Initialisation
		public void init(GLAutoDrawable drawable) { 
	
			float red[] = { 0.8f, 0.1f, 0.0f, 1.0f };
		    float green[] = { 0.0f, 0.8f, 0.2f, 1.0f };
		    float blue[] = { 0.2f, 0.2f, 1.0f, 1.0f };
		    float white[] = { 1.0f, 1.0f, 1.0f, 1.0f };
		    float black[] = { 0.0f, 0.0f, 0.0f, 1.0f };
		    float yellow[] ={ 1.0f, 1.0f, 0.0f, 1.0f };
			float grey[] ={ 0.5f, 0.5f, 0.5f, 1.0f };
			System.out.println("Set what is visible by default");
			// Set what is visible by default
			showwireframe=true;
			showsurfacevoxels=false;
			visiblepoints=new boolean[pointsfoundforeachcamera.length];
			visiblelines=new boolean[linesfromcameratopoints.length];
			for (int i=0;i<visiblepoints.length;i++) visiblepoints[i]=true;
			for (int i=0;i<visiblelines.length;i++) visiblelines[i]=false;
			
			GL gl=drawable.getGL();
	        gl.glClearColor (0, 0, 0, 0); // set the clear colour to black
	        gl.glPixelStorei(GL.GL_UNPACK_ALIGNMENT, 1);
		   //	gl.glEnable(GL.GL_DEPTH_TEST);
	       // gl.glDepthFunc(GL.GL_LEQUAL);
	        gl.glShadeModel(GL.GL_SMOOTH);
	        
		   	
	        System.out.println("Set up the camera points");
			// Set up the camera points
			cameras = gl.glGenLists(1);
			gl.glNewList(cameras, GL.GL_COMPILE);
			gl.glPointSize(10);
	    	gl.glBegin(GL.GL_POINTS);
	    	gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, red, 0);
	    	for (int i=0;i<cameracentre.length;i++)
	    		gl.glVertex3d(cameracentre[i].x,cameracentre[i].y,cameracentre[i].z);
	    	gl.glEnd();
	    	gl.glEndList();
	    	
	    	System.out.println("Set up the wireframe for the bounding volume of the object");
			// Set up the wireframe for the bounding volume of the object
	    	Point3d[] vertices=boundingvolumeofobject.GetCornersof3DBoundingBox();
	    	int[][] pointpair=boundingvolumeofobject.GetPointPairIndicesFor3DWireFrameLines();
	    	objectboundingvolumewireframe = gl.glGenLists(1);
			gl.glNewList(objectboundingvolumewireframe, GL.GL_COMPILE);
			gl.glLineWidth(3);
			gl.glBegin(GL.GL_LINES);
			gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, green, 0);
			for (int i=0;i<12;i++){
	    		gl.glVertex3d(vertices[pointpair[i][0]].x,vertices[pointpair[i][0]].y,vertices[pointpair[i][0]].z);
	    		gl.glVertex3d(vertices[pointpair[i][1]].x,vertices[pointpair[i][1]].y,vertices[pointpair[i][1]].z);
	    	}
	    	gl.glEnd();
	    	gl.glEndList();

	    	System.out.println("Set up the wireframe for the volume of interest");
			// Set up the wireframe for the volume of interest
	    	vertices=volumeofinterest.GetCornersof3DBoundingBox();
	    	pointpair=volumeofinterest.GetPointPairIndicesFor3DWireFrameLines();
	    	volumeofinterestwireframe = gl.glGenLists(1);
			gl.glNewList(volumeofinterestwireframe, GL.GL_COMPILE);
			gl.glLineWidth(3);
			gl.glBegin(GL.GL_LINES);
			gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, yellow, 0);
			for (int i=0;i<12;i++){
	    		gl.glVertex3d(vertices[pointpair[i][0]].x,vertices[pointpair[i][0]].y,vertices[pointpair[i][0]].z);
	    		gl.glVertex3d(vertices[pointpair[i][1]].x,vertices[pointpair[i][1]].y,vertices[pointpair[i][1]].z);
	    	}
	    	gl.glEnd();
	    	gl.glEndList();
			
	    	System.out.println("Set up the calibration sheet");
			// Set up the calibration sheet
	    	calibrationsheet = gl.glGenLists(1);
			    gl.glNewList(calibrationsheet, GL.GL_COMPILE);
			  gl.glNormal3f(0.0f, 0.0f, 1.0f);
			   // Create the white background for the calibration sheet (using the first 4 vertices of the volume of interest as the floor for the calibration sheet)
				gl.glBegin(GL.GL_QUADS);
				 gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, white, 0);
				for (int i=0;i<4;i++)
					gl.glVertex3d(vertices[i].x,vertices[i].y,vertices[i].z);
				 gl.glEnd();
		    
				// Create the black circles in the calibration sheet
		       for (int i=0;i<calibrationcirclecenters.length;i++){
		    	   // There is no circle or ellipse primitive so we will create an ellipse by using a triangle fan
		    	    gl.glBegin(GL.GL_TRIANGLE_FAN);
		    	   gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, black, 0);
			       gl.glVertex3d(calibrationcirclecenters[i].x,calibrationcirclecenters[i].y,0);
			       Ellipse temp=calibrationellipse.clone();
			       temp.ResetCenter(calibrationcirclecenters[i]);
					//For each step draw a triangle from the fan.
					for (int step = 0; step < steps; step++) {
						double angle = (2 * Math.PI / steps) * step;
						Point2d circumferencepoint=temp.GetEllipseEdgePointPolar(angle);
						gl.glVertex3d(circumferencepoint.x,circumferencepoint.y, 0);
					}
					Point2d circumferencepoint=temp.GetEllipseEdgePointPolar((double)0);
					gl.glVertex3d(circumferencepoint.x,circumferencepoint.y, 0);
					// End the list of triangles.
					gl.glEnd();
				}// end for each circle
				gl.glEndList();
			   
				System.out.println("Set up lines from the cameras to the corners of the calibration sheet (the first 4 vectices of the volume of interest)");
			// Set up lines from the cameras to the corners of the calibration sheet (the first 4 vectices of the volume of interest)
				cameralines = gl.glGenLists(1);
				gl.glNewList(cameralines, GL.GL_COMPILE);
				gl.glLineWidth(2);
				gl.glBegin(GL.GL_LINES);
				gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, red, 0);
				for (int i=0;i<cameracentre.length;i++){
					for (int j=0;j<4;j++){
						gl.glVertex3d(cameracentre[i].x,cameracentre[i].y,cameracentre[i].z);
						gl.glVertex3d(vertices[j].x,vertices[j].y,vertices[j].z);
					}
				}
				gl.glEnd();
				gl.glEndList();
				
				System.out.println("Set up cubes for the surface voxels");
				// Set up cubes for the surface voxels
				bordervoxels = gl.glGenLists(1);
				gl.glNewList(bordervoxels, GL.GL_COMPILE);
				gl.glBegin(GL.GL_QUADS);
				gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, grey, 0);
				for (int i=0;i<surfacevoxels.length;i++){
					MakeBox(gl,surfacevoxels[i]);
				}
				gl.glEnd();
				gl.glEndList();
				
				System.out.println("Set up the points found from each camera");
				// Set up the points found from each camera
				for (int i=0;i<pointsfoundforeachcamera.length;i++){
					pointsfoundforeachcamera[i]=gl.glGenLists(1);
					gl.glNewList(pointsfoundforeachcamera[i], GL.GL_COMPILE);
					gl.glPointSize(2);
			    	gl.glBegin(GL.GL_POINTS);
					gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, red, 0);
					for (int j=0;j<points3d[i].getLength();j++){
						Point3d temp=points3d[i].GetPoint(j);
						gl.glVertex3d(temp.x,temp.y,temp.z);
					} // end for j
					gl.glEnd();
					gl.glEndList();
				}
				
				System.out.println("Set up the lines found from each camera to the points found in that camera");
				// Set up the lines found from each camera to the points found in that camera
				for (int i=0;i<linesfromcameratopoints.length;i++){
					linesfromcameratopoints[i]=gl.glGenLists(1);
				
					gl.glNewList(linesfromcameratopoints[i], GL.GL_COMPILE);
					gl.glLineWidth(1);
					gl.glBegin(GL.GL_LINES);
					gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT_AND_DIFFUSE, red, 0);
					for (int j=0;j<points3d[i].getLength();j++){
						Point3d temp=points3d[i].GetPoint(j);
						gl.glVertex3d(cameracentre[i].x,cameracentre[i].y,cameracentre[i].z);
						gl.glVertex3d(temp.x,temp.y,temp.z);
					} // end for j
					gl.glEnd();
					gl.glEndList();
				}
		
				
			drawable.addKeyListener(new KeyAdapter() {
		        public void keyPressed(KeyEvent e) {
		          dispatchKey(e.getKeyCode(), e.getKeyChar());
		        }
		        // Normally would add single line keyReleased method: updownrotation=false but some set-ups (including mine) report alternate keyReleased/keyPressed events when a key is held down
		        // so have put this line in the key pressed method instead (encased in an if statement)
	           });
		    drawable.addMouseListener(this);
		    drawable.addMouseMotionListener(this);
		    
		 } // end init method

		// What happens when the window is resized
		public void reshape(GLAutoDrawable drawable, int x, int y, int width, int height) {
		    GL gl = drawable.getGL();
		    gl.glViewport(0, 0, width, height);
	     }
		
		  	   
		
		// What happens when you press certain keys
		private void dispatchKey(int keyCode, char k) {
			switch (keyCode) {
		   		case KeyEvent.VK_ESCAPE: // escape key pressed - reset eyepoint etc.
		   			eyepoint=initialeyepoint.clone();
		   			lookat=new Point3d(0,0,0);
		   			angle=0;
		   			up=new Point3d(0,1,0);
		   			updownrotation=false;
		   			break;
		   		case KeyEvent.VK_LEFT : // Arrow key left is pressed
	     		case KeyEvent.VK_KP_LEFT : // or left arrow on keypad
	     			if (!mouseLButtonDown){ // Rotate the lookat point around the up vector
	     				Point3d axisofrotation=up.clone();
	     				axisofrotation=axisofrotation.times(0.017453293/Math.sqrt(axisofrotation.lengthSquared())); // set length equal to 1 degree, converted to radians
		        		Matrix R=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(new MatrixManipulations().ConvertPointTo3x1Matrix(axisofrotation));
		        		lookat=eyepoint.minus(new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(eyepoint.minus(lookat)))));
		       			
		        	}
		        	else {//Rotate the up vector around the inverted eyepoint vector (inverted by the minus sign in the times function below)
		        		Point3d axisofrotation=eyepoint.minus(lookat);
		        		axisofrotation=axisofrotation.times(-0.017453293/Math.sqrt(axisofrotation.lengthSquared())); // set length equal to 1 degree, converted to radians, note the minus sign here to go in the opposite direction to the right arrow key
		        		Matrix R=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(new MatrixManipulations().ConvertPointTo3x1Matrix(axisofrotation));
		        		// set the length of the up vector to be 1 then rotate it
		        		up=up.times(1/Math.sqrt(up.lengthSquared()));
		        		up=new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(up)));
		        	}
	        	break;
		        case KeyEvent.VK_RIGHT :    // Arrow key right is pressed
		        case KeyEvent.VK_KP_RIGHT : // or right arrow on keypad
		        	if (!mouseLButtonDown){ // Rotate the lookat point around the up vector
		        		Point3d axisofrotation=up.clone();
		        		axisofrotation=axisofrotation.times(-0.017453293/Math.sqrt(axisofrotation.lengthSquared())); // set length equal to 1 degree, converted to radians, note the minus sign here to go in the opposite direction to the left arrow key
		        		Matrix R=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(new MatrixManipulations().ConvertPointTo3x1Matrix(axisofrotation));
		        		lookat=eyepoint.minus(new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(eyepoint.minus(lookat)))));
		       			
		        	}
		        	else {//	 Rotate the up vector around the eyepoint vector
		        		Point3d axisofrotation=eyepoint.minus(lookat);
		        		axisofrotation=axisofrotation.times(0.017453293/Math.sqrt(axisofrotation.lengthSquared())); // set length equal to 1 degree, converted to radians
		        		Matrix R=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(new MatrixManipulations().ConvertPointTo3x1Matrix(axisofrotation));
		        		//	set the length of the up vector to be 1 then rotate it
		        		up=up.times(1/Math.sqrt(up.lengthSquared()));
		        		up=new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(up)));
		        		
		        	}
	        	break;
		      
		        case KeyEvent.VK_UP :	// Arrow key up is pressed
		        case KeyEvent.VK_KP_UP :	// or up arrow key on keypad
		        	// If the right mouse button is pressed this is a zoom, if the left it is a translation in the direction of the point we're looking at
		        	if ((mouseRButtonDown) || (mouseLButtonDown)){
		        		// First find the vector from the lookat point to the eyepoint
		        		Point3d oldVector=eyepoint.minus(lookat);
		        		// then scale it and reset the eyepoint
		        		Point3d newVector=oldVector.times(0.9);
		        		if (newVector.lengthSquared()<100) newVector=oldVector.clone();
		        		eyepoint=lookat.plus(newVector);
		        		// Reset the lookat point if need to
		        		if (!mouseRButtonDown) lookat=eyepoint.minus(oldVector);
		        	}
		        	else {// if no mouse button is down it is a rotation of the lookat point in the direction of the up vector i.e. around the axis at right angles to the current eyevector and the upvector
		        		if (!updownrotation){ // set the initial eyevector and angle of 0
		        			updownrotation=true;
		        			angle=0;
		        			eyevector=eyepoint.minus(lookat);
		        			upvector=up.times(1/Math.sqrt(up.lengthSquared())); // make sure the upvector is of unit length
		            		axisofrotationvector=upvector.crossProduct(eyevector);
		        		}
			        	// increment the angle
		        		angle++;
		        		if (angle>360) angle=angle-360;
		        	}
		        	break;
		        case KeyEvent.VK_DOWN :    // Arrow key down is pressed
		        case KeyEvent.VK_KP_DOWN :	// or down arrow key on keypad
		        	// If the right mouse button is pressed this is a zoom, if the left it is a translation in the direction of the point we're looking at
		        	if ((mouseRButtonDown) || (mouseLButtonDown)){
			        	// First find the vector from the lookat point to the eyepoint
		        		Point3d oldVector=eyepoint.minus(lookat);
		        		// then scale it and reset the eyepoint
		        		Point3d newVector=oldVector.times(1.1);
		        		eyepoint=lookat.plus(newVector);
		        		// Reset the lookat point if need to
		        		if (!mouseRButtonDown) lookat=eyepoint.minus(oldVector);
		        	}
		        	else {// if no mouse button is down it is a rotation of the lookat point in the direction of the up vector i.e. around the axis at right angles to the current eyevector and the upvector
		        		if (!updownrotation){ // set the initial eyevector and angle of 0
		        			updownrotation=true;
		        			angle=0;
		        			eyevector=eyepoint.minus(lookat);
		        			upvector=up.times(1/Math.sqrt(up.lengthSquared())); // make sure the upvector is of unit length
		            		axisofrotationvector=upvector.crossProduct(eyevector);
			        	}
		        		// decrement the angle
		        		angle--;
		        		if (angle<=0) angle=360+angle;
		        	}
		        	break;
		      
		       } // end switch
		   switch(k) {
		   	case 'w':
		   	case 'W':
		   		showwireframe=!showwireframe;
		   		break;
		   	case 's':
		   	case 'S':
		   		showsurfacevoxels=!showsurfacevoxels;
		   		break;
		   	case 'p':
		   	case 'P':
		   		boolean set=!visiblepoints[0];
		   		for (int i=0;i<visiblepoints.length;i++) visiblepoints[i]=set;
		   		break;
		   	case 'l':
		   	case 'L':
		   		set=!visiblelines[0];
		   		for (int i=0;i<visiblelines.length;i++) visiblelines[i]=set;
		   		break;
		   		
		   //	case 't':
		   //	case 'T':
		   //		testcounter++;
		   //		if (testcounter>teststuff.length) testcounter=0;
		   //		break;
		   	case '0': 
		   	case '1': 
		   	case '2': 
		   	case '3': 
		   	case '4': 
		   	case '5': 
		   	case '6': 
		   	case '7': 
		   	case '8': 
		   	case '9': 
		   		int index=Character.getNumericValue(k);
		   		// Toggle through three modes: neither the points nor the lines being visible, just the points visible, and the lines visible (as well as the points)
		   		if ((index<visiblepoints.length) && (index<visiblelines.length))
		   		{
		   			if (visiblelines[index]){ visiblepoints[index]=false; visiblelines[index]=false;}
		   			else if (visiblepoints[index]) visiblelines[index]=true;
		   			else visiblepoints[index]=true;
		   		}
		   		break;
		   }
		   // This if statement is here as some machines report alternate keyPressed/keyReleased events when a key is held down
		   // so updownrotation can't be set to false in the keyReleased method
		   // This assumes we can't press process two keys held down at the same time
		   if (updownrotation){
			   updownrotation=((keyCode==KeyEvent.VK_DOWN) || (keyCode==KeyEvent.VK_KP_DOWN) || (keyCode==KeyEvent.VK_UP) || (keyCode==KeyEvent.VK_KP_UP));
		   }
		   if (updownrotation){
			   // Do the rotation for the initial eyepoint to get the current eyepoint
			  // axisofrotationvector=axisofrotationvector.times((Math.PI*(angle/180))/Math.sqrt(axisofrotationvector.lengthSquared())); // set length equal to number of degrees, converted to radians
        	//	Matrix R=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(new MatrixManipulations().ConvertPointTo3x1Matrix(axisofrotationvector));
        	//	eyepoint=lookat.plus(new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(eyevector))));
        		// rotate the initial up vector as well to get the current up vector
        	//	up=new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(upvector)));
			   
			   // Rotate the lookat point around the eyepoint
			   axisofrotationvector=axisofrotationvector.times((Math.PI*(angle/180))/Math.sqrt(axisofrotationvector.lengthSquared())); // set length equal to number of degrees, converted to radians
			   Matrix R=new MatrixManipulations().getRotationMatrixFromRodriguesRotationVector(new MatrixManipulations().ConvertPointTo3x1Matrix(axisofrotationvector));
			   lookat=eyepoint.minus(new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(eyevector))));
       			// rotate the initial up vector as well to get the current up vector
	        		up=new Point3d(R.times(new MatrixManipulations().ConvertPointTo3x1Matrix(upvector)));

		   }
		 } // end dispatchKey

		
		 // OpenGL display function where the work is done but we've set up a lot of display lists in the init so its just a question of whether or not we display them.
		public void display(GLAutoDrawable drawable) {
			
		    GL gl = drawable.getGL();
		    gl.glClear(GL.GL_COLOR_BUFFER_BIT);

	       	gl.glEnable(GL.GL_LIGHTING);
		    gl.glEnable(GL.GL_LIGHT0);
		    gl.glShadeModel(GL.GL_FLAT);
		    // Set the eyepoint
		    // Change to projection matrix.
	        gl.glMatrixMode(GL.GL_PROJECTION);
	        gl.glLoadIdentity();
	        // Perspective.
	        float widthHeightRatio = (float) drawable.getWidth() / (float) drawable.getHeight();
	        glu.gluPerspective(45, widthHeightRatio, 1, maxdistance*2);
	         // Change back to model view matrix and draw the scene elements
	        gl.glMatrixMode(GL.GL_MODELVIEW);
	        gl.glLoadIdentity();
	        // The Lookat should go here rather than in the projection
	        glu.gluLookAt(eyepoint.x,eyepoint.y,eyepoint.z, lookat.x, lookat.y, lookat.z, up.x, up.y, up.z);
	        gl.glCallList(calibrationsheet);
	        gl.glCallList(cameras);
		    if (showwireframe)gl.glCallList(volumeofinterestwireframe);
		    if (showwireframe)gl.glCallList(objectboundingvolumewireframe);
		    if (showwireframe) gl.glCallList(cameralines);
	        if (showsurfacevoxels) gl.glCallList(bordervoxels);
	        for (int i=0;i<linesfromcameratopoints.length;i++) if (visiblelines[i]) gl.glCallList(linesfromcameratopoints[i]);
			for (int i=0;i<pointsfoundforeachcamera.length;i++) if (visiblepoints[i]) gl.glCallList(pointsfoundforeachcamera[i]);
			// If the testcounter is 0, don't show any of the test stuff, if its at its max, show everything, otherwise just show the one we're interested in at the moment.
			//if (testcounter!=0) for (int i=1;i<teststuff.length;i++) if ((testcounter==i) || (testcounter==teststuff.length)) gl.glCallList(teststuff[i]);
	        
	        
	        gl.glFlush();
	   } // end of display method
		
		public void displayChanged(GLAutoDrawable drawable, boolean modeChanged, boolean deviceChanged) {}

		  // Methods required for the implementation of MouseListener
		  public void mouseEntered(MouseEvent e) {}
		  public void mouseExited(MouseEvent e) {}

		  public void mousePressed(MouseEvent e) {
			  // Inserted as we can't tell when the up and down arrow keys are released but at this point they definately are
			  if (updownrotation) updownrotation=false;
			  prevMouseX = e.getX();
			  prevMouseY = e.getY();
		    if ((e.getModifiers() & e.BUTTON3_MASK) != 0) {
		      mouseRButtonDown = true;
		    }
		    else mouseLButtonDown = true;
		  }
		    
		  public void mouseReleased(MouseEvent e) {
			  // Inserted as we can't tell when the up and down arrow keys are released but at this point they definately are
			  if (updownrotation) updownrotation=false;
			  if ((e.getModifiers() & e.BUTTON3_MASK) != 0) {
		      mouseRButtonDown = false;
		    }
			  else mouseLButtonDown = false;
		  }
		    
		  public void mouseClicked(MouseEvent e) {}
		    
		  // Methods required for the implementation of MouseMotionListener
		  public void mouseDragged(MouseEvent e) {
			  // Inserted as we can't tell when the up and down arrow keys are released but at this point they definately are
			  if (updownrotation) updownrotation=false;
		   int x = e.getX();
		   int y = e.getY();
		   double dx=(prevMouseX-x);
		   double dy=(y-prevMouseY);
			 // adjust on plane formed using eyepoint as point on plane and eyepoint-lookat as normal rather than the x and y axis  
		   Plane plane=new Plane(eyepoint,eyepoint.minus(lookat));
		   Point3d neweyepoint=plane.GetParametricPointOnPlane(up,dx,dy);
		   if (!mouseRButtonDown){
		    	lookat=lookat.plus(neweyepoint.minus(eyepoint));
		    }
			eyepoint=neweyepoint.clone();
			prevMouseX = x;
		    prevMouseY = y;

		    
		  }
		    
		  public void mouseMoved(MouseEvent e) {}
	} // end Listener class


	public void exit(){

		animator.stop();
		frame.dispose();   
	}

	private void MakeBox(GL gl,AxisAlignedBoundingBox box){
		// It is assumed that this is called between a gl.glBegin(GL.GL_QUADS) and gl.glEnd()
		// So we need to write out 24 vertices in 6 lots of 4 for the six faces of the box
		Point3d[] vertices=box.GetCornersof3DBoundingBox();
		int[][] faces=box.GetPointQuadIndicesForBuildingFaces();
		for (int i=0;i<6;i++)
			for (int j=0;j<4;j++)
				gl.glVertex3d(vertices[faces[i][j]].x,vertices[faces[i][j]].y,vertices[faces[i][j]].z);
		
	} // end method
	
}
*/