package org.reprap.devices;

import java.io.IOException;
import org.reprap.utilities.Debug;
import org.reprap.Device;
import org.reprap.Printer;
import org.reprap.Preferences;
import org.reprap.AxisMotor;
import org.reprap.ReprapException;
import org.reprap.comms.Address;
import org.reprap.comms.Communicator;
import org.reprap.comms.IncomingContext;
import org.reprap.comms.OutgoingMessage;
import org.reprap.comms.IncomingMessage;
import org.reprap.comms.IncomingMessage.InvalidPayloadException;
import org.reprap.comms.messages.IncomingIntMessage;
import org.reprap.comms.messages.OutgoingAddressMessage;
import org.reprap.comms.messages.OutgoingBlankMessage;
import org.reprap.comms.messages.OutgoingByteMessage;
import org.reprap.comms.messages.OutgoingIntMessage;

public class NullStepperMotor implements AxisMotor {

	/**
	 * 
	 */
//	private boolean haveSetNotification = false;
//	private boolean haveCalibrated = false;
	
	
	/**
	 * Useful to know what we're called
	 */
	private String axis;
	
	
	/**
	 * 
	 */
	private int firmwareVersion = 0;
	
	private static final int firmwareVersionForBuffering = (1 << 8) + 4; // Version 1.4
	
	/**
	 * @param communicator
	 * @param address
	 * @param prefs
	 * @param motorId
	 */
	public NullStepperMotor(int motorId) {
			
		switch(motorId)
		{
		case 1:
			axis = "X";
			break;
		case 2:
			axis = "Y";
			break;
		case 3:
			axis = "Z";
			break;
		default:
			axis = "X";
			System.err.println("GenericStepperMotor - dud axis id: " + motorId);	
		}
		refreshPreferences();
	}

	public void refreshPreferences()
	{
		
	}
	
	/**
	 * Dispose of this object
	 */
	public void dispose() {
	}
	
	/**
	 * Is the comms working?
	 * @return
	 */
	public boolean isAvailable()
	{
		return true;
	}
	
	/**
	 * 
	 *
	 */
	public void waitTillNotBusy() throws IOException
	{
	}	
	
	/**
	 * Add an XY point to the firmware buffer for plotting
	 * Only works for recent firmware.
	 * 
	 * @param endX
	 * @param endY
	 * @param movementSpeed
	 * @return
	 */
	public boolean queuePoint(int endX, int endY, int movementSpeed) throws IOException 
	{

		return true;
	}
	
	/**
	 * Set the motor speed (or turn it off) 
	 * @param speed A value between -255 and 255.
	 * @throws ReprapException
	 * @throws IOException
	 */
	public void setSpeed(int speed) throws IOException {
	}

	/**
	 * @throws IOException
	 */
	public void setIdle() throws IOException {

	}
	
	/**
	 * @throws IOException
	 */
	public void stepForward() throws IOException {

	}
	
	/**
	 * @throws IOException
	 */
	public void stepBackward() throws IOException {

	}
	
	/**
	 * @throws IOException
	 */
	public void resetPosition() throws IOException {

	}
	
	/**
	 * @param position
	 * @throws IOException
	 */
	public void setPosition(int position) throws IOException {

	}
	
	/**
	 * @return current position of the motor
	 * @throws IOException
	 */
	public int getPosition() throws IOException {
		
		return 0;
	}
	
	/**
	 * @param speed
	 * @param position
	 * @throws IOException
	 */
	public void seek(int speed, int position) throws IOException {

	}

	/**
	 * @param speed
	 * @param position
	 * @throws IOException
	 */
	public void seekBlocking(int speed, int position) throws IOException {

	}

	/**
	 * @param speed
	 * @return range of the motor
	 * @throws IOException
	 * @throws InvalidPayloadException
	 */
	public Range getRange(int speed) throws IOException, InvalidPayloadException {
		return new AxisMotor.Range();
	}
	
	/**
	 * @param speed
	 * @throws IOException
	 * @throws InvalidPayloadException
	 */
	public void homeReset(int speed) throws IOException, InvalidPayloadException {

	}
	
	/**
	 * @param syncType
	 * @throws IOException
	 */
	public void setSync(byte syncType) throws IOException {

		
	}
	
	/**
	 * @param speed
	 * @param x1
	 * @param deltaY
	 * @throws IOException
	 */
	public void dda(int speed, int x1, int deltaY) throws IOException {

	}
	


	/**
	 * 
	 * @param maxTorque An integer value 0 to 100 representing the maximum torque percentage
	 * @throws IOException
	 */
	public void setMaxTorque(int maxTorque) throws IOException {

		
	}
	
}
