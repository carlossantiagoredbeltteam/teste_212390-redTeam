package org.reprap.machines;

import java.io.IOException;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JFrame;
import javax.media.j3d.*;

import org.reprap.Attributes;
import org.reprap.CartesianPrinter;
import org.reprap.Preferences;
import org.reprap.Extruder;
import org.reprap.AxisMotor;
import org.reprap.devices.NullStepperMotor;
import org.reprap.ReprapException;
import org.reprap.gui.*;
import org.reprap.devices.NullExtruder;
import org.reprap.devices.GenericStepperMotor;

/**
 *
 */
public class NullCartesianMachine extends GenericCartesianPrinter {
	
	/**
	 * @param config
	 */
	public NullCartesianMachine() throws Exception {
		super();
	}
	
	public Extruder extruderFactory(int count)
	{
		return new NullExtruder(count);
	}
	
	public void waitTillNotBusy() throws IOException {}
	public void finishedLayer(int layerNumber) throws Exception {}
	public void betweenLayers(int layerNumber) throws Exception{}
	public void startingLayer(int layerNumber) throws Exception {}
	public void printTo(double x, double y, double z, boolean stopExtruder, boolean closeValve) {}
	public void delay(long millis) {}
	
	//TODO: make this work normally.
	public void stopValve() throws IOException
	{
	}
	
	//TODO: make this work normally.
	public void stopMotor() throws IOException
	{
	}
}
