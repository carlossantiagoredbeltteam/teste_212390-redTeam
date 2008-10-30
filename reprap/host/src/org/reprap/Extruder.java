package org.reprap;
import java.io.IOException;
import javax.media.j3d.Appearance;

import org.reprap.Device;

public interface Extruder
{
	
	/**
	 * Dispose of the extruder object 
	 */
	public void dispose(); 
	
	/**
	 * Reload the preferences from the preferences file
	 *
	 */
	public void refreshPreferences();

	/**
	 * Start the extruder motor at a given speed.  This ranges from 0
	 * to 255 but is scaled by maxSpeed and t0, so that 255 corresponds to the
	 * highest permitted speed.  It is also scaled so that 0 would correspond
	 * with the lowest extrusion speed.
	 * @param speed The speed to drive the motor at (0-255)
	 * @throws IOException
	 */
	public void setExtrusion(int speed) throws IOException;
	
	/**
	 * Start the extruder motor at a given speed.  This ranges from 0
	 * to 255 but is scaled by maxSpeed and t0, so that 255 corresponds to the
	 * highest permitted speed.  It is also scaled so that 0 would correspond
	 * with the lowest extrusion speed.
	 * @param speed The speed to drive the motor at (0-255)
	 * @param reverse If set, run extruder in reverse
	 * @throws IOException
	 */
	public void setExtrusion(int speed, boolean reverse) throws IOException;
	
	/**
	* start extruding at the normal rate.
	*/
	public void startExtruding();
	
	/**
	* stop extruding
	*/
	public void stopExtruding();
	
	/**
	* Start/stop the extruder motor
	*/
	public void setMotor(boolean motorOn) throws IOException;
		
	/**
	 * Open and close the valve (if any).
	 * @param pulseTime
	 * @param valveOpen
	 * @throws IOException
	 */
	public void setValve(boolean valveOpen) throws IOException;
	
	/**
	 * Turn the heater of the extruder on. Inital temperatur is defined by ???
	 * @throws Exception
	 */
	public void heatOn() throws Exception; 

	/**
	* Turns the heater for the extruder off.
	*/
	public void heatOff() throws Exception; 

	/**
	 * Set the temperature of the extruder at a given height. This height is given
	 * in centigrades, i.e. 100 equals 100 centigrades. 
	 * @param temperature The temperature of the extruder in centigrades
	 * @throws Exception
	 */
	public void setTemperature(double temperature) throws Exception; 
	
	/**
	 * Set a heat output power.  For normal production use you would
	 * normally call setTemperature, however this method may be useful
	 * for lower temperature profiling, etc.
	 * @param heat Heater power (0-255)
	 * @param maxTemp Cutoff temperature in celcius
	 * @throws IOException
	 */
	public void setHeater(int heat, double maxTemp) throws IOException; 
	
	/**
	 * Check if the extruder is out of feedstock
	 * @return true if there is no material remaining
	 */
	public boolean isEmpty(); 
	
	/**
	 * @return the target temperature of the extruder
	 */
	public double getTemperatureTarget(); 

	/**
	 * @return the default temperature of the extruder
	 */
	public double getDefaultTemperature();

	/**
	 * @return the current temperature of the extruder 
	 */
	public double getTemperature(); 

	/**
	 * @return the infill speed as a value between [0,1]
	 */
	public double getInfillSpeedFactor();
	
	/**
	* @return the infill feedrate as a value in mm/minute
	*/
	public double getInfillFeedrate();

	/**
	 * @return the outline speed as a avlue between [0,1]
	 */
	public double getOutlineSpeedFactor();

	/**
	* @return the infill feedrate as a value in mm/minute
	*/
	public double getOutlineFeedrate();
	
	/**
	 * @return The length in mm to speed up when going round corners
	 */
	public double getAngleSpeedUpLength();

	/**
	 * The factor by which to speed up when going round a corner.
	 * The formula is speed = baseSpeed*[1 - 0.5*(1 + ca)*getAngleSpeedFactor()]
	 * where ca is the cos of the angle between the lines.  So it goes fastest when
	 * the line doubles back on itself (returning 1), and slowest when it 
	 * continues straight (returning 1 - getAngleSpeedFactor()).
	 * @return the angle-speed factor 
	 */
	public double getAngleSpeedFactor();
	
	/**
	* @return the angle feedrate as a value in mm/minute
	*/
	public double getAngleFeedrate();
	
	/**
	 * Turn the cooler (fan?) on or off
	 * @param f true if the cooler is to be turned on, false to turn off
	 * @throws IOException
	 */
	public void setCooler(boolean f) throws IOException ;
	
	/**
	 * Check if the extruder is available, which is determined by ???
	 * @return true if the extruder is available
	 */
	public boolean isAvailable(); 

    /**
     * The speed of X and Y movement
     * @return the XY feedrate in mm/minute
     */
    public double getXYFeedrate();
 
    /**
     * @return the extruder speeds
     */
    public int getExtruderSpeed();

    /**
     * @return the extrusion size in millimeters
     */
    public double getExtrusionSize();
 
    /**
     * @return the extrusion height in millimeters
     */
    public double getExtrusionHeight();

    /**
     * @return the cooling period in seconds
     */
    public double getCoolingPeriod();
 
    /**
     * @return the X offset in millimeters
     */
    public double getOffsetX();
 
    /**
     * @return the Y offset in millimeters
     */
    public double getOffsetY();
 
    /**
     * @return the Z offset in millimeters
     */
    public double getOffsetZ();
    
    /**
     * @return the appearance (colour) to use in the simulation window for this material
     */
    public Appearance getAppearance();  
    
    /**
     * @return the material name
     */
    //public String toString();
    
    /**
     * @return whether nozzle wipe method is enabled or not 
     */
    public boolean getNozzleWipeEnabled();
    
    /**
     * @return the X-cord for the nozzle wiper
     */
    public double getNozzleWipeDatumX();

    /**
     * @return the Y-cord for the nozzle wiper
     */
    public double getNozzleWipeDatumY();
    
    /**
     * @return the X length of the nozzle movement over the wiper
     */
    public double getNozzleWipeStrokeX();
    
    /**
     * @return the Y length of the nozzle movement over the wiper
     */
    public double getNozzleWipeStrokeY();
    
    /**
     * @return the number of times the nozzle moves over the wiper
     */
    public int getNozzleWipeFreq();
    
    /**
     * @return the time to extrude before wiping the nozzle
     */
    public double getNozzleClearTime();
    
    /**
     * @return the time to wait after wiping the nozzle
     */
    public double getNozzleWaitTime();
    
    /**
     * Start polygons at a random location round their perimiter
     * @return
     */
    public boolean randomStart();

    /**
     * Start polygons at an incremented location round their perimiter
     * @return
     */
    public boolean incrementedStart();
    
    /**
     * get short lengths which need to be plotted faster
     * set -ve to turn this off.
     * @return
     */
    public double getShortLength();
    
    /**
     * Factor (between 0 and 1) to use to set the speed for
     * short lines.
     * @return
     */
    public double getShortLineSpeedFactor();

	/**
	* Feedrate for short lines in mm/minute
	* @return
	*/
	public double getShortLineFeedrate();
    
    /**
     * Number of mm to overlap the hatching infill with the outline.  0 gives none; -ve will 
     * leave a gap between the two
     * @return
     */
    public double getInfillOverlap();
    
    /**
	 * Gets the number of milliseconds to wait before starting the extrude motor
	 * for the first track of a layer
	 * @return
     */
    public double getExtrusionDelayForLayer();
    
    /**
	 * Gets the number of milliseconds to wait before starting the extrude motor
	 * for any other track
	 * @return
     */
    public double getExtrusionDelayForPolygon();
    
    /**
	 * Gets the number of milliseconds to wait before opening the valve
	 * for the first track of a layer
	 * @return
     */
    public double getValveDelayForLayer();
    
    /**
	 * Gets the number of milliseconds to wait before opening the valve
	 * for any other track
	 * @return
     */
    public double getValveDelayForPolygon();
    
    /**
     * @return the extrusion overrun in millimeters (i.e. how many mm
     * before the end of a track to turn off the extrude motor)
     */
    public double getExtrusionOverRun();
    
    /**
     * @return the valve overrun in millimeters (i.e. how many mm
     * before the end of a track to turn off the extrude motor)
     */
    public double getValveOverRun();
    
    /**
     * The number of times to go round the outline (0 to supress)
     * @return
     */
    public int getShells();
    
    /**
     * The smallest allowable free-movement height above the base
     * @return
     */
    public double getMinLiftedZ();
    
    /**
     * Stop the extrude motor between segments?
     * @return
     */
    public boolean getPauseBetweenSegments();
    
    /**
     * 
     * @param p
     */
	public void setPrinter(Printer p);

	/**
	 * 
	 * @return
	 */
	public Printer getPrinter();
	
	/**
	 * 
	 * @return
	 */
	public double getExtrusionFoundationWidth();
	
	/**
	 * 
	 * @return
	 */
	public double getExtrusionInfillWidth();
	
	/**
	 * 
	 * @return
	 */
	public double getExtrusionBroadWidth();
	
	
	public int getLowerFineLayers();
	public int getUpperFineLayers();
	
	/**
	 * At the support layer before a layer is to be separated, how far up
	 * the normal Z movement do we go to make a bigger gap to form a weak join?
	 * @return
	 */
	public double getSeparationFraction();
	
	/**
	 * Wait if the XY movement buffer is active in the mictrocontroller
	 * @throws IOException
	 */
	public void waitTillNotBusy() throws IOException;
    
	/**
	 * The arc compensation factor.  
	 * See org.reprap.geometry.polygons.RrPolygon.arcCompensate(...)
	 * @return
	 */
	public double getArcCompensationFactor();
	
	/**
	 * The arc short sides.  
	 * See org.reprap.geometry.polygons.RrPolygon.arcCompensate(...)
	 * @return
	 */
	public double getArcShortSides();
	
	/**
	 * What stuff are we working with?
	 * @return
	 */
	public String getMaterial();
	
}