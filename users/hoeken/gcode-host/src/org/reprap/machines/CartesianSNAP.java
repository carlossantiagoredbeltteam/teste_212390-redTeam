package org.reprap.machines;

import java.io.IOException;

import org.reprap.comms.Communicator;
import org.reprap.comms.snap.SNAPAddress;
import org.reprap.comms.snap.SNAPCommunicator;
import org.reprap.devices.SNAPExtruder;
import org.reprap.devices.GenericStepperMotor;
import org.reprap.devices.pseudo.LinePrinter;
import org.reprap.gui.CalibrateZAxis;

import org.reprap.Attributes;
import org.reprap.CartesianPrinter;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.gui.Previewer;
import org.reprap.Extruder;
import org.reprap.utilities.Debug;


/**
 * 
 * A Reprap printer is a 3-D cartesian printer with one or more
 * extruders
 *
 */
public class CartesianSNAP extends GenericCartesianPrinter {
	
	/**
	 * 
	 */
	private final int localNodeNumber = 0;
	
	/**
	 * comms speed
	 */
	
	/**
	 * 
	 */
	private Communicator communicator;

	/**
	 * Stepper motors for the 3 axis 
	 */
	private GenericStepperMotor motorX;
	private GenericStepperMotor motorY;
	private GenericStepperMotor motorZ;

	/**
	 * 
	 */
	private LinePrinter layerPrinter;
	
	/**
	 * Initial default speed
	 */
	private int currentSpeedXY = 200;
	
	/**
	 * 
	 */
	private int fastSpeedXY = 230;
	
	/**
	 * Initial default speed
	 */
	private int speedZ = 230;
	
	/**
	 * Don't perform Z operations.  
	 * FIXME: Should be removed later.
	 */
	private boolean excludeZ = false;
	
	/**
	 * @param prefs
	 * @throws Exception
	 */
	public CartesianSNAP(Preferences prefs) throws Exception {
		
		super(prefs);
		
		String commPortName = prefs.loadString("Port(name)");
		
		SNAPAddress myAddress = new SNAPAddress(localNodeNumber); 
		communicator = new SNAPCommunicator(commPortName, myAddress);
		
		motorX = new GenericStepperMotor(communicator,
				new SNAPAddress(prefs.loadInt("XAxisAddress")), prefs, 1);
		motorY = new GenericStepperMotor(communicator,
				new SNAPAddress(prefs.loadInt("YAxisAddress")), prefs, 2);
		motorZ = new GenericStepperMotor(communicator,
				new SNAPAddress(prefs.loadInt("ZAxisAddress")), prefs, 3);
		
		layerPrinter = new LinePrinter(motorX, motorY, extruders[extruder]);
	
		idleZ = prefs.loadBool("IdleZAxis");
		fastSpeedXY = prefs.loadInt("FastSpeed(0..255)");
		
		try {
			currentX = convertToPositionZ(motorX.getPosition());
			currentY = convertToPositionZ(motorY.getPosition());
		} catch (Exception ex) {
			throw new Exception("Warning: X and/or Y controller not responding, cannot continue");
		}
		try {
			currentZ = convertToPositionZ(motorZ.getPosition());
		} catch (Exception ex) {
			System.err.println("Z axis not responding and will be ignored");
			excludeZ = true;
		}
	}
	
	public void loadExtruders(Preferences config)
	{
		extruders = new SNAPExtruder[extruderCount];
		
		super.loadExtruders(config);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#moveTo(double, double, double, boolean, boolean)
	 */
	public void moveTo(double x, double y, double z, boolean startUp, boolean endUp) throws ReprapException, IOException {
		
		if (isCancelled()) return;
		
		int stepperX = convertToStepX(x);
		int stepperY = convertToStepY(y);
		int stepperZ = convertToStepZ(z);
		int currentStepperX = convertToStepX(currentX);
		int currentStepperY = convertToStepY(currentY);
		int currentStepperZ = convertToStepZ(currentZ);		
		
		if (currentStepperX == stepperX && 
				currentStepperY ==stepperY && 
				currentStepperZ == stepperZ && 
				!startUp)
			return;

		// We don't need to lift a whole layer up. Half a layer should do
		// and will dribble less. Remember the Z axis is kinda slow...
		double liftedZ = z + (extruders[extruder].getExtrusionHeight()/2);
		int stepperLiftedZ = convertToStepZ(liftedZ);
		int targetZ;
		
		// Raise head slightly before move?
		if(startUp)
		{
			targetZ = stepperLiftedZ;
			currentZ = liftedZ;
		} else
		{
			targetZ = stepperZ;
			currentZ = z;
		}
		
		if (targetZ != currentStepperZ) {
			totalDistanceMoved += Math.abs(currentZ - liftedZ);
			if (!excludeZ) motorZ.seekBlocking(speedZ, targetZ);
			if (idleZ) motorZ.setIdle();
			currentStepperZ = targetZ;
		}
		
		layerPrinter.moveTo(stepperX, stepperY, currentSpeedXY);
		totalDistanceMoved += segmentLength(x - currentX, y - currentY);
		currentX = x;
		currentY = y;
		
		if(endUp)
		{
			targetZ = stepperLiftedZ;
			currentZ = liftedZ;
		} else
		{
			targetZ = stepperZ;
			currentZ = z;
		}
		
		// Move head back down to surface?
		if(targetZ != currentStepperZ)
		{
			totalDistanceMoved += Math.abs(currentZ - z);
			if (!excludeZ) motorZ.seekBlocking(speedZ, targetZ);
			if (idleZ) motorZ.setIdle();
			currentStepperZ = targetZ;
		} 
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#printTo(double, double, double, boolean)
	 */
	public void printTo(double x, double y, double z, boolean turnOff) 
		throws ReprapException, IOException {
		if (isCancelled()) return;
		EnsureNotEmpty();
		if (isCancelled()) return;
		EnsureHot();
		if (isCancelled()) return;

		int stepperX = convertToStepX(x);
		int stepperY = convertToStepY(y);
		int stepperZ = convertToStepZ(z);
		
		if ((stepperX != layerPrinter.getCurrentX() || stepperY != layerPrinter.getCurrentY()) && z != currentZ)
			throw new ReprapException("Reprap cannot print a line across 3 axes simultaneously");

		if (previewer != null)
			previewer.addSegment(convertToPositionX(layerPrinter.getCurrentX()),
					convertToPositionY(layerPrinter.getCurrentY()), currentZ,
					x, y, z);

		if (isCancelled()) return;
		
		
		if (z != currentZ) 
		{
			// Print a simple vertical extrusion
			double distance = Math.abs(currentZ - z);
			totalDistanceExtruded += distance;
			totalDistanceMoved += distance;
			extruders[extruder].setExtrusion(extruders[extruder].getExtruderSpeed());
			if (!excludeZ) motorZ.seekBlocking(speedZ, stepperZ);
			extruders[extruder].setExtrusion(0);
			currentZ = z;
			return;
		}

		// Otherwise printing only in X/Y plane
		double deltaX = x - currentX;
		double deltaY = y - currentY;
		double distance = segmentLength(deltaX, deltaY);
		totalDistanceExtruded += distance;
		totalDistanceMoved += distance;
		layerPrinter.printTo(stepperX, stepperY, currentSpeedXY, extruders[extruder].getExtruderSpeed(), turnOff);
		currentX = x;
		currentY = y;
	}
	
	public void stopExtruding() throws IOException
	{
		layerPrinter.stopExtruding();
	}

	/* Move to zero stop on X axis.
	 * (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX() 
	 */
	public void homeToZeroX() throws ReprapException, IOException {
		motorX.homeReset(fastSpeedXY);
		currentX=0;
	}
	
	/* Move to zero stop on Y axis.
	 * (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {
		motorY.homeReset(fastSpeedXY);
		currentY=0;
	}
	



	/* (non-Javadoc)
	 * @see org.reprap.Printer#terminate()
	 */
	public void terminate() throws Exception {
		motorX.setIdle();
		motorY.setIdle();
		
		if (!excludeZ)
			motorZ.setIdle();
			
		extruders[extruder].setExtrusion(0);
		extruders[extruder].setTemperature(0);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#dispose()
	 */
	public void dispose()
	{
		motorX.dispose();
		motorY.dispose();
		motorZ.dispose();

		//todo: move to cartesian bot
		for(int i = 0; i < extruderCount; i++)
			extruders[i].dispose();
			
		communicator.close();
		communicator.dispose();
	}

	/**
	 * @return Returns the speed for the X & Y axes.
	 */
//	public int getSpeed() {
//		return currentSpeedXY;
//	}
	
	/**
	 * @return Returns the maximum speed for the X & Y axes in air movement.
	 */
	public int getFastSpeed() {
		return fastSpeedXY;
	}	
	
	/**
	 * @param speed The speed to set for the X and Y axes.
	 */
	public void setSpeed(int speed) {
		currentSpeedXY = speed;
	}
	
	/**
	 * @param speed The speed to set for the X and Y axes moving in air.
	 */
	public void setFastSpeed(int speed) {
		this.fastSpeedXY = speed;
	}

	/**
	 * @return Returns the speed for the Z axis.
	 */
	public int getSpeedZ() {
		return speedZ;
	}
	/**
	 * @param speed The speed to set for the Z axis.
	 */
	public void setSpeedZ(int speed) {
		this.speedZ = speed;
	}

	/**
	 * Returns the speedExtruder.
	 */
//	public int getExtruderSpeed() {
//		return speedExtruder;
//	}
	/**
	 * The speedExtruder to set.
	 */
//	public void setExtruderSpeed(int speedExtruder) {
//		this.speedExtruder = speedExtruder;
//	}
	
//	public void setTemperature(int temperature) throws Exception {
//		extruder.setTemperature(temperature);
//	}
	
	/**
	 * outline speed and the infill speed
	 */
//	public double getOutlineSpeed()
//	{
//		return extruder.getOutlineSpeed();
//	}
//	public double getInfillSpeed()
//	{
//		return extruder.getInfillSpeed();
//	}
	
	/**
	 * The length in mm to speed up when going round corners
	 */
//	public double getAngleSpeedUpLength()
//	{
//		return extruder.getAngleSpeedUpLength();
//	}
	
	/**
	 * The factor by which to speed up when going round a corner.
	 * The formula is speed = baseSpeed*[1 + 0.5*(1 - ca)*getAngleSpeedFactor()]
	 * where ca is the cos of the angle between the lines.  So it goes fastest when
	 * the line doubles back on itself, and slowest when it continues straight.
	 */	
//	public double getAngleSpeedFactor()
//	{
//		return extruder.getAngleSpeedFactor();
//	}

	/**
	 * 
	 */
	private void EnsureNotEmpty() {
		if (!extruders[extruder].isEmpty()) return;
		
		while (extruders[extruder].isEmpty() && !isCancelled()) {
			if (previewer != null)
				previewer.setMessage("Extruder is out of feedstock.  Waiting for refill.");
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
			}
		}
		if (previewer != null) previewer.setMessage(null);
	}
	
	/**
	 * @throws ReprapException
	 * @throws IOException
	 */
	private void EnsureHot() throws ReprapException, IOException {
		if(extruders[extruder].getTemperatureTarget() <= Preferences.absoluteZero() + 1)
			return;
		
		double threshold = extruders[extruder].getTemperatureTarget() * 0.90;	// Changed from 0.95 by Vik.
		
		if (extruders[extruder].getTemperature() >= threshold)
			return;
		

		double x = currentX;
		double y = currentY;
		int tempReminder=0;
		temperatureReminder();
		Debug.d("Moving to heating zone");
		int oldSpeed = currentSpeedXY;
		
		// Ensure the extruder is off
		
		extruders[extruder].setExtrusion(0);
				
		moveToHeatingZone();
		while(extruders[extruder].getTemperature() < threshold && !isCancelled()) {
			if (previewer != null) previewer.setMessage("Waiting for extruder to reach working temperature (" + 
					Math.round(extruders[extruder].getTemperature()) + ")");
			try {
				Thread.sleep(1000);
				// If it stays cold for 10s, remind it of its purpose.
				if (tempReminder++ >10) {
					tempReminder=0;
					temperatureReminder();
				}
			} catch (InterruptedException e) {
			}
		}
		Debug.d("Returning to previous position");
		moveTo(x, y, currentZ, true, false);
		setSpeed(oldSpeed);
		if (previewer != null) previewer.setMessage(null);
		
	}

	/** A bodge to fix the extruder's current tendency to forget what temperature
	 * it is supposed to be reaching.
	 * 
	 * Vik
	 */
	private void temperatureReminder() {
		if(extruders[extruder].getTemperatureTarget() < Preferences.absoluteZero())
			return;
		Debug.d("Reminding it of the temperature");
		try {
			extruders[extruder].setTemperature(extruders[extruder].getTemperatureTarget());
			//setTemperature(Preferences.loadGlobalInt("ExtrusionTemp"));
		} catch (Exception e) {
			System.err.println("Error resetting temperature.");
		}
	}
	
	/**
	 * Moves the head to the predefined heating area
	 * @throws IOException
	 * @throws ReprapException
	 */
	private void moveToHeatingZone() throws ReprapException, IOException {
		setSpeed(fastSpeedXY);
		moveTo(5, 5, currentZ, true, false);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#isCancelled()
	 */
	public boolean isCancelled() {
		if (previewer == null)
			return false;
		return previewer.isCancelled();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#initialise()
	 */
	public void initialise() throws Exception {
		super.initialise();
	}
	
	public void home()
	{
		try
		{
			motorX.homeReset(fastSpeedXY);
			motorY.homeReset(fastSpeedXY);
		
			if (!excludeZ)
				motorZ.homeReset(speedZ);

			super.home();
		} catch (Exception e) {
			Debug.d("Error homing");
		}
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setZManual()
	 */
	public void setZManual() throws IOException {
		setZManual(0.0);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setZManual(double)
	 */
	public void setZManual(double zeroPoint) throws IOException {
		
		CalibrateZAxis msg =
			new CalibrateZAxis(null, motorZ, scaleZ, speedZ);
		msg.setVisible(true);
		try {
			synchronized(msg) {
				msg.wait();
			}
		} catch (Exception ex) {
		}
		msg.dispose();
		
		motorZ.setPosition(convertToStepZ(zeroPoint));
	}

}
