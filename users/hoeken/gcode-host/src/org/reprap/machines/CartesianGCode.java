package org.reprap.machines;

/*
 * TODO: To do's:
 * 
 * TODO: fixup warmup segments GCode (forgets to turn on extruder) 
 * TODO: fixup all the RR: println commands 
 * TODO: find a better place for the code. You cannot even detect a layer change without hacking now. 
 * TODO: read Zach's GCode examples to check if I messed up. 
 * TODO: make GCodeWriter a subclass of NullCartesian, so I don't have to fix code all over the place.
 */

import org.reprap.Attributes;
import org.reprap.CartesianPrinter;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.gui.Previewer;
import org.reprap.Extruder;
import org.reprap.comms.GCodeWriter;
import org.reprap.utilities.Debug;
import org.reprap.devices.GCodeExtruder;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;

/**
 *
 */
public class CartesianGCode extends GenericCartesianPrinter {
	
	/**
	* our class to send gcode instructions
	*/
	GCodeWriter gcode;
	
	/**
	 * @param prefs
	 * @throws Exception
	 */
	public CartesianGCode(Preferences config) throws Exception {
		
		super(config);

		String portname = config.loadString("Port(name)");
		boolean useSerialPort = config.loadBool("GCodeUseSerial");

		gcode = new GCodeWriter();
		if (useSerialPort)
			gcode.openSerialConnection(portname);
		else
			gcode.openFile();
			
		loadExtruders(config);
	}
	
	public void loadExtruders(Preferences config)
	{
		extruders = new GCodeExtruder[extruderCount];
		
		super.loadExtruders(config);
	}
	
	public Extruder extruderFactory(Preferences prefs, int count)
	{
		return new GCodeExtruder(gcode, prefs, count);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#moveTo(double, double, double, boolean, boolean)
	 */
	public void moveTo(double x, double y, double z, boolean startUp, boolean endUp) throws ReprapException, IOException
	{
		if (isCancelled())
			return;

		super.moveTo(x, y, z, startUp, endUp);
		
		double gx = round(x, 4);
		double gy = round(y, 4);
		double gz = round(z, 4);
		
		gcode.queue("G0 X" +gx + " Y" + gy + " Z" + gz);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#printTo(double, double, double)
	 */
	public void printTo(double x, double y, double z, boolean turnOff) throws ReprapException, IOException
	{
		if (previewer != null)
			previewer.addSegment(currentX, currentY, currentZ, x, y, z);
			
		if (isCancelled())
			return;

		double distance = segmentLength(x - currentX, y - currentY);
		if (z != currentZ)
			distance += Math.abs(currentZ - z);
		totalDistanceExtruded += distance;
		totalDistanceMoved += distance;

		double gx = round(x, 4);
		double gy = round(y, 4);
		double gz = round(z, 4);
		double feed = round(getFeedrate(), 4);

		gcode.queue("G1 X" + gx + " Y" + gy + " Z" + gz + " F" + feed);

		currentX = x;
		currentY = y;
		currentZ = z;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getSpeedZ()
	 */
	public int getSpeedZ() {
		return 200;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setSpeedZ(int)
	 */
	public void setSpeedZ(int speed) {
		// TODO: MiniMug prints this, but I don't know what to do with it
		Debug.d("RR: set speed Z: " + speed);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#dispose()
	 */
	public void dispose() {
		// TODO: fix this to be more flexible
		
		try
		{
			// Fan off
			getExtruder().setCooler(false);

			// Extruder off
			getExtruder().setExtrusion(0);

			// heater off
			getExtruder().heatOff();
		} catch(Exception e){
			//oops
		}
		
		//write/close our file/serial port
		gcode.finish();
	}


	/* (non-Javadoc)
	 * @see org.reprap.Printer#initialise()
	 */
	public void initialise() {
		
		// TODO: Fix this to be more flexible - howso?
		gcode.queue("G21");
		
		// Set incremental positioning, so you can
		// decide where to print in the beginning
		// without messing up the rest of the Gcode
		gcode.queue("G91");
		
		try	{
			super.initialise();
		} catch (Exception E) {
			Debug.d("Initialization error.");
		}
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#printStartDelay(long)
	 */
	public void printStartDelay(long msDelay) {
		// This would extrude for the given interval to ensure polymer flow.
		getExtruder().startExtruding();
		gcode.queue("G4 P" + msDelay);
	}

	public void home() {
		super.home();
		
		gcode.queue("G0 X-999 Y-999");
		gcode.queue("G0 Z-999");
		gcode.queue("G92");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX()
	 */
	public void homeToZeroX() throws ReprapException, IOException {
		super.homeToZeroX();
		gcode.queue("G0 X-999");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {
		super.homeToZeroY();
		gcode.queue("G0 Y-999");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroZ() throws ReprapException, IOException {
		super.homeToZeroZ();
		gcode.queue("G0 Z-999");
	}
	
	public double round(double c, double d)
	{
		double power = Math.pow(10.0, d);
		
		return Math.round(c*power)/power;
	}
}
