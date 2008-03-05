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
import org.reprap.utilities.Debug;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;

/**
 *
 */
public class CartesianGCode extends CartesianBot {
	
	// Added by Blerik, needs JavaDoc
	private java.io.PrintStream file;
	
	/**
	 * @param prefs
	 * @throws Exception
	 */
	public CartesianGCode(Preferences prefs) throws Exception {
		
		super(prefs);

		currentX = 0;
		currentY = 0;
		currentZ = 0;
		
		// I open the file here because I have config here
		// and it seems like the host recreates the writer
		// for each print job
		String filename = config.loadString("Port(name)");
		if (filename.equals("stdout")) {
			file = System.out;
		} else {
			try {
				OutputStream out = new FileOutputStream(filename);
				file = new PrintStream(out);
			} catch (FileNotFoundException e) {
				System.err.println("Problem with filename, printing to stdout");
				file = System.out;
			}
		}
		requestedSpeed = 0;
		currentSpeed = 0;
		temperature = config.loadInt("Extruder0_ExtrusionTemp(C)");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#moveTo(double, double, double, boolean, boolean)
	 */
	public void moveTo(double x, double y, double z, boolean startUp, boolean endUp) throws ReprapException, IOException
	{
		if (isCancelled())
			return;

		super.moveTo();
		
		file.print("G0");
		file.print(" X" + x + " Y" + y);
		if (deltaZ != 0)
			file.print(" Z" + z);
		file.println();
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
		
		double deltaX = round(x - currentX);
		double deltaY = round(y - currentY);
		double deltaZ = round(z - currentZ);

		file.print("G1");
		file.print(" X" + deltaX + " Y" + deltaY);
		if (deltaZ != 0) file.print(" Z" + deltaZ);
		if (currentSpeed != requestedSpeed)
		{
			file.print(" F" + requestedSpeed);
			currentSpeed = requestedSpeed;
		}
		file.println();

		currentX = x;
		currentY = y;
		currentZ = z;
	}
	
	public void stopExtruding() {
		file.println("M103");
	}

	/**
	 * @return speed of the extruder
	 */
	public int getSpeed() {
		return 200;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getFastSpeed()
	 */
	public int getFastSpeed() {
		return getSpeed();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setSpeed(int)
	 */
	public void setSpeed(int speed) {
		//	TODO: convert feedrate from RepRap host value to GCode value 
		requestedSpeed = speed;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setFastSpeed(int)
	 */
	public void setFastSpeed(int speed) {
		file.println("RR: set fast speed: " + speed);
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
		file.println("M9");
		
		// Extruder off
		file.println("M103");
		
		// heater off
		file.println("M104 P0");
		
		if (!file.equals(System.out)) {
			file.close();
		}
	}


	/* (non-Javadoc)
	 * @see org.reprap.Printer#initialise()
	 */
	public void initialise() {
		if (previewer != null)
			previewer.reset();
		
		// TODO: Fix this to be more flexible
		// TODO: check if RapRap uses mm as scale
		file.println("G21");
		
		// Set incremental positioning, so you can
		// decide where to print in the beginning
		// without messing up the rest of the Gcode
		file.println("G91");
		file.println("M104 P" + temperature);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setCooling(boolean)
	 */
	public void setCooling(boolean enable) {
		file.println("RR: set cooling: " + enable);
	}


	/* (non-Javadoc)
	 * @see org.reprap.Printer#printStartDelay(long)
	 */
	public void printStartDelay(long msDelay) {
		// This would extrude for the given interval to ensure polymer flow.
		file.println("M101");
		
		//TODO: add dwell command.
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX()
	 */
	public void homeToZeroX() throws ReprapException, IOException {
		file.println("G0 X-999");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {
		file.println("G0 Y-999");
	}
}
