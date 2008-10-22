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
	public GCodeExtruder(GCodeWriter writer, int extruderId)
	{
		super(extruderId);

		gcode = writer;
	}
	
	public void setTemperature(double temperature) throws Exception
	{
		gcode.queue("M104 S" + temperature + " ;set temperature");
	}
	
	public void setHeater(int heat, double maxTemp) {}
	
	public double getTemperature()
	{
		return Double.parseDouble(gcode.queueRespond("M105; get temperature").substring(2)); // Throw away "T:"
	}
	
	public void setExtrusion(int speed, boolean reverse) throws IOException
	{
		if(extrusionSpeed < 0)
			return;
		
		if (speed == 0)
		{
			gcode.queue("M103" + " ;extruder off");
			isExtruding = false;
		}
		else
		{
			if (speed != currentSpeed)
			{
				gcode.queue("M108 R" + speed + " ;extruder speed in RPM");
				currentSpeed = speed;
			}

			if (reverse)
				gcode.queue("M102" + " ;extruder on, reverse");
			else
			{
				try
				{
					gcode.queue("M101" + " ;extruder on, forward");
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			}

			isExtruding = true;
		}
	}
	
	//TODO: make these real G codes.
	public void setCooler(boolean coolerOn) throws IOException
	{
		if (coolerOn)
			gcode.queue("M106 ;cooler on");
		else
			gcode.queue("M107 ;cooler off");
	}
	

	public void setValve(boolean valveOpen) throws IOException
	{
		if(valvePulseTime <= 0)
			return;
		if (valveOpen)
			gcode.queue("M126 P" + valvePulseTime + ";valve open");
		else
			gcode.queue("M127 P" + valvePulseTime + ";valve closed");
	}
	
	public boolean isEmpty()
	{
		return false;
	} 
}