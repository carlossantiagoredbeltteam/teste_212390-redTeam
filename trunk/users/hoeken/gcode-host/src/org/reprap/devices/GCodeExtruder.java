package org.reprap.devices;

import java.io.IOException;
import org.reprap.Device;
import org.reprap.Extruder;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import javax.media.j3d.Appearance;
import javax.vecmath.Color3f;
import javax.media.j3d.Material;

public class GCodeExtruder extends GenericExtruder
{
	/**
	 * @param prefs
	 * @param extruderId
	 */
	public GCodeExtruder(Preferences prefs, int extruderId)
	{
		super(prefs, extruderId);

		isCommsAvailable = true;
	}
	
	public void setCooler(boolean f) throws IOException
	{
		
	}
	
	public boolean isEmpty()
	{
		return false;
	} 
}