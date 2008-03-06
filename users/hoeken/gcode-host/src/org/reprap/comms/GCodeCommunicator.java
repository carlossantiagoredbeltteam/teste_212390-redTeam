package org.reprap.comms;

import java.util.*;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;

import gnu.io.CommPortIdentifier;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import gnu.io.SerialPort;
import gnu.io.UnsupportedCommOperationException;

import org.reprap.utilities.Debug;
import org.reprap.Preferences;

public class GCodeCommunicator
{
	/**
	* this is if we need to talk over serial
	*/
	private SerialPort port;
	
	/**
	* this is if we need to write to a file.
	*/
	private java.io.PrintStream file;

	/**
	* are we printing to a file, or serial?
	*/
	boolean printToFile = false;
	
	Vector commands;
	
	public GCodeCommunicator()
	{
		commands = new Vector();
	}
	
	public void queueCommand(String cmd)
	{
		commands.add(cmd);
	}
	
	public void openSerialConnection(String portName)
	{
		Debug.d("Opening port " + portName);
		CommPortIdentifier commId = CommPortIdentifier.getPortIdentifier(portName);
		port = (SerialPort)commId.open(portName, 30000);
		int baudRate = Preferences.loadGlobalInt("BaudRate");
		
		// Workround for javax.comm bug.
		// See http://forum.java.sun.com/thread.jspa?threadID=673793
		// FIXME: jvandewiel: is this workaround also needed when using the RXTX library?
		try {
			port.setSerialPortParams(baudRate,
					SerialPort.DATABITS_8,
					SerialPort.STOPBITS_1,
					SerialPort.PARITY_NONE);
		}
		catch (Exception e) {
			
		}
			 
		port.setSerialPortParams(baudRate,
				SerialPort.DATABITS_8,
				SerialPort.STOPBITS_1,
				SerialPort.PARITY_NONE);
		
		// End of workround
		
		try {
			port.setFlowControlMode(SerialPort.FLOWCONTROL_NONE);
		} catch (Exception e) {
			// Um, Linux USB ports don't do this. What can I do about it?
		}

		writeStream = port.getOutputStream();
		readStream = port.getInputStream();

		Debug.d("Attempting to initialize Arduino");
        try {Thread.sleep(1000);} catch (Exception e) {}
        for(int i = 0; i < 10; i++)
                writeStream.write('0');
        try {Thread.sleep(1000);} catch (Exception e) {}
	}
	
	public void openFile(String filename)
	{
		if (filename.equals("stdout"))
		{
			file = System.out;
		}
		else
		{
			try
			{
				OutputStream out = new FileOutputStream(filename);
				file = new PrintStream(out);
			} catch (FileNotFoundException e) {
				System.err.println("Problem with filename, printing to stdout");
				file = System.out;
			}
		}
	}
}