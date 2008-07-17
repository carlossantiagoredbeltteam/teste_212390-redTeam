package org.reprap.devices;

import java.io.IOException;
import org.reprap.utilities.Debug;
import org.reprap.Device;
import org.reprap.Printer;
import org.reprap.Preferences;
import org.reprap.AxisMotor;
import org.reprap.ReprapException;
import org.reprap.devices.GenericStepperMotor;

public class GCodeStepperMotor extends GenericStepperMotor {

	/**
	 * @param motorId
	 */
	public GCodeStepperMotor(int motorId) {
		super(null, motorId);
	}

	/**
	 * Is the comms working?
	 * @return
	 */
	public boolean isAvailable()
	{
		return false;
	}
}
