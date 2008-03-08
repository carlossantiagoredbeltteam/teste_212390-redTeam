package org.reprap.devices;

import java.io.IOException;

import org.reprap.Device;
import org.reprap.Preferences;
import org.reprap.utilities.Debug;
import org.reprap.Extruder;
import org.reprap.comms.Address;
import org.reprap.comms.Communicator;
import org.reprap.comms.IncomingMessage;
import org.reprap.comms.OutgoingMessage;
import org.reprap.comms.IncomingMessage.InvalidPayloadException;
import org.reprap.comms.messages.OutgoingBlankMessage;
import org.reprap.comms.messages.OutgoingByteMessage;
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
	protected int extrusionSpeed;
	
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
	 * The number of mm to stop extruding before the end of a track
	 */
	protected double extrusionOverRun; 
	
	/**
	 * The number of milliseconds to wait before starting a track
	 */
	protected int extrusionDelay;
	
	/**
	 * The number of seconds to cool between layers
	 */
	protected int coolingPeriod;

	/**
	 * The base speed of movement in XY in mm/minute
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
	 * Identifier of extruder
	 * TODO: which values mean what? 
	 */
	protected int myExtruderID;
	
	/**
	 * Start polygons at random perimiter points? 
	 */
	protected boolean randSt = false;
	
	/**
	 * Flag indicating if initialisation succeeded.  Usually this
	 * indicates if the extruder is present in the network. 
	 */
	protected boolean isCommsAvailable = false;
	
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
	protected int nozzleWipeDatumX;
	protected int nozzleWipeDatumY;
	
	/**
	 * Distance to move nozzle over wiper
	 */
	protected int nozzleWipeStroke;
	
	/**
	 * Number of wipe cycles per method call
	 */
	protected int nozzleWipeFreq;

	/**
	* name of our extruder
	*/
	String prefName;

	public GenericExtruder(Preferences prefs, int extruderId)
	{
		myExtruderID = extruderId;
		prefName = "Extruder" + extruderId + "_";
		
		maxExtruderSpeed = prefs.loadInt(prefName + "MaxSpeed(0..255)");
		extrusionSpeed = prefs.loadInt(prefName + "ExtrusionSpeed(0..255)");
		extrusionTemp = prefs.loadDouble(prefName + "ExtrusionTemp(C)");
		extrusionSize = prefs.loadDouble(prefName + "ExtrusionSize(mm)");
		extrusionHeight = prefs.loadDouble(prefName + "ExtrusionHeight(mm)");
		extrusionInfillWidth = prefs.loadDouble(prefName + "ExtrusionInfillWidth(mm)");
		extrusionOverRun = prefs.loadDouble(prefName + "ExtrusionOverRun(mm)");
		extrusionDelay = prefs.loadInt(prefName + "ExtrusionDelay(ms)");
		coolingPeriod = prefs.loadInt(prefName + "CoolingPeriod(s)");
		xyFeedrate = prefs.loadDouble(prefName + "XYFeedrate(mm/minute)");
		t0 = prefs.loadInt(prefName + "t0(0..255)");
		iSpeed = prefs.loadDouble(prefName + "InfillSpeed(0..1)");
		oSpeed = prefs.loadDouble(prefName + "OutlineSpeed(0..1)");
		asLength = prefs.loadDouble(prefName + "AngleSpeedLength(mm)");
		asFactor = prefs.loadDouble(prefName + "AngleSpeedFactor(0..1)");
		material = prefs.loadString(prefName + "MaterialType(name)");
		offsetX = prefs.loadDouble(prefName + "OffsetX(mm)");
		offsetY = prefs.loadDouble(prefName + "OffsetY(mm)");
		offsetZ = prefs.loadDouble(prefName + "OffsetZ(mm)");
		nozzleWipeEnabled = prefs.loadBool(prefName + "NozzleWipeEnabled");
		nozzleWipeDatumX = prefs.loadInt(prefName + "NozzleWipeDatumX(mm)");
		nozzleWipeDatumY = prefs.loadInt(prefName + "NozzleWipeDatumY(mm)");
		nozzleWipeStroke = prefs.loadInt(prefName + "NozzleWipeStroke(mm)");
		nozzleWipeFreq = prefs.loadInt(prefName + "NozzleWipeFreq");
		randSt = prefs.loadBool(prefName + "RandomStart");
		shortLength = prefs.loadDouble(prefName + "ShortLength(mm)");
		shortSpeed = prefs.loadDouble(prefName + "ShortSpeed(0..1)");
		infillOverlap = prefs.loadDouble(prefName + "InfillOverlap(mm)");
		
		Color3f col = new Color3f((float)prefs.loadDouble(prefName + "ColourR(0..1)"), 
				(float)prefs.loadDouble(prefName + "ColourG(0..1)"), 
				(float)prefs.loadDouble(prefName + "ColourB(0..1)"));
		materialColour = new Appearance();
		materialColour.setMaterial(new Material(col, black, col, black, 101f));
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Extruder#dispose()
	 */
	public void dispose() {
	}

	/**
	 * Turn the extruder on using the extrusionTemp property
	 * @throws Exception
	 */
	
	public void heatOn() throws Exception 
	{
		setTemperature(extrusionTemp);
	}
	
	public void heatOff() throws Exception 
	{
		setTemperature(0);
	}
	
	/**
	 * Start the extruder motor at a given speed.  This ranges from 0
	 * to 255 but is scaled by maxSpeed and t0, so that 255 corresponds to the
	 * highest permitted speed.  It is also scaled so that 0 would correspond
	 * with the lowest extrusion speed.
	 * @param speed The speed to drive the motor at (0-255)
	 * @throws IOException
	 */
	public void setExtrusion(int speed) throws IOException
	{
		setExtrusion(speed, false);
	}
	
	public void startExtruding()
	{
		try
		{
			setExtrusion(0);
		} catch (Exception e) {
			//hmm.
		}
	}
	
	
	public void stopExtruding()
	{
		try
		{
			setExtrusion(0);
		} catch (Exception e) {
			//hmm.
		}
	}

	
	public void setHeater(int heat, double maxTemp) throws IOException
	{
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
	
	/* (non-Javadoc)
	 * @see org.reprap.Extruder#getTemperature()
	 */
	public double getTemperature()
	{
		return currentTemperature;
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
		return isCommsAvailable;
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
    public int getExtruderSpeed()
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
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getExtrusionInfillWidth()
     */
    public double getExtrusionInfillWidth()
    {
    	return extrusionInfillWidth;
    } 
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getExtrusionOverRun()
     */
    public double getExtrusionOverRun()
    {
    	return extrusionOverRun;
    } 
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getExtrusionDelay()
     */
    public long getExtrusionDelay()
    {
    	return extrusionDelay;
    } 
    
    /* (non-Javadoc)
     * @see org.reprap.Extruder#getCoolingPeriod()
     */
    public int getCoolingPeriod()
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
    
    /**
     * @return the name of the material
     */
    public String toString()
    {
    	return material;
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
    public int getNozzleWipeDatumX()
    {
    	return nozzleWipeDatumX;
    }

    /**
     * @return the Y-cord for the nozzle wiper
     */
    public int getNozzleWipeDatumY()
    {
    	return nozzleWipeDatumY;
    }
    
    /**
     * @return the length of the nozzle movement over the wiper
     */
    public int getNozzleWipeStroke()
    {
    	return nozzleWipeStroke;
    }
    
    /**
     * @return the number of times the nozzle moves over the wiper
     */
    public int getNozzleWipeFreq()
    {
    	return nozzleWipeFreq;
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

}
