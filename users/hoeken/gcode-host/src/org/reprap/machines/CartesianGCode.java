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
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#moveTo(double, double, double, boolean, boolean)
	 */
	public void moveTo(double x, double y, double z, boolean startUp, boolean endUp) throws ReprapException, IOException
	{
		if (isCancelled())
			return;

		super.moveTo(x, y, z, startUp, endUp);
		
		gcode.queue("G0 X" + x + " Y" + y + " Z" + z);
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

		gcode.queue("G1 X" + x + " Y" + y + " Z" + z + " F" + getFeedrate());

		currentX = x;
		currentY = y;
		currentZ = z;
	}
	
	public void stopExtruding() {
		gcode.queue("M103");
	}

	/**
	 * @return speed of the extruder
	 */
	public int getSpeed() {
		return 200;
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
		//file.println("RR: set speed Z: " + speed);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#dispose()
	 */
	public void dispose() {
		// TODO: fix this to be more flexible
		
		// Fan off
		gcode.queue("M9");
		
		// Extruder off
		gcode.queue("M103");
		
		// heater off
		gcode.queue("M104 P0");
		
		//write/close our file/serial port
		gcode.dispose();
	}


	/* (non-Javadoc)
	 * @see org.reprap.Printer#initialise()
	 */
	public void initialise() {
		if (previewer != null)
			previewer.reset();
		
		// TODO: Fix this to be more flexible
		// TODO: check if RapRap uses mm as scale
		gcode.queue("G21");
		
		// Set incremental positioning, so you can
		// decide where to print in the beginning
		// without messing up the rest of the Gcode
		gcode.queue("G91");
		
		// Tell it to start warming up.
		gcode.queue("M104 P" + getExtruder().getTemperatureTarget());
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setCooling(boolean)
	 */
	public void setCooling(boolean enable) {
		Debug.d("RR: set cooling: " + enable);
	}


	/* (non-Javadoc)
	 * @see org.reprap.Printer#printStartDelay(long)
	 */
	public void printStartDelay(long msDelay) {
		// This would extrude for the given interval to ensure polymer flow.
		gcode.queue("M101");
		
		//TODO: add dwell command.
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX()
	 */
	public void homeToZeroX() throws ReprapException, IOException {
		gcode.queue("G0 X-999");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {
		gcode.queue("G0 Y-999");
	}
}
