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
import org.reprap.devices.GCodeStepperMotor;

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
	* what is our current feedrate?
	*/
	double currentFeedrate = 0.0;
	
	boolean useSerialPort = false;
	String portName;
	
	/**
	 * @param prefs
	 * @throws Exception
	 */
	public CartesianGCode() throws Exception {
		
		super();
		
		portName = Preferences.loadGlobalString("Port(name)");
		useSerialPort = Preferences.loadGlobalBool("GCodeUseSerial");

		gcode = new GCodeWriter();
			
		loadExtruders();
	}
	
	public void loadMotors()
	{
		motorX = new GCodeStepperMotor('X');
		motorY = new GCodeStepperMotor('Y');
		motorZ = new GCodeStepperMotor('Z');
	}
	
	public void loadExtruders()
	{
		extruders = new GCodeExtruder[extruderCount];
		
		super.loadExtruders();
	}
	
	public Extruder extruderFactory(int count)
	{
		return new GCodeExtruder(gcode, count);
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
		
		String code;

		if (dx == 0.0 && dy == 0.0 && dz == 0.0)
			return;
		
		double liftedZ = round(currentZ + (extruders[extruder].getExtrusionHeight()/2), 4);

		//go up first?
		if (startUp)
		{
			code = "G1 Z" + liftedZ;

			if (zFeedrate != currentFeedrate)
			{
				code += " F" + zFeedrate;
				currentFeedrate = zFeedrate;
			}

			code += " ;lift up";
			
			gcode.queue(code);
			currentZ = liftedZ;
			dz = 0;
		}
		
		//our real command
		if (dx != 0 | dy != 0)
		{
			code = "";
			if (currentFeedrate != xyFeedrate)
				code = "G1 ";

			if (dx != 0)
				code += "X" + gx;
			if (dy != 0)
				code += " Y" + gy;
			if (currentFeedrate != xyFeedrate)
			{
				code += " F" + xyFeedrate;
				currentFeedrate = xyFeedrate;
			}

			code += " ;xy move";
			gcode.queue(code);
		}
		

		if (dz != 0)
		{
			code = "G1 ";
			code += " Z" + gz;
			
			if (zFeedrate != currentFeedrate)
			{
				code += " F" + zFeedrate;
				currentFeedrate = zFeedrate;
			}
			
			code += " ;lift down";
			gcode.queue(code);
		}
		
		//go back down?
		if (!endUp && z != currentZ)
		{
			code = "G1 Z" + gz;
			
			if (zFeedrate != currentFeedrate)
			{
				code += " F" + zFeedrate;
				currentFeedrate = zFeedrate;
			}

			code += " ;z down";
			gcode.queue(code);
		}
		
		super.moveTo(x, y, z, startUp, endUp);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#printTo(double, double, double)
	 */
	public void printTo(double x, double y, double z, boolean stopExtruder, boolean closeValve) throws ReprapException, IOException
	{
		if (previewer != null)
			previewer.addSegment(currentX, currentY, currentZ, x, y, z);
			
		if (isCancelled())
			return;
		
		maybeReZero();
		
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

		String code = "";
		
		if (feed != currentFeedrate)
			code += "G1 ";
		
		if (dx != 0)
			code += " X" + gx;
		if (dy != 0)
			code += " Y" + gy;
		if (dz != 0)
			code += " Z" + gz;
		if (feed != currentFeedrate)
		{
			code += " F" + feed;
			currentFeedrate = feed;
		}
		
		code += " ;print segment";
		gcode.queue(code);
		
		if(stopExtruder)
			getExtruder().stopExtruding();
		if(closeValve)
			getExtruder().setValve(false);

		currentX = x;
		currentY = y;
		currentZ = z;
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
	public void initialise()
	{
		if (useSerialPort)
			gcode.openSerialConnection(portName);
		else
			gcode.openFile();

		gcode.queue(";gcode generated by RepRap Host Software");

		//take us to fun, safe metric land.
		gcode.queue("G21 ;metric is good!");
		
		// Set absolute positioning, which is what we use.
		gcode.queue("G90 ;absolute positioning");
		
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
		
		gcode.queue("G1 X-999 Y-999 F" + xyFeedrate + " ;xy home");
		currentFeedrate = xyFeedrate;
		
		//gcode.queue("G0 Z-999");
		gcode.queue("G92 ;set current position as home");
	}
	
	private void delay(long millis)
	{
		gcode.queue("G4 P" + millis + " ;delay");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX()
	 */
	public void homeToZeroX() throws ReprapException, IOException {
		super.homeToZeroX();
		
		double feedrate = round(getMaxFeedrateX(), 4);
		gcode.queue("G1 X-999 F" + feedrate + " ;home x");
		currentFeedrate = feedrate;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {
		super.homeToZeroY();

		double feedrate = round(getMaxFeedrateY(), 4);
		gcode.queue("G1 Y-999 F" + feedrate + " ;home y");
		currentFeedrate = feedrate;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroZ() throws ReprapException, IOException {
		super.homeToZeroZ();

		double feedrate = round(getMaxFeedrateZ(), 4);
		gcode.queue("G1 Z-999 F" + feedrate + " ;home z");
		currentFeedrate = feedrate;
	}
	
	public double round(double c, double d)
	{
		double power = Math.pow(10.0, d);
		
		return Math.round(c*power)/power;
	}
	
	public void waitTillNotBusy() throws IOException {}

	//TODO: make this work normally.
	public void stopMotor() throws IOException
	{
	}
	
	//TODO: make this work normally.
	public void stopValve() throws IOException
	{
	}
	
	/**
	 * All machine dwells and delays are routed via this function, rather than 
	 * calling Thread.sleep - this allows them to generate the right G codes (G4) etc.
	 * 
	 * The RS232/USB etc comms system doesn't use this - it sets its own delays.
	 * @param milliseconds
	 */
	public void machineWait(double milliseconds)
	{
		delay((long)milliseconds);
	}
}
