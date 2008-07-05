package org.reprap.devices;

import java.io.IOException;
import org.reprap.Device;
import org.reprap.Extruder;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import javax.media.j3d.Appearance;
import javax.vecmath.Color3f;
import javax.media.j3d.Material;

/**
 * @author Adrian
 *
 */
public class NullExtruder extends GenericExtruder
{
	/**
	 * @param prefs
	 * @param extruderId
	 */
	public NullExtruder(Preferences prefs, int extruderId)
	{
		super(prefs, extruderId);
		
		isCommsAvailable = true;
	}
	
	/**
	 * Start the extruder motor at a given speed.  This ranges from 0
	 * to 255 but is scaled by maxSpeed and t0, so that 255 corresponds to the
	 * highest permitted speed.  It is also scaled so that 0 would correspond
	 * with the lowest extrusion speed.
	 * @param speed The speed to drive the motor at (0-255)
	 * @param reverse If set, run extruder in reverse
	 * @throws IOException
	 */
	public void setExtrusion(int speed, boolean reverse) throws IOException {
	}
	
	/**
	 * Set a heat output power.  For normal production use you would
	 * normally call setTemperature, however this method may be useful
	 * for lower temperature profiling, etc.
	 * @param heat Heater power (0-255)
	 * @param maxTemp Cutoff temperature in celcius
	 * @throws IOException
	 */
	public void setHeater(int heat, double maxTemp) throws IOException {

	}
	

	/**
	 * Check if the extruder is out of feedstock
	 * @return true if there is no material remaining
	 */
	public boolean isEmpty() {
		return false;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Extruder#setCooler(boolean)
	 */
	public void setCooler(boolean f) throws IOException {

	}
	
	public void setTemperature(double temperature) throws Exception
	{
		currentTemperature = temperature;
		requestedTemperature = temperature;
	}
}
