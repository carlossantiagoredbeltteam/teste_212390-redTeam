package org.reprap.devices;

import java.io.IOException;
import org.reprap.Device;
import org.reprap.Extruder;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.utilities.Debug;

import javax.media.j3d.Appearance;
import javax.vecmath.Color3f;
import javax.media.j3d.Material;
import org.reprap.comms.GCodeWriter;


public class GCodeExtruder extends GenericExtruder
{
	GCodeWriter gcode;
	
	int currentSpeed = 0;
	
	/**
	 * @param prefs
	 * @param extruderId
	 */
	public GCodeExtruder(GCodeWriter writer, Preferences prefs, int extruderId)
	{
		super(prefs, extruderId);

		gcode = writer;
		isCommsAvailable = true;
	}
	
	public void setTemperature(double temperature) throws Exception
	{
		gcode.queue("M104 S" + temperature);
	}
	
	public void setExtrusion(int speed, boolean reverse) throws IOException
	{
		if (speed == 0)
			gcode.queue("M103");
		else
		{
			if (speed != currentSpeed)
			{
				gcode.queue("M108 R" + speed);
				currentSpeed = speed;
			}
			if (reverse)
				gcode.queue("M102");
			else
				gcode.queue("M101");
		}
	}
	
	public void setCooler(boolean f) throws IOException
	{
		if (f)
			gcode.queue("M106");
		else
			gcode.queue("M107");
	}
	
	public boolean isEmpty()
	{
		return false;
	} 
}