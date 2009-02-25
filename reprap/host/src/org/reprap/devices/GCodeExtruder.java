package org.reprap.devices;

import java.io.IOException;

import org.reprap.comms.GCodeReaderAndWriter;
import org.reprap.Preferences;

public class GCodeExtruder extends GenericExtruder
{
	GCodeReaderAndWriter gcode;
	
	double currentSpeed = 0;
	
	/**
	 * @param prefs
	 * @param extruderId
	 */
	public GCodeExtruder(GCodeReaderAndWriter writer, int extruderId)
	{
		super(extruderId);
		currentSpeed = 0;
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
	
	public void setExtrusion(double speed, boolean reverse) throws IOException
	{
		if(extrusionSpeed < 0)
			return;
		
		if (speed < Preferences.tiny())
		{
			gcode.queue("M103" + " ;extruder off");
			currentSpeed = 0;
			isExtruding = false;
		}
		else
		{
			if (speed != currentSpeed)
			{
				gcode.queue("M108 S" + speed + " ;extruder speed in RPM");
				currentSpeed = speed;
			}

			if (reverse)
				gcode.queue("M102" + " ;extruder on, reverse");
			else
				gcode.queue("M101" + " ;extruder on, forward");

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