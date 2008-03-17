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

		double gx = round(x, 1);
		double gy = round(y, 1);
		double gz = round(z, 4);
		double zFeedrate = round(getMaxFeedrateZ(), 4);
		double xyFeedrate = round(getFeedrate(), 1);

		double dx = currentX - x;
		double dy = currentY - y;
		double dz = currentZ - z;

		if (dx == 0.0 && dy == 0.0 && dz == 0.0)
			return;
		
		double liftedZ = round(currentZ + (extruders[extruder].getExtrusionHeight()/2), 4);

		//go up first?
		if (startUp)
		{
			gcode.queue("G1 Z" + liftedZ + " F" + zFeedrate);
			currentZ = liftedZ;
			dz = 0;
		}
		
		//our real command
		String code = "G1";
		if (dx != 0)
			code += " X" + gx;
		if (dy != 0)
			code += " Y" + gy;
		code += " F" + xyFeedrate;
		gcode.queue(code);

		if (dz != 0)
		{
			code = "G1";
			code += " Z" + gz;
			code += " F" + zFeedrate;
			gcode.queue(code);
		}
		
		//go back down?
		if (!endUp && z != currentZ)
			gcode.queue("G1 Z" + gz + " F" + zFeedrate);

		super.moveTo(x, y, z, startUp, endUp);
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
			
		getExtruder().startExtruding();		

		double distance = segmentLength(x - currentX, y - currentY);
		if (z != currentZ)
			distance += Math.abs(currentZ - z);
		totalDistanceExtruded += distance;
		totalDistanceMoved += distance;

		double gx = round(x, 1);
		double gy = round(y, 1);
		double gz = round(z, 4);
		double feed = round(getFeedrate(), 1);

		double dx = currentX - x;
		double dy = currentY - y;
		double dz = currentZ - z;

		if (dx == 0.0 && dy == 0.0 && dz == 0.0)
			return;

		String code = "G1";
		
		if (dx != 0)
			code += " X" + gx;
		if (dy != 0)
			code += " Y" + gy;
		if (dz != 0)
			code += " Z" + gz;
		code += " F" + feed;
		
		gcode.queue(code);
		
		if(turnOff)
			getExtruder().stopExtruding();

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
		
		//take us to fun, safe metric land.
		gcode.queue("G21");
		
		// Set absolute positioning, which is what we use.
		gcode.queue("G90");
		
		// set our extruder speed.
		gcode.queue("M104 P" + getExtruder().getExtruderSpeed());		
		
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
		
		delay(msDelay);
	}

	public void home() {
		super.home();
		
		double xyFeedrate = round(getFastFeedrateXY(), 4);
		
		gcode.queue("G1 X-999 Y-999 F" + xyFeedrate);
		//gcode.queue("G0 Z-999");
		gcode.queue("G92");
	}
	
	public void delay(long millis)
	{
		gcode.queue("G4 P" + millis);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX()
	 */
	public void homeToZeroX() throws ReprapException, IOException {
		super.homeToZeroX();
		
		double feedrate = round(getMaxFeedrateX(), 4);
		gcode.queue("G0 X-999 F" + feedrate);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {
		super.homeToZeroY();

		double feedrate = round(getMaxFeedrateY(), 4);
		gcode.queue("G0 Y-999 F" + feedrate);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroZ() throws ReprapException, IOException {
		super.homeToZeroZ();

		double feedrate = round(getMaxFeedrateZ(), 4);
		gcode.queue("G0 Z-999 F" + feedrate);
	}
	
	public double round(double c, double d)
	{
		double power = Math.pow(10.0, d);
		
		return Math.round(c*power)/power;
	}
}
