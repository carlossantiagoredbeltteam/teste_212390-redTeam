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

import org.reprap.ReprapException;
import org.reprap.Extruder;
import org.reprap.Preferences;
import org.reprap.comms.GCodeReaderAndWriter;
import org.reprap.utilities.Debug;
import org.reprap.devices.GCodeExtruder;
import org.reprap.devices.ExtrudedLength;
import org.reprap.devices.GCodeStepperMotor;
import org.reprap.geometry.LayerRules;

import java.io.IOException;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 *
 */
public class GCodeRepRap extends GenericRepRap {
	
	/**
	* our class to send gcode instructions
	*/
	GCodeReaderAndWriter gcode;
	
	/**
	 * @param prefs
	 * @throws Exception
	 */
	public GCodeRepRap() throws Exception {
		
		super();

		gcode = new GCodeReaderAndWriter();
		
		loadExtruders();
	}
	
	public void loadMotors()
	{
		motorX = new GCodeStepperMotor(this, 1);
		motorY = new GCodeStepperMotor(this, 2);
		motorZ = new GCodeStepperMotor(this, 3);
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
	
	private void qFeedrate(double feedrate)
	{		
		if(currentFeedrate == feedrate)
			return;
		gcode.queue("G1 F" + feedrate + "; feed for start of next move");
		currentFeedrate = feedrate;		
	}
	
	private void qXYMove(double x, double y, double feedrate)
	{	
		double dx = x - currentX;
		double dy = y - currentY;
		
		double xyFeedrate = round(extruders[extruder].getXYFeedrate(), 1);
		
		if(xyFeedrate < feedrate)
		{
			System.err.println("GCodeRepRap().qXYMove: feedrate (" + feedrate + ") exceeds maximum (" + xyFeedrate + ").");
			feedrate = xyFeedrate;
		}
		
		if(!accelerating)
			qFeedrate(feedrate);
		
		if(dx == 0.0 && dy == 0.0)
			return;
		
		double extrudeLength;
		String code = "G1 ";

		if (dx != 0)
			code += "X" + x;
		if (dy != 0)
			code += " Y" + y;

		extrudeLength = extruders[extruder].getDistance(Math.sqrt(dx*dx + dy*dy), feedrate);

		if(extrudeLength > 0)
		{
			if(extruders[extruder].getReversing())
				extruders[extruder].getExtrudedLength().add(-extrudeLength);
			else
				extruders[extruder].getExtrudedLength().add(extrudeLength);
			if(extruders[extruder].get4D())
				code += " E" + round(extruders[extruder].getExtrudedLength().length(), 1);
		}
		
		if (currentFeedrate != feedrate)
		{
			code += " F" + feedrate;
			currentFeedrate = feedrate;
		}
		
		code += " ;horizontal move";
		gcode.queue(code);
		currentX = x;
		currentY = y;
	}
	
	private void qZMove(double z, double feedrate)
	{	
		// Z doesn't accelerate (yet); note we set the feedrate whether we move or not
		
		double zFeedrate = round(getMaxFeedrateZ(), 1);
		
		if(zFeedrate < feedrate)
		{
			System.err.println("GCodeRepRap().qZMove: feedrate (" + feedrate + ") exceeds maximum (" + zFeedrate + ").");
			feedrate = zFeedrate;
		}
		
		if(currentFeedrate != feedrate)
			qFeedrate(feedrate);
		
		double dz = z - currentZ;
		
		if(dz == 0.0)
			return;
		
		String code;
		double extrudeLength;
		
		code = "G1 Z" + z;

		extrudeLength = extruders[extruder].getDistance(dz, feedrate);

		if(extrudeLength > 0)
		{
			if(extruders[extruder].getReversing())
				extruders[extruder].getExtrudedLength().add(-extrudeLength);
			else
				extruders[extruder].getExtrudedLength().add(extrudeLength);
			if(extruders[extruder].get4D())
				code += " E" + round(extruders[extruder].getExtrudedLength().length(), 1);
		}
		
		code += " ;z move";
		gcode.queue(code);
		currentZ = z;	
	}



	/* (non-Javadoc)
	 * @see org.reprap.Printer#moveTo(double, double, double, boolean, boolean)
	 */
	public void moveTo(double x, double y, double z, double feedrate, boolean startUp, boolean endUp) throws ReprapException, IOException
	{
		if (isCancelled())
			return;

		x = round(x, 1);
		y = round(y, 1);
		z = round(z, 4);
		feedrate = round(feedrate, 1);
		
		double dx = x - currentX;
		double dy = y - currentY;
		double dz = z - currentZ;
		
		if (dx == 0.0 && dy == 0.0 && dz == 0.0)
			return;
		
		// This should either be a Z move or an XY move, but not all three
		
		boolean zMove = dz != 0;
		boolean xyMove = dx!= 0 || dy != 0;
		
		if(zMove && xyMove)
			System.err.println("GcodeRepRap.moveTo(): attempt to move in X|Y and Z simultaneously: (x, y, z) = (" + x + ", " + y + ", " + z + ")");

		double zFeedrate = round(getMaxFeedrateZ(), 1);
		
		double liftIncrement = extruders[extruder].getExtrusionHeight()/2;
		double liftedZ = round(currentZ + liftIncrement, 4);

		//go up first?
		if (startUp)
		{
			qZMove(liftedZ, zFeedrate);
			qFeedrate(feedrate);
		}
		
		if(xyMove)
			qXYMove(x, y, feedrate);
		
		if(zMove)
			qZMove(z, feedrate);
		
		if(endUp && !startUp)
		{
			qZMove(liftedZ, zFeedrate);
			qFeedrate(feedrate);			
		}
		
		if(!endUp && startUp)
		{
			qZMove(liftedZ - liftIncrement, zFeedrate);
			qFeedrate(feedrate);			
		}		
		
		super.moveTo(x, y, z, feedrate, startUp, endUp);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#printTo(double, double, double)
	 */
	public void printTo(double x, double y, double z, double feedrate, boolean stopExtruder, boolean closeValve) throws ReprapException, IOException
	{
		moveTo(x, y, z, feedrate, false, false);
		
		if(stopExtruder)
			getExtruder().stopExtruding();
		if(closeValve)
			getExtruder().setValve(false);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#dispose()
	 */
	public void dispose() {
		// TODO: fix this to be more flexible
		gcode.startingEpilogue();
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
		gcode.reverseLayers();
		gcode.finish();

		super.dispose();
	}


	/* (non-Javadoc)
	 * @see org.reprap.Printer#initialise()
	 */
	public void startRun()
	{	
		// If we are printing from a file, that should contain all the headers we need.
		if(gcode.buildingFromFile())
			return;
		
		gcode.startRun();
		
		gcode.queue("; GCode generated by RepRap Java Host Software");
		Date myDate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd:HH-mm-ss");
		String myDateString = sdf.format(myDate);
		gcode.queue("; Created: " + myDateString);

		//take us to fun, safe metric land.
		gcode.queue("G21 ;metric is good!");
		
		// Set absolute positioning, which is what we use.
		gcode.queue("G90 ;absolute positioning");
				
		try	{
			super.startRun();
		} catch (Exception E) {
			Debug.d("Initialization error: " + E.toString());
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

		// Assume the extruder is off...
		
		try
		{
			moveTo(-250, -250, currentZ, slowFeedrateXY, false, false);
			moveTo(currentX, currentY, -250, getMaxFeedrateZ(), false, false);
		} catch (Exception e)
		{}
		
		String setHome = "G92 X0 Y0 Z0";
		if(extruders[extruder].get4D())
			setHome += " E0";
		setHome += "; set current position as home";
		gcode.queue(setHome);
		super.home();
	}
	
	private void delay(long millis)
	{
		double extrudeLength = getExtruder().getDistance(millis);
		if(extrudeLength > 0)
		{
			if(extruders[extruder].getReversing())
				extruders[extruder].getExtrudedLength().add(-extrudeLength);
			else
				extruders[extruder].getExtrudedLength().add(extrudeLength);
			if(extruders[extruder].get4D())
			{
				double feed = round(extruders[extruder].getCurrentSpeed(), 1);
				gcode.queue("G1 F" + feed + "; force feedrate");
				gcode.queue("G1 E" + round(extruders[extruder].getExtrudedLength().length(), 1) + 
						" F" + feed + " ; extrude dwell");
				return;
			}
		}
		
		gcode.queue("G4 P" + millis + " ;delay");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX()
	 */
	public void homeToZeroX() throws ReprapException, IOException {

		
		// Assume extruder is off...
		try
		{
			moveTo(-250, currentY, currentZ, slowFeedrateXY, false, false);
		} catch (Exception e)
		{}
		gcode.queue("G92 X0 ;set x 0");
		super.homeToZeroX();
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {

		// Assume extruder is off...
		
		try
		{
			moveTo(currentX, -250, currentZ, slowFeedrateXY, false, false);
		} catch (Exception e)
		{}
		gcode.queue("G92 Y0 ;set y 0");
		super.homeToZeroY();

	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroZ() throws ReprapException, IOException {

		// Assume extruder is off...
		try
		{
			moveTo(currentX, currentY, -250, getMaxFeedrateZ(), false, false);
		} catch (Exception e)
		{}
		gcode.queue("G92 Z0 ;set z 0");	
		super.homeToZeroZ();
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
		getExtruder().stopExtruding();
	}
	
	//TODO: make this work normally.
	public void stopValve() throws IOException
	{
		getExtruder().setValve(false);
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
		if(milliseconds <= 0)
			return;
		delay((long)milliseconds);
	}
	
	/**
	 * Wait until the GCodeWriter has exhausted its buffer.
	 */
	public void waitWhileBufferNotEmpty()
	{
		while(!gcode.bufferEmpty())
			gcode.sleep(97);
	}
	
	public void slowBuffer()
	{
		gcode.slowBufferThread();
	}
	
	public void speedBuffer()
	{
		gcode.speedBufferThread();
	}
	
	/**
	 * Load a GCode file to be made.
	 * @return the name of the file
	 */
	public String loadGCodeFileForMaking()
	{
		super.loadGCodeFileForMaking();
		return gcode.loadGCodeFileForMaking();
	}
	
	/**
	 * Set an output file
	 * @return
	 */
	public String setGCodeFileForOutput()
	{
		return gcode.setGCodeFileForOutput(getTopDown());
	}
	
	/**
	 * If a file replay is being done, do it and return true
	 * otherwise return false.
	 * @return
	 */
	public boolean filePlay()
	{
		return gcode.filePlay();
	}
	
	/**
	 * Stop the printer building.
	 * This _shouldn't_ also stop it being controlled interactively.
	 */
	public void pause()
	{
		gcode.pause();
	}
	
	/**
	 * Resume building.
	 *
	 */
	public void resume()
	{
		gcode.resume();
	}
	
	public void startingLayer(LayerRules lc) throws Exception
	{
		gcode.startingLayer(lc);
		gcode.queue(";#!LAYER: " + (lc.getMachineLayer() + 1) + "/" + lc.getMachineLayerMax());		
		super.startingLayer(lc);
	}
	
	public void finishedLayer(LayerRules lc) throws Exception
	{
		super.finishedLayer(lc);
		gcode.finishedLayer();
	}
}
