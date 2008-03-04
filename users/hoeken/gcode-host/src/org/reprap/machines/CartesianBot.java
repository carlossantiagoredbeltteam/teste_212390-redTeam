import javax.media.j3d.*;

import org.reprap.Attributes;
import org.reprap.CartesianPrinter;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.gui.Previewer;
import org.reprap.devices.NullExtruder;
import org.reprap.Extruder;
import org.reprap.utilities.Debug;

public abstract class CartesianBot implements CartesianPrinter {
	
	/**
	 * 
	 */
	Previewer previewer = null;

	/**
	 * 
	 */
	double totalDistanceMoved = 0.0;
	
	/**
	 * 
	 */
	double totalDistanceExtruded = 0.0;
	
	/**
	 * Scale for each axis in steps/mm.
	 */
	double scaleX, scaleY, scaleZ;
	
	/**
	 * Current X, Y and Z position of the extruder 
	 */
	double currentX, currentY, currentZ;
	
	/**
	 * Maximum feedrate for X, Y, and Z axes
	 */
	double maxFeedrateX, maxFeedrateY, maxFeedrateZ;
	
	/**
	 * Number of extruders on the 3D printer
	 */
	private int extruderCount;
	
	/**
	 * Array containing the extruders on the 3D printer
	 */
	private Extruder extruders[];

	/**
	 * Current extruder?
	 */
	private int extruder;
	
	/**
	 * 
	 */
	private long startTime;
	
	/**
	 * 
	 */
	private boolean idleZ;
	
	public CartesianSNAP(Preferences prefs) throws Exception
	{
		startTime = System.currentTimeMillis();
		
		//load axis prefs
		int axes = prefs.loadInt("AxisCount");
		if (axes != 3)
			throw new Exception("A Cartesian Bot must contain 3 axes");
			
		//load extruder prefs
		extruderCount = prefs.loadInt("NumberOfExtruders");
		extruders = new GenericExtruder[extruderCount];
		if (extruderCount < 1)
			throw new Exception("A Reprap printer must contain at least one extruder");
		
		//load our actual extruders.
		loadExtruders();
			
		// TODO This should be from calibration
		scaleX = prefs.loadDouble("XAxisScale(steps/mm)");
		scaleY = prefs.loadDouble("YAxisScale(steps/mm)");
		scaleZ = prefs.loadDouble("ZAxisScale(steps/mm)");
		
		// Load our maximum feedrate variables
		maxFeedrateX = prefs.loadDouble("MaximumFeedrateX(mm/minute)");
		maxFeedrateY = prefs.loadDouble("MaximumFeedrateY(mm/minute)");
		maxFeedrateZ = prefs.loadDouble("MaximumFeedrateZ(mm/minute)");
	}
	
	public void loadExtruders()
	{
		//instantiate extruders
		extruderCount = config.loadInt("NumberOfExtruders");
		extruders = new Extruder[extruderCount];
		for(int i = 0; i < extruderCount; i++)
		{
			String prefix = "Extruder" + i + "_";
			extruders[i] = extruderFactory(prefs, i);
		}
		extruder = 0;
	}
}