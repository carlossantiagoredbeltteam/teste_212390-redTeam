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

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;

/**
 *
 */
public class CartesianGCode extends CartesianBot {
	
	/**
	 * 
	 */
	private double overRun;
	
	/**
	 * 
	 */
	private long delay;

	/**
	 * 
	 */
	private long startTime;
	
	/**
	 * 
	 */
	private Extruder extruders[];
	
	/**
	 * 
	 */
	private int extruder;
	
	/**
	 * 
	 */
	private int extruderCount;

	// Added by Blerik, needs JavaDoc
	private java.io.PrintStream file;
	private int requestedSpeed;
	private int currentSpeed;
	private int temperature;
	
	/**
	 * @param prefs
	 * @throws Exception
	 */
	public CartesianSNAP(Preferences prefs) throws Exception {
		
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
	 * @see org.reprap.Printer#calibrate()
	 */
	public void calibrate() {
	}

	/**
	 * @param startX
	 * @param startY
	 * @param startZ
	 * @param endX
	 * @param endY
	 * @param endZ
	 * @throws ReprapException
	 * @throws IOException
	 */
	public void printSegment(double startX, double startY, double startZ, 
			double endX, double endY, double endZ, boolean turnOff) throws ReprapException, IOException {
		moveTo(startX, startY, startZ, true, true);
		printTo(endX, endY, endZ, turnOff);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#moveTo(double, double, double, boolean, boolean)
	 */
	public void moveTo(double x, double y, double z, boolean startUp, 
			boolean endUp) throws ReprapException, IOException {
		if (isCancelled()) return;

		totalDistanceMoved += segmentLength(x - currentX, y - currentY);
		//TODO - next bit needs to take account of startUp and endUp
		if (z != currentZ)
			totalDistanceMoved += Math.abs(currentZ - z);

		double deltaX = round(x - currentX);
		double deltaY = round(y - currentY);
		double deltaZ = round(z - currentZ);
		
		file.print("G0");
		file.print(" X" + deltaX + " Y" + deltaY);
		if (deltaZ != 0) file.print(" Z" + deltaZ);
		file.println();

		currentX = x;
		currentY = y;
		currentZ = z;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#printTo(double, double, double)
	 */
	public void printTo(double x, double y, double z, 
			boolean turnOff) throws ReprapException, IOException {
		if (previewer != null)
			previewer.addSegment(currentX, currentY, currentZ, x, y, z);
		if (isCancelled()) return;

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
		if (currentSpeed != requestedSpeed) {
			file.print(" F" + requestedSpeed);
			currentSpeed = requestedSpeed;
		}
		file.println();

		currentX = x;
		currentY = y;
		currentZ = z;
	}

	private double round(double in) {
		return Math.round(in * 1000) / 1000.;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#selectMaterial(int)
	 */
	public void selectExtruder(int materialIndex) {
		if (isCancelled()) return;
		if(materialIndex < 0 || materialIndex >= extruderCount)
			System.err.println("Selected material (" + materialIndex + ") is out of range.");
		else
			extruder = materialIndex;
			
//		if (previewer != null)
//			previewer.setExtruder(extruders[extruder]);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#selectMaterial(int)
	 */
	public void selectExtruder(Attributes att) {
		for(int i = 0; i < extruderCount; i++)
		{
			if(att.getMaterial().equals(extruders[i].toString()))
			{
				selectExtruder(i);
				return;
			}
		}
		System.err.println("selectExtruder() - extruder not found for: " + att.getMaterial());
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#terminate()
	 */
	public void terminate() throws IOException {
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
	
	/**
	 * @return angle speedup length
	 */
	public double getAngleSpeedUpLength()
	{
		return 1;
	}
	
	/**
	 * @return angle speed factor
	 */
	public double getAngleSpeedFactor()
	{
		return 0;
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

	/**
	 * @return the extruder speeds
	 */
	public int getExtruderSpeed() {
		return 200;
	}

	/**
	 * @param speed
	 */
	public void setExtruderSpeed(int speed) {
		file.println("RR: set extruder speed: " + speed);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setPreviewer(org.reprap.gui.Previewer)
	 */
	public void setPreviewer(Previewer previewer) {
		this.previewer = previewer;
	}

	/**
	 * @param temperature
	 */
	public void setTemperature(int temperature) {
		file.println("RR: set temperature: " + temperature);
	}
	
	/**
	 * outline speed and the infill speed
	 */
	public double getOutlineSpeed()
	{
		return 1.0;
	}
	/**
	 * @return the infill speed
	 */
	public double getInfillSpeed()
	{
		return 1.0;
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
	 * @see org.reprap.Printer#isCancelled()
	 */
	public boolean isCancelled() {
		if (previewer != null)
			return previewer.isCancelled();
		return false;
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
	 * @see org.reprap.Printer#getX()
	 */
	public double getX() {
		return currentX;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getY()
	 */
	public double getY() {
		return currentY;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getZ()
	 */
	public double getZ() {
		return currentZ;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalDistanceMoved()
	 */
	public double getTotalDistanceMoved() {
		return totalDistanceMoved;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalDistanceExtruded()
	 */
	public double getTotalDistanceExtruded() {
		return totalDistanceExtruded;
	}

	/**
	 * @param x
	 * @param y
	 * @return segment length in millimeters
	 */
	public double segmentLength(double x, double y) {
		return Math.sqrt(x*x + y*y);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtrusionSize()
	 */
//	public double getExtrusionSize() {
//		return extrusionSize;
//	}
//
//	public double getExtrusionHeight() {
//		return extrusionHeight;
//	}
//	
//	public double getInfillWidth() {
//		return infillWidth;
//	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setCooling(boolean)
	 */
	public void setCooling(boolean enable) {
		file.println("RR: set cooling: " + enable);
	}
	
	/**
	 * Get the length before the end of a track to turn the extruder off
	 * to allow for the delay in the stream stopping.
	 * @return overrun in millimeters
	 */
	public double getOverRun() { return overRun; };
	
	/**
	 * Get the number of milliseconds to wait between turning an 
	 * extruder on and starting to move it.
	 * @return delay in milliseconds
	 */
	public long getDelay() { return delay; };

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalElapsedTime()
	 */
	public double getTotalElapsedTime() {
		long now = System.currentTimeMillis();
		return (now - startTime) / 1000.0;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#printStartDelay(long)
	 */
	public void printStartDelay(long msDelay) {
		// This would extrude for the given interval to ensure polymer flow.
		file.println("M101");
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setLowerShell(javax.media.j3d.Shape3D)
	 */
	public void setLowerShell(BranchGroup ls)
	{
		previewer.setLowerShell(ls);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setZManual()
	 */
	public void setZManual() {
		setZManual(0.0);
		file.println("RR: set Z manual");
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setZManual(double)
	 */
	public void setZManual(double zeroPoint) {
		file.println("RR: set Z manual: " + zeroPoint);
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
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder()
	 */
	public Extruder getExtruder()
	{
		return extruders[extruder];
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder(String)
	 */
	public Extruder getExtruder(String name)
	{
		for(int i = 0; i < extruderCount; i++)
			if(name.equals(extruders[i].toString()))
				return extruders[i];
		return null;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder(String)
	 */
	public Extruder[] getExtruders()
	{
		return extruders;
	}
	
	public void wipeNozzle() throws ReprapException, IOException {
		
		if (getExtruder().getNozzleWipeEnabled() == false) return;
		
		else {
			
			int freq = getExtruder().getNozzleWipeFreq();
			int datumX = getExtruder().getNozzleWipeDatumX();
			int datumY = getExtruder().getNozzleWipeDatumY();
			int stroke = getExtruder().getNozzleWipeStroke();
			
			//setSpeed(fastSpeedXY);
			
			// Moves nozzle back and forth over wiper
			for (int w=0; w < freq; w++)
			{
				moveTo(datumX, datumY+(stroke/2), currentZ, false, false);
				moveTo(datumX, datumY-(stroke/2), currentZ, false, false);
			}
		}
	}
	
}
