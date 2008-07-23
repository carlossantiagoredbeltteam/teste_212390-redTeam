/**
 * 
 */
package org.reprap.devices;

import java.io.IOException;
import org.reprap.Device;
import org.reprap.Extruder;
import org.reprap.Printer;
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
	 * @param extruderId
	 */
	public NullExtruder(int extruderId)
	{
		super(extruderId);
	}
	
	public void setExtrusion(int speed, boolean reverse) throws IOException {}
	public void setCooler(boolean f) throws IOException {}
	public void setValve(boolean valveOpen) throws IOException {}
	public void heatOn() throws Exception {}
	public void setHeater(int heat, double maxTemp) throws IOException {}
	public void setTemperature(double temperature) throws Exception {}

	public boolean isEmpty()
	{
		return false;
	}
	
	public double getTemperature()
	{
		return getTemperatureTarget();
	}
	
}
