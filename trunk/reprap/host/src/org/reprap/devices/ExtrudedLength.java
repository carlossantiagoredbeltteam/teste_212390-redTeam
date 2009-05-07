package org.reprap.devices;

/**
 * Tiny class to hold the length of filament that an extruder has extruded so far.
 * 
 * @author Adrian
 *
 */
public class ExtrudedLength 
{
	private double l;
	
	ExtrudedLength()
	{
		l = 0;
	}
	
	public double length()
	{
		return l;
	}
	
	public void add(double e)
	{
		l += e;
	}
	
	public void zero()
	{
		l = 0;
	}
}
