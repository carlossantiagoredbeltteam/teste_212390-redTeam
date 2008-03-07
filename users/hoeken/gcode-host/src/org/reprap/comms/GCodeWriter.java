package org.reprap.comms;

import java.util.*;

import javax.swing.JFileChooser;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;

import gnu.io.CommPortIdentifier;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import gnu.io.SerialPort;
import gnu.io.UnsupportedCommOperationException;

import org.reprap.utilities.Debug;
import org.reprap.Preferences;

public class GCodeWriter
{
	/**
	* this is if we need to talk over serial
	*/
	private SerialPort port;
	
	/**
	* this is for doing easy writes
	*/
	private PrintStream outStream;
	
	/**
	 * this is our read handle
	 */
	private InputStream inStream;

	/**
	* are we printing to a file, or serial?
	*/
	boolean printToFile = false;
	
	/**
	* our array of gcode commands
	*/
	Vector commands;
	
	/***********************************************************************
	* These will be used when we want to buffer commands to the arduino.
	************************************************************************/
	
	/**
	* our pointer to the currently executing command
	*/
	int currentCommand = 0;
	
	/**
	* what was the last command we sent? (we may send commands faster than it can process)
	*/
	int lastSentCommand = 0;
	
	/**
	* the size of the buffer on the GCode host
	*/
	int maxBufferSize = 256;
	
	/**
	* the amount of data we've sent and is in the buffer.
	*/
	int bufferSize = 0;
		
	public GCodeWriter()
	{
		commands = new Vector();
	}
	
	public void finish()
	{
		Debug.d("disposing of gcodewriter.");
		
		//outStream.flush();
		
		try
		{
			if (inStream != null)
				inStream.close();

			if (outStream != null)
				outStream.close();
		} catch (Exception e) {}
	}
	
	public void queue(String cmd)
	{
		//cmd = "N" + cmd.size().toString() + " " + cmd;
		commands.add(cmd);
		
		if (printToFile)
		{
			//not really needed, but why not.
			//currentCommand = cmd.size() - 1;
			//lastSentCommand = cmd.size() - 1;
			
			outStream.println(cmd);
		}
		else
		{
			//read until we get a 'done'
			
			//then send the new command.
			outStream.println(cmd);
		}
		
		//Debug.d(cmd);
		
		//make sure it gets written right now.
		//outStream.flush();
	}
	
	public void openSerialConnection(String portName)
	{
		int baudRate = 19200;
		
		//open our port.
		Debug.d("Opening port " + portName);
		try 
		{
			CommPortIdentifier commId = CommPortIdentifier.getPortIdentifier(portName);
			port = (SerialPort)commId.open(portName, 30000);
		} catch (NoSuchPortException e) {
			Debug.d("Error opening port: " + port);
		}
		catch (PortInUseException e){
			Debug.d("Port '" + port + "' is already in use.");
		}
		
		//get our baudrate
		try {
			baudRate = Preferences.loadGlobalInt("BaudRate");
		}
		catch (IOException e){}
		
		// Workround for javax.comm bug.
		// See http://forum.java.sun.com/thread.jspa?threadID=673793
		// FIXME: jvandewiel: is this workaround also needed when using the RXTX library?
		try {
			port.setSerialPortParams(baudRate,
					SerialPort.DATABITS_8,
					SerialPort.STOPBITS_1,
					SerialPort.PARITY_NONE);
		}
		catch (UnsupportedCommOperationException e) {
			Debug.d("An unsupported comms operation was encountered.");
		}

/*			 
		port.setSerialPortParams(baudRate,
				SerialPort.DATABITS_8,
				SerialPort.STOPBITS_1,
				SerialPort.PARITY_NONE);
*/		
		// End of workround
		
		try {
			port.setFlowControlMode(SerialPort.FLOWCONTROL_NONE);
		} catch (Exception e) {
			// Um, Linux USB ports don't do this. What can I do about it?
		}

		//create our steams
		try {
			OutputStream writeStream = port.getOutputStream();
			inStream = port.getInputStream();
			outStream = new PrintStream(writeStream);
		} catch (IOException e) {
			Debug.d("Error opening serial port stream.");
		}

		//arduino bootloader skip.
		Debug.d("Attempting to initialize Arduino");
        try {Thread.sleep(1000);} catch (Exception e) {}
        for(int i = 0; i < 10; i++)
                outStream.write('0');
        try {Thread.sleep(1000);} catch (Exception e) {}
	}
	
	public void openFile(String filename)
	{
		Debug.d("Opening file for GCode output: " + filename);
		if (filename.equals("stdout"))
		{
			outStream = System.out;
		}
		else
		{
			try
			{
				Debug.d("opening: " + filename);
				
				FileOutputStream fileStream = new FileOutputStream(filename);
				outStream = new PrintStream(fileStream);
			} catch (FileNotFoundException e) {
				Debug.d("File '" + filename + "' not found, printing to stdout");
				outStream = System.out;
			}
		}
	}
	
	public void openFile()
	{
		JFileChooser chooser = new JFileChooser();
		chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
		//chooser.setCurrentDirectory();

		int result = chooser.showSaveDialog(null);
		if (result == JFileChooser.APPROVE_OPTION)
		{
			String name = chooser.getSelectedFile().getAbsolutePath();
			openFile(name);
		}
		else
		{
			openFile("stdout");
		}
	}
}