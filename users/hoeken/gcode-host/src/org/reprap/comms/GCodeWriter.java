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
	private boolean printToFile = false;
	
	/**
	* our array of gcode commands
	*/
	private Vector commands;
	
	/**
	* our pointer to the currently executing command
	*/
	private int currentCommand = 0;
	
	/**
	* what was the last command we sent? (we may send commands faster than it can process)
	*/
	private int nextCommandToSend = 0;
	
	/**
	* the size of the buffer on the GCode host
	*/
	private int maxBufferSize = 128;
	
	/**
	* the amount of data we've sent and is in the buffer.
	*/
	private int bufferSize = 0;
	
	/**
	* how many commands do we have in the buffer?
	*/
	private int bufferLength = 0;
	
	private String result = "";
	
		
	public GCodeWriter()
	{
		commands = new Vector();
	}
	
	public void finish()
	{
		Debug.d("disposing of gcodewriter.");
		
		if (!printToFile)
		{
			Debug.d("Sending serial commands.");
			fillSerialBuffer();
		}
		
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
		//cmd = "N" + commands.size() + " " + cmd;
		commands.add(cmd);
		
		if (printToFile)
			outStream.println(cmd);
		
		Debug.d("Queued: " + cmd);
	}
	
	public void fillSerialBuffer()
	{
		//keep trying until we send all commands.
		while(nextCommandToSend < commands.size())
		{
			//check to see if we got a response.
			readResponse();
			
			//whats our next command?
			String next = (String)commands.get(nextCommandToSend);
			
			//will it fit into our buffer?
			while (bufferSize + next.length() < maxBufferSize)
			{
				//send it a byte at a time.
				for (int i=0; i<next.length(); i++)
				{
					outStream.write(next.charAt(i));
					outStream.flush();
										
					//wait 5us between bytes.
					try{
						Thread.sleep(5);
					} catch (Exception e){}
				}

				//newline is our delimiter.
				outStream.write('\n');
				outStream.flush();
				
				//wait between commands.
				try{
					Thread.sleep(5);
				} catch (Exception e){}
				
				//record it in our buffer tracker.
				nextCommandToSend++;

				bufferSize += next.length() + 1;
				bufferLength++;
				
				//debug... let us know whts up!
				Debug.c("Sent: " + next);
				Debug.d("Buffer: " + bufferSize + " (" + bufferLength + " commands)");
				
				if (nextCommandToSend == commands.size())
					break;
				
				next = (String)commands.get(nextCommandToSend);
			}
		}
	}
	
	public void readResponse()
	{
		String cmd = "";
		
		//read for any results.
		for (;;)
		{
			try
			{
				//read a byte.
				int i = inStream.read();

				//nothing found.
				if (i == -1)
					break;
				else
				{
					//get it as ascii.
					char c = (char)i;
					result += c;
				
					//is it a done command?
					if (c == '\n')
					{
						if (result.startsWith("ok"))
						{
							cmd = (String)commands.get(currentCommand);

							Debug.c(result.substring(0, result.length()-2) + "(" + bufferSize + " - " + (cmd.length() + 1) + " = " + (bufferSize - (cmd.length() + 1)) + ")");

							bufferSize -= cmd.length() + 1;
							bufferLength--;
							
							currentCommand++;
							result = "";
							
							Debug.d("Buffer: " + bufferSize + " (" + bufferLength + " commands)");

							//bail, buffer is almost empty.  fill it!
							if (bufferLength < 2)
								break;
							
							//we'll never get here.. for testing.
							if (bufferLength == 0)
								Debug.d("Empy buffer!! :(");
						}
						else if (result.startsWith("T:"))
							Debug.d(result.substring(0, result.length()-2));
						else
							Debug.c(result.substring(0, result.length()-2));
							
						result = "";
					}
				}					
			} catch (IOException e) {
				break;
			}
		}	
	}
	
	public void openSerialConnection(String portName)
	{
		printToFile = false;
		
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
		
		try {
			port.enableReceiveTimeout(1);
		} catch (UnsupportedCommOperationException e) {
			Debug.d("Read timeouts unsupported on this platform");
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
		printToFile = true;
		
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