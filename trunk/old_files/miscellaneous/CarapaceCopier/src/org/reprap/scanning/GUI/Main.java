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
 * Last modified by Reece Arnott 16th December 2010
 * 
 * Note that most of the layout commands were initially produced by NetBeans for JDK 6
 * and significantly modified by hand. For future reference if it needs to be done the other way the main things to change are:
 *    .addPreferredGap(type,pref,max) -> .addGap(min,pref,max)
 *    GroupLayout.LEADING/TRAILING and LayoutStyle.RELATED/UNRELATED -> GroupLayout.Alignment.LEADING/TRAILING/RELATED/UNRELATED
 *    and as the add method is not overloaded as much .add(group/component -> .addGroup(  or .addComponent(
 *
 *
 * The initial major work is done by pairs of 2d coordinates where pointone is the centre of a circle on the calibration sheet with the origin at the centre of the calibration sheet
 *  pointtwo is the estimated centre of an ellipse in the image with the points normally having the origin at the top left of the image but in most calculations the origin
 *  needs to be adjusted to the principal point of the image. This is initially estimated to be the centre of the image but can change, hence why it is stored seperately
 *  and the coordinates transformed when they need to be.
 *
 * This gives a set of known point pairs for each image which are used to 'calibrate' the camera which gives us, among other things, knowledge about where the cameras were in each image.
 * The visible calibration sheet is found for each image and this knowledge, along with camera position, used to create a crude estimation of the maximum volume occupied by the unknown object.
 * 
 * The following is currently commented out: 
 * 
 * Each image is then inspected for edge pixels, each of which when combine with camera position give a ray in space. The lines that go through \
 * the above maximum volume are then triangulated and give an estimation of 3d edge points in space.
 * 
 * The space is carved into tetrahedrons using these 3d points as vertices for the tetrahedrons and the knowledge of which points are visible from which cameras used to delete the tetrahedra that don't belong to the object.
 * The surviving tetrahedra are finally split into their triangular faces and these triangles are used to create the output STL file. 
 * 
 *  Note that some formulae that traditionally use pi have been replaced to use tau where tau is defined as 2*pi. For an explanation of why this may make things clearer see That Tau Manifesto available at http://tauday.com/
 * 
 * 
 ********************************************************************************/  
package org.reprap.scanning.GUI;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;


import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.io.File;

import javax.swing.*;

import java.awt.EventQueue;


import Jama.Matrix;


// These are the classes imported from the swing jar file.
// These will need to be changed if it is ever upgraded to JDK 6
import org.jdesktop.layout.GroupLayout;
import org.jdesktop.layout.GroupLayout.ParallelGroup;
import org.jdesktop.layout.LayoutStyle;
import javax.swing.filechooser.*;

import org.reprap.scanning.FeatureExtraction.*;
import org.reprap.scanning.FileIO.*;
import org.reprap.scanning.FileIO.MainPreferences.Papersize;
import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.Calibration.*;
import org.reprap.scanning.DataStructures.*;
 


public class Main extends JFrame {
	private final static double tau=Math.PI*2;
	private boolean save = true;
	private static final long serialVersionUID = 1L; //serial number needed as this a a serializable class
//	 These are standard global variables used in multiple methods 
    private double calibrationsheetwidth,calibrationsheetheight; // these relate to the real world physical dimensions of the printed calibration sheet calculated from the paper size, orientation and margins
    private double calibrationsheetxlength,calibrationsheetylength; // these relate to the calculated physical dimensions of circles on the printed calibration sheet.
    private int calibrationsheetpixelswidth,calibrationsheetpixelsheight; // These are only used in writing out images the same size as the calibration sheet if debugging
    private Ellipse[] calibrationcircles; // only needs to be a global variable if the DebugPointPairMatching is set to true
	private Ellipse[] imageellipses; // only needs to be a global variable if the DebugPointPairMatching is set to true
	private AxisAlignedBoundingBox volumeofinterest;
    private Point2d[] calibrationcirclecenters;
	private Point3d[] surfacepoints;
	private TriangularFace[] surfacetriangles;
	private MainPreferences prefs;
	private JProgressBar jProgressBar1,jProgressBar2; 
	private JLabel jLabelTitle,jLabelProgressBar1,jLabelProgressBar2,jLabelOutputLog;
	private JTextArea jTextAreaOutput;
	private JScrollPane jScrollPanel;
	private Image[] images; // used to store the images
	private JButton JButtonNext;
    private JButton JButtonCancel;
    private JButton JButtonPrevious;
    private Ellipse standardcalibrationcircleonprintedsheet; // This is the ellipical pattern of the circles of the calibration sheet taking into account the squash/stretch applied at print time.
    static int gap = 18; // size of the gap between edges of GUI containers in pixels. Also used as a bit of a hack for sizing GUI elements where needed
    
    // defined as global just so as can access from actionPerformed methods
    private JList filelist;
    private JComboBox Papersize;
	private JLabel widthlabel,heightlabel;
	
    
   //  private final boolean allsameresonsamecamera=false; // TODO - this should eventually be in the GUI as a tickbox and saved as part of the MainPreferences. Note that it also assumes that the image resolutions are the same for the calculation of the principal point etc.  
 //  private final int maxiterations=0;// TODO - this should eventually be added to the GUI and/or as part of the MainPreferences if it is used
	
	private boolean print=true; // Just for testing purposes
    
    // This defines how many chunks the shared second progress bar is broken up into for the 3 steps it is shared with
	 private final static int calibrationsheetinterrogationnumberofsteps=1;
	   private final static int calibrationnumberofsubsteps=6;
    private final static int objectvoxelisationnumberofsteps=2;
    private final static int numberofotherprogressbarsteps=2;
    
/* This enumerated list and associated setstep method is for the programmer to add to if any additional intermediate steps need to be added.
 *  Note that the last enum value should not be used for anything other than exiting the program.
 *  
 */ 

   public static enum steps {calibrationsheet, fileio, calibrationsheetinterrogation,calibration,objectfindingvoxelisation,texturematching,writetofile,end};
    private final static steps stepsarray[]=steps.values();
    private static steps laststep = steps.valueOf("end");
    private static steps firststep = steps.valueOf("calibrationsheet");
    private steps currentstep=firststep;
    /*
    *  This method is normally called when the next or previous buttons are clicked.
    * But it also called by setStep(laststep) when the program needs to exit
    * It calls the methods to redraw the Window depending on the which step it is at.
    * 
    * It is also complicated by the fact that the preferences file can specify that some of the steps can be skipped
    * and the default values taken from the preferences file for these steps.
    * 
    * This means that the 3D scanning can be easily linked into other programs which can just run this with after writing their own
    * preferences file.
    *
    */
	
    
    
    
//  This is the main method which runs the first GUI step.
 	public static void main(String[] args) {
 	if (args.length==0){
 		Thread.currentThread().setName("Main");
        
		 
        EventQueue.invokeLater(new Runnable(){ 
          public void run() {
         	 try {
             	 Thread.currentThread().setName("RepRap Scanning");
            	 new Main().setStep(firststep);
          	 }             
              catch (Exception ex) {
             	 JOptionPane.showMessageDialog(null, "Error in the main GUI: " + ex);
             	 ex.printStackTrace();
              	}
          }
          });	
 	}
 	else { // Use the arguments passed
 		// It is assumed that the first argument is the filename to the preferences file to load
 		final String filename=args[0];
 		Thread.currentThread().setName("Main");
        
		 
        EventQueue.invokeLater(new Runnable(){ 
          public void run() {
         	 try {
             	 Thread.currentThread().setName("RepRap Scanning");
            	 new Main(filename).setStep(firststep);
          	 }             
              catch (Exception ex) {
             	 JOptionPane.showMessageDialog(null, "Error in the main GUI: " + ex);
             	 ex.printStackTrace();
              	}
          }
          });
 	}
      }    
	// This constructor creates a new GUI by simply calling the initComponents() method after initialising the preferences.
	public Main() {
		prefs = new MainPreferences(stepsarray.length);
		initComponents();
	}
	public Main(String filename){
		if (filename!="") System.out.println("Using non-standard properties file "+filename);
		prefs = new MainPreferences(stepsarray.length, filename);
		initComponents();
	}
	
 	public void setStep (steps stepnumber) {
 			currentstep=stepnumber;
		
 			// Set the text on the Cancel and Previous Buttons
    		JButtonCancel.setText("Cancel");
			JButtonPrevious.setText("Previous");

			// Find whether or not the currentstep is the first non-skipped one.
			boolean first=true;
			for (int i=0;i<(currentstep.ordinal());i++) if (prefs.SkipStep[i]==false) first=false;
			
			// Set the Previous button to be disabled if it is
			JButtonPrevious.setEnabled(!first);
			
			// Find whether or not the currentstep is the last non-skipped one.
			boolean finish=true;
			for (int i=(currentstep.ordinal()+2);i<prefs.SkipStep.length;i++) 
				if (prefs.SkipStep[i]==false) finish=false;
				
			// Set the Next button to Finish if it is
			if (finish) JButtonNext.setText("Finish");
			else JButtonNext.setText("Next");	
			
			// ignore it if the proposed step is the first one and it is to be skipped (i.e. we are trying to go back but the currentstep is the first non-skipped step
			if (!(stepnumber.equals(firststep) && (prefs.SkipStep[stepnumber.ordinal()]))) currentstep = stepnumber;

			// if the previous button is disabled then this is the first step not skipped, so reset the firststep if need be
			if (!JButtonPrevious.isEnabled() && !firststep.equals(stepnumber)) firststep=stepnumber;

				
			String Title = "Reprap 3D Scanning from photos - Step "+(currentstep.ordinal()+1)+" of "+laststep.ordinal();
			setTitle(Title);
			try
			{
				switch(currentstep) {
				case calibrationsheet : 
					if ((prefs.SkipStep[currentstep.ordinal()]) && (prefs.calibrationpatterns.getSize()!=0)) setStep(stepsarray[currentstep.ordinal()+1]);
					else ChooseCalibrationSheet(); break;
				case fileio :
					if ((prefs.SkipStep[currentstep.ordinal()]) && (prefs.imagefiles.getSize()!=0)) setStep(stepsarray[currentstep.ordinal()+1]);
					else ChooseImagesAndOutputFile(); break;
				case calibrationsheetinterrogation : 
					FindCalibrationSheetCirclesEtc(); break;
					// There is an if statement in this step that reads values from a file if it is an automatic step
					// Note that the end is an unconditional call to this method with an incremented step
					// i.e. automatically go onto the next step
					// There is an if statement 
				case calibration : 
					Calibration(); break;  // this is one of the big ones
					// There is an if statement in this step that reads values from: a properties file and two image files per original image file if it is an automatic step
					// Note that the end is an unconditional call to this method with an incremented step
					// i.e. automatically go onto the next step
				case objectfindingvoxelisation : 
					FindCoarseVoxelisedObject(); break; // this is another of the big ones
					// Note that the end is a call to this method with an incremented step if the next step is set to Automatic
					// i.e. exit without the user pressing the exit button
				case texturematching :SurfacePointTextureMatching();break;
				case writetofile:
					OutputSTLFile(); 
					GraphicsFeedback(); // image feedback if the debug options are set
 					 break;
				
				case end : end(); break;
				}
			}
			catch (Exception e) {
				System.out.println("Error in step "+(currentstep.ordinal()+1));
				System.out.println(e);
			}
			
			
    	} // end of method
 
 
	
 	
//  This method redraws the Window for the step in which the calibration pattern is chosen
 	 private void ChooseCalibrationSheet() {
    	jLabelTitle.setText("Selection of Calibration Pattern");
		JButton jButtonBrowse;
		JComboBox jComboBox;
		JLabel printinglabel=new JLabel();
		widthlabel=new JLabel();
		heightlabel=new JLabel();
		JLabel horizontalmarginlabel=new JLabel();
		JLabel verticalmarginlabel=new JLabel();
		printinglabel.setText("Printed Sheet Dimensions");
		widthlabel.setText("Custom Width (mm)");
		heightlabel.setText("Custom Height (mm)");
		horizontalmarginlabel.setText("Horizontal Margin (mm)");
		verticalmarginlabel.setText("Vertical Margin (mm)");
		//TODO there has got to be a better way of doing this!
		String[] papernames=new String[prefs.PaperSizeList.getSize()];
		for (int i=0;i<papernames.length;i++){
			Papersize current=(Papersize)prefs.PaperSizeList.getElementAt(i);
			papernames[i]=current.Name+", "+current.width+"mm x "+current.height+"mm";
		}
		Papersize=new JComboBox(papernames);
		if (Papersize.getItemCount()>0)
			Papersize.setSelectedIndex(prefs.CurrentPaperSizeIndexNumber);
		
		jButtonBrowse = new JButton();
		jButtonBrowse.setText("Browse");
	    jComboBox= new JComboBox(prefs.calibrationpatterns);
	    if (jComboBox.getItemCount()>0)
	    	jComboBox.setSelectedIndex(prefs.CurrentCalibrationPatternIndexNumber);
		
	    // TODO align the text in the combo box so if the path is too long to fit we see the right hand side
	    // I would have thought the commented out lines below would work but they don't!
	   // Alternatively show a tooltip with the full path
	   // Also adjust the combobox display below so it will auto resize if the window does.
	   // ListCellRenderer renderer = new DefaultListCellRenderer();
	   // ( (JLabel) renderer ).setHorizontalAlignment( SwingConstants.RIGHT );
	   // jComboBox.setRenderer(renderer);
	    
	    // Initialise which parts are enabled and which are disabled, this is changed by clicking the custom checkbox
		 Papersize.setEnabled(!prefs.PaperSizeIsCustom.isSelected());
	    prefs.PaperCustomSizeHeightmm.setEnabled(prefs.PaperSizeIsCustom.isSelected());
	     prefs.PaperCustomSizeWidthmm.setEnabled(prefs.PaperSizeIsCustom.isSelected());
	    widthlabel.setEnabled(prefs.PaperSizeIsCustom.isSelected());
	    heightlabel.setEnabled(prefs.PaperSizeIsCustom.isSelected());
	    JButtonNext.setEnabled(prefs.calibrationpatterns.getSize()!=0);
	    //Now display everything on the screen
		    getContentPane().removeAll(); // Blank everything
		    GroupLayout  thislayout = new GroupLayout(getContentPane());
		    getContentPane().setLayout(thislayout);
			    thislayout.setHorizontalGroup(
		            thislayout.createParallelGroup(GroupLayout.LEADING)
		            .add(defaulthorizontal(thislayout)) //add Default buttons etc.
		            .add(thislayout.createSequentialGroup()
		            		.addContainerGap()
		            		.add(thislayout.createParallelGroup(GroupLayout.LEADING)
		                    	// The Combo-box and the Browse button
		            				.add(thislayout.createSequentialGroup()
		                    				.add(jComboBox,GroupLayout.PREFERRED_SIZE,500,500)
		                    				//.add(jComboBox,GroupLayout.PREFERRED_SIZE,getPreferredSize().width-jButtonBrowse.getPreferredSize().width-(3*gap),getPreferredSize().width-jButtonBrowse.getPreferredSize().width-(3*gap))
		            						//.add(jComboBox)
		            						.addPreferredGap(LayoutStyle.RELATED)
		                    				.add(jButtonBrowse)
		                    				 .addContainerGap(gap, gap) 
		          		                   )
		        		            .add(printinglabel)
		        		            .add(Papersize,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE,GroupLayout.PREFERRED_SIZE)
		        		            .add(thislayout.createSequentialGroup()
		        		            		// The check boxes and radio buttons
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(thislayout.createParallelGroup(GroupLayout.LEADING)
		        		            				.add(prefs.CalibrationSheetKeepAspectRatioWhenPrinted)
		        		            				.add(prefs.PaperSizeIsCustom)
		        		            				)
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(thislayout.createParallelGroup(GroupLayout.LEADING)
		        		            				.add(prefs.PaperOrientationIsPortrait)
		        		            				.add(prefs.PaperOrientationIsLandscape)
		        		            				)
		        		            		)
		        		            .add(thislayout.createSequentialGroup()
		        		            		//width and horizontal margins
		        		            		.add(widthlabel)
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(prefs.PaperCustomSizeWidthmm,gap*3,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE)
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(horizontalmarginlabel)
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(prefs.PaperMarginHorizontalmm,gap*3,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE)
		        		            		)
		                    		.add(thislayout.createSequentialGroup()
		        		            		//height and vertical margins
		        		            		.add(heightlabel)
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(prefs.PaperCustomSizeHeightmm,gap*3,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE)
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(verticalmarginlabel)
		        		            		.addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
		        		            		.add(prefs.PaperMarginVerticalmm,gap*3,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE)
		        		            		)
		                    )
		                    .addContainerGap(gap, gap)
		            )
				   		
		        );
		    thislayout.setVerticalGroup(
		            thislayout.createParallelGroup(GroupLayout.LEADING)
		            .add(defaultvertical(thislayout)) // add Default buttons etc.
		             .add(thislayout.createSequentialGroup()
		                     .addPreferredGap(LayoutStyle.RELATED, 3*gap, 3*gap)
		                     // The Combo box and browse button
		                     .add(thislayout.createParallelGroup(GroupLayout.BASELINE)
		                   		 .add(jComboBox)
		                        .add(jButtonBrowse)
		                    )
		                    .addPreferredGap(LayoutStyle.RELATED)
		                    .add(printinglabel)
		                    .addPreferredGap(LayoutStyle.RELATED)
		                    .add(Papersize,GroupLayout.PREFERRED_SIZE,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE)
				            	
		                    //aspect ratio check box and portrait radio button
		                    .add(thislayout.createParallelGroup(GroupLayout.BASELINE)
				            		.add(prefs.CalibrationSheetKeepAspectRatioWhenPrinted)
				            		.add(prefs.PaperOrientationIsPortrait)
		            				)
		            		.addPreferredGap(LayoutStyle.RELATED)
		                    // custom size checkbox and landscape radio button
		                    .add(thislayout.createParallelGroup(GroupLayout.BASELINE)
				            		.add(prefs.PaperSizeIsCustom)
				            		.add(prefs.PaperOrientationIsLandscape)
		            				)
		            		.addPreferredGap(LayoutStyle.RELATED)
		                    .add(thislayout.createParallelGroup(GroupLayout.BASELINE)
        		            		//width and horizontal margins
        		            		.add(widthlabel)
        		            		.add(prefs.PaperCustomSizeWidthmm)
        		            		.add(horizontalmarginlabel)
        		            		.add(prefs.PaperMarginHorizontalmm)
        		            		)
		            		.addPreferredGap(LayoutStyle.RELATED)
		                    .add(thislayout.createParallelGroup(GroupLayout.BASELINE)
        		            		//height and vertical margins
        		            		.add(heightlabel)
        		            		.add(prefs.PaperCustomSizeHeightmm)
        		            		.add(verticalmarginlabel)
        		            		.add(prefs.PaperMarginVerticalmm)
        		            		)

		            )
		        );
		 		    
		    
		    // Update when the combo box selection changes
		    jComboBox.addActionListener(new ActionListener() {
		        public void actionPerformed(ActionEvent evt) {
		        	JComboBox cb = (JComboBox)evt.getSource();
		        	try 
		        	{
		        		 prefs.CurrentCalibrationPatternIndexNumber=cb.getSelectedIndex();
		    			
		        	}
		        	catch (Exception e) {
		        		System.out.println("Error updating Calibration selection combo box");
						System.out.println(e);
					}
		        	
		        }
		     });
		    
		    // Bring up a file selection dialog (and update the list with the new selection if needed) when the browse button is pressed
		    jButtonBrowse.addActionListener(new ActionListener() {
		        public void actionPerformed(ActionEvent evt){
		        	int index=0;
		        	JFileChooser Chooser= new JFileChooser();
		        	String[] imagefile=new String[] {"jpg","JPG","jpeg","JPEG"};
		            FileFilter filter= new  FileExtensionFilter(imagefile,"JPEG image file (*.jpg, *.jpeg)");
		        	Chooser.setFileFilter(filter);
		        	
		        	Chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
	            	
		        	if (JFileChooser.APPROVE_OPTION==Chooser.showDialog(null, "Select Calibration Sheet image file"))
		        	{
		        		File file = Chooser.getSelectedFile();
		        		if (new ImageFile(file.toString()).IsInvalid()) JOptionPane.showMessageDialog(getContentPane(), "Selected file, "+file.toString()+", does not seem to be an image file");
		        		else {
		        			index=prefs.calibrationpatterns.getSize();// As the index number for the last element is always one less than the size,
		        			prefs.calibrationpatterns.addElement(file.toString());// we set the index number to the size before we add the new one.
			    			 prefs.CurrentCalibrationPatternIndexNumber=index;
			    			 prefs.calibrationpatterns.setSelectedItem(file.toString());
			    		}
		    				
		    		} // end if Chooser approved
		        	JButtonNext.setEnabled(prefs.calibrationpatterns.getSize()!=0);
		        } //end ActionPerformed
		    });
		    
		    // Set the various components to be enabled or disabled when the custom check box is un/ticked and sanity check the margins against the new width and height
		    prefs.PaperSizeIsCustom.addActionListener(new ActionListener() {
		        public void actionPerformed(ActionEvent evt){
		        	 Papersize.setEnabled(!prefs.PaperSizeIsCustom.isSelected());
		     	    prefs.PaperCustomSizeHeightmm.setEnabled(prefs.PaperSizeIsCustom.isSelected());
		     	     prefs.PaperCustomSizeWidthmm.setEnabled(prefs.PaperSizeIsCustom.isSelected());
		     	    widthlabel.setEnabled(prefs.PaperSizeIsCustom.isSelected());
		     	    heightlabel.setEnabled(prefs.PaperSizeIsCustom.isSelected());
		     	  // Sanity check the margins
		     	   prefs.SanityCheckMargins();
		     	   }
		    });
		       
		   //Update the prefs.PaperSizeList index when the paper size is changed
		    Papersize.addActionListener(new ActionListener() {
		        public void actionPerformed(ActionEvent evt){
		        	JComboBox cb = (JComboBox)evt.getSource();
		        	try 
		        	{
		        		prefs.CurrentPaperSizeIndexNumber=cb.getSelectedIndex();
		        		prefs.PaperSizeList.setSelectedItem(prefs.PaperSizeList.getElementAt(prefs.CurrentPaperSizeIndexNumber));
		        		// sanity check the margins with the new change of size
		        		prefs.SanityCheckMargins();
		        		}
		        	catch (Exception e) {
		        		System.out.println("Error updating Paper size combo box");
						System.out.println(e);
					}
		        }
		    });
		   // Sanity check the horizontal and vertical margins when the margins field has lost focus
		    prefs.PaperMarginVerticalmm.addFocusListener(new java.awt.event.FocusAdapter() {
		    	public void focusLost(java.awt.event.FocusEvent e) {
		    		prefs.SanityCheckMargins();
		    		}
		    });
		   	prefs.PaperMarginHorizontalmm.addFocusListener(new java.awt.event.FocusAdapter() {
		    	public void focusLost(java.awt.event.FocusEvent e) {
		    		prefs.SanityCheckMargins(); 
		    	}
		    });
		   	
		   	// Sanity check the horizontal and vertical margins when the custom paper size fields have lost focus
		    prefs.PaperCustomSizeHeightmm.addFocusListener(new java.awt.event.FocusAdapter() {
		    	public void focusLost(java.awt.event.FocusEvent e) {
		    		prefs.SanityCheckMargins();
		    	}
		    });
		    prefs.PaperCustomSizeWidthmm.addFocusListener(new java.awt.event.FocusAdapter() {
		    	public void focusLost(java.awt.event.FocusEvent e) {
		    		prefs.SanityCheckMargins();
		    	}
		    });
		   	
		   	
 }
//  This method redraws the Window for the step in which the images are chosen and output file selected.
   private void ChooseImagesAndOutputFile() {      
		// Set up window elements
		jLabelTitle.setText("Selection of Images");
		 JButton jButtonAdd = new JButton();
	     JButton jButtonRemove = new JButton();
	     jButtonAdd.setText("Add");
	     jButtonRemove.setText("Remove");
	     
	     JLabel jLabel2 = new javax.swing.JLabel();
	     jLabel2.setText("Selection of output file");
	     jLabel2.setFont(new java.awt.Font("DejaVu Sans", java.awt.Font.BOLD, 13));
	     
	     JLabel jLabel3 = new javax.swing.JLabel();
	     jLabel3.setText("Optional Internal Object Name");
	     jLabel3.setFont(new java.awt.Font("DejaVu Sans", java.awt.Font.PLAIN, 13));
	     
	     JButton jButtonBrowse = new javax.swing.JButton();
	     jButtonBrowse.setText("Browse");  
	        
	    JButtonNext.setEnabled((prefs.imagefiles.getSize()!=0) && (prefs.OutputFileName.getText().length()!=0)); 
	     filelist=new JList(prefs.imagefiles); // Get the current list of files
		 
	     filelist.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
	     
	     JScrollPane jScrollPanel = new JScrollPane();
	     jScrollPanel.setViewportView(filelist); 
		  
	     // Organise on the screen	

	     getContentPane().removeAll(); //Blank all
	     GroupLayout thislayout = new GroupLayout(getContentPane());
	     getContentPane().setLayout(thislayout);
	     
	     thislayout.setHorizontalGroup(
	            thislayout.createParallelGroup(GroupLayout.LEADING)
	            .add(defaulthorizontal(thislayout)) // add Default buttons etc.
	            .add(thislayout.createSequentialGroup()
	                .addContainerGap()
            		 .add(thislayout.createParallelGroup(GroupLayout.LEADING)
            				//Scroll panel, labels, and output filename all same horizontal alignment
            				 // with output object name just beside the label for it
            				 .add(jScrollPanel)
     	                    .add(jLabel2)
     	                    .add(prefs.OutputFileName)
     	                    .add(thislayout.createSequentialGroup()
     	                    		.add(jLabel3)
     	                    		.addPreferredGap(LayoutStyle.RELATED)
	            					.add(prefs.OutputObjectName)
     	                    )
						 )
                    .addPreferredGap(LayoutStyle.RELATED)
                    // The Add,Remove and Browse buttons
                    .add(thislayout.createParallelGroup(GroupLayout.LEADING)
                        .add(jButtonAdd, GroupLayout.PREFERRED_SIZE, 5*gap, GroupLayout.PREFERRED_SIZE)
                        .add(jButtonRemove, GroupLayout.PREFERRED_SIZE, 5*gap, GroupLayout.PREFERRED_SIZE)
                        .add(jButtonBrowse, GroupLayout.PREFERRED_SIZE, 5*gap, GroupLayout.PREFERRED_SIZE)
                        )
                  .addContainerGap(gap, gap) // Gap between next container to the right and this one (preferred and max).
	                )
	        );
	    thislayout.setVerticalGroup(
	        thislayout.createParallelGroup(GroupLayout.LEADING)
	            .add(defaultvertical(thislayout)) // add Default buttons etc.
	            .add(thislayout.createSequentialGroup()
	            		.addPreferredGap(LayoutStyle.RELATED,3*gap,3*gap)
	            		.add(thislayout.createParallelGroup(GroupLayout.LEADING)
	    				// The scroll panel, linked in with jListImagefilenames variable
	            				.add(jScrollPanel, GroupLayout.DEFAULT_SIZE,10*gap , GroupLayout.PREFERRED_SIZE)
	        					// The Add and Remove buttons
								.add(thislayout.createSequentialGroup()
	            						.add(jButtonAdd)
	            						.addPreferredGap(LayoutStyle.RELATED)
	            						.add(jButtonRemove)
	            						
								)
	        		 )
						.addPreferredGap(LayoutStyle.UNRELATED,gap,gap)
						//The labels, output data and browse button with the browse button at the same vertical place as the output file name and the label the same for the metadata
						.add(thislayout.createSequentialGroup()
								.add(jLabel2)
								.addPreferredGap(LayoutStyle.UNRELATED,gap,gap)
								.add(thislayout.createParallelGroup(GroupLayout.LEADING)
										.add(prefs.OutputFileName,GroupLayout.PREFERRED_SIZE,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE)
										.add(jButtonBrowse)
										)
								.addPreferredGap(LayoutStyle.RELATED,gap,gap)
								.add(thislayout.createParallelGroup(GroupLayout.LEADING)
										.add(jLabel3)
										.add(prefs.OutputObjectName,GroupLayout.PREFERRED_SIZE,GroupLayout.PREFERRED_SIZE, GroupLayout.PREFERRED_SIZE)
										)
								
										
                			)
	    				
				)

	    );

		        // What happens when you press the Add and Remove buttons	        
		        jButtonAdd.addActionListener(new ActionListener() {
		            public void actionPerformed(ActionEvent evt) {
			        	JFileChooser Chooser= new JFileChooser();
		            	Chooser.setMultiSelectionEnabled(true);
		            	String[] imagefile=new String[] {"jpg","JPG","jpeg","JPEG"};
			            FileFilter filter= new FileExtensionFilter(imagefile,"JPEG image file (*.jpg, *.jpeg)");
			        	Chooser.setFileFilter(filter);

		            	Chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
		                
		       		            	
		            	if (JFileChooser.APPROVE_OPTION==Chooser.showDialog(null, "Select"))
			        	{
		            		 File[] files = Chooser.getSelectedFiles();
				             for (int i=0;i<files.length;i++){  
				            	 if (new ImageFile(files[i].toString()).IsInvalid()) JOptionPane.showMessageDialog(getContentPane(), "Selected file, "+files[i].toString()+", does not seem to be an image file");
				            	 else {
				            		 prefs.imagefiles.addElement(files[i].toString());
				            	 }
				             } 	
			        	}
		        	    JButtonNext.setEnabled((prefs.imagefiles.getSize()!=0) && (prefs.OutputFileName.getText().length()!=0));
		        	}
	            });
	            jButtonRemove.addActionListener(new ActionListener() {
		            public void actionPerformed(ActionEvent evt) {
		            // if no items are selected then ignore else remove them
		            	if (filelist.getSelectedIndices().length>0) {
		            		   int[] tmp = filelist.getSelectedIndices();
		       			    int[] selectedIndices = filelist.getSelectedIndices();
		       			   for (int i = tmp.length-1; i >=0; i--) {
		       			       selectedIndices = filelist.getSelectedIndices();
		       			       prefs.imagefiles.remove(selectedIndices[i]);  
		       				  } // end-for
		       			 } // end-ifremovefromlist();
		        	    JButtonNext.setEnabled((prefs.imagefiles.getSize()!=0) && (prefs.OutputFileName.getText().length()!=0));
		        	    }
	            });
	
	            // Bring up a file selection dialog (and update the outputfilename) when the browse button is pressed
			    jButtonBrowse.addActionListener(new ActionListener() {
			        public void actionPerformed(ActionEvent evt){
			        	JFileChooser Chooser= new JFileChooser();
			        	String[] stl=new String[] {"stl","STL"};
			            FileFilter filter= new FileExtensionFilter(stl,"STL file");
			        	Chooser.setFileFilter(filter);
			        	Chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
		            	
			        	if (JFileChooser.APPROVE_OPTION==Chooser.showSaveDialog(null))
			        	{
			        		File file = Chooser.getSelectedFile();
			        		prefs.OutputFileName.setText(file.toString());
			    		}
			    	    JButtonNext.setEnabled((prefs.imagefiles.getSize()!=0) && (prefs.OutputFileName.getText().length()!=0));
			    	    } //end ActionPerformed
			    });
	            // Set the next button enabled if appropriate when the text field changes
			    // Note that if add a key listener then need all 3 methods keyPressed,keyReleased, and keyTyped
			  prefs.OutputFileName.addKeyListener(new java.awt.event.KeyListener() {		   
			    		public void keyPressed(java.awt.event.KeyEvent keyEvent) {
			    		JButtonNext.setEnabled((prefs.imagefiles.getSize()!=0) && (prefs.OutputFileName.getText().length()!=0));
			    } //end ActionPerformed	  
			    		public void keyTyped(java.awt.event.KeyEvent keyEvent) {
				    		JButtonNext.setEnabled((prefs.imagefiles.getSize()!=0) && (prefs.OutputFileName.getText().length()!=0));
				    } //end ActionPerformed
			    		public void keyReleased(java.awt.event.KeyEvent keyEvent) {
				    		JButtonNext.setEnabled((prefs.imagefiles.getSize()!=0) && (prefs.OutputFileName.getText().length()!=0));
				    } //end ActionPerformed	  
			    });
    
	}
private void FindCalibrationSheetCirclesEtc(){
	 //Need to split the actual work and the GUI into separate threads 
    // The code that paints the GUI and events generated by the GUI are executed on a single thread, called the "event-dispatching thread". 
    // And the code that does the work needs to be run in another thread so that the event-dispatching thread can actually update the GUI
    // The simplest solution is to create a new instance of a thread class that has the long-running for loop as its run method. 
    // And a call to the EventQueue to update the GUI elements (with any variables needing to be defined as 'final' i.e. once defined, not changed within the code block)
	class workingThread implements Runnable {
    	
 	   // This method is called when the thread runs
 	   public void run(){
 			 ProcessCalibrationSheet();
 			 
 			 final int value=calibrationsheetinterrogationnumberofsteps;
   		  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  jProgressBar2.setValue(value);
					  }
				  });
 			 
 			// Re-enable the next and previous buttons
	    		  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  JButtonNext.setEnabled(true);
						  JButtonPrevious.setEnabled(true);

					  }
	    		 });
	    		  // Automatically go on to the next step 
			    		setStep(stepsarray[currentstep.ordinal()+1]);

	 		   
 	   }
	}
 	
	
	// This should queue up all the GUI elements to be processed and then carry on with the method
	// Which consists of simply spinning off another thread to do all the work (of the workingThread class above)
	EventQueue.invokeLater(new Runnable(){
		  public void run(){
			  JButtonNext.setEnabled(false);
			  JButtonPrevious.setEnabled(false);
			  
			  jLabelProgressBar1 = new javax.swing.JLabel();
    		   jProgressBar2 = new JProgressBar(0,(prefs.imagefiles.getSize()*calibrationnumberofsubsteps)+objectvoxelisationnumberofsteps+calibrationsheetinterrogationnumberofsteps+numberofotherprogressbarsteps); // There are a certain number of steps per image plus an additional number of steps to voxelise the object and process the calibration sheet.  
    		   jProgressBar2.setValue(0);
    		   jLabelProgressBar2 = new javax.swing.JLabel();
    		   jLabelOutputLog = new javax.swing.JLabel();
    		   
    		   jScrollPanel = new JScrollPane();
    		   jTextAreaOutput = new JTextArea();
    		   jLabelProgressBar1 = new javax.swing.JLabel();
    		   jLabelTitle.setText("Interrogating Calibration Sheet Image");
    		   
    		   jTextAreaOutput.setColumns(20);
    		   jTextAreaOutput.setRows(5);
    		   jTextAreaOutput.setEditable(false);
    		   jTextAreaOutput.setLineWrap(true);
    		   jScrollPanel.setViewportView(jTextAreaOutput);
    		   
    		   
    		   jLabelProgressBar1.setFont(new java.awt.Font("Dialog", 0, 12));
    		   jLabelProgressBar1.setText("");
    		   jLabelProgressBar2.setFont(new java.awt.Font("Dialog", 0, 12));
    		   jLabelProgressBar2.setText("");
    		   jLabelOutputLog.setFont(new java.awt.Font("Dialog", 0, 12));
    		   jLabelOutputLog.setText("Processing Log");   
    		   // Organise on the screen
    		   getContentPane().removeAll(); // Blank all
    		   GroupLayout thislayout = new GroupLayout(getContentPane());
    		   getContentPane().setLayout(thislayout);
    		   thislayout.setHorizontalGroup(
    				   thislayout.createParallelGroup(GroupLayout.LEADING)    
    				   .add(defaulthorizontal(thislayout)) // add Default buttons etc.   
    				   .add(thislayout.createSequentialGroup()
    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
    						   // Progress Labels, Progress Bars and jScrollPanel (which is for the output of the calibration)
    						   .add(thislayout.createParallelGroup(GroupLayout.LEADING)
    								   .add(jLabelProgressBar1)
    								   .add(jProgressBar1)
    								   .add(jLabelProgressBar2)
    								   .add(jProgressBar2)
    								   .add(jLabelOutputLog)
    								   .add(jScrollPanel)
    						   )
    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)                   
    				   )
    		   );
    		   thislayout.setVerticalGroup(
    				   thislayout.createParallelGroup(GroupLayout.LEADING)
    				   .add(defaultvertical(thislayout)) // add Default buttons etc.
    				   .add(thislayout.createSequentialGroup()
    						   .addPreferredGap(LayoutStyle.RELATED, 3*gap, 3*gap)
    						   // Progress bars, Progress Labels, jScrollPanel i.e. Calibration Output
    						   .add(jProgressBar1)
    						   .addPreferredGap(LayoutStyle.RELATED)
    						   .add(jLabelProgressBar1)
    						   .addPreferredGap(LayoutStyle.UNRELATED)
    						   .add(jProgressBar2)
    						   .addPreferredGap(LayoutStyle.RELATED)
    						   .add(jLabelProgressBar2)
    						   .addPreferredGap(LayoutStyle.UNRELATED)
    						   .add(jLabelOutputLog)
    						   .addPreferredGap(LayoutStyle.RELATED)
    						   .add(jScrollPanel)
    						   .addPreferredGap(LayoutStyle.UNRELATED,5*gap,5*gap)   
    				   )
          
    		   );
    		  
			
		  } // end run() method
	}); // end EventQueue.invokeLater
//	Set these here so just in case.
	// As the EventQueue should process the invokeLater commands in the correct order
	// it shoiuldn't matter whether these are here or in the run() method below but better safe than sorry
	JButtonNext.setEnabled(false);
	JButtonPrevious.setEnabled(false);
	jProgressBar1 = new JProgressBar(0,1);
	jProgressBar1.setValue(0);
	jProgressBar2 = new JProgressBar(0,1);
	jProgressBar2.setValue(0);
	
	// Invoke the thread to do the actual work
	Thread t=new Thread(new workingThread());
	t.start();

	}
 
	
	
//  This method redraws the Window for the step in which the actual calibration is done
	private void Calibration() {
		 //Need to split the actual work and the GUI into separate threads 
	       // The code that paints the GUI and events generated by the GUI are executed on a single thread, called the "event-dispatching thread". 
	       // And the code that does the work needs to be run in another thread so that the event-dispatching thread can actually update the GUI
	       // The simplest solution is to create a new instance of a thread class that has the long-running for loop as its run method. 
	       // And a call to the EventQueue to update the GUI elements (with any variables needing to be defined as 'final' i.e. once defined, not changed within the code block)

		// Set up the thread class to do the actual work.
		class workingThread implements Runnable {
    	
    	   // This method is called when the thread runs
    	   public void run(){
    		// Now create the data structrue to store the images 
    		   images=new Image[prefs.imagefiles.getSize()];
    		  
    		   // For each of the images, do a 5 step process (and update the second progress bar after each step)
    		 // If the number of steps changes the private static int calibrationnumberofsubsteps needs to be changed at the top of the class;


    		   for (int j=0;j<prefs.imagefiles.getSize();j++){
    			   final String text2="Processing image "+(j+1)+" of "+prefs.imagefiles.getSize();
					  try{ 
							// This is the recommended way of passing GUI information between threads
								  EventQueue.invokeLater(new Runnable(){
									  public void run(){
										  jLabelProgressBar2.setText(text2);
									  }
								  });
								 }
								 catch (Exception e) { 
									 System.out.println("Exception in updating the progress bar"+e.getMessage());
						         }
								 
								 boolean compute=true;
								
								 if (prefs.SkipStep[currentstep.ordinal()])	{
										compute=false;
										try{
											// Load the undistorted image
											images[j]=new Image(new File(prefs.imagefiles.getElementAt(j).toString()).getParent()+File.separatorChar+"UndistortedImage"+new File(prefs.imagefiles.getElementAt(j).toString()).getName());
											// Load the processed image properties
											ProcessedImageProperties io=new ProcessedImageProperties(prefs.imagefiles.getElementAt(j).toString()+".properties");
											io.loadProperties();
											images[j].originofimagecoordinates=io.originofimagecoordinates.clone();
											images[j].setWorldtoImageTransformMatrix(io.WorldToImageTransform); 	
											images[j].skipprocessing=io.skipprocessing;
											// Load the calibration sheet boolean array
											// First load it from file into a PixelColour array, then convert that to a boolean array, dividing at greyscale value 128
											if (!io.skipprocessing) images[j].SetProcessedPixels(new PixelColour().ConvertGreyscaleToBoolean(new ImageFile(new File(prefs.imagefiles.getElementAt(j).toString()).getParent()+File.separatorChar+"SegmentedImage"+new File(prefs.imagefiles.getElementAt(j).toString()).getName()).ReadImageFromFile(new float[0]),images[j].width,images[j].height,128));		  		    				 
										} // end try
										catch (Exception e){
											System.out.println("Error reading processed image properties from file, initiating real-time processing");
											compute=true;
											} // end catch
								 } // end if

								 if (compute){
//Sub-Step 1
								 Point2d[] ellipsecenters=FindEllipses(j);

	    					 if (Continue(j,ellipsecenters)){
//Sub-Step 2    						  
	      					PointPairMatch circles=MatchCircles(j,ellipsecenters);
	      					
	      					if (prefs.Debug) {
	      						if (prefs.DebugCalibrationSheetBarycentricEstimate){
	      						// Write out a file that is the dimensions of the calibration sheet with the colours corresponding to the colours in the image
	      						// matched using barycentric coordinate transforms between the two using the found point pair matches 
	      						// Do this all twice, once with all the point pairs, once with just the first 3
	      						for (int useallpointpairs=0;useallpointpairs<2;useallpointpairs++){
	      							PointPair2D[] basepairs;
		      						PointPair2D[] correct=circles.getMatchedPoints();
	      							if (useallpointpairs==1) {
		      							basepairs=new PointPair2D[correct.length];
		      							for (int i=0;i<correct.length;i++) basepairs[i]=correct[i].clone();
		      						}
		      						else{
		      							//Use only the first 3 to get the estimated greyscale values of the entire calibration sheet
		      							basepairs=new PointPair2D[3];
		      							for (int i=0;i<3;i++) basepairs[i]=correct[i].clone();
		      						}
		      						
	      							// Note the coordinates of the points in the calibration sheet are not pixel coordinates but are transformed to have the origin at the centre of the sheet
		      						Point2d offset=new Point2d(calibrationsheetwidth/2,calibrationsheetheight/2);
		      						// For each pixel of the calibration sheet work out the colour it corresponds to in the image
	      							// using a barycentric transformation
		      						PixelColour[][] newimage=new PixelColour[calibrationsheetpixelswidth][calibrationsheetpixelsheight];
		      						for (int x=0;x<calibrationsheetpixelswidth;x++){
		      							for (int y=0;y<calibrationsheetpixelsheight;y++){
		      								// calculate the point pair for each pixel of the calibration sheet and get the colour value
		      								Point2d point=new Point2d(x,y);
		      								// Convert from pixel to mm coordinates
			      							point.x=point.x*(calibrationsheetwidth/calibrationsheetpixelswidth);
			      							point.y=point.y*(calibrationsheetheight/calibrationsheetpixelsheight);
			      							point.minus(offset);
		      								PointPair2D pair=new PointPair2D();
		      								pair.pointone=point.clone();
		      								boolean success=pair.EstimateSecondPoint(basepairs);
		      								if (success) newimage[x][y]=images[j].InterpolatePixelColour(pair.pointtwo);
		      								else newimage[x][y]=new PixelColour();
		      							}
		      							if (x%100==0) System.out.print(".");
		      						}
		      						System.out.println();
		      						// Overwrite the pixels that are the centers of the circles with white to give a guide to how the matching was done
		      						// With the center represented by a rectangle that it 1% of the size of the calibration sheet
		      						int dx=(int)(calibrationsheetpixelswidth/200);
		      						int dy=(int)(calibrationsheetpixelsheight/200);
		      						
		      						for (int i=0;i<correct.length;i++){
		      							Point2d point=correct[i].pointone.clone();
		      							point.plus(offset);
		      							// Convert from mm to pixel coordinates
		      							point.x=point.x*(calibrationsheetpixelswidth/calibrationsheetwidth);
		      							point.y=point.y*(calibrationsheetpixelsheight/calibrationsheetheight);
		      							for (int x=(int)point.x-dx;x<(int)point.x+dx;x++)
		      								for (int y=(int)point.y-dy;y<(int)point.y+dy;y++)
				      							if ((x>=0) && (x<calibrationsheetpixelswidth) && (y>=0) && (y<=calibrationsheetpixelsheight)) newimage[x][y]=new PixelColour((byte)255);
		      						} // end for 
	      							String filename;
	      							if (useallpointpairs==0) filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"BarycentricCalibrationSheetImageUsingFirst3Matches"+j+".jpg";
	      							else filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"BarycentricCalibrationSheetImageUsingAllMatches"+j+".jpg";
		      						GraphicsFeedback graphics=new GraphicsFeedback(true);
	      							graphics.ShowPixelColourArray(newimage,calibrationsheetpixelswidth,calibrationsheetpixelsheight);
	      							graphics.SaveImage(filename);
	      						} // end for useallpointpairs
	      					}// end if
	      					
	      					 if (prefs.DebugPointPairMatching){
	      						GraphicsFeedback graphics1=new GraphicsFeedback(true);
	  		    				Image calibrationsheet=new Image(prefs.calibrationpatterns.getElementAt(prefs.CurrentCalibrationPatternIndexNumber).toString()); // Read in the image with no blurring filter kernel
	  			    		    graphics1.ShowImage(calibrationsheet);
	  			    		    GraphicsFeedback graphics2=new GraphicsFeedback(true);
	  		    				 graphics2.ShowImage(images[j]);
	  		    				 PointPair2D[] pairs=circles.getMatchedPoints();
	  		    				PixelColour.StandardColours[] standardcolours=PixelColour.StandardColours.values();
	  		    				for (int k=0;k<pairs.length;k++){
	  		    					// The first point of the pair represents the calibration sheet circle center transformed into real world coordinates
	  		    					// The second point of the pair represents the centre of the ellipse in the image.
	  		    					// We want to output 2 images with the colours matching so we need to find the circle the image point were matched with
	  		    					int calibrationsheetindex=-1;
	  		    					int imageellipseindex=-1;
	  		    					for (int l=0;l<calibrationcirclecenters.length;l++) if (calibrationcirclecenters[l].isApproxEqual(pairs[k].pointone,0.001)) calibrationsheetindex=l;
	  		    					for (int l=0;l<imageellipses.length;l++)if (imageellipses[l].GetCenter().isApproxEqual(pairs[k].pointtwo,0.001)) imageellipseindex=l;
	  		    					 PixelColour colour;
	  		    					if (k<standardcolours.length)colour=new PixelColour(standardcolours[k]);
	  		    					else colour=new PixelColour(standardcolours[standardcolours.length-1]);
	 							   if(calibrationsheetindex>=0) graphics1.PrintEllipse(calibrationcircles[calibrationsheetindex],colour,new Point2d(0,0));
	 							   if(imageellipseindex>=0)graphics2.PrintEllipse(imageellipses[imageellipseindex],colour,images[j].originofimagecoordinates);
	 							 } // end for k
	  		    				String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"CircleandEllipseMatchesForCalibrationSheetWithImage"+j+".jpg";
		 						graphics1.SaveImage(filename);
		      					filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"CircleandEllipseMatchesinImage"+j+".jpg";
		      					graphics2.SaveImage(filename);
	      					}// end if
	      					} // end if Debug

// Sub-Step 3	      					
	      					LensDistortion distortion=EstimatingCameraParameters(j,circles);
	      					// Note that the above will set the skipprocessing if the camera matrix cannot be estimated. 
	      					if (!images[j].skipprocessing){
// Sub-Steps 4 and 5	      						
	      						UndoLensDistortion(j,distortion,false);
	      						ImageSegmentation(j);
	      					}

	    					 } // end if continue
	    					 // Save processed image if necessary
	    					 if (prefs.SaveProcessedImageProperties){
	    						 // Save the important calculated properties of the image
	    						 ProcessedImageProperties io=new ProcessedImageProperties(prefs.imagefiles.getElementAt(j).toString()+".properties");
	  		    			   	io.originofimagecoordinates=images[j].originofimagecoordinates.clone();
	  		    			   	if (!images[j].skipprocessing) io.WorldToImageTransform=images[j].getWorldtoImageTransformMatrix().copy();
	  		    			   	else io.WorldToImageTransform=new Matrix(3,3);
	  		    			   	io.skipprocessing=images[j].skipprocessing;
	  		    			   	try{io.saveProperties();}
	  		    			   	catch (Exception e){System.out.println("Error writing processed image properties.");}
	  		    			     // save the undistorted image
	  		    				 GraphicsFeedback graphics=new GraphicsFeedback();
	  		    				 graphics.ShowImage(images[j]);
	  		    				 graphics.SaveImage(new File(prefs.imagefiles.getElementAt(j).toString()).getParent()+File.separatorChar+"UndistortedImage"+new File(prefs.imagefiles.getElementAt(j).toString()).getName());
	  		    				 
	  		    				
	  		    				 if (!images[j].skipprocessing){
	  		    					 // save the image segmentation
	  		    					 graphics=new GraphicsFeedback();
	  		    					 graphics.ShowBinaryimage(images[j].getProcessedPixels(),images[j].width,images[j].height);
	  		    					 graphics.SaveImage(new File(prefs.imagefiles.getElementAt(j).toString()).getParent()+File.separatorChar+"SegmentedImage"+new File(prefs.imagefiles.getElementAt(j).toString()).getName());
	  		  					}
	  		    		   } // end if save	
	    						 
	  		    				 
						} // end if compute    		   
								
 // End of loop steps 1-5
	    	 final int value=calibrationsheetinterrogationnumberofsteps+(calibrationnumberofsubsteps*(j+1));
    		  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  jProgressBar2.setValue(value);
					  }
				  });
    		  } // end for j


		   // Re-enable the next and previous buttons
	    		  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  JButtonNext.setEnabled(true);
						  JButtonPrevious.setEnabled(true);

					  }
	    		 });
//	    		 Automatically go onto the next step
	    		  setStep(stepsarray[currentstep.ordinal()+1]);

	 		
    	   }
    	    } // end Thread class
		
		// This should queue up all the GUI elements to be processed and then carry on with the method
		// Which consists of simply spinning off another thread to do all the work (of the workingThread class above)
		EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  JButtonNext.setEnabled(false);
				  JButtonPrevious.setEnabled(false);
				  jProgressBar1=new JProgressBar(0,1);
				  jProgressBar1.setValue(0);
				  jProgressBar2.setValue(calibrationsheetinterrogationnumberofsteps);
	    		  jLabelTitle.setText("Calibration");
	    		  jLabelProgressBar1.setText(" ");
	    		  jLabelProgressBar2.setText(" ");
	    		   
	    		   // Organise on the screen
	    		   getContentPane().removeAll(); // Blank all
	    		   GroupLayout thislayout = new GroupLayout(getContentPane());
	    		   getContentPane().setLayout(thislayout);
	    		   thislayout.setHorizontalGroup(
	    				   thislayout.createParallelGroup(GroupLayout.LEADING)    
	    				   .add(defaulthorizontal(thislayout)) // add Default buttons etc.   
	    				   .add(thislayout.createSequentialGroup()
	    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
	    						   // Progress Labels, Progress Bars and jScrollPanel (which is for the output of the calibration)
	    						   .add(thislayout.createParallelGroup(GroupLayout.LEADING)
	    								   .add(jLabelProgressBar1)
	    								   .add(jProgressBar1)
	    								   .add(jLabelProgressBar2)
	    								   .add(jProgressBar2)
	    								   .add(jLabelOutputLog)
	    								   .add(jScrollPanel)
	    						   )
	    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)                   
	    				   )
	    		   );
	    		   thislayout.setVerticalGroup(
	    				   thislayout.createParallelGroup(GroupLayout.LEADING)
	    				   .add(defaultvertical(thislayout)) // add Default buttons etc.
	    				   .add(thislayout.createSequentialGroup()
	    						   .addPreferredGap(LayoutStyle.RELATED, 3*gap, 3*gap)
	    						   // Progress bars, Progress Labels, jScrollPanel i.e. Calibration Output
	    						   .add(jProgressBar1)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jLabelProgressBar1)
	    						   .addPreferredGap(LayoutStyle.UNRELATED)
	    						   .add(jProgressBar2)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jLabelProgressBar2)
	    						   .addPreferredGap(LayoutStyle.UNRELATED)
	    						   .add(jLabelOutputLog)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jScrollPanel)
	    						   .addPreferredGap(LayoutStyle.UNRELATED,5*gap,5*gap)   
	    				   )
              
	    		   );
	    		  
			  } // end run() method
		}); // end EventQueue.invokeLater

		//Set these here just in case.
		// As the EventQueue should process the invokeLater commands in the correct order
		// it shoiuldn't matter whether these are here or in the run() method above but better safe than sorry
		JButtonNext.setEnabled(false);
		JButtonPrevious.setEnabled(false);
		 jProgressBar2.setValue(calibrationsheetinterrogationnumberofsteps);
		  
		// Invoke the thread to do the actual work
		Thread t=new Thread(new workingThread());
		t.start();
		
	} // end Calibration Method
	
	
	
	private void FindCoarseVoxelisedObject(){
		 //Need to split the actual work and the GUI into separate threads 
	    // The code that paints the GUI and events generated by the GUI are executed on a single thread, called the "event-dispatching thread". 
	    // And the code that does the work needs to be run in another thread so that the event-dispatching thread can actually update the GUI
	    // The simplest solution is to create a new instance of a thread class that has the long-running for loop as its run method. 
	    // And a call to the EventQueue to update the GUI elements (with any variables needing to be defined as 'final' i.e. once defined, not changed within the code block)
		class workingThread implements Runnable {
	    	
	 	   // This method is called when the thread runs
	 	   public void run(){

    		   
	 			 int countimages=0;
	 	    		   
	 	    		 for (int j=0;j<images.length;j++) if (!images[j].skipprocessing) countimages++;		  
	 	    		 if (countimages<2){
	 	    			 final String text4="Error: Not enough valid images to extract 3D information. At least two are needed.\n";
	 	    		 	  EventQueue.invokeLater(new Runnable(){
	 							  public void run(){
	 								  jTextAreaOutput.setText(jTextAreaOutput.getText()+text4);
	 							  }
	 	  				  });
	 					}
	 				  else {
	 				  	 Voxel voxels=Voxelisation();
	 				  	 RestrictSearch(voxels);
	 				  	 //SurfaceVoxelsToTriangles(voxels); //TODO delete when finished testing
	 				  	 } // end else for if there are enough images to extract 3D information 
	 	    		 // automatically continue to the next step
	 	   		    	setStep(stepsarray[currentstep.ordinal()+1]);

	 	   		    
	 	   }
		}
	 	
		
		// This should queue up all the GUI elements to be processed and then carry on with the method
		// Which consists of simply spinning off another thread to do all the work (of the workingThread class above)
		EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  JButtonNext.setEnabled(false);
				  JButtonPrevious.setEnabled(false);
				  jProgressBar1=new JProgressBar(0,1);
				  jProgressBar1.setValue(0);
				  jProgressBar2.setValue((prefs.imagefiles.getSize()*calibrationnumberofsubsteps)+calibrationsheetinterrogationnumberofsteps);
				  jLabelTitle.setText("Finding Object");
	    		   jLabelProgressBar1.setText(" ");
	    		  jLabelProgressBar2.setText("Finding Object");
	    		  
	    		   // Organise on the screen
	    		   getContentPane().removeAll(); // Blank all
	    		   GroupLayout thislayout = new GroupLayout(getContentPane());
	    		   getContentPane().setLayout(thislayout);
	    		   thislayout.setHorizontalGroup(
	    				   thislayout.createParallelGroup(GroupLayout.LEADING)    
	    				   .add(defaulthorizontal(thislayout)) // add Default buttons etc.   
	    				   .add(thislayout.createSequentialGroup()
	    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
	    						   // Progress Labels, Progress Bars and jScrollPanel (which is for the output of the calibration)
	    						   .add(thislayout.createParallelGroup(GroupLayout.LEADING)
	    								   .add(jLabelProgressBar1)
	    								   .add(jProgressBar1)
	    								   .add(jLabelProgressBar2)
	    								   .add(jProgressBar2)
	    								    .add(jLabelOutputLog)
	    								  .add(jScrollPanel)
	    						   )
	    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)                   
	    				   )
	    		   );
	    		   thislayout.setVerticalGroup(
	    				   thislayout.createParallelGroup(GroupLayout.LEADING)
	    				   .add(defaultvertical(thislayout)) // add Default buttons etc.
	    				   .add(thislayout.createSequentialGroup()
	    						   .addPreferredGap(LayoutStyle.RELATED, 3*gap, 3*gap)
	    						   // Progress bars, Progress Labels, jScrollPanel i.e. Calibration Output
	    						   .add(jProgressBar1)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jLabelProgressBar1)
	    						   .addPreferredGap(LayoutStyle.UNRELATED)
	    						   .add(jProgressBar2)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jLabelProgressBar2)
	    						   .addPreferredGap(LayoutStyle.UNRELATED)
	    						   .add(jLabelOutputLog)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jScrollPanel)
	    						   .addPreferredGap(LayoutStyle.UNRELATED,5*gap,5*gap)   
	    				   )
	          
	    		   );
	   
				
			  } // end run() method
		}); // end EventQueue.invokeLater

		//	Set these here just in case.
		// As the EventQueue should process the invokeLater commands in the correct order
		// it shoiuldn't matter whether these are here or in the run() method above but better safe than sorry
		JButtonNext.setEnabled(false);
		JButtonPrevious.setEnabled(false);
		jProgressBar2.setValue((prefs.imagefiles.getSize()*calibrationnumberofsubsteps)+calibrationsheetinterrogationnumberofsteps);
		 
		// Invoke the thread to do the actual work
		Thread t=new Thread(new workingThread());
		t.start();
	}
 	//This method is an intermediary one for testing purposes
 	// Eventually this will be replaced by a SurfacePatchTextureMatching method that give better output.
 	public void SurfacePointTextureMatching(){
		//TODO set the progress bar and text   
 		TrianglePlusVertexArray totaltriplusvertex=new TrianglePlusVertexArray(new Point3d[0]);
 		   int sampleswide=(int)((volumeofinterest.maxx-volumeofinterest.minx)/prefs.AlgorithmSettingSurfacePointTextureResolutionmm);
 		   int sampleshigh=(int)((volumeofinterest.maxy-volumeofinterest.miny)/prefs.AlgorithmSettingSurfacePointTextureResolutionmm);
 		   int zsamples=(int)(((volumeofinterest.maxz-volumeofinterest.minz)/prefs.AlgorithmSettingSurfacePointTextureResolutionmm));
 		   JProgressBar bar=new JProgressBar(0,(zsamples*2)+1);
 		   bar.setValue(0);
	 		
 		   // Increment the second progress bar
 		   try{ 
 				// This is the recommended way of passing GUI information between threads
 					  EventQueue.invokeLater(new Runnable(){
 						  public void run(){
 							  // Update progress bar
 							  jProgressBar2.setValue(jProgressBar2.getValue()+1);
 							  
 						  }
 					  });
 				  }
 				  catch (Exception e) { 
 					  System.out.println("Exception in updating the progress bar"+e.getMessage());
 		         } 
 		   // Find the camera center of each image
 		   Point3d[] C=new Point3d[images.length];
 		   for (int i=0;i<C.length;i++) C[i]=new Point3d(MatrixManipulations.GetRightNullSpace(images[i].getWorldtoImageTransformMatrix()));
 		   // To do this sweep properly we need to sweep in all eight combinations of +/- x/y/z
 		   double xstep=prefs.AlgorithmSettingSurfacePointTextureResolutionmm;
 		   double ystep=prefs.AlgorithmSettingSurfacePointTextureResolutionmm;
 		   double zstep=prefs.AlgorithmSettingSurfacePointTextureResolutionmm;
 		   BoundingPolygon2D[] boundingpolygon=new BoundingPolygon2D[zsamples+1];
 		   for (int i=0;i<=zsamples;i++) boundingpolygon[i]=new BoundingPolygon2D(new Point2d[0]);
			
 		   //TODO comment code!
 		   for (int zdir=-1;zdir<=1;zdir=zdir+2) {
 			   double z=volumeofinterest.minz;
				if (zdir==-1) z=volumeofinterest.maxz;
				while ((z>=volumeofinterest.minz) && (z<=volumeofinterest.maxz)){
					int zindex=(int)(((z-volumeofinterest.minz)/(volumeofinterest.maxz-volumeofinterest.minz))*(double)zsamples);
					//progressbar update
			 	 		bar.setValue(bar.getValue()+1);
			 	 		final JProgressBar temp=bar;
			 	 		String directionofsweep="down";
			 	 		if (zdir>0) directionofsweep="up";
			 	 		// This just shows four significant digits for the resolution
			 	 		final String text="Finding Surface Points for z="+new BigDecimal(z,new MathContext(4, RoundingMode.DOWN)).toPlainString()+" sweeping "+directionofsweep+".";
			 	 		  try{ 
			 	 				// This is the recommended way of passing GUI information between threads
			 	 					  EventQueue.invokeLater(new Runnable(){
			 	 						  public void run(){
			 	 							  // Update progress bar
			 	 							jProgressBar1.setMinimum(temp.getMinimum());
			 	 							  jProgressBar1.setMaximum(temp.getMaximum());
			 	 							  jProgressBar1.setValue(temp.getValue());
			 	 							  jLabelProgressBar1.setText(text);
			 	 						  }
			 	 					  });
			 	 				  }
			 	 				  catch (Exception e) { 
			 	 					  System.out.println("Exception in updating the progress bar"+e.getMessage());
			 	 		         } 
			
					boolean[][] skip=new boolean[sampleswide+1][sampleshigh+1];
					PixelColour[][] colour=new PixelColour[sampleswide+1][sampleshigh+1]; // currently not used for anything but the debugging images
					
					for (int i=0;i<=sampleswide;i++)
						for (int j=0;j<=sampleshigh;j++){
							skip[i][j]=true;
							colour[i][j]=new PixelColour(PixelColour.StandardColours.White);
						}
					
					for (int ydir=1;ydir>=-1;ydir=ydir-2){
						double y=volumeofinterest.miny;
						if (ydir==-1) y=volumeofinterest.maxy;
						while ((y>=volumeofinterest.miny) && (y<=volumeofinterest.maxy)){	
							for (int xdir=1;xdir>=-1;xdir=xdir-2){
								double x=volumeofinterest.minx;
								if (xdir==-1) x=volumeofinterest.maxx;
								while ((x>=volumeofinterest.minx) && (x<=volumeofinterest.maxx)){
									//Find if the point is unprocessed in all scenes or not
									Point3d point=new Point3d(x,y,z);
									boolean unprocessed=true;
									for (int i=0;i<images.length;i++) if ((!images[i].skipprocessing) && unprocessed) unprocessed=images[i].PointIsUnprocessed(point);
									if (unprocessed) {
										// 1) find the mean colour using only those images where the camera center is in the correct octant (determined by the current 3d point and the direction of the x/y/z loops
										PixelColour[] colours=new PixelColour[images.length];
										int[] cameras=new int[images.length];
										int index=0;
										for (int i=0;i<images.length;i++) if (!images[i].skipprocessing){
											// make the combinations of +/- x,y,z a number between 0 and 7 to make the case statements easier
											int correctoctant=(int)((xdir==1)?1:0)+((int)((ydir==1)?1:0)*2)+((int)((zdir==1)?1:0)*4);
											boolean process=false;
											switch (correctoctant){
												case 0:process=(C[i].x>x) && (C[i].y>y) && (C[i].z>z);break;
 												case 1:process=(C[i].x<x) && (C[i].y>y) && (C[i].z>z);break;
 												case 2:process=(C[i].x>x) && (C[i].y<y) && (C[i].z>z);break;
 												case 3:process=(C[i].x<x) && (C[i].y<y) && (C[i].z>z);break;
 												case 4:process=(C[i].x>x) && (C[i].y>y) && (C[i].z<z);break;
 												case 5:process=(C[i].x<x) && (C[i].y>y) && (C[i].z<z);break;
 												case 6:process=(C[i].x>x) && (C[i].y<y) && (C[i].z<z);break;
 												case 7:process=(C[i].x<x) && (C[i].y<y) && (C[i].z<z);break;
											} // end switch statement
											if (process){
												colours[index]=images[i].InterpolatePixelColour(images[i].getWorldtoImageTransform(point.ConvertPointTo4x1Matrix()));
												cameras[index]=i;
												index++;
											} // end if camera centre in correct octant
										} // end for i
										// 2) find similarity measure and mean colour if in two or more images
										if (index>1) {
											PixelColour[] truncatedcolours=new PixelColour[index];
											for (int i=0;i<index;i++) truncatedcolours[i]=colours[i].clone();
											PixelColour newcolour=new PixelColour();
											double[] variance=newcolour.SetPixelToMeanColourAndReturnVariance(truncatedcolours);
											// 	if similar enough set set processed flag on pixels in each contributing image and add to the bounding polygon
											// also storing the colour but currently not used for anything but displaying debug images
											if (variance[4]<prefs.AlgorithmSettingSurfacePointTextureVarianceThreshold) {
												int xindex=(int)(((x-volumeofinterest.minx)/(volumeofinterest.maxx-volumeofinterest.minx))*(double)sampleswide);
												int yindex=(int)(((y-volumeofinterest.miny)/(volumeofinterest.maxy-volumeofinterest.miny))*(double)sampleshigh);
												colour[xindex][yindex]=newcolour.clone();
												// Set to be skipped to save time if this is not the last sweep
												skip[xindex][yindex]=false;
												// Add to the bounding polygon
												boundingpolygon[zindex].ExpandPolygon(new Point2d(x,y));
												// 3) reset binary pixel in each contributing image so this pixel is not used in successive runs through the loop if similar enough
												for (int j=0;j<index;j++){
													int i=cameras[j];
													Point2d imagepoint=images[i].getWorldtoImageTransform(point.ConvertPointTo4x1Matrix());
													images[i].setPixeltoProcessed(imagepoint);
												}
											} // end if similar enough
										} // end if match in more than one image

									} // end if potentially part of surface of object
									x=x+(xdir*xstep);
								}} // end while and for x
							y=y+(ydir*ystep);
						}} // end while and for y
					if ((prefs.Debug) && (prefs.DebugSurfacePointTextureMatching)){
						GraphicsFeedback graphics=new GraphicsFeedback(true);
						graphics.ShowPixelColourArray(colour,sampleswide+1,sampleshigh+1);
						BoundingPolygon2D polygon=boundingpolygon[zindex].clone();
						// Need to reset the origin and re-scale this before displaying it
						polygon.ResetOrigin(new Point2d(volumeofinterest.minx,volumeofinterest.miny));
						polygon.scale(1/prefs.AlgorithmSettingSurfacePointTextureResolutionmm);
						graphics.OutlinePolygon(polygon,new PixelColour(PixelColour.StandardColours.Blue),0,0);
						String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"SurfaceTextureMatchImageForZ="+String.valueOf(z)+"-"+directionofsweep+".jpg";
						graphics.SaveImage(filename);
					}
					if (zdir>0){ // only add triangles on the last sweep upwards.
						System.out.println("Check start");
						
						TrianglePlusVertexArray triplusvertex=boundingpolygon[zindex].ExtrudeTo3DAndConvertToTriangles(zstep,z+(zstep/2));
						System.out.println("Check");
						totaltriplusvertex=totaltriplusvertex.MergeAndReturn(triplusvertex);
						System.out.println("Check2");
						if (print) System.out.println("This layer triangles="+triplusvertex.GetTriangleArrayLength()+" total triangles="+totaltriplusvertex.GetTriangleArrayLength());
						System.out.println("Finished");
					}
					
 					z=z+(zdir*zstep);
				}} // end while and for z

 		   surfacetriangles=totaltriplusvertex.GetTriangleArray();
 		   surfacepoints=totaltriplusvertex.GetVertexArray();
 		   if (print) System.out.println("triangle length="+surfacetriangles.length);
 		   if (print) System.out.println("points length="+surfacepoints.length);
 		   //		 Automatically go onto the next step
 		   setStep(stepsarray[currentstep.ordinal()+1]);
 	} // end of method
 
	private void OutputSTLFile(){
		 //Need to split the actual work and the GUI into separate threads 
	    // The code that paints the GUI and events generated by the GUI are executed on a single thread, called the "event-dispatching thread". 
	    // And the code that does the work needs to be run in another thread so that the event-dispatching thread can actually update the GUI
	    // The simplest solution is to create a new instance of a thread class that has the long-running for loop as its run method. 
	    // And a call to the EventQueue to update the GUI elements (with any variables needing to be defined as 'final' i.e. once defined, not changed within the code block)
		class workingThread implements Runnable {
	    	
	 	   // This method is called when the thread runs
	 	   public void run(){

		String lasterror;
		// Write the Output to an STL ASCII file - format available http://en.wikipedia.org/wiki/STL_(file_format)
		if ((prefs.OutputFileName.getText()!="") && (surfacetriangles.length!=0)){
			STLFile stl=new STLFile(prefs.OutputFileName.getText());
			lasterror=stl.Write(jProgressBar1, surfacetriangles,surfacepoints,prefs.OutputObjectName.getText());
		}
		else lasterror="Output filename blank or nothing to write, not saving.";
		
		
		// Set both progress bars to maximum.
				final String text5=lasterror;
			  EventQueue.invokeLater(new Runnable(){
				  public void run(){
					  jProgressBar1.setValue(jProgressBar1.getMaximum());
					  jProgressBar2.setValue(jProgressBar2.getMaximum());
					  jTextAreaOutput.setText(jTextAreaOutput.getText()+text5);
					  
				  }
			  });
			  
	    		 // Re-enable the next and previous buttons and add finish to log
	    		 final String text="Processing complete. Click Finish to exit.\n";
	    		  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  JButtonNext.setEnabled(true);
						  JButtonPrevious.setEnabled(true);
						 jTextAreaOutput.setText(jTextAreaOutput.getText()+text);
					  }
	    		 });
	    		  
	    		  // If the last step is set to be skipped, automatically exit.
	   		    	if (prefs.SkipStep[currentstep.ordinal()+1])  setStep(stepsarray[currentstep.ordinal()+1]);

	 	   	} // end run method
	 	   } // end workingThread class
//		 This should queue up all the GUI elements to be processed and then carry on with the method
		// Which consists of simply spinning off another thread to do all the work (of the workingThread class above)
		EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  JButtonNext.setEnabled(false);
				  JButtonPrevious.setEnabled(false);
				  jProgressBar1=new JProgressBar(0,1);
				  jProgressBar1.setValue(0);
				  jProgressBar2.setValue((prefs.imagefiles.getSize()*calibrationnumberofsubsteps)+calibrationsheetinterrogationnumberofsteps+objectvoxelisationnumberofsteps);
				  jLabelTitle.setText("Writing Output File");
	    		   jLabelProgressBar1.setText(" ");
	    		  jLabelProgressBar2.setText("Writing Output File");
	    		  
	    		   // Organise on the screen
	    		   getContentPane().removeAll(); // Blank all
	    		   GroupLayout thislayout = new GroupLayout(getContentPane());
	    		   getContentPane().setLayout(thislayout);
	    		   thislayout.setHorizontalGroup(
	    				   thislayout.createParallelGroup(GroupLayout.LEADING)    
	    				   .add(defaulthorizontal(thislayout)) // add Default buttons etc.   
	    				   .add(thislayout.createSequentialGroup()
	    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)
	    						   // Progress Labels, Progress Bars and jScrollPanel (which is for the output of the calibration)
	    						   .add(thislayout.createParallelGroup(GroupLayout.LEADING)
	    								   .add(jLabelProgressBar1)
	    								   .add(jProgressBar1)
	    								   .add(jLabelProgressBar2)
	    								   .add(jProgressBar2)
	    								    .add(jLabelOutputLog)
	    								  .add(jScrollPanel)
	    						   )
	    						   .addPreferredGap(LayoutStyle.UNRELATED, gap, gap)                   
	    				   )
	    		   );
	    		   thislayout.setVerticalGroup(
	    				   thislayout.createParallelGroup(GroupLayout.LEADING)
	    				   .add(defaultvertical(thislayout)) // add Default buttons etc.
	    				   .add(thislayout.createSequentialGroup()
	    						   .addPreferredGap(LayoutStyle.RELATED, 3*gap, 3*gap)
	    						   // Progress bars, Progress Labels, jScrollPanel i.e. Calibration Output
	    						   .add(jProgressBar1)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jLabelProgressBar1)
	    						   .addPreferredGap(LayoutStyle.UNRELATED)
	    						   .add(jProgressBar2)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jLabelProgressBar2)
	    						   .addPreferredGap(LayoutStyle.UNRELATED)
	    						   .add(jLabelOutputLog)
	    						   .addPreferredGap(LayoutStyle.RELATED)
	    						   .add(jScrollPanel)
	    						   .addPreferredGap(LayoutStyle.UNRELATED,5*gap,5*gap)   
	    				   )
	          
	    		   );
	   
				
			  } // end run() method
		}); // end EventQueue.invokeLater

		//	Set these here just in case.
		// As the EventQueue should process the invokeLater commands in the correct order
		// it shoiuldn't matter whether these are here or in the run() method above but better safe than sorry
		JButtonNext.setEnabled(false);
		JButtonPrevious.setEnabled(false);
		jProgressBar2.setValue((prefs.imagefiles.getSize()*calibrationnumberofsubsteps)+calibrationsheetinterrogationnumberofsteps+objectvoxelisationnumberofsteps);
		 
		// Invoke the thread to do the actual work
		Thread t=new Thread(new workingThread());
		t.start();
	}
	
	
	
	
	// This method is called at the end of everything to tidy it all up
	private void end() {
	if (save) {
		try {	
		prefs.save(); 
			}
		catch (Exception e) {
			System.out.println("Error saving preferences");
			System.out.println(e);
			}
		}
	dispose();
	System.exit(0);
	}
  
 	
	// This sets the initial GUI interface with just Cancel, Previous, and Next buttons
	private void initComponents() {
		surfacetriangles=new TriangularFace[0];
		surfacepoints=new Point3d[0];
		
		
		setDefaultLookAndFeelDecorated(false);    
		setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		    // Uncomment if use menus
	        //JMenuBar menubar = new JMenuBar();
	        //The below line is required so menus float over Java3DsetHorizontalGroup
	        //JPopupMenu.setDefaultLightWeightPopupEnabled(false);
	        
	        //Example of how to create menus
	        //JMenu viewMenu = new JMenu("View");
	        //viewMenu.setMnemonic(KeyEvent.VK_V);
	        //menubar.add(viewMenu);
	        
	        //Example of how to create menu items
	        //JMenuItem X = new JMenuItem("X", KeyEvent.VK_X);
	        //X.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, ActionEvent.CTRL_MASK));
	        //X.addActionListener(new ActionListener() {
			//	public void actionPerformed(ActionEvent arg0) {
			//		onX();
			//	}});
	        //viewMenu.add(X);
	        
	        // Or, if want menu checkboxes
	        // samplecheckbox = new JCheckBoxMenuItem("Title");
	        // where the checkbox has previously been defined as
	        //  private JCheckBoxMenuItem samplecheckbox;
	        
	        //Uncomment if use menus
	        //mainFrame.setJMenuBar(menubar);
	      
	    //Set the Frame dimensions to half the screen width and height i.e. 1/4 of the screen area and center it
		// Note that for dual screen setups with the same screen resolution on both 
		// it will probably snap to the edge of the leftmost screen as it will take up the whole width of one screen. 
	        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
	        //Dimension frameSize = new Dimension(screenSize.width/2, screenSize.height/2);
	        Dimension frameSize = new Dimension(640,480);
	        if (screenSize.width<frameSize.width) frameSize=new Dimension(screenSize.width,screenSize.height);
	        setPreferredSize(frameSize);	        
	        setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);
	        // Set up the Cancel, Previous, Next buttons and Title
	        jLabelTitle = new JLabel();
	        jLabelTitle.setSize(360, gap);
	        JButtonNext = new JButton();
	        JButtonCancel = new JButton();
	        JButtonPrevious = new JButton();
	        // set progress bars to initial values
	        jProgressBar1=new JProgressBar(0,1);
	        jProgressBar2=new JProgressBar(0,1);
	        jProgressBar1.setValue(1);
	        jProgressBar2.setValue(1);
	        
	        
	        // What happens when you press the default buttons Next, Previous, and Cancel	        
	        JButtonNext.addActionListener(new ActionListener() {
	            public void actionPerformed(ActionEvent evt) {
	            	if (!currentstep.equals(laststep)) // currentstep should never equal laststep at this point but just in case, do nothing.
	             	   setStep(stepsarray[currentstep.ordinal()+1]);
	            	
	            	
	            }
             });
            JButtonPrevious.addActionListener(new ActionListener() {
	            public void actionPerformed (ActionEvent evt) {
	            	//currentstep should never equal firststep at this point (as the previous button should be disabled for the first screen 
	            	//but just in case, do nothing.
	            	if (!currentstep.equals(firststep)) setStep(stepsarray[currentstep.ordinal()-1]); 
	            }
            });
            JButtonCancel.addActionListener(new ActionListener() {
	            public void actionPerformed(ActionEvent evt) {
	            	save=prefs.SaveOnProgramCancel;
	            	setStep(laststep); 
	            }
            });
         

            // Add in a Listener for WindowsExit to gracefully close the program
            addWindowListener(new WindowAdapter() {
               public void windowClosing(WindowEvent evt) { 
            	   save=prefs.SaveOnProgramWindowClose;
            	   setStep(laststep);
               }
            });	        
	        pack();
	        setVisible(true);
}

 

	/**************************************************************************************************************************************************************************
	 * 
	 * Private methods invoked by without user interaction one after the other by the Calibration step
	 * 
	 * These are primarily in different methods for tidyness only
	 *
	 **************************************************************************************************************************************************************************/
	private void ProcessCalibrationSheet(){
		   JProgressBar bar=new JProgressBar(0,1);
		   
					   try{ 
							// This is the recommended way of passing GUI information between threads
								  EventQueue.invokeLater(new Runnable(){
									  public void run(){
										  jLabelProgressBar1.setText("Please wait...");
										  jLabelProgressBar2.setText("Finding Circles in Calibration Sheet");
									  }
								  });
								 }
								 catch (Exception e) { 
									 System.out.println("Exception in updating the progress bar"+e.getMessage());
						         }
	
								 // We need to find values for these local variables, either by loading from file or by processing the calibration sheet
								 // then we can use them to set the global variables needed
								 Image calibrationsheet=new Image(); // only using the width and height values after the if statement
								 double circleradius=0;
								 calibrationcircles=new Ellipse[0]; // only use the ellipse centers after the if statement
								 boolean compute=true; // used to contol if the calibration sheet is interrogated or not
	 // If this step is supposed to be skipped, load the pre-computed properties if possible.
	if (prefs.SkipStep[currentstep.ordinal()])	{
		compute=false;
		CalibrationSheetProperties io=new CalibrationSheetProperties(prefs.calibrationpatterns.getElementAt(prefs.CurrentCalibrationPatternIndexNumber).toString()+".properties");
		try{
			io.load();
			circleradius=io.circleradius;
			calibrationsheet.width=io.width;
			calibrationsheet.height=io.height;
			calibrationcircles=io.calibrationcircles.clone();
			   
		}
		catch (Exception e){
			System.out.println("Error reading in pre-computed calibration sheet properties. Reverting to interrogation of calibration sheet image");
			compute=true;
		}
	}
	if (compute) {
		    		   // Read in the calibration image
		    		   calibrationsheet=new Image(prefs.calibrationpatterns.getElementAt(prefs.CurrentCalibrationPatternIndexNumber).toString()); // Read in the image with no blurring filter kernel
		    		   // Get the edge map for the calibration image	
		    		   EdgeExtraction2D edges=new EdgeExtraction2D(calibrationsheet);
		    		   edges.NonMaximalLocalSuppressionAndThresholdStrengthMap(prefs.AlgorithmSettingEdgeStrengthThreshold);
		    		   edges.RemoveSpuriousPoints();
		    		   FindEllipses find=new FindEllipses(edges,1); 
		    		   // From the edgemap, finding the circles in the image in a perfect calibration sheet with perfect edge finding circles would be finding ellipses with major axis being any length and lowest angle is 0, finding the minor axis within 1 pixel
		    		   // Note that this assumes the calibration sheet has square pixels so circles are actually circles i.e. major and minor axes are both the same	
		    		   // And that the edge finding is exactly pixel perfect. To make up for where this is not the case we use the lowest angle to be 10 degrees which means it will find ellipses with the minor axis being at least 98.5% of the size of the major axis
		    		   bar.setValue(0);
		    		   double minsquared=0;
		    		   double angle=((double)10/360)*tau; // Have to cast the numbers to double otherwise it does the calculation as int then casts to double which gives the value of 0.0
		    		   double maxsquared=Double.MAX_VALUE;
		    		 while (bar.getValue()<bar.getMaximum()){
		    					  bar=find.ExtractEllipses(minsquared,maxsquared,angle,1);
								  // If the range is at its widest, see if an ellipse has been found so we can refine the min/max range
								  if (maxsquared==Double.MAX_VALUE){
									  Ellipse[] ellipses=find.getEllipses();
									  if (ellipses.length!=0) {
										  // Set the min and max to 95% and 105% of the first found near-circle. 
										  minsquared=Math.pow(ellipses[0].GetMinorSemiAxisLength()*0.95*2,2);
										  maxsquared=Math.pow(ellipses[0].GetMajorSemiAxisLength()*1.05*2,2);
										 }
								  }
								  final JProgressBar temp=bar;
								  final boolean foundcircle=maxsquared!=Double.MAX_VALUE;
								  try{ 
							// This is the recommended way of passing GUI information between threads
									  EventQueue.invokeLater(new Runnable(){
									  public void run(){
										  jProgressBar1.setMinimum(temp.getMinimum());
										  jProgressBar1.setMaximum(temp.getMaximum());
										  jProgressBar1.setValue(temp.getValue());
										  if (foundcircle) jLabelProgressBar1.setText("Finding Circles in Calibration Sheet");
									  }
								  });
								 }
								 catch (Exception e) { 
									 System.out.println("Exception in updating the progress bar"+e.getMessage());
						         }
							  } // end while
		    		   calibrationcircles=find.getEllipses();
		    		   circleradius=0;
		    		   // Find the consensus radius for the calibration sheet circles i.e. the average of all the semi-minor and semi-major axis lengths
		    		   for (int i=0;i<calibrationcircles.length;i++)  circleradius=circleradius+calibrationcircles[i].GetMinorSemiAxisLength()+calibrationcircles[i].GetMajorSemiAxisLength();
		    		   circleradius=circleradius/(2*calibrationcircles.length);
		    			if (prefs.SaveCalibrationSheetProperties){
		    			   CalibrationSheetProperties io=new CalibrationSheetProperties(prefs.calibrationpatterns.getElementAt(prefs.CurrentCalibrationPatternIndexNumber).toString()+".properties");
		    			   io.circleradius=circleradius;
		    			   io.width=calibrationsheet.width;
		    			   io.height=calibrationsheet.height;
		    			   io.calibrationcircles=calibrationcircles.clone();
		    			   try{io.save();}
		    			   catch (Exception e){System.out.println("Error writing calibration sheet properties.");}
		    		   } // end if save
	} // end if compute
		    		 		   
		    		   // Record the calibration sheet width and height in pixels for use in debugging
						calibrationsheetpixelswidth=calibrationsheet.width;
						calibrationsheetpixelsheight=calibrationsheet.height;
						// simple if statements to find the width and height of the calibration sheet in mm.
		    		   double w,h;
		   				if (prefs.PaperSizeIsCustom.isSelected()){ w= Double.valueOf(prefs.PaperCustomSizeWidthmm.getText()); h=Double.valueOf(prefs.PaperCustomSizeHeightmm.getText());}
		   				else {Papersize current=(Papersize)prefs.PaperSizeList.getElementAt(prefs.CurrentPaperSizeIndexNumber);w=current.width;h=current.height;}
		   				// Swap w and h around if using landscape
		   				if (!prefs.PaperOrientationIsPortrait.isSelected()){double tempw=w;w=h;h=tempw;}
		   			//	Now Convert the calibration sheet dimensions to real world coordinates (mm) rather than pixel coordinates based on known calibration printed sheet size and margins
		    		  // Note that if the pixels in the printed calibration sheet are not square the circles will become ellipses. This matters for the backprojection later on.
		    		   
		    		    
		   			
		   			// Set the calibration sheet width and height in real world coordinates (i.e. in terms of mm)
		   			// taking into account whether or not the image was printed in portrait or landscape
		   			if (prefs.PaperOrientationIsPortrait.isSelected()){
		   				calibrationsheetwidth=w-Double.valueOf(prefs.PaperMarginHorizontalmm.getText());
		   				calibrationsheetheight=h-Double.valueOf(prefs.PaperMarginVerticalmm.getText());
		   			}
		   			else{
		   				calibrationsheetheight=w-Double.valueOf(prefs.PaperMarginHorizontalmm.getText());
		   				calibrationsheetwidth=h-Double.valueOf(prefs.PaperMarginVerticalmm.getText());
		   			}
		   			if (calibrationsheetheight<1) calibrationsheetheight=1;
		    		if (calibrationsheetwidth<1) calibrationsheetwidth=1;
		    		   // Assuming the image was squashed/stretched to fill the whole area with no regard for aspect ratio
		    		   double xscale=calibrationsheetwidth/calibrationsheet.width; // gives how many pixels per mm in the x direction
		    		   double yscale=calibrationsheetheight/calibrationsheet.height; // gives how many pixels per mm in the y direction
		    		   // Adjust if the aspect ratio was preserved
		    		   if (prefs.CalibrationSheetKeepAspectRatioWhenPrinted.isSelected()){
		    			   // The scale in the larger dimension will not need to be changed but the other will need to be recalculated to match it
		       			   if (calibrationsheet.height>calibrationsheet.width){
		       				calibrationsheetwidth=yscale*calibrationsheet.width;
		       				xscale=yscale;
		       			   }
		       			   else {
		       				calibrationsheetheight=xscale*calibrationsheet.height;
		       				yscale=xscale;
		       			   }
		       		   }
		 
		    		   // Convert the centres of the circles from the calibration sheet to a real world (i.e. in terms of mm) coordinate system with the origin at the center of the sheet and round them to the nearest pixel
		    		  // And put them in a Point2d array after changing the coordinate system to have the origin in the center of the calibration sheet (assuming the current calibration sheet coordinate system has 0,0 at the bottom left corner.)
					  calibrationcirclecenters=new Point2d[calibrationcircles.length];
		    		  Point2d calibrationcsheetcenter=new Point2d(calibrationsheetwidth/2,calibrationsheetheight/2); 
		    		  for (int i=0;i<calibrationcircles.length;i++){
		    			  calibrationcirclecenters[i]=new Point2d((calibrationcircles[i].GetCenter().x*xscale),(calibrationcircles[i].GetCenter().y*yscale));
		    			   calibrationcirclecenters[i].minus(calibrationcsheetcenter);
		    		   }
		    		  
		    		   //Also construct the volume of interest knowing that the world coordinates have the origin at the centre of the calibration sheet, x and y scales are those of the image
		    		   // and the z axis is perpindicular to the calibration sheet with positive z above it and a scale based on the x and y scales
		    		   volumeofinterest=new AxisAlignedBoundingBox();
		    		   volumeofinterest.minx=-calibrationsheetwidth/2;
		    		   volumeofinterest.maxx=calibrationsheetwidth/2;
		    		   volumeofinterest.miny=-calibrationsheetheight/2;
		    		   volumeofinterest.maxy=calibrationsheetheight/2;
		    		   volumeofinterest.minz=0;
		    		   //recalculate the max z value
		    		   if (calibrationsheetheight>calibrationsheetwidth) volumeofinterest.maxz=calibrationsheetheight;
		    		   else volumeofinterest.maxz=calibrationsheetwidth;
						
		    		    // calculate the semi-axis lengths and orientation angle to produce the printed (and squashed/stretched) circle/ellipse (lacking only a center)
		    		   calibrationsheetxlength=circleradius*xscale;
		    		   calibrationsheetylength=circleradius*yscale;
		    		   double calibrationsheetangle=0;
		    		   if (calibrationsheetylength>calibrationsheetxlength)  calibrationsheetangle=tau/4;
		    		   standardcalibrationcircleonprintedsheet=new Ellipse(new Point2d(0,0),calibrationsheetxlength,calibrationsheetylength,calibrationsheetangle);
		    		
  
		    		   String extratext="";
		    		   if (calibrationsheetxlength!=calibrationsheetylength){
		    			   String direction;
		    			   if (calibrationsheetangle==0) direction="X"; 
		    			   else direction="Y";
		    			    extratext="Given the size of the printed sheet this means calibration circles are printed as ellipses \noriented in the "+direction+" direction with semi-axis lengths of "+new BigDecimal(calibrationsheetxlength,new MathContext(4, RoundingMode.DOWN)).toString()+"mm and "+new BigDecimal(calibrationsheetylength,new MathContext(4, RoundingMode.DOWN)).toString()+"mm\n";
		    		   }
		    		   else extratext="Given the size of the printed sheet this means calibration circles are printed as circles \nwith radius of "+new BigDecimal(calibrationsheetxlength,new MathContext(4, RoundingMode.DOWN)).toString()+"mm\n";
				    final String firsttext=""+calibrationcirclecenters.length+" circle(s) found in calibration sheet with radius estimated to be approximately "+Math.round(circleradius)+" pixels \n"+extratext;
						  EventQueue.invokeLater(new Runnable(){
							  public void run(){
								 jTextAreaOutput.setText(firsttext);
							  }
						  });

	}
	
	
	private Point2d[] FindEllipses(int i){
		EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  jProgressBar1.setValue(jProgressBar1.getMinimum());
				  jProgressBar2.setValue(jProgressBar2.getValue()+1);
				  jLabelProgressBar1.setText("Finding Ellipses in the image");
			 
			  }
		  }); 
		
		double lowestangleinradians=((double)prefs.AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees/360)*tau; 
		   // Load up the kernel to apply a semi-Gaussian filter of radius 3 (where the radius is the 3-sigma point) to the image at the same time as reading into memory
		   float[] kernel=GetGaussianFilter(3);
		   //Load the greyscale image in with no pre-processing filtering
		   //images[i]=new CalibratedImage(prefs.imagefiles.getElementAt(i).toString());	
		   // Load the image in apply the Gaussian filtering kernel as a pre-processing filtering step
		   images[i]=new Image(prefs.imagefiles.getElementAt(i).toString(), kernel);	
		  	
		   // Re-sample image based on the width algorithm parameter and keeping current aspect ratio
		   int width=prefs.AlgorithmSettingResampledImageWidthForEllipseDetection;
		   double scale=(double)images[i].width/(double)width;
		   int height=(int)((double)images[i].height/scale);
		   PixelColour[][] scaledpixels=new PixelColour[width][height];
		   for (int x=0;x<width;x++){
			   final JProgressBar temp=new JProgressBar(0,width);
			   final int h=height;
			   temp.setValue(x);
			     try{ 
			// This is the recommended way of passing GUI information between threads
					  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  jProgressBar1.setMinimum(temp.getMinimum());
						  jProgressBar1.setMaximum(temp.getMaximum());
						  jProgressBar1.setValue(temp.getValue());
						  jLabelProgressBar1.setText("Temporarily resampling image to "+temp.getMaximum()+"x"+h);
					  }
				  });
				 }
				 catch (Exception e) { 
					 System.out.println("Exception in updating the progress bar"+e.getMessage());
		         }
				 for (int y=0;y<height;y++){
				   Point2d point=new Point2d(x*scale,y*scale);//Note that this assumes the origin of the image coordinates is not changed from the initial reading it in
				   scaledpixels[x][y]=images[i].InterpolatePixelColour(point); 
			   }
			}
		   Image scaledimage=new Image(scaledpixels,width,height);
		   
		   /* Now we construct a right angle triangle. If we label the sides a,b,h (for hypotenuse)
		    * we can make the length of side a the length of the diagonal across the image and angle(A) is the lowestangle value
		    * Now we find the lengths of b and h
		    * 
		    *  We are assuming that as the angle gets further from the vertical that the camera gets closer to the calibration sheet so that in the limit where we are at the lowest angle
		    *  the camera is directly above the edge of the calibration sheet. Therefore in the calculation we're doing, h is the distance to the middle of the furtherest away circle viewed at the lowest angle
		    *  and b is the distance to the middle of the closest circle when viewed at this lowest angle.
		    *   
		    *  As the distance to an object increases the angle between the edges decreases and when converted to a known distance plane it appears smaller.
		    *  We now have the ratio of min:max long axis length i.e. b:h
		    *  
		    *  We also assume that the image contains all of the calibration sheet. If the image contains nothing but the calibration sheet then this is obviously the maximal size of the ellipses.
		    *  For this to occur the camera must be directly above the calibration sheet center and the circles will be seen as circles.
		    *  To get the maximum long axis length therefore we just need the radius of circles in the calibration sheet and the ratio of width to height in the calibration sheet and image.
		    *  
		    */
		   double asquared=Math.pow(scaledimage.width,2)+Math.pow(scaledimage.height,2);
		   double a=Math.sqrt(asquared);
		   // using standard trig sin(A)=a/h, rearranging to get h we have h=a/sin(A) where A=lowestangleinradians 
		   double h=a/Math.sin(lowestangleinradians);
		   // Using pythagoras we now find b: a^2+b^2=h^2 so b^2=h^2-a^2
		   double b=Math.sqrt((h*h)-asquared);
		   
		   // Find the maximum semi-axis length of an ellipse when the image contains the whole calibration sheet and nothing else.
		   double radiustowidth=calibrationsheetxlength/calibrationsheetwidth;
		   double radiustoheight=calibrationsheetylength/calibrationsheetheight;
		   double maxradius=radiustowidth*scaledimage.width;
		   if (radiustoheight*scaledimage.height>maxradius) maxradius=radiustoheight*scaledimage.height;
		  
		   // Now convert this to the max and min long axes squared
		   double maxsquared=Math.pow((maxradius*2),2);
		   double minsquared=Math.pow((maxradius*2*(b/h)),2);;
		   double accumulatorquantumsize=5;
		   EdgeExtraction2D edges=new EdgeExtraction2D(scaledimage);
		   
		   if ((prefs.Debug) && (prefs.DebugEdgeFindingForEllipseDetection)){
			   GraphicsFeedback graphics=new GraphicsFeedback(true);
			   byte[][] temp=edges.GetStrengthMap();
			   boolean[][] newimage=new boolean[scaledimage.width][scaledimage.height];
			   for (int x=0;x<scaledimage.width;x++)
				   for (int y=0;y<scaledimage.height;y++)
					   newimage[x][y]=((int)temp[x][y]!=0);
				graphics.ShowBinaryimage(newimage,scaledimage.width,scaledimage.height);
				String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"InitialEdgeStrengthMapImage"+i+".jpg";
				graphics.SaveImage(filename);
		   }
		   
		   
		   edges.NonMaximalLocalSuppressionAndThresholdStrengthMap(prefs.AlgorithmSettingEdgeStrengthThreshold);
		   edges.RemoveSpuriousPoints();
		   
		   if ((prefs.Debug) && (prefs.DebugEdgeFindingForEllipseDetection)){
			   GraphicsFeedback graphics=new GraphicsFeedback(true);
			   byte[][] temp=edges.GetStrengthMap();
			   boolean[][] newimage=new boolean[scaledimage.width][scaledimage.height];
			   for (int x=0;x<scaledimage.width;x++)
				   for (int y=0;y<scaledimage.height;y++)
					   newimage[x][y]=((int)temp[x][y]!=0);
				graphics.ShowBinaryimage(newimage,scaledimage.width,scaledimage.height);
				String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"FilteredEdgeStrengthMapImage"+i+".jpg";
				graphics.SaveImage(filename);
		   }
		   
		   
		   FindEllipses find=new FindEllipses(edges,standardcalibrationcircleonprintedsheet.GetMinorSemiAxisLength()/standardcalibrationcircleonprintedsheet.GetMajorSemiAxisLength()); 
		    // Find the ellipses 
		  JProgressBar bar=new JProgressBar(0,1);
		   bar.setValue(0);
		  	
			 while (bar.getValue()<bar.getMaximum()){
					  bar=find.ExtractEllipses(minsquared,maxsquared,lowestangleinradians,accumulatorquantumsize);
					  final JProgressBar temp=bar; 
					  try{ 
				// This is the recommended way of passing GUI information between threads
						  EventQueue.invokeLater(new Runnable(){
						  public void run(){
							  jProgressBar1.setMinimum(temp.getMinimum());
							  jProgressBar1.setMaximum(temp.getMaximum());
							  jProgressBar1.setValue(temp.getValue());
							  jLabelProgressBar1.setText("Finding Ellipses in the resampled image");
						  }
					  });
					 }
					 catch (Exception e) { 
						 System.out.println("Exception in updating the progress bar"+e.getMessage());
			         }
				  } // end while
		   int countellipses=0;
		   imageellipses=find.getEllipses();
		   boolean keep[]=new boolean[imageellipses.length];
		   // Take out those ellipses that aren't black ellipses on a white background
		   for (int j=0;j<imageellipses.length;j++){
			   // Rescale the imageellipses to be the same as the original image size now
			   	imageellipses[j]=new Ellipse(imageellipses[j].GetCenter().timesEquals(scale),imageellipses[j].GetMajorSemiAxisLength()*scale,imageellipses[j].GetMinorSemiAxisLength()*scale,imageellipses[j].GetOrientationAngleinRadians());
				// Test to see whether this should be kept or not
			   	keep[j]=imageellipses[j].IsBlackEllipseOnWhiteBackground(images[i],prefs.AlgorithmSettingEdgeStrengthThreshold,prefs.AlgorithmSettingEllipseValidityThresholdPercentage);
			   if (keep[j]) countellipses++;
		   }
		    
		   // Output the debug file if appropriate, this will show all ellipses found, the valid ones in green and the rest in red
				if ((prefs.Debug) && (prefs.DebugEllipseFinding)){
						PixelColour red=new PixelColour(PixelColour.StandardColours.Red);
						PixelColour green=new PixelColour(PixelColour.StandardColours.Green);
						
						GraphicsFeedback graphics=new GraphicsFeedback(true);
						graphics.ShowImage(images[i]);
						for (int j=0;j<imageellipses.length;j++){
							   if (keep[j]) graphics.OutlineEllipse(imageellipses[j],green,images[i].originofimagecoordinates);
							   else graphics.OutlineEllipse(imageellipses[j],red,images[i].originofimagecoordinates);
						   }
						String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"FoundEllipsesInImage"+i+".jpg";
						graphics.SaveImage(filename);
					}

		   Point2d[] ellipsecenters=new Point2d[countellipses];
	      countellipses=0;
		   for (int j=0;j<imageellipses.length;j++) {
			   if (keep[j]) {
				   imageellipses[j].ResetCenter(imageellipses[j].GetCentreOfGravity(images[i],prefs.AlgorithmSettingEdgeStrengthThreshold));
				   ellipsecenters[countellipses]=imageellipses[j].GetCenter();
				   countellipses++;
			   }
		   }
			 // display output
		   final String text="Number of Ellipses detected in image "+(i+1)+"="+ellipsecenters.length+"\n";
			//if (ellipsecenters.length==imageellipses.length) text="Number of Ellipses detected in image "+i+"="+imageellipses.length+"\n";
			//else text="Number of Ellipses detected in image "+i+"="+imageellipses.length+" which were cut down to "+ellipsecenters.length+" which have a similar eccentricity\n";
				
			 	  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  jTextAreaOutput.setText(jTextAreaOutput.getText()+text);
					  }
				  });
		return ellipsecenters;		 
	}
	
	private boolean Continue(int j,Point2d[] ellipsecenters){
		boolean returnvalue=(ellipsecenters.length!=0);
		if (!returnvalue){
				final String text3="Error: No ellipses found in the image, this image will not be processed further\n";
				  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  jTextAreaOutput.setText(jTextAreaOutput.getText()+text3);
					  }
				  });
			}
			else {

				// Test to make sure there is at least 4 non-colinear points. 
				boolean skip;
				int count=2;
				int third=0;
				if (ellipsecenters.length>=4){
					for (int i=2;i<ellipsecenters.length;i++){
						if (count<4){
							skip=ellipsecenters[i].isCollinear(ellipsecenters[0],ellipsecenters[1]);
							if (count==3){
								skip=skip || ellipsecenters[i].isCollinear(ellipsecenters[0],ellipsecenters[third]);
								skip=skip || ellipsecenters[i].isCollinear(ellipsecenters[1],ellipsecenters[third]);
							}
							if (!skip) {
								count++;
								if (count==3) third=i;
							}
						} // end if
					} // end for
				} // end if
			returnvalue=count>=4;	
				
			  if (!returnvalue){ // four non-collinear points is the minimum number of point matches to get a homography to find camera parameters, rotation, and translation, although 8 are needed for lens distortion matrix
				final String text4="Error: Not enough ellipses found in the image or all centre points are collinear, this image will not be processed further.\n Four is the absolute minimum\n";
				  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  jTextAreaOutput.setText(jTextAreaOutput.getText()+text4);
					  }
				  });
			  }
			}
		images[j].skipprocessing=!returnvalue;	 
		return returnvalue;
		}
	
	private PointPairMatch MatchCircles(int i, Point2d[]ellipsecenters){
		  // Update progress bars
		EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  jProgressBar1.setValue(jProgressBar1.getMinimum());
				  jProgressBar2.setValue(jProgressBar2.getValue()+1);
				  jLabelProgressBar1.setText("Matching Calibration Circles in the image");
			 
			  }
		  });
	PointPairMatch circles=new PointPairMatch(ellipsecenters);
	  
	JProgressBar bar=new JProgressBar(0,1);
	bar.setValue(bar.getMinimum());
		  while (bar.getValue()<bar.getMaximum()){
//			This matches circle centers in the calibration sheet with ellipse centers found in the image
			 bar=circles.MatchCircles(calibrationcirclecenters);
			 // bar=circles.OldMatchCircles(calibrationcirclecenters);
			  final JProgressBar temp=bar; 
			  try{ 
			// This is the recommended way of passing GUI information between threads
				  EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  // Update progress bar
						  jProgressBar1.setMinimum(temp.getMinimum());
						  jProgressBar1.setMaximum(temp.getMaximum());
						  jProgressBar1.setValue(temp.getValue());
					  }
				  });
			  }
			  catch (Exception e) { 
				  System.out.println("Exception in updating the progress bar"+e.getMessage());
	         }
	  } // end while
	  // display output
		  final String text4="Number of Matched Point Pairs in image "+(i+1)+"="+circles.getNumberofPointPairs()+"\n";
		  EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  jTextAreaOutput.setText(jTextAreaOutput.getText()+text4);
			 
			  }
		  });
		  return circles;
}
	
	private LensDistortion EstimatingCameraParameters(int i, PointPairMatch circles){
		//Update Progress bars
		EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  jProgressBar1.setMinimum(0);
				  jProgressBar1.setValue(jProgressBar1.getMinimum());
				  jProgressBar1.setMaximum(prefs.AlgorithmSettingMaxBundleAdjustmentNumberOfIterations);
				  jProgressBar2.setValue(jProgressBar2.getValue()+1);
				  jLabelProgressBar1.setText("Estimating and fine-tuning camera parameters");
			 
			  }
		  });
		
		//LensDistortion previousdistortion=new LensDistortion();
			LensDistortion distortion=new LensDistortion();
			//double olderror=0;
			//CalibratedImage oldimage=new CalibratedImage();
			
  
	

			  //  Extract the point pairs with pointone being the calibration sheet and pointtwo the image coordinates
				images[i].matchingpoints=circles.getMatchedPoints();
				
				
				// Camera Calibration from these matching points. Currently only doing once but could do this a number of times, readjusting the points in light of previously calculated lens distortion
				//for (int iterate=0;iterate<maxiterations;iterate++){
					// This is all in a sub-method so the loop is easy to read
				if (!images[i].skipprocessing) distortion=IndividualCameraCalibration(i,prefs.AlgorithmSettingMaxBundleAdjustmentNumberOfIterations);
					  // adjust the matched points in the image
					if (!images[i].skipprocessing) {
						for (int j=0;j<images[i].matchingpoints.length;j++) {
						  images[i].matchingpoints[j].pointtwo=distortion.UndoThisLayerOfDistortion(images[i].matchingpoints[j].pointtwo);
					  }
					//if (iterate==0)	{ // Initialise the previous values if this is the first time through
					//	previousdistortion=distortion.clone();
					//	olderror=images[i].GetDsquaredSumError();
					//	oldimage.CopyCalibrationParameters(images[i]);
					//}
					//else { // Compare to the previous values
					//	double error=images[i].GetDsquaredSumError();
					//	if ((olderror-error)>1){ // if the new adjustment is significantly better than the old one, use it and continue the loop, otherwise exit the loop prematurely
					//		previousdistortion.SetLowerLayersOfDistortion(distortion);
  				//		distortion=previousdistortion.clone();
  				//		oldimage.CopyCalibrationParameters(images[i]);
  				//		olderror=error;
					//	}
					//	else {
					//		// Revert the camera parameters and macthed points back to their previous state and exit the loop prematurely
					//		images[i].CopyCalibrationParameters(oldimage);
					//		iterate=maxiterations+1;
					//	}
					//} // end else iterate==0
				// Update the progress bar
					final int progress=prefs.AlgorithmSettingMaxBundleAdjustmentNumberOfIterations;  
				  //final int progress;
				  //if (iterate<maxiterations) progress=(iterate+1)*prefs.AlgorithmSettingMaxBundleAdjustmentNumberOfIterations;
				  //else progress=maxiterations*prefs.AlgorithmSettingMaxBundleAdjustmentNumberOfIterations;
					try{ 
				// This is the recommended way of passing GUI information between threads
					  EventQueue.invokeLater(new Runnable(){
						  public void run(){
							jProgressBar1.setValue(progress);
						  }
					  });
				  }
				  catch (Exception e) { 
					  System.out.println("Exception in updating the progress bar"+e.getMessage());
		         }	
					}
				//} // end for loop
				return distortion;
	}
	private void UndoLensDistortion(int i,LensDistortion distortion, boolean colour){
		// Update progress bars
		EventQueue.invokeLater(new Runnable(){
					  public void run(){
						  jLabelProgressBar1.setText("Undoing lens distortion");
						  jProgressBar1.setValue(jProgressBar1.getMinimum());
						  jProgressBar2.setValue(jProgressBar2.getValue()+1);
					  }
				  });	    		 

		  if (!images[i].skipprocessing) images[i].NegateLensDistortion(distortion,jProgressBar1);
		  }
	private void ImageSegmentation(int i){
		//From the known camera calibration and the matching circle centers on the calibration sheet found, determine the visible portion of the calibration sheet
		// Update progress bars
		EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  jLabelProgressBar1.setText("Finding visible portion of Calibration Sheet");
				  jProgressBar1.setValue(jProgressBar1.getMinimum());
				  jProgressBar2.setValue(jProgressBar2.getValue()+1);
				}
		  });

		//		 Redo the edge calculations now that we have corrected for lens distortion
			EdgeExtraction2D edges=new EdgeExtraction2D(images[i]);
			edges.NonMaximalLocalSuppressionAndThresholdStrengthMap(prefs.AlgorithmSettingEdgeStrengthThreshold);
			edges.RemoveSpuriousPoints();
			// Recalculate the ellipses now that we know the camera position 
			Ellipse[] matchedellipses=new Ellipse[images[i].matchingpoints.length];
  		// Finding ellipse from camera matrix, circle centre, and radius
  		for (int j=0;j<images[i].matchingpoints.length;j++){
				// Create the matched ellipse as a circle in the calibration sheet
  			// transformed to the image
  			Ellipse tempellipse=standardcalibrationcircleonprintedsheet.clone();
  			tempellipse.ResetCenter(images[i].matchingpoints[j].pointone);
			matchedellipses[j]=new Ellipse(images[i].getWorldtoImageTransformMatrix(),images[i].originofimagecoordinates,tempellipse,360);
      		// But readjust the centre to be the one we found in the image rather than the calculated on
				matchedellipses[j].ResetCenter(images[i].matchingpoints[j].pointtwo);
		}														      													
  		
  		// Find the calibration sheet corners in the image and order them anti/clockwise (so that corners 1 and 3 are on opposite sides of the calibration sheet)
  		// Note that the calibration sheet corners are adjusted 1mm out in both x and y to take ocare of possible rounding errors.
  		Point2d[] corners=new Point2d[4];
  		corners[0]=images[i].getWorldtoImageTransform(new Point3d(((double)(-calibrationsheetwidth)/2)-1,((double)(-calibrationsheetheight)/2)-1,0).ConvertPointTo4x1Matrix());
  		corners[1]=images[i].getWorldtoImageTransform(new Point3d(((double)(-calibrationsheetwidth)/2)-1,((double)(calibrationsheetheight)/2)+1,0).ConvertPointTo4x1Matrix());
  		corners[2]=images[i].getWorldtoImageTransform(new Point3d(((double)(calibrationsheetwidth)/2)+1,((double)(calibrationsheetheight)/2)+1,0).ConvertPointTo4x1Matrix());
  		corners[3]=images[i].getWorldtoImageTransform(new Point3d(((double)(calibrationsheetwidth)/2)+1,((double)(-calibrationsheetheight)/2)-1,0).ConvertPointTo4x1Matrix());
  		
		// Give this information to the ImageSegmentation class	
  		ImageSegmentation segmented=new ImageSegmentation(edges,corners);
  			JProgressBar bar=new JProgressBar(0,1);
			 bar.setValue(bar.getMinimum());
			  while (bar.getValue()<bar.getMaximum()){
				  bar=segmented.Segment(matchedellipses, images[i]);
				  final JProgressBar temp=bar; 
				  try{ 
				// This is the recommended way of passing GUI information between threads
					  EventQueue.invokeLater(new Runnable(){
						  public void run(){
							  jProgressBar1.setMinimum(temp.getMinimum());
							  jProgressBar1.setMaximum(temp.getMaximum());
							  jProgressBar1.setValue(temp.getValue());
						  }
					  });
				  }
				  catch (Exception e) { 
					  System.out.println("Exception in updating the progress bar"+e.getMessage());
		         }
		  } // end while
			// Take this information and feed it back as a mask for the edges so we can eliminate those edges that are part of the calibration sheet 
				edges.ApplyMask(segmented.GetEdges());
				
				images[i].SetEdges(edges);
				images[i].SetProcessedPixels(segmented.GetCalibrationSheet());
				// Also take out those pixels that are do not form rays that cross our volume of interest
				images[i].setPixelsOutsideBackProjectedVolumeToProcessed(volumeofinterest);
			  if (prefs.Debug && prefs.DebugImageSegmentation) segmented.Display(prefs.DebugSaveOutputImagesFolder+File.separatorChar+"SegmentedImage"+i+".jpg");
			
			  
			  // Update progress bars.
			EventQueue.invokeLater(new Runnable(){
			  public void run(){
				  jProgressBar1.setValue(jProgressBar1.getMinimum());
				  jProgressBar2.setValue(jProgressBar2.getValue()+1);
				 
			  }
		  });
	}
	
	/**************************************************************************************************************************************************************************
	 * 
	 * Private methods invoked by without user interaction one after the other by the Object Estimation step
	 * These are primarily in different methods for tidyness only
	 *
	 **************************************************************************************************************************************************************************/

	
	private Voxel Voxelisation(){
					  Voxel rootvoxel=new Voxel();
	    		 JProgressBar bar=new JProgressBar(0,1);
	    		 bar.setValue(bar.getMinimum());
					  while (bar.getValue()<bar.getMaximum()){
						  bar=rootvoxel.Voxelise(images,volumeofinterest,prefs.AlgorithmSettingVolumeSubDivision,bar);
						  final JProgressBar temp=bar;
						  // This just gives us four significant digits for the resolution
						  BigDecimal bigdecimal=new BigDecimal((rootvoxel.getVoxelResolution()/prefs.AlgorithmSettingVolumeSubDivision),new MathContext(4, RoundingMode.DOWN));
						  final String res=bigdecimal.toPlainString();
						  
						  
						  
						  try{ 
						// This is the recommended way of passing GUI information between threads
							  EventQueue.invokeLater(new Runnable(){
								  public void run(){
									  jProgressBar1.setMinimum(temp.getMinimum());
									  jProgressBar1.setMaximum(temp.getMaximum());
									  jProgressBar1.setValue(temp.getValue());
									  jLabelProgressBar1.setText("Estimating Bounding Volume Surface using boxes with a maximum of "+res+"mm on a side.");
								  }
							  });
						  }
						  catch (Exception e) { 
							  System.out.println("Exception in updating the progress bar"+e.getMessage());
				         }
				  } // end while
					  rootvoxel.RestrictSubVoxelsToGroundedOnes();
					 
						
	 					final String text2="Object bounding volume surface estimated using "+rootvoxel.getNumberofSurfaceSubVoxels()+" boxes.\n";
					  // display output
					  EventQueue.invokeLater(new Runnable(){
						  public void run(){
							  jTextAreaOutput.setText(jTextAreaOutput.getText()+text2);
							}
					  });
				return rootvoxel;	  
}
	
	private void RestrictSearch(Voxel rootvoxel){
		 try{ 
				// This is the recommended way of passing GUI information between threads
					  EventQueue.invokeLater(new Runnable(){
						  public void run(){
							  jProgressBar1.setValue(jProgressBar1.getMinimum());
							  jProgressBar2.setValue(jProgressBar2.getValue()+1);
							  jLabelProgressBar1.setText("Restricting Search space");
						  }
					  });
		 }
		 catch (Exception e) { 
			  System.out.println("Exception in updating the progress bar"+e.getMessage());
     }		  
	JProgressBar bar=new JProgressBar(0,(images.length*2)+1);
	 bar.setValue(0);
	  	 // Find the new volume of interest based on the surface voxels we've found
	  AxisAlignedBoundingBox[] surfacevoxels=rootvoxel.getSurfaceVoxels();
		for (int i=0;i<surfacevoxels.length;i++) {
			if (i==0) volumeofinterest=surfacevoxels[i].clone();
			else volumeofinterest.Expand3DBoundingBox(surfacevoxels[i]);
		}
	
		// Go through each image and scope out any pixels outside the volume of interest
		for (int i=0;i<images.length;i++){
			
			// Update progress bar
			bar.setValue(bar.getValue()+1);
			final JProgressBar temp2=bar;
			final String text="Restricting Search space for image "+(i+1)+" of "+images.length;
			 try{ 
					// This is the recommended way of passing GUI information between threads
						  EventQueue.invokeLater(new Runnable(){
							  public void run(){
								  jProgressBar1.setMinimum(temp2.getMinimum());
								  jProgressBar1.setMaximum(temp2.getMaximum());
								  jProgressBar1.setValue(temp2.getValue());
								  jLabelProgressBar1.setText(text);
							  }
						  });
					  }
					  catch (Exception e) { 
						  System.out.println("Exception in updating the progress bar"+e.getMessage());
			         }
			  
			
			images[i].setPixelsOutsideBackProjectedVolumeToProcessed(volumeofinterest);
			
//			 Update progress bar
			bar.setValue(bar.getValue()+1);
			 try{ 
					// This is the recommended way of passing GUI information between threads
						  EventQueue.invokeLater(new Runnable(){
							  public void run(){
								  jProgressBar1.setMinimum(temp2.getMinimum());
								  jProgressBar1.setMaximum(temp2.getMaximum());
								  jProgressBar1.setValue(temp2.getValue());
							  }
						  });
					  }
					  catch (Exception e) { 
						  System.out.println("Exception in updating the progress bar"+e.getMessage());
			         }
			
			
			images[i].setPixeltoProcessedIfNoVolumesOfInterestBackProjectsToIt(surfacevoxels);
			
			if (prefs.Debug && prefs.DebugRestrictedSearch){
				String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"RestrictedSearchForImageBinaryImage"+String.valueOf(i)+".jpg";
				GraphicsFeedback graphics=new GraphicsFeedback(true);
				boolean[][] processedpixels=images[i].getProcessedPixels();
				graphics.ShowBinaryimage(processedpixels,images[i].width,images[i].height);
				graphics.SaveImage(filename);
			
				// now save image with black background except where unprocessed pixels
				graphics.ShowImage(images[i]);
				PixelColour black=new PixelColour(PixelColour.StandardColours.Black);
				for (int x=0;x<images[i].width;x++)
					for (int y=0;y<images[i].height;y++){
						if (processedpixels[x][y]){
							graphics.Print(x,y,black,0,0);
						}
					}
				filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"RestrictedSearchForImageColourImage"+String.valueOf(i)+".jpg";
				graphics.SaveImage(filename);
					
			}
			
			
		} // end for
		
		// Update progress bar
		bar.setValue(bar.getValue()+1);
		final JProgressBar temp2=bar;
		 try{ 
				// This is the recommended way of passing GUI information between threads
					  EventQueue.invokeLater(new Runnable(){
						  public void run(){
							  jProgressBar1.setMinimum(temp2.getMinimum());
							  jProgressBar1.setMaximum(temp2.getMaximum());
							  jProgressBar1.setValue(temp2.getValue());
						  }
					  });
				  }
				  catch (Exception e) { 
					  System.out.println("Exception in updating the progress bar"+e.getMessage());
		         }
		
	}

	
	//TODO delete when not needed
	/*
	private void SurfaceVoxelsToTriangles(Voxel rootvoxel){
		 try{ 
				// This is the recommended way of passing GUI information between threads
					  EventQueue.invokeLater(new Runnable(){
						  public void run(){
							  jProgressBar1.setValue(jProgressBar1.getMinimum());
							  jProgressBar2.setValue(jProgressBar2.getValue()+1);
							  jLabelProgressBar1.setText("Converting to Triangles");
						  }
					  });
		 }
		 catch (Exception e) { 
			  System.out.println("Exception in updating the progress bar"+e.getMessage());
        }		  
		 TrianglePlusVertexArray triplusvertices=rootvoxel.ConvertSurfaceVoxelsToTriangles(jProgressBar1);
		 surfacepoints=triplusvertices.GetVertexArray();
		 surfacetriangles=triplusvertices.GetTriangleArray();
			  
			final String text2="Object bounding volume surface estimated using "+surfacetriangles.length+" triangles.\n";
			  // display output
			  EventQueue.invokeLater(new Runnable(){
				  public void run(){
					  jTextAreaOutput.setText(jTextAreaOutput.getText()+text2);
					}
			  });

	}
	*/


	private void GraphicsFeedback(){
		 if (prefs.Debug && prefs.DebugImageOverlay){
			 for (int j=0;j<images.length;j++){     						
				 PixelColour colour;
				 GraphicsFeedback graphics=new GraphicsFeedback();
				 graphics.ShowImage(images[j]); // Note that the graphics feedback should be called at the end, otherwise the colour image may not exist
				 if (!images[j].skipprocessing){
					 PointPair2D[] matchingpoints=images[j].matchingpoints.clone();
	    				
					
						// Show the matched points (image frame) in white
						colour=new PixelColour(PixelColour.StandardColours.White);
						for (int i=0;i<matchingpoints.length;i++) {
							Point2d temp=matchingpoints[i].pointtwo.clone();
							graphics.PrintPoint(temp.x,temp.y,colour);
						}
						
					// Show the estimated ellipse center of the matched circle transferred to the image coordinate plane in teal
					// as well as the ellipse itself
						for (int i=0;i<matchingpoints.length;i++) {
							colour=new PixelColour(PixelColour.StandardColours.Teal);
							Ellipse tempellipse=standardcalibrationcircleonprintedsheet.clone();
							tempellipse.ResetCenter(matchingpoints[i].pointone);
	   						Ellipse ellipse=new Ellipse(images[j].getWorldtoImageTransformMatrix(),images[j].originofimagecoordinates,tempellipse,360);
	   						Point2d temp=ellipse.GetCenter();
	   						graphics.PrintPoint(temp.x,temp.y,colour);
	   						graphics.OutlineEllipse(ellipse,colour,new Point2d(0,0));
							   							
						}
						// Show outline of calibration sheet
						colour=new PixelColour(PixelColour.StandardColours.Teal);
						for (int x=(int)(-calibrationsheetwidth/2);x<(calibrationsheetwidth/2);x++){
							//convert from calibration coordinates to image coordinates and draw top
							int y=(int)(calibrationsheetheight/2);
							Matrix point=new Matrix(4,1);
							point.set(0,0,x);
							point.set(1,0,y);
							point.set(3,0,1);
							Point2d temp;
//					3D Point Backprojection
						temp=images[j].getWorldtoImageTransform(point);
							graphics.PrintPoint(temp.x,temp.y,colour);
							
							//convert from calibration coordinates to image coordinates and draw bottom
							point=new Matrix(4,1);
							point.set(0,0,x);
							point.set(1,0,-y);
							point.set(3,0,1);
//					 3D Point Backprojection
						temp=images[j].getWorldtoImageTransform(point);
							graphics.PrintPoint(temp.x,temp.y,colour);
						} // end for x
						for (int y=(int)(-calibrationsheetheight/2);y<(calibrationsheetheight/2);y++){
							//convert from calibration coordinates to image coordinates and draw right
							int x=(int)(calibrationsheetwidth/2);
							Matrix point=new Matrix(4,1);
							point.set(0,0,x);
							point.set(1,0,y);
							point.set(3,0,1);
							Point2d temp;
//					 3D Point Backprojection
							temp=images[j].getWorldtoImageTransform(point);
							graphics.PrintPoint(temp.x,temp.y,colour);
							
							//convert from calibration coordinates to image coordinates and draw left
							point=new Matrix(4,1);
							point.set(0,0,-x);
							point.set(1,0,y);
							point.set(3,0,1);
//					 3D Point Backprojection
							temp=images[j].getWorldtoImageTransform(point);
							graphics.PrintPoint(temp.x,temp.y,colour);
							
						} // end for y

						
						
						/*
	   					// Show the inside sub voxel centers in black
						colour=new PixelColour(PixelColour.StandardColours.Black);
					graphics.PrintInsideSubVoxels(rootvoxel, images[j], colour);
						// Show the surface sub voxel centers in grey
						colour=new PixelColour(PixelColour.StandardColours.Gray);
					graphics.PrintSurfaceSubVoxels(rootvoxel, images[j], colour);
						//*/
						// Show the 3d Points backprojected into the image in grey
					
						colour=new PixelColour(PixelColour.StandardColours.Gray);
					for (int i=0;i<surfacepoints.length;i++){
							Matrix point=new Matrix(4,1);
							point.set(0,0,surfacepoints[i].x);
							point.set(1,0,surfacepoints[i].y);
							point.set(2,0,surfacepoints[i].z);
							point.set(3,0,1);
							if (!images[j].WorldPointBehindCamera(point)){
								Point2d temp=images[j].getWorldtoImageTransform(point);
								graphics.PrintPoint(temp.x,temp.y,colour);
							}
					} // end for i
					//*/	
				
					 } // end if !skipprocessing
				//graphics.initGraphics();
				
					String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"ImageOverlay"+String.valueOf(j)+".jpg";
					graphics.SaveImage(filename);
					System.out.println("Saved "+filename);	
				
			 } // end for
		} // end if prefs.DebugShowImageOverlay
		 // This is commented out so that OS dependent libraries don't need to be used.
		 //
		 /*
		 if (prefs.Debug && prefs.DebugShow3DModel){
			 // Get the camera centres
			 Point3d[] C=new Point3d[images.length];
			  for (int i=0;i<C.length;i++) C[i]=new Point3d(new MatrixManipulations().GetRightNullSpace(images[i].getWorldtoImageTransformMatrix()));
			 
			  AxisAlignedBoundingBox oldvolumeofinterest=new AxisAlignedBoundingBox();
   		   oldvolumeofinterest.minx=-calibrationsheetwidth/2;
   		   oldvolumeofinterest.maxx=calibrationsheetwidth/2;
   		   oldvolumeofinterest.miny=-calibrationsheetheight/2;
   		   oldvolumeofinterest.maxy=calibrationsheetheight/2;
   		   oldvolumeofinterest.minz=0;
   		   //recalculate the max z value
   		   if (calibrationsheetheight>calibrationsheetwidth) oldvolumeofinterest.maxz=calibrationsheetheight;
   		   else oldvolumeofinterest.maxz=calibrationsheetwidth;
				
			 // Redo the 3d points so that there is an array for each image containing points that were calculated from that image
			 Point3dArray[] temppoints3d=new Point3dArray[images.length];
			 for (int i=0;i<images.length;i++){
		 		int count=0;
			 		for (int j=0;j<surfacepoints.length;j++) if (sources[j][i]) count++;
			 		Point3d[] points=new Point3d[count];
			 		count=0;
			 		for (int j=0;j<surfacepoints.length;j++) if (sources[j][i]) {
			 			points[count]=surfacepoints[j].clone();
			 			count++;
			 		}
			 		temppoints3d[i]=new Point3dArray(points);
			 }
			 Graphics3DFeedback graphics=new Graphics3DFeedback(oldvolumeofinterest,volumeofinterest,calibrationcirclecenters,standardcalibrationcircleonprintedsheet,C,surfacevoxels, temppoints3d);
			 graphics.initGraphics();
			
		  } // end if prefs.DebugShow3DModel
		  //Note that if this is uncommented and used as is then a Point3dArray class will be needed which would look like the following
		  /*
public class Point3dArray {
	private Point3d[] points;
	private final int length;
	
	public Point3dArray(Point3d[] array){
		length=array.length;
		points=new Point3d[length];
		for (int i=0;i<length;i++) points[i]=array[i].clone();
	}
	public Point3dArray clone(){
		Point3dArray returnvalue=new Point3dArray(points);
		return returnvalue;
	}
	
	public int getLength(){ return length;}
	
	public Point3d GetPoint(int index){
		if ((index>=0) && (index<length)) return points[index];
		else return new Point3d(0,0,0);
	}
	
}
		  
*/
	}
/***********************************************************************************************************************************************
 * 
 * Other private methods
 * 
 ************************************************************************************************************************************************/
	

	private float[] GetGaussianFilter(double radius){
		// Autocreation of a Gaussian filter using the radius passed in
		int r = (int)(Math.ceil(radius));
		int masksize = (r*2+1)*(r*2+1);
		float[] mask=new float[masksize];
		float sigma = r/3; // the radius is assumed to be 3 sigma out.
		float total=0;
		int index=0;
		for (int i = -r; i <= r; i++) {
			for (int j = -r; j <= r; j++) {
				float distancesquared = (i*i)+(j*j);
				if (distancesquared > ((r*r)+1)) // the plus 1 is just so that the mask also includes those that are just outside of the radius which is helpful when the radius is rather small 
				mask[index] = 0;
			else{
				mask[index] = (float)(Math.exp(-(distancesquared)/(2*sigma*sigma)) / (tau*sigma*sigma));
				total+=mask[index];
			} // end else
				index++;
			} // end for j
		} // end for i
		// Normalise
		for (int i=0;i<masksize;i++)
			mask[i] /=total;
			return mask;
	}
	
	private LensDistortion IndividualCameraCalibration(int n,int maxbundleadjustmentiterations){
		CalibrateCamera camera;
		LensDistortion distortion=new LensDistortion();
		 // We need to use the assumption that the principal point is at the origin so start by setting the imagecenter to be the origin
			 Point2d imagecenter=new Point2d(images[n].width/2,images[n].height/2);
			images[n].originofimagecoordinates=imagecenter.clone();
			camera=new CalibrateCamera(images[n]);
		 Matrix K=camera.getCameraMatrix();
		 double errorcode=K.get(2,2);
		if (errorcode==1) distortion=CalculateIndividualCameraCalibration(n,K,maxbundleadjustmentiterations);
		if ((camera.warnings!="") || (errorcode!=1)){
			if (errorcode==-1) {
				images[n].skipprocessing=true;
				camera.warnings=camera.warnings+"Skipping further processing of this image.\n\n";
			}
			 final String warnings="Warnings for image "+(n+1)+"\n"+camera.warnings;
			  EventQueue.invokeLater(new Runnable(){
				  public void run(){
					  jTextAreaOutput.setText(jTextAreaOutput.getText()+warnings);
				  }
			  });

		 }
		 
		 return distortion;
	}
	
	// This is split from the above method in case we want to one day add in calculating the camera matrix parameters from multiple images
	// That was the original intention of the code but it has now been taken out.
	private LensDistortion CalculateIndividualCameraCalibration(int i, Matrix cameramatrix, int maxbundleadjustmentiterations){
			 
			 // Adjust the origin of image coordinates based on the camera matrix
			 // TODO - If we are going to do this then we also need to reset the camera matrix u0,v0 to be 0,0 again.
			 // Unless there is a good reason to do so, leave this commented out in which case the image origin will be the image center which is a good first approximation of the principal point
			 //images[i].originofimagecoordinates.x=images[i].originofimagecoordinates.x+(cameramatrix.get(0,2)/cameramatrix.get(0,0));
			 //images[i].originofimagecoordinates.y=images[i].originofimagecoordinates.y+(cameramatrix.get(1,2)/cameramatrix.get(0,0));

			 PointPair2D[] newpointpairs=new PointPair2D[images[i].matchingpoints.length];
			 for (int j=0;j<newpointpairs.length;j++){
				 newpointpairs[j]=images[i].matchingpoints[j].clone();
				 // reset the coordinate origin to the internal representation with the origin at the image center (or the actual principal point if the above adjustment is uncommented 
				 newpointpairs[j].pointtwo.minus(images[i].originofimagecoordinates);
			}
			CalibrateImage calibration=new CalibrateImage(newpointpairs);
			calibration.CalculateTranslationandRotation(cameramatrix);
			calibration.setZscalefactor(images[i].originofimagecoordinates,cameramatrix);
			
			
			if ((prefs.Debug) && (prefs.DebugCalibrationSheetPlanarHomographyEstimate)){
				// Write out a file that is the dimensions of the calibration sheet with the colours corresponding to the colours in the image
				// matched using the planar homography transforms between the two 
				Matrix H=calibration.getHomography();
				
					// Note the coordinates of the points in the calibration sheet are not pixel coordinates but are transformed to have the origin at the centre of the sheet
					Point2d offset=new Point2d(calibrationsheetwidth/2,calibrationsheetheight/2);
					// For each pixel of the calibration sheet work out the colour it corresponds to in the image
					// using a barycentric transformation
					PixelColour[][] newimage=new PixelColour[calibrationsheetpixelswidth][calibrationsheetpixelsheight];
					for (int x=0;x<calibrationsheetpixelswidth;x++){
						for (int y=0;y<calibrationsheetpixelsheight;y++){
							Point2d point=new Point2d(x,y);
							// Convert from pixel to mm coordinates
  							point.x=point.x*(calibrationsheetwidth/calibrationsheetpixelswidth);
  							point.y=point.y*(calibrationsheetheight/calibrationsheetpixelsheight);
  							point.minus(offset);
  							//transform to image point via plnar homography
							Point2d imagepoint=new Point2d(H.times(point.ConvertPointTo3x1Matrix()));
							imagepoint.plus(images[i].originofimagecoordinates);
							newimage[x][y]=images[i].InterpolatePixelColour(imagepoint);
						}
						if (x%100==0) System.out.print(".");
					}
					System.out.println();
					// Overwrite the pixels that are the centers of the circles with white to give a guide to how the matching was done
						// With the center represented by a rectangle that it 1% of the size of the calibration sheet
						int dx=(int)(calibrationsheetpixelswidth/200);
						int dy=(int)(calibrationsheetpixelsheight/200);
						
						for (int j=0;j<images[i].matchingpoints.length;j++){
							Point2d point=images[i].matchingpoints[j].pointone.clone();
							point.plus(offset);
							// Convert from mm to pixel coordinates
							point.x=point.x*(calibrationsheetpixelswidth/calibrationsheetwidth);
							point.y=point.y*(calibrationsheetpixelsheight/calibrationsheetheight);
							for (int x=(int)point.x-dx;x<(int)point.x+dx;x++)
								for (int y=(int)point.y-dy;y<(int)point.y+dy;y++)
      							if ((x>=0) && (x<calibrationsheetpixelswidth) && (y>=0) && (y<=calibrationsheetpixelsheight)) newimage[x][y]=new PixelColour((byte)255);
						} // end for 
				GraphicsFeedback graphics=new GraphicsFeedback(true);
				graphics.ShowPixelColourArray(newimage,calibrationsheetpixelswidth,calibrationsheetpixelsheight);
				String filename=prefs.DebugSaveOutputImagesFolder+File.separatorChar+"PlanarHomographyCalibrationSheetEstimate"+i+".jpg";
				graphics.SaveImage(filename);
			} // end if Debug
			 
			 // Find the corner furtherest away from the origin and pass the distance to it through to the lens distortion class as the maximum radius
			 double maxradiussquared=images[i].originofimagecoordinates.CalculateDistanceSquared(new Point2d(0,0));
			 if (images[i].originofimagecoordinates.CalculateDistanceSquared(new Point2d(images[i].width,0))>maxradiussquared) maxradiussquared=images[i].originofimagecoordinates.CalculateDistanceSquared(new Point2d(images[i].width,0));
			 if (images[i].originofimagecoordinates.CalculateDistanceSquared(new Point2d(0,images[i].height))>maxradiussquared) maxradiussquared=images[i].originofimagecoordinates.CalculateDistanceSquared(new Point2d(0,images[i].height));
			 if (images[i].originofimagecoordinates.CalculateDistanceSquared(new Point2d(images[i].width,images[i].height))>maxradiussquared) maxradiussquared=images[i].originofimagecoordinates.CalculateDistanceSquared(new Point2d(images[i].width,images[i].height));
			 
			  Matrix K=cameramatrix.copy();
			  Matrix R=calibration.getRotation();
			  Matrix t=calibration.getTranslation();
			  double z=calibration.getZscalefactor();
			  Matrix Z=MatrixManipulations.getZscaleMatrix(z);
			  Matrix P=MatrixManipulations.WorldToImageTransformMatrix(cameramatrix,R,t,Z);
			 LensDistortion distortion=new LensDistortion(images[i].width/10, images[i].height/10, P, newpointpairs,false, maxradiussquared);
			 distortion.CalculateDistortion();
			 // TODO Add in if statements to deal with distortion matrix and distortion formula
			  double k1=distortion.getDistortionCoefficient();
			 Point2d origin=images[i].originofimagecoordinates.clone();
			 
			 // Bundle adjustment
			  CalibrationBundleAdjustment Adjust=new CalibrationBundleAdjustment();
			 // Set the ellipse settings
			 Adjust.ellipse=standardcalibrationcircleonprintedsheet.clone();
			 Adjust.stepsaroundcircle=prefs.AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment;
			 // Now do the adjustment
			 Adjust.BundleAdjustment(maxbundleadjustmentiterations, images[i].matchingpoints, K,R,t,z,k1,origin,jProgressBar1);
			 
			 // Set the settings to their final values
			 distortion.SetDistortionCoefficient(k1,origin); 
			  images[i].originofimagecoordinates=origin.clone();
			  // Update the world to image transform matrix 
			  Z=MatrixManipulations.getZscaleMatrix(z);
			  P=MatrixManipulations.WorldToImageTransformMatrix(K,R,t,Z);
			  images[i].setWorldtoImageTransformMatrix(P);
			 
			  return distortion;
	}

/*************************************************************************************************************
 * 
 *  From here on down are some of the repeating GUI layouts etc.
 *  
 *************************************************************************************************************/
		
	
	 /* This is designed to be run from within the setHorizontalGroup GUI method at each step
	  * i.e. insert the following line atFileSelection temp= the start of it
	  *               .add(defaulthorizontal(thislayout))
	  */  
	
	 private ParallelGroup defaulthorizontal(GroupLayout layout) { 
		        // Space out the buttons and title horizontally so they are relative to each other and the edge of the screen 
	 		 ParallelGroup temp =  layout.createParallelGroup(GroupLayout.LEADING)
		                // Place Title
		                .add(layout.createSequentialGroup()
	                		.addContainerGap(gap, gap) // Gap between next container to the left and this one
			                .add(jLabelTitle)
		                  	) 
	                  
	                  	// Place buttons
	                	.add(GroupLayout.TRAILING, layout.createSequentialGroup()
		                	.addContainerGap(gap, Short.MAX_VALUE) // Gap between next container to the left and this one.
		                    // Note that the max value implies that the group will sit as far to the right as possible 
		                	.add(JButtonCancel)
		                    .addPreferredGap(LayoutStyle.RELATED)
		                    .add(JButtonPrevious)
		                    .addPreferredGap(LayoutStyle.RELATED)
		                    .add(JButtonNext)
		                    .addContainerGap(gap, gap) // Gap between next container to the right and this one (preferred and max).
		                    // In this case it is normally the gap between the right of the last button and the right of the screen
		                );
		        return temp;
		 }
	 
	 
	 /* This is designed to be run from within the setVerticalGroup GUI method at each step
	  * i.e. insert the following line at the start of it
	  *               .add(defaultvertical(thislayout))
	  */  
	 private ParallelGroup defaultvertical(GroupLayout layout) { 
			 	// Space out the buttons and title vertically relative to each other and the edge of the screen 
		        		 ParallelGroup temp = layout.createParallelGroup(GroupLayout.BASELINE)
	                 // Place Title
		 	             .add(layout.createSequentialGroup()
	    	        		 .addContainerGap(gap, gap) // Gap between next container up and this one.
	    	        		 .add(jLabelTitle)
	    	        		 .addContainerGap(gap, gap) // Gap between next container below this one.
		 	             )

	                  // Place buttons
	                	.add(layout.createSequentialGroup() 
	                		.addContainerGap(gap, Short.MAX_VALUE) // Gap between next container above and this one (preferred and maximum)
	                	    // Note that the max value implies that the group will sit as far down as possible 
		                	.add(layout.createParallelGroup(GroupLayout.LEADING) // Create a group for the buttons
		                       // As the are no .addPreferredGap and it is a parallel group they will all be on the same vertical coordinates.
		                		.add(JButtonCancel)
		                		.add(JButtonPrevious)
		                        .add(JButtonNext)
	                        )
	    	 	            .addContainerGap(gap,gap) // Gap between next container below and this one (preferred and maximum)
	    	 	             // In this case it is normally the gap between the bottom of the lowest button and the bottom of the screen
	                	);
	            return temp;
	 }



 	 
} // end of Main class