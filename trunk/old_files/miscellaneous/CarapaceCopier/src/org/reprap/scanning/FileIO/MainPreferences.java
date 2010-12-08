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
 *****************************************************************************/

package org.reprap.scanning.FileIO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.util.Properties;
import java.text.DecimalFormat;

import javax.swing.DefaultListModel;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JTextField;
import javax.swing.JFormattedTextField;
import javax.swing.JCheckBox;
import javax.swing.JRadioButton;
import javax.swing.JComboBox;
import javax.swing.ButtonGroup;
public class MainPreferences {
	public class Papersize{
		public String Name;
		public double width;
		public double height;
		public Papersize(String name, double Width, double Height){
			Name=name;
			width=Width;
			height=Height;
		}
		public boolean equals(Papersize other){
			return ((width==other.width) && (height==other.height) && (Name.equals(other.Name)));
		}
		public Papersize clone(){
			return new Papersize(Name,width,height);
		}
	}
	
	// These variables determine the preferences file names and folder
	private static final String propsFile = "reprapscanning.properties";
	private static final String propsFolder = ".reprap";
	private static String path; // The path to the preferences file. Set by the constructor
	public JTextField OutputFileName;
	public JTextField OutputObjectName;
	public String DebugSaveOutputImagesFolder;
	public int AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees;
	public int AlgorithmSettingResampledImageWidthForEllipseDetection;
	public int AlgorithmSettingMaxBundleAdjustmentNumberOfIterations;
	public int AlgorithmSettingEllipseValidityThresholdPercentage;
	public int AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment;
	public int AlgorithmSettingEdgeStrengthThreshold;
	public int AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation;
	public int AlgorithmSettingVolumeSubDivision;
	public JFormattedTextField PaperMarginHorizontalmm;
	public JFormattedTextField PaperMarginVerticalmm;
	public JFormattedTextField PaperCustomSizeWidthmm;
	public JFormattedTextField PaperCustomSizeHeightmm;
	public boolean SaveOnProgramWindowClose;
	public boolean SaveCalibrationSheetProperties;
	public boolean SaveProcessedImageProperties;
	public boolean[] SkipStep; 
	public boolean SaveOnProgramCancel;
	public boolean SaveOnProgramFinish;
	public boolean BlankOutputFilenameOnLoad;
	//public boolean DebugShow3DModel;
	public boolean DebugImageOverlay;
	public boolean DebugImageSegmentation;
	public boolean DebugCalibrationSheetBarycentricEstimate;
	public boolean DebugRestrictedSearch;
	public boolean DebugEllipseFinding;
	public boolean DebugPointPairMatching;
	public boolean DebugEdgeFindingForEllipseDetection;
	public boolean Debug;
	public JCheckBox CalibrationSheetKeepAspectRatioWhenPrinted;
	public JCheckBox PaperSizeIsCustom;
	public DefaultComboBoxModel PaperSizeList;
	public int CurrentPaperSizeIndexNumber;
	
	public ButtonGroup PaperOrientation;
	public JRadioButton PaperOrientationIsPortrait;
	public JRadioButton PaperOrientationIsLandscape;
	
	public DefaultListModel imagefiles;
	public DefaultComboBoxModel calibrationpatterns;
	public int CurrentCalibrationPatternIndexNumber;
	
// Constructors
    public MainPreferences(int numberofsteps, String filepath) {
    	init(numberofsteps, filepath);
    }
    
	public MainPreferences(int numberofsteps) {
		// Construct URL of user properties file
		String filepath = new String(System.getProperty("user.home") + File.separatorChar + 
			propsFolder + File.separatorChar + propsFile);
		init(numberofsteps, filepath);
	}
	
	private void init(int numberofsteps, String filepath){
		path=filepath;
		// Initialise all preferences and set to defaults (to allow for the case where there is no preferences file or an incomplete one).
		// Then try and load preferences from file
		
		// Defaults for boolean variables
		SaveOnProgramWindowClose = true;
		SaveOnProgramCancel = false;
		SaveOnProgramFinish = true;
		SaveCalibrationSheetProperties=true;
		SaveProcessedImageProperties=false;
		DebugImageOverlay=false;
		DebugImageSegmentation=false;
		DebugRestrictedSearch=false;
		DebugCalibrationSheetBarycentricEstimate=false;
		DebugEllipseFinding=false;
		DebugPointPairMatching=false;
		DebugEdgeFindingForEllipseDetection=false;
		Debug=false;
		BlankOutputFilenameOnLoad=true;
		SkipStep = new boolean[numberofsteps];
		for (int i=0;i<SkipStep.length;i++) SkipStep[i]=false;
		SkipStep[2]=true;
		// Set up checkboxes (including default selected state)
		CalibrationSheetKeepAspectRatioWhenPrinted=new JCheckBox("Preserve Aspect Ratio",true);
		PaperSizeIsCustom=new JCheckBox("Custom Paper Size",false);
		
		// Set up radio buttons and group
		PaperOrientationIsPortrait=new JRadioButton("Portrait",true);
		PaperOrientationIsLandscape=new JRadioButton("Landscape",false);
		PaperOrientation = new ButtonGroup();
		PaperOrientation.add(PaperOrientationIsPortrait);
		PaperOrientation.add(PaperOrientationIsLandscape);
		
 
		// Set up TextFields
		OutputFileName=new JTextField();
		OutputFileName.setText(System.getProperty("user.home") + File.separatorChar + "output.stl");
        OutputObjectName=new JTextField();
		OutputObjectName.setText("");
        // Set Up Strings
        DebugSaveOutputImagesFolder="";
        // Set up lists - default to being empty
        imagefiles= new DefaultListModel();
		calibrationpatterns = new DefaultComboBoxModel();
        
		// Set up algoirhtm default settings
		AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees=80;
		AlgorithmSettingMaxBundleAdjustmentNumberOfIterations=100;
		AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment=16;
		AlgorithmSettingEdgeStrengthThreshold=20;
		AlgorithmSettingEllipseValidityThresholdPercentage=60;
		AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation=1;
		AlgorithmSettingVolumeSubDivision=128;
		AlgorithmSettingResampledImageWidthForEllipseDetection=1024;
        // Set up default index number(s) - default to 0
        CurrentCalibrationPatternIndexNumber=0;
        CurrentPaperSizeIndexNumber=0;
        // Set up the Paper Sizes list
        PaperSizeList=new DefaultComboBoxModel();
        PaperSizeList.addElement(new Papersize("A4",210,297));
        PaperSizeList.addElement(new Papersize("US Letter",215.9,279.4));
        PaperSizeList.setSelectedItem(PaperSizeList.getElementAt(CurrentPaperSizeIndexNumber));
        // Set up default paper margins and paper sizes
        DecimalFormat df=new DecimalFormat("###0.0");
        PaperMarginHorizontalmm=new JFormattedTextField(df);
        PaperMarginVerticalmm=new JFormattedTextField(df);;
        PaperCustomSizeWidthmm=new JFormattedTextField(df);
        PaperCustomSizeHeightmm=new JFormattedTextField(df);
        PaperMarginHorizontalmm.setText("0");
        PaperMarginVerticalmm.setText("0");
        PaperCustomSizeWidthmm.setText("215.9");
        PaperCustomSizeHeightmm.setText("279.4");
        try {
        	load();	
        }
		catch (Exception e) {
			System.out.println("Error reading in parameters");
			System.out.println(e);
		}
	}
	
	
// This method loads the Preferences. If there is no entry in the preferences file it will not error out but will leave it at its default setting (set above in the constructor method)
	public void load() throws IOException{
		int i;
		
		File file = new File(path);
		URL url = file.toURI().toURL();
		// Open it if it exists and extract the preferences
		if (file.exists()) {
			Properties temp = new Properties();
			temp.load(url.openStream());
	
			// Load Text fields
			if (temp.getProperty("OutputFileName")!=null) OutputFileName.setText(temp.getProperty("OutputFileName"));
			if (temp.getProperty("OutputObjectName")!=null) OutputObjectName.setText(temp.getProperty("OutputObjectName"));
			// Load Strings
			if (temp.getProperty("DebugSaveOutputImagesFolder")!=null) {DebugSaveOutputImagesFolder=temp.getProperty("DebugSaveOutputImagesFolder");Debug=true;}
			// Load boolean variables
			if (temp.getProperty("SaveOnProgramWindowClose")!=null) SaveOnProgramWindowClose = temp.getProperty("SaveOnProgramWindowClose").equals("true");
			if (temp.getProperty("SaveOnProgramCancel")!=null) SaveOnProgramCancel = temp.getProperty("SaveOnProgramCancel").equals("true");
			if (temp.getProperty("SaveOnProgramFinish")!=null) SaveOnProgramFinish = temp.getProperty("SaveOnProgramFinish").equals("true");
			if (temp.getProperty("SaveCalibrationSheetProperties")!=null) SaveCalibrationSheetProperties = temp.getProperty("SaveCalibrationSheetProperties").equals("true");
			if (temp.getProperty("SaveProcessedImageProperties")!=null) SaveProcessedImageProperties = temp.getProperty("SaveProcessedImageProperties").equals("true");
			if (temp.getProperty("BlankOutputFilenameOnLoad")!=null) BlankOutputFilenameOnLoad = temp.getProperty("BlankOutputFilenameOnLoad").equals("true");
			//if (temp.getProperty("DebugShow3DModel")!=null) DebugShow3DModel = temp.getProperty("DebugShow3DModel").equals("true");
			if (temp.getProperty("DebugImageOverlay")!=null) DebugImageOverlay = temp.getProperty("DebugImageOverlay").equals("true");
			if (temp.getProperty("DebugImageSegmentation")!=null) DebugImageSegmentation = temp.getProperty("DebugImageSegmentation").equals("true");
			if (temp.getProperty("DebugRestrictedSearch")!=null) DebugRestrictedSearch = temp.getProperty("DebugRestrictedSearch").equals("true");
			if (temp.getProperty("DebugCalibrationSheetBarycentricEstimate")!=null) DebugCalibrationSheetBarycentricEstimate = temp.getProperty("DebugCalibrationSheetBarycentricEstimate").equals("true");
			if (temp.getProperty("DebugEllipseFinding")!=null) DebugEllipseFinding = temp.getProperty("DebugEllipseFinding").equals("true");
			if (temp.getProperty("DebugPointPairMatching")!=null) DebugPointPairMatching = temp.getProperty("DebugPointPairMatching").equals("true");
			if (temp.getProperty("DebugEdgeFindingForEllipseDetection")!=null) DebugEdgeFindingForEllipseDetection = temp.getProperty("DebugEdgeFindingForEllipseDetection").equals("true");
			
			// Note the i+1 here as humans start counting the steps from 1 but the array starts from 0. 
			for (i=0;i<SkipStep.length;i++) if (temp.getProperty("SkipStep"+Integer.toString(i+1))!=null) SkipStep[i] = temp.getProperty("SkipStep"+Integer.toString(i+1)).equals("true");

			// Load the state of checkboxes 
			if (temp.getProperty("CalibrationSheetKeepAspectRatioWhenPrinted")!=null) CalibrationSheetKeepAspectRatioWhenPrinted.setSelected(temp.getProperty("CalibrationSheetKeepAspectRatioWhenPrinted").equals("true"));
			if (temp.getProperty("PaperSizeIsCustom")!=null) PaperSizeIsCustom.setSelected(temp.getProperty("PaperSizeIsCustom").equals("true"));
			
			// Load the radio buttons
			if (temp.getProperty("PaperOrientationIsPortrait")!=null) PaperOrientationIsPortrait.setSelected(temp.getProperty("PaperOrientationIsPortrait").equals("true"));
			//PaperOrientationIsLandscape.setSelected(!PaperOrientationIsPortrait.isSelected());
			
			// Load algorithm numbers and run sanity checks
			if (temp.getProperty("AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees = Integer.valueOf(temp.getProperty("AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees - leaving as default: "+e);}
				if (AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees>89) AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees=89;
				if (AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees<0) AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees=0;
			}
			if (temp.getProperty("AlgorithmSettingResampledImageWidthForEllipseDetection")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingResampledImageWidthForEllipseDetection = Integer.valueOf(temp.getProperty("AlgorithmSettingResampledImageWidthForEllipseDetection"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingResampledImageWidthForEllipseDetection - leaving as default: "+e);}
				if (AlgorithmSettingResampledImageWidthForEllipseDetection<320) AlgorithmSettingResampledImageWidthForEllipseDetection=320;
			}
			if (temp.getProperty("AlgorithmSettingEllipseValidityThresholdPercentage")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingEllipseValidityThresholdPercentage = Integer.valueOf(temp.getProperty("AlgorithmSettingEllipseValidityThresholdPercentage"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingEllipseValidityThresholdPercentage - leaving as default: "+e);}
				if (AlgorithmSettingEllipseValidityThresholdPercentage>100) AlgorithmSettingEllipseValidityThresholdPercentage=100;
				if (AlgorithmSettingEllipseValidityThresholdPercentage<0) AlgorithmSettingEllipseValidityThresholdPercentage=0;
			}
			if (temp.getProperty("AlgorithmSettingEdgeStrengthThreshold")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingEdgeStrengthThreshold = Integer.valueOf(temp.getProperty("AlgorithmSettingEdgeStrengthThreshold"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingEdgeStrengthThreshold - leaving as default: "+e);}
				if (AlgorithmSettingEdgeStrengthThreshold>255) AlgorithmSettingEdgeStrengthThreshold=255;
				if (AlgorithmSettingEdgeStrengthThreshold<0) AlgorithmSettingEdgeStrengthThreshold=0;
			}
			if (temp.getProperty("AlgorithmSettingMaxBundleAdjustmentNumberOfIterations")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingMaxBundleAdjustmentNumberOfIterations = Integer.valueOf(temp.getProperty("AlgorithmSettingMaxBundleAdjustmentNumberOfIterations"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingMaxBundleAdjustmentNumberOfIterations - leaving as default: "+e);}
				if (AlgorithmSettingMaxBundleAdjustmentNumberOfIterations<1) AlgorithmSettingMaxBundleAdjustmentNumberOfIterations=1;
			}
			if (temp.getProperty("AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment = Integer.valueOf(temp.getProperty("AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment - leaving as default: "+e);}
				if (AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment<4) AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment=4;
			}
			if (temp.getProperty("AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation = Integer.valueOf(temp.getProperty("AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation - leaving as default: "+e);}
				if (AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation<1) AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation=1;
			}
			if (temp.getProperty("AlgorithmSettingVolumeSubDivision")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {AlgorithmSettingVolumeSubDivision = Integer.valueOf(temp.getProperty("AlgorithmSettingVolumeSubDivision"));}catch (Exception e) {System.out.println("Error loading AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation - leaving as default: "+e);}
				if (AlgorithmSettingVolumeSubDivision<1) AlgorithmSettingVolumeSubDivision=1;
			}
			
			// Load default index numbers
			if (temp.getProperty("CurrentCalibrationPatternIndexNumber")!=null) // if the property exists try to convert to integer, just ignore if can't
				try {CurrentCalibrationPatternIndexNumber = Integer.valueOf(temp.getProperty("CurrentCalibrationPatternIndexNumber"));}catch (Exception e) {System.out.println("Error loading CurrentCalibrationPatternIndexNumber - leaving as default: "+e);}
			if (temp.getProperty("CurrentPaperSizeIndexNumber")!=null) // if the property exists try to convert to integer, just ignore if can't
				try {CurrentPaperSizeIndexNumber = Integer.valueOf(temp.getProperty("CurrentPaperSizeIndexNumber"));}catch (Exception e) {System.out.println("Error loading CurrentPaperSizeIndexNumber - leaving as default: "+e);}
		        
			// Load lists and potentially rework the index numbers.
	       
			i=0;
	        while (temp.getProperty("ImageFileList"+Integer.toString(i))!=null) 
	        {
	        	String element=temp.getProperty("ImageFileList"+Integer.toString(i));
		 	       boolean add=false;
		      	// Gracefully degrade list. If the file doesn't exist, or the file is already in the list, or it is not an image filejust don't add it to the list.
		        	if (new File(element).exists()) {
		        		add=!new ImageFile(element).IsInvalid();
		        		if (add) for (int j=0;j<i;j++) if (imagefiles.getElementAt(j).toString().equals(element)) add=false;
	        	}
	        	if (add) imagefiles.addElement(element);
		 		i++;
	        }
	        i=0;
	        while (temp.getProperty("CalibrationPatternFileList"+Integer.toString(i))!=null) 
	        {
	         	String element=temp.getProperty("CalibrationPatternFileList"+Integer.toString(i));
	 	       boolean add=false;
	        	// Gracefully degrade list. If the file doesn't exist, or the file is already in the list, or it is not an image filejust don't add it to the list.
	        	if (new File(element).exists()) {
	        		add=!new ImageFile(element).IsInvalid();
	        		if (add) for (int j=0;j<calibrationpatterns.getSize();j++) if (calibrationpatterns.getElementAt(j).toString().equals(element)) add=false;
	        	}
	        	if (add) calibrationpatterns.addElement(element);
        		else if (CurrentCalibrationPatternIndexNumber>i)
        			CurrentCalibrationPatternIndexNumber--; // If the file wasn't added then the index of the default may need to be changed.
        		i++;
	        }
	        i=0;
	        while ((temp.getProperty("PaperSizeNameList"+Integer.toString(i))!=null)&& (temp.getProperty("PaperSizeWidthmmList"+Integer.toString(i))!=null) && (temp.getProperty("PaperSizeHeightmmList"+Integer.toString(i))!=null)) 
	        {
	         	Papersize element=new Papersize(temp.getProperty("PaperSizeNameList"+Integer.toString(i)),Double.valueOf(temp.getProperty("PaperSizeWidthmmList"+Integer.toString(i))), Double.valueOf(temp.getProperty("PaperSizeHeightmmList"+Integer.toString(i))));
	 	     	boolean add=true;
	        	// If the element is already in the list
	        	for (int j=0;j<PaperSizeList.getSize();j++) if (((Papersize)PaperSizeList.getElementAt(j)).equals(element)) add=false;
	        	if (add) PaperSizeList.addElement(element);
        			i++;
	        }
	        
	        // Sanity check on the Indexes. Reset to zero if not in range. Remember the indexnumber starts at zero but the size starts counting from 1.
	        if ((CurrentCalibrationPatternIndexNumber<0) || (CurrentCalibrationPatternIndexNumber>=calibrationpatterns.getSize())) CurrentCalibrationPatternIndexNumber=0;
	        if ((CurrentPaperSizeIndexNumber<0) || (CurrentPaperSizeIndexNumber>=PaperSizeList.getSize())) CurrentPaperSizeIndexNumber=0;
	       
	    	// load double variables and run sanity checks
			if (temp.getProperty("PaperCustomSizeWidthmm")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {PaperCustomSizeWidthmm.setText(temp.getProperty("PaperCustomSizeWidthmm"));}catch (Exception e) {System.out.println("Error loading PaperCustomSizeWidthmm - leaving as default: "+e);}
				if (Double.valueOf(PaperCustomSizeWidthmm.getText())<1) PaperCustomSizeWidthmm.setText("1");
			}
			if (temp.getProperty("PaperCustomSizeHeightmm")!=null){ // if the property exists try to convert to integer, just ignore if can't
				try {PaperCustomSizeHeightmm.setText(temp.getProperty("PaperCustomSizeHeightmm"));}catch (Exception e) {System.out.println("Error loading PaperCustomSizeHeightmm- leaving as default: "+e);}
				if (Double.valueOf(PaperCustomSizeHeightmm.getText())<1) PaperCustomSizeHeightmm.setText("1");
			}
			if (temp.getProperty("PaperMarginHorizontalmm")!=null) // if the property exists try to convert to integer, just ignore if can't
				try {PaperMarginHorizontalmm.setText(temp.getProperty("PaperMarginHorizontalmm"));}catch (Exception e) {System.out.println("Error loading PaperMarginHorizontalmm - leaving as default: "+e);}
			if (temp.getProperty("PaperMarginVerticalmm")!=null) // if the property exists try to convert to integer, just ignore if can't
				try {PaperMarginVerticalmm.setText(temp.getProperty("PaperMarginVerticalmm"));}catch (Exception e) {System.out.println("Error loading PaperMarginVerticalmm - leaving as default: "+e);}
			SanityCheckMargins();
		
		}
		if (BlankOutputFilenameOnLoad) OutputFileName.setText("");
	}

	public void save()throws IOException {
		File file = new File(path);
		if (!file.exists()) {
			File p = new File(file.getParent());
			if (!p.isDirectory()){
				// Create folder if necessary
				p.mkdirs();	
			}
		}	
		OutputStream output = new FileOutputStream(file);
		Properties temp = new Properties();
		// Save Text Fields
		temp.setProperty("OutputFileName",OutputFileName.getText());
		temp.setProperty("OutputObjectName",OutputObjectName.getText());
	    temp.setProperty("PaperMarginHorizontalmm",PaperMarginHorizontalmm.getText());
	    temp.setProperty("PaperMarginVerticalmm",PaperMarginVerticalmm.getText());
	    temp.setProperty("PaperCustomSizeWidthmm",PaperCustomSizeWidthmm.getText());
	    temp.setProperty("PaperCustomSizeHeightmm",PaperCustomSizeHeightmm.getText());
		// Save Strings
		temp.setProperty("DebugSaveOutputImagesFolder",DebugSaveOutputImagesFolder);
		// Save boolean variables
		temp.setProperty("SaveOnProgramFinish", String.valueOf(SaveOnProgramFinish));
		temp.setProperty("SaveOnProgramWindowClose", String.valueOf(SaveOnProgramWindowClose));
		temp.setProperty("SaveOnProgramCancel", String.valueOf(SaveOnProgramCancel));
		temp.setProperty("SaveCalibrationSheetProperties", String.valueOf(SaveCalibrationSheetProperties));
		temp.setProperty("SaveProcessedImageProperties", String.valueOf(SaveProcessedImageProperties));
		temp.setProperty("BlankOutputFilenameOnLoad", String.valueOf(BlankOutputFilenameOnLoad));
		//temp.setProperty("DebugShow3DModel", String.valueOf(DebugShow3DModel));
		temp.setProperty("DebugImageOverlay", String.valueOf(DebugImageOverlay));
		temp.setProperty("DebugImageSegmentation", String.valueOf(DebugImageSegmentation));
		temp.setProperty("DebugRestrictedSearch", String.valueOf(DebugRestrictedSearch));
		temp.setProperty("DebugCalibrationSheetBarycentricEstimate", String.valueOf(DebugCalibrationSheetBarycentricEstimate));
		temp.setProperty("DebugEllipseFinding", String.valueOf(DebugEllipseFinding));
		temp.setProperty("DebugPointPairMatching", String.valueOf(DebugPointPairMatching));
		temp.setProperty("DebugEdgeFindingForEllipseDetection", String.valueOf(DebugEdgeFindingForEllipseDetection));
				
		// Note the i+1 here as humans start counting the steps from 1 but the array starts from 0. 
		for (int i=0;i<SkipStep.length;i++)temp.setProperty("SkipStep"+Integer.toString(i+1),String.valueOf(SkipStep[i]));
		// Save state of checkboxes
		temp.setProperty("CalibrationSheetKeepAspectRatioWhenPrinted", String.valueOf(CalibrationSheetKeepAspectRatioWhenPrinted.isSelected()));
		temp.setProperty("PaperSizeIsCustom", String.valueOf(PaperSizeIsCustom.isSelected()));
		
		// Save state of radio buttons
		temp.setProperty("PaperOrientationIsPortrait", String.valueOf(PaperOrientationIsPortrait.isSelected()));
		
		// Save lists
	    for(int i = 0; i< imagefiles.getSize(); i++) temp.setProperty("ImageFileList"+Integer.toString(i), String.valueOf(imagefiles.getElementAt(i)));
	    for(int i = 0; i< calibrationpatterns.getSize(); i++) temp.setProperty("CalibrationPatternFileList"+Integer.toString(i), String.valueOf(calibrationpatterns.getElementAt(i)));
	    for(int i = 0; i< PaperSizeList.getSize(); i++) {
	    	Papersize element=(Papersize)PaperSizeList.getElementAt(i);
	    	temp.setProperty("PaperSizeNameList"+Integer.toString(i), element.Name);
	    	temp.setProperty("PaperSizeWidthmmList"+Integer.toString(i), String.valueOf(element.width));
	    	temp.setProperty("PaperSizeHeightmmList"+Integer.toString(i), String.valueOf(element.height));
	    }
		    // Save Algorithm setting numbers
	    temp.setProperty("AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees",String.valueOf(AlgorithmSettingMaximumCameraAngleFromVerticalInDegrees));
	    temp.setProperty("AlgorithmSettingMaxBundleAdjustmentNumberOfIterations",String.valueOf(AlgorithmSettingMaxBundleAdjustmentNumberOfIterations));
	    temp.setProperty("AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment",String.valueOf(AlgorithmSettingStepsAroundCircleCircumferenceForEllipseEstimationInBundleAdjustment));
	    temp.setProperty("AlgorithmSettingEdgeStrengthThreshold",String.valueOf(AlgorithmSettingEdgeStrengthThreshold));
	    temp.setProperty("AlgorithmSettingEllipseValidityThresholdPercentage",String.valueOf(AlgorithmSettingEllipseValidityThresholdPercentage));
	    temp.setProperty("AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation",String.valueOf(AlgorithmSettingMinimumNumberofIntersectingRayPairsForPointEstimation));
	    temp.setProperty("AlgorithmSettingVolumeSubDivision",String.valueOf(AlgorithmSettingVolumeSubDivision));
	    temp.setProperty("AlgorithmSettingResampledImageWidthForEllipseDetection",String.valueOf(AlgorithmSettingResampledImageWidthForEllipseDetection));
	    // Save default index numbers
	    temp.setProperty("CurrentCalibrationPatternIndexNumber",String.valueOf(CurrentCalibrationPatternIndexNumber));
	    temp.setProperty("CurrentPaperSizeIndexNumber",String.valueOf(CurrentPaperSizeIndexNumber));
	    // Write to file with headers.
		String comments = "Reprap 3D Scanning properties http://reprap.org/ - can be edited by hand but not recommended as elements may be reordered by the program\n";
		comments=comments+"Note that for boolean values, anything other than true (all in lowercase), will be evaluated as false \n";
	    temp.store(output, comments);
	}

	public void SanityCheckMargins(){
		double w,h;
		if (PaperSizeIsCustom.isSelected()){ w=Double.valueOf(PaperCustomSizeWidthmm.getText()); h=Double.valueOf(PaperCustomSizeHeightmm.getText());}
		else { 
			Papersize current=(Papersize)PaperSizeList.getElementAt(CurrentPaperSizeIndexNumber);
			w=current.width;
			h=current.height;
		} 
 	   	if (Double.valueOf(PaperMarginVerticalmm.getText())<0) PaperMarginVerticalmm.setText("0");
		if (Double.valueOf(PaperMarginVerticalmm.getText())>(h-1)) PaperMarginVerticalmm.setText(String.valueOf(h-1)); 
		if (Double.valueOf(PaperMarginHorizontalmm.getText())<0) PaperMarginHorizontalmm.setText("0");
		if (Double.valueOf(PaperMarginHorizontalmm.getText())>(w-1)) PaperMarginHorizontalmm.setText(String.valueOf(w-1)); 
	}
}
