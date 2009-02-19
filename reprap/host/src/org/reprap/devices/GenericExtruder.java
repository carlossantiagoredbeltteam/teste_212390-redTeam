package org.reprap.devices;

import java.io.IOException;

import org.reprap.Preferences;
import org.reprap.Extruder;
import org.reprap.Printer;
import org.reprap.geometry.LayerRules;
import javax.media.j3d.Appearance;
import javax.vecmath.Color3f;
import javax.media.j3d.Material;

/**
 * @author jwiel
 *
 */
public abstract class GenericExtruder implements Extruder
{
	/**
	 * Offset of 0 degrees centigrade from absolute zero
	 */
	public static final double absZero = 273.15;
	
	/**
	 * The temperature to maintain 
	 */
	protected double requestedTemperature = 0;
	
	/**
	 * The temperature most recently read from the device 
	 */
	protected double currentTemperature = 0; 

	/**
	 * Maximum motor speed (value between 0-255)
	 */
	protected int maxExtruderSpeed; 
	
	/**
	 * The actual extrusion speed
	 */
	protected double extrusionSpeed;
	
	/**
	 * The extrusion temperature
	 */
	protected double extrusionTemp; 
	
	/**
	 * The extrusion width in XY
	 */
	protected double extrusionSize;
	
	/**
	 * The extrusion height in Z
	 * TODO: Should this be a machine-wide constant? - AB
	 */
	protected double extrusionHeight; 
	                                
	/**
	 * The step between infill tracks
	 */
	protected double extrusionInfillWidth; 
	
	/**
	 * below this infill finely
	 */
	protected int lowerFineLayers;
	
	/**
	 * Above this infill finely
	 */
	protected int upperFineLayers;
	
	/**
	 * Use this for broad infill in the middle; if negative, always
	 * infill fine.
	 */
	protected double extrusionBroadWidth;
   	
	/**
	 * The number of seconds to cool between layers
	 */
	protected double coolingPeriod;
	
	/**
	 * The speed of movement in XY when depositing
	 */
	protected double xyFeedrate; 
	
	/**
	 * Zero torque speed 
	 */
	protected int t0;
	
	/**
	 * Infill speed [0,1]*maxSpeed
	 */
	protected double iSpeed;
	
	/**
	 * Outline speed [0,1]*maxSpeed
	 */
	protected double oSpeed;
	
	/**
	 * Length (mm) to speed up round corners
	 */
	protected double asLength;
	
	/**
	 * Factor by which to speed up round corners
	 */
	protected double asFactor;
	
	/**
	 * Line length below which to plot faster
	 */
	protected double shortLength;
	
	/**
	 *Factor for short line speeds
	 */
	protected double shortSpeed;
	
	/**
	 * The name of this extruder's material
	 */
	protected String material;
	
	/**
	 * Number of mm to overlap the hatching infill with the outline.  0 gives none; -ve will 
     * leave a gap between the two
	 */
	protected double infillOverlap = 0;
	
	/**
	 * Where to put the nozzle
	 */
	protected double offsetX, offsetY, offsetZ; 
	
	/**
	 * 
	 */
	protected long lastTemperatureUpdate = 0;
	
	/**
	 * Identifier of and extruder
	 * TODO: which values mean what? 
	 */
	protected int myExtruderID;
	
	/**
	* prefix for our preferences.
	*/
	protected String prefName;
	
	/**
	 * Start polygons at random perimiter points 
	 */
	protected boolean randSt = false;

	/**
	 * Start polygons at incremented perimiter points 
	 */
	protected boolean incrementedSt = false;
	
	/**
	 * Flag indicating if initialisation succeeded.  Usually this
	 * indicates if the extruder is present in the network. 
	 */
	//private boolean isCommsAvailable = false;
	
	/**
	 *  The colour black
	 */	
	protected static final Color3f black = new Color3f(0, 0, 0);
	
	/**
	 *  The colour of the material to use in the simulation windows 
	 */	
	protected Appearance materialColour;
	
	/**
	 * Enable wiping procedure for nozzle
	 */
	protected boolean nozzleWipeEnabled;
	
	/**
	 * Co-ordinates for the nozzle wiper
	 */
	protected double nozzleWipeDatumX;
	protected double nozzleWipeDatumY;
	
	/**
	 * X Distance to move nozzle over wiper
	 */
	protected double nozzleWipeStrokeX;
	
	/**
	 * Y Distance to move nozzle over wiper
	 */
	protected double nozzleWipeStrokeY;
	
	/**
	 * Number of wipe cycles per method call
	 */
	protected int nozzleWipeFreq;
	
	/**
	 * Number of seconds to run to re-start the nozzle before a wipe
	 */
	protected double nozzleClearTime;

	/**
	 * Number of seconds to wait after restarting the nozzle
	 */
	protected double nozzleWaitTime;
	
	/**
	 * The current coordinate to wipe at
	 */
	protected double wipeX;
	
	/**
	 * The number of ms to pulse the valve to open or close it
	 * -ve to supress
	 */
	protected double valvePulseTime;
	
	/**
	 * The number of milliseconds to wait before starting a border track
	 */
	protected double extrusionDelayForLayer = 0;
	
	/**
	 * The number of milliseconds to wait before starting a hatch track
	 */
	protected double extrusionDelayForPolygon = 0;
	
	/**
	 * The number of milliseconds to wait before starting a border track
	 */
	protected double valveDelayForLayer = 0;
	
	/**
	 * The number of milliseconds to wait before starting a hatch track
	 */
	protected double valveDelayForPolygon = 0;
	
	/**
	 * The number of mm to stop extruding before the end of a track
	 */
	protected double extrusionOverRun; 
	
	/**
	 * The number of mm to stop extruding before the end of a track
	 */
	protected double valveOverRun; 
	
    /**
     * The smallest allowable free-movement height above the base
     */
	protected double minLiftedZ = 1;
	
	/**
	 * The number of outlines to plot
	 */
	protected int shells = 1;
	
	/**
	 * Stop the extrude motor between segments?
	 */
	protected boolean pauseBetweenSegments = true;
	
	/**
	* Are we currently extruding?
	*/
	protected boolean isExtruding = false;
	
	private double extrusionFoundationWidth;
	private double extrusionLastFoundationWidth;
	private double separationFraction;
	
	private double arcCompensationFactor;
	private double arcShortSides;
	
	private double evenHatchDirection;
	private double oddHatchDirection;
	private String supportMaterial;
	/**
	* Our printer object.
	*/
	Printer printer = null;
	
	/**
	 * @param communicator
	 * @param address
	 * @param prefs
	 * @param extruderId
	 */
	public GenericExtruder(int extruderId)
	{
		myExtruderID = extruderId;
		refreshPreferences();
	}

	
	
	public void refreshPreferences()
	{
		prefName = "Extruder" + myExtruderID + "_";

		try
		{
			maxExtruderSpeed = Preferences.loadGlobalInt(prefName + "MaxSpeed(0..255)");
			extrusionSpeed = Preferences.loadGlobalDouble(prefName + "ExtrusionSpeed(mm/minute)");
			extrusionTemp = Preferences.loadGlobalDouble(prefName + "ExtrusionTemp(C)");
			extrusionSize = Preferences.loadGlobalDouble(prefName + "ExtrusionSize(mm)");
			extrusionHeight = Preferences.loadGlobalDouble(prefName + "ExtrusionHeight(mm)");
			extrusionInfillWidth = Preferences.loadGlobalDouble(prefName + "ExtrusionInfillWidth(mm)");
			lowerFineLayers = Preferences.loadGlobalInt(prefName + "LowerFineLayers(0...)");
			upperFineLayers = Preferences.loadGlobalInt(prefName + "UpperFineLayers(0...)");
			extrusionBroadWidth = Preferences.loadGlobalDouble(prefName + "ExtrusionBroadWidth(mm)");		
			coolingPeriod = Preferences.loadGlobalDouble(prefName + "CoolingPeriod(s)");
			xyFeedrate = Preferences.loadGlobalDouble(prefName + "XYFeedrate(mm/minute)");
			t0 = Preferences.loadGlobalInt(prefName + "t0(0..255)");
			iSpeed = Preferences.loadGlobalDouble(prefName + "InfillSpeed(0..1)");
			oSpeed = Preferences.loadGlobalDouble(prefName + "OutlineSpeed(0..1)");
			asLength = Preferences.loadGlobalDouble(prefName + "AngleSpeedLength(mm)");
			asFactor = Preferences.loadGlobalDouble(prefName + "AngleSpeedFactor(0..1)");
			material = Preferences.loadGlobalString(prefName + "MaterialType(name)");
			supportMaterial = Preferences.loadGlobalString(prefName + "SupportMaterialType(name)");
			offsetX = Preferences.loadGlobalDouble(prefName + "OffsetX(mm)");
			offsetY = Preferences.loadGlobalDouble(prefName + "OffsetY(mm)");
			offsetZ = Preferences.loadGlobalDouble(prefName + "OffsetZ(mm)");
			nozzleWipeEnabled = Preferences.loadGlobalBool(prefName + "NozzleWipeEnabled");
			nozzleWipeDatumX = Preferences.loadGlobalDouble(prefName + "NozzleWipeDatumX(mm)");
			nozzleWipeDatumY = Preferences.loadGlobalDouble(prefName + "NozzleWipeDatumY(mm)");
			nozzleWipeStrokeX = Preferences.loadGlobalDouble(prefName + "NozzleWipeStrokeX(mm)");
			nozzleWipeStrokeY = Preferences.loadGlobalDouble(prefName + "NozzleWipeStrokeY(mm)");
			nozzleWipeFreq = Preferences.loadGlobalInt(prefName + "NozzleWipeFreq");
			nozzleClearTime = Preferences.loadGlobalDouble(prefName + "NozzleClearTime(s)");
			nozzleWaitTime = Preferences.loadGlobalDouble(prefName + "NozzleWaitTime(s)");
			randSt = Preferences.loadGlobalBool(prefName + "RandomStart");
			incrementedSt = Preferences.loadGlobalBool(prefName + "IncrementedStart");
			shortLength = Preferences.loadGlobalDouble(prefName + "ShortLength(mm)");
			shortSpeed = Preferences.loadGlobalDouble(prefName + "ShortSpeed(0..1)");
			infillOverlap = Preferences.loadGlobalDouble(prefName + "InfillOverlap(mm)");
			extrusionDelayForLayer = Preferences.loadGlobalDouble(prefName + "ExtrusionDelayForLayer(ms)");
			extrusionDelayForPolygon = Preferences.loadGlobalDouble(prefName + "ExtrusionDelayForPolygon(ms)");
			extrusionOverRun = Preferences.loadGlobalDouble(prefName + "ExtrusionOverRun(mm)");
			valveDelayForLayer = Preferences.loadGlobalDouble(prefName + "ValveDelayForLayer(ms)");
			valveDelayForPolygon = Preferences.loadGlobalDouble(prefName + "ValveDelayForPolygon(ms)");
			valveOverRun = Preferences.loadGlobalDouble(prefName + "ValveOverRun(mm)");		
			minLiftedZ = Preferences.loadGlobalDouble(prefName + "MinimumZClearance(mm)");
			// NB - store as 2ms ticks to allow longer pulses
			valvePulseTime = 0.5*Preferences.loadGlobalDouble(prefName + "ValvePulseTime(ms)");
			shells = Preferences.loadGlobalInt(prefName + "NumberOfShells(0..N)");
			pauseBetweenSegments = Preferences.loadGlobalBool(prefName + "PauseBetweenSegments");
			extrusionFoundationWidth = Preferences.loadGlobalDouble(prefName + "ExtrusionFoundationWidth(mm)");
			extrusionLastFoundationWidth = Preferences.loadGlobalDouble(prefName + "ExtrusionLastFoundationWidth(mm)");
			separationFraction = Preferences.loadGlobalDouble(prefName + "SeparationFraction(0..1)");
			arcCompensationFactor = Preferences.loadGlobalDouble(prefName + "ArcCompensationFactor(0..)");
			arcShortSides = Preferences.loadGlobalDouble(prefName + "ArcShortSides(0..)");
			
			evenHatchDirection = Preferences.loadGlobalDouble(prefName + "EvenHatchDirection(degrees)");
			oddHatchDirection = Preferences.loadGlobalDouble(prefName + "OddHatchDirection(degrees)");			
			
			Color3f col = new Color3f((float)Preferences.loadGlobalDouble(prefName + "ColourR(0..1)"), 
					(float)Preferences.loadGlobalDouble(prefName + "ColourG(0..1)"), 
					(float)Preferences.loadGlobalDouble(prefName + "ColourB(0..1)"));
			materialColour = new Appearance();
			materialColour.setMaterial(new Material(col, black, col, black, 101f));
		} catch (Exception ex)
		{
			System.err.println("Refresh extruder preferences: " + ex.toString());
		}
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Extruder#dispose()
	 */
	public void dispose() {
	}
	
	/**
	 * Wait while the motors move about
	 * @throws IOException
	 */
	public void waitTillNotBusy() throws IOException
	{
		if(printer == null)
			return;
		printer.waitTillNotBusy();
	}
	
	
	public void setPrinter(Printer p)
	{
		printer = p;
	}
	
	public Printer getPrinter()
	{
		return printer;
	}	

	/**
	 * Start the extruder motor at a given speed.  This ranges from 0
	 * to 255 but is scaled by maxSpeed and t0, so that 255 corresponds to the
	 * highest permitted speed.  It is also scaled so that 0 would correspond
	 * with the lowest extrusion speed.
	 * @param speed The speed to drive the motor at (0-255)
	 * @throws IOException
	 */
	public void setExtrusion(double speed) throws IOException
	{
		if (speed > 0)
			isExtruding = true;
		else
			isExtruding = false;
			
		setExtrusion(speed, false);
	}
	
	public void startExtruding()
	{
		if (!isExtruding)
		{
			try
			{
				setExtrusion(getExtruderSpeed());
			} catch (Exception e) {
				//hmm.
			}
			isExtruding = true;
		}
	}
	
	public void stopExtruding()
	{
		if (isExtruding)
		{
			try
			{
				setExtrusion(0);
			} catch (Exception e) {
				//hmm.
			}
			isExtruding = false;
		}
	}
	
	public void setMotor(boolean motorOn) throws IOException
	{
		if(extrusionSpeed < 0)
			return;
		
		if(motorOn)
			setExtrusion(extrusionSpeed, false);
		else
			setExtrusion(0, false);
	}

	public void heatOn() throws Exception 
	{
		setTemperature(extrusionTemp);
	}
	
	public void heatOff() throws Exception 
	{
		setTemperature(0);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Extruder#getTemperatureTarget()
	 */
	public double getTemperatureTarget() {
		return requestedTemperature;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Extruder#getDefaultTemperature()
	 */
	public double getDefaultTemperature() {
		return extrusionTemp;
	}

	/**
	 * The the outline speed and the infill speed [0,1]
	 */
	public double getInfillSpeedFactor()
	{
		return iSpeed;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Extruder#getInfillFeedrate()
	 */
	public double getInfillFeedrate()
	{
		return getInfillSpeedFactor() * getXYFeedrate();
	}

	/* (non-Javadoc)
	 * @see org.reprap.Extruder#getOutlineSpeedFactor()
	 */
	public double getOutlineSpeedFactor()
	{
		return oSpeed;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Extruder#getOutlineFeedrate()
	 */
	public double getOutlineFeedrate()
	{
		return getOutlineSpeedFactor() * getXYFeedrate();
	}
	
	/**
	 * The length in mm to speed up when going round corners
	 * (non-Javadoc)
	 * @see org.reprap.Extruder#getAngleSpeedUpLength()
	 */
	public double getAngleSpeedUpLength()
	{
		return asLength;
	}
	
	/**
	 * The factor by which to speed up when going round a corner.
	 * The formula is speed = baseSpeed*[1 - 0.5*(1 + ca)*getAngleSpeedFactor()]
	 * where ca is the cos of the angle between the lines.  So it goes fastest when
	 * the line doubles back on itself (returning 1), and slowest when it 
	 * continues straight (returning 1 - getAngleSpeedFactor()).
	 * (non-Javadoc)
	 * @see org.reprap.Extruder#getAngleSpeedFactor()
	 */
	public double getAngleSpeedFactor()
	{
		return asFactor;
	}
	
	public double getAngleFeedrate()
	{
		return getAngleSpeedFactor() * getXYFeedrate();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Extruder#isAvailable()
	 */
	public boolean isAvailable()
	{
		return true;
	}

    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getXYSpeed()
     */
    public double getXYFeedrate()
    {
    	return xyFeedrate;
    }
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getExtruderSpeed()
     */
    public double getExtruderSpeed()
    {
    	return extrusionSpeed;
    } 
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getExtrusionSize()
     */
    public double getExtrusionSize()
    {
    	return extrusionSize;
    } 
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getExtrusionHeight()
     */
    public double getExtrusionHeight()
    {
    	return extrusionHeight;
    } 
    
    /**
     * At the top and bottom return the fine width; in between
     * return the braod one.  If the braod one is negative, just do fine.
     */
    public double getExtrusionInfillWidth()
    {
    		return extrusionInfillWidth;
    } 
    
    public double getExtrusionBroadWidth()
    {
    		return extrusionBroadWidth;
    } 
    
	public int getLowerFineLayers()
	{
		return lowerFineLayers;
	}
	
	public int getUpperFineLayers()
	{
		return upperFineLayers;
	}
    
  
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getCoolingPeriod()
     */
    public double getCoolingPeriod()
    {
    	return coolingPeriod;
    } 
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getOffsetX()
     */
    public double getOffsetX()
    {
    	return offsetX;
    }    
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getOffsetY()
     */
    public double getOffsetY()
    {
    	return offsetY;
    }
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getOffsetZ()
     */
    public double getOffsetZ()
    {
    	return offsetZ;
    }
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getColour()
     */    
    public Appearance getAppearance()
    {
    	return materialColour;
    }  
    
//    /**
//     * @return the name of the material
//     * TODO: should this give more information?
//     */
//    public String toString()
//    {
//    	return material;
//    }
    
	/**
	 * What stuff are we working with?
	 * @return
	 */
	public String getMaterial()
	{
		return material;
	}
	
	/**
	 * What stuff are we working with?
	 * @return
	 */
	public String getSupportMaterial()
	{
		return supportMaterial;
	}
    
    /**
     * @return determine whether nozzle wipe method is enabled or not 
     */
    public boolean getNozzleWipeEnabled()
    {
    	return nozzleWipeEnabled;
    }    
    
    /**
     * @return the X-cord for the nozzle wiper
     */
    public double getNozzleWipeDatumX()
    {
    	return nozzleWipeDatumX;
    }

    /**
     * @return the Y-cord for the nozzle wiper
     */
    public double getNozzleWipeDatumY()
    {
    	return nozzleWipeDatumY;
    }
    
    /**
     * @return the length of the nozzle movement over the wiper
     */
    public double getNozzleWipeStrokeX()
    {
    	return nozzleWipeStrokeX;
    }
    
    /**
     * @return the length of the nozzle movement over the wiper
     */
    public double getNozzleWipeStrokeY()
    {
    	return nozzleWipeStrokeY;
    }
    
    /**
     * @return the number of times the nozzle moves over the wiper
     */
    public int getNozzleWipeFreq()
    {
    	return nozzleWipeFreq;
    }
    
    /**
     * @return the time to extrude before wiping the nozzle
     */
    public double getNozzleClearTime()
    {
    	return nozzleClearTime;
    }
    
    /**
     * @return the time to wait after extruding before wiping the nozzle
     */
    public double getNozzleWaitTime()
    {
    	return nozzleWaitTime;
    }
    
    
    /**
     * Start polygons at a random location round their perimiter
     * @return
     */
    public boolean randomStart()
    {
    	return randSt;
    }

    /**
     * Start polygons at an incremented location round their perimiter
     * @return
     */
    public boolean incrementedStart()
    {
    	return incrementedSt;
    }
    
    /**
     * get short lengths which need to be plotted faster
     * set -ve to turn this off.
     * @return
     */
    public double getShortLength()
    {
    	return shortLength; 
    }
    
    /**
     * Factor (between 0 and 1) to use to set the speed for
     * short lines.
     * @return
     */
    public double getShortLineSpeedFactor()
    {
    	return shortSpeed; 
    }

	/**
	 * Feedrate for short lines in mm/minute
	 * @return
	 */
	public double getShortLineFeedrate()
	{
		return getShortLineSpeedFactor() * getXYFeedrate();
	}
    
    /**
     * Number of mm to overlap the hatching infill with the outline.  0 gives none; -ve will 
     * leave a gap between the two
     * @return
     */
    public double getInfillOverlap()
    {
    	return infillOverlap;
    }
    
    /**
	 * Gets the number of milliseconds to wait before starting a border track
	 * @return
     */
    public double getExtrusionDelayForLayer()
    {
    	return extrusionDelayForLayer; 
    }
    
    /**
	 * Gets the number of milliseconds to wait before starting a hatch track
	 * @return
     */
    public double getExtrusionDelayForPolygon()
    {
    	return extrusionDelayForPolygon; 
    }
    
    /**
	 * Gets the number of milliseconds to wait before opening the valve
	 * for the first track of a layer
	 * @return
     */
    public double getValveDelayForLayer()
    {
    	return valveDelayForLayer;
    }
    
    /**
	 * Gets the number of milliseconds to wait before opening the valve
	 * for any other track
	 * @return
     */
    public double getValveDelayForPolygon()
    {
    	return valveDelayForPolygon;
    }
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getExtrusionOverRun()
     */
    public double getExtrusionOverRun()
    {
    	return extrusionOverRun;
    } 
 
    /**
     * @return the valve overrun in millimeters (i.e. how many mm
     * before the end of a track to turn off the extrude motor)
     */
    public double getValveOverRun()
    {
    	return valveOverRun;
    }
    
    /**
     * The smallest allowable free-movement height above the base
     * @return
     */
    public double getMinLiftedZ()
    {
    	return minLiftedZ;
    }
    
    /**
     * The number of times to go round the outline (0 to supress)
     * @return
     */
    public int getShells()
    {
    	return shells;
    }
    
    /**
     * Stop the extrude motor between segments?
     * @return
     */
    public boolean getPauseBetweenSegments()
    {
    	return pauseBetweenSegments;
    }
    

	
    public static int getNumberFromMaterial(String material)
    {
    	String[] names;
		try
		{
			names = Preferences.allMaterials();
			for(int i = 0; i < names.length; i++)
			{
				if(names[i].equals(material))
					return i;
			}

		} catch (Exception ex)
		{
			System.err.println(ex.toString());
		}
		return -1;
    }
    
    public static Appearance getAppearanceFromNumber(int n)
    {
    	String prefName = "Extruder" + n + "_";
    	Color3f col = null;
		try
		{
			col = new Color3f((float)Preferences.loadGlobalDouble(prefName + "ColourR(0..1)"), 
				(float)Preferences.loadGlobalDouble(prefName + "ColourG(0..1)"), 
				(float)Preferences.loadGlobalDouble(prefName + "ColourB(0..1)"));
		} catch (Exception ex)
		{
			System.err.println(ex.toString());
		}
		Appearance a = new Appearance();
		a.setMaterial(new Material(col, black, col, black, 101f));
		return a;
    }
    
    public static Appearance getAppearanceFromMaterial(String material)
    {
    	return(getAppearanceFromNumber(getNumberFromMaterial(material)));
    }
    
    public double getExtrusionFoundationWidth()
    {
    	return extrusionFoundationWidth;
    }

    public double getLastFoundationWidth(LayerRules lc)
    {
    	return extrusionLastFoundationWidth;
    }
    
	/**
	 * At the support layer before a layer is to be separated, how far up
	 * the normal Z movement do we go to make a bigger gap to form a weak join?
	 * @return
	 */
	public double getSeparationFraction()
	{
		return separationFraction;
	}
	
	/**
	 * The arc compensation factor.  
	 * See org.reprap.geometry.polygons.RrPolygon.arcCompensate(...)
	 * @return
	 */
	public double getArcCompensationFactor()
	{
		return arcCompensationFactor;
	}
	
	/**
	 * The arc short sides.  
	 * See org.reprap.geometry.polygons.RrPolygon.arcCompensate(...)
	 * @return
	 */
	public double getArcShortSides()
	{
		return arcShortSides;
	}
	
	/**
	 * The direction to hatch even-numbered layers in degrees anticlockwise
	 * from the X axis
	 * @return
	 */
	public double getEvenHatchDirection()
	{
		return evenHatchDirection;
	}

	/**
	 * The direction to hatch odd-numbered layers in degrees anticlockwise
	 * from the X axis
	 * @return
	 */
	public double getOddHatchDirection()
	{
		return oddHatchDirection;		
	}
    
}
