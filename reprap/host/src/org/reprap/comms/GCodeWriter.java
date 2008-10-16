package org.reprap.comms;

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
	 * Are we talking to the RepRap machine directly?
	 */
	boolean useSerialPort = false;
	
	/**
	 * The name of the port talking to the RepRap machine
	 */
	String portName;
	
	/**
	* this is if we need to talk over serial
	*/
	private SerialPort port;
	
	/**
	 * Flag to tell it we've finished
	 */
	private boolean threadKilled = false;
	
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
	 * The ring buffer that stores the commands for direct
	 * transmission to the RepRap machine.
	 */
	private int head, tail;
	private static final int buflen = 100;
	private String[] ringBuffer;
	private boolean threadLock = false;
	private Thread bufferThread;
	private int responsesExpected = 0;
	private boolean responseAvailable = false;
	private String response;
	
//	/**
//	* our array of gcode commands
//	*/
//	private Vector commands;
//	
//	/**
//	* our pointer to the currently executing command
//	*/
//	private int currentCommand = 0;
//	
//	/**
//	* what was the last command we sent? (we may send commands faster than it can process)
//	*/
//	private int nextCommandToSend = 0;
//	
//	/**
//	* the size of the buffer on the GCode host
//	*/
//	private int maxBufferSize = 128;
//	
//	/**
//	* the amount of data we've sent and is in the buffer.
//	*/
//	private int bufferSize = 0;
//	
//	/**
//	* how many commands do we have in the buffer?
//	*/
//	private int bufferLength = 0;
//	
//	private String result = "";
//	
		
	public GCodeWriter()
	{
		//commands = new Vector();
		ringBuffer = new String[buflen];
		head = 0;
		tail = 0;
		threadLock = false;
		threadKilled = false;
		responsesExpected = 0;
		responseAvailable = false;
		response = "";
		try
		{
			portName = Preferences.loadGlobalString("Port(name)");
			useSerialPort = Preferences.loadGlobalBool("GCodeUseSerial");
		} catch (Exception ex)
		{
			portName = "stdout";
			useSerialPort = false;
		}
		if (useSerialPort)
			openSerialConnection(portName);
		else
			openFile();
		
        /*
         * If comms is direct, fork off a thread to send buffered commands to the RepRap
         */
		if(!printToFile)
		{
			bufferThread = new Thread() 
			{
				public void run() 
				{
					Thread.currentThread().setName("GCodeWriter() Buffer Thread");
					bufferDeQueue();
				}
			};

			bufferThread.start();
		}
	}
	
	/**
	 * Wrapper for Thread.sleep()
	 * @param millis
	 */
	private void sleep(int millis)
	{
		try
		{
			Thread.sleep(millis);
		} catch (Exception ex)
		{}		
	}
	
	/**
	 * All done.
	 *
	 */
	public void finish()
	{
		Debug.c("disposing of gcodewriter.");
		
		// Wait for the ring buffer to be exhausted
		if(!printToFile)
		{
			threadKilled = true;
			while(threadKilled)	sleep(200);
		}
		
		try
		{
			if (inStream != null)
				inStream.close();

			if (outStream != null)
				outStream.close();
		} catch (Exception e) {}
	}
	
	/**
	 * Queue a command into the ring buffer.  Note the use of prime time periods
	 * in the following code.  That's probably just superstition, but it feels more robust...
	 * @param cmd
	 */
	private void bufferQueue(String cmd)
	{
		// Are we locked out by the transmit thread?
		while(threadLock) sleep(211);
		// Lock out the transmit thread
		threadLock = true;
		// Next location in the ring
		head++;
		if(head >= buflen) head = 0;
		// Have we collided with the tail (i.e. is the ring full)?
		while(head == tail-1 || (tail == 0 && head == buflen-1))
		{
			// Release the lock so the transmit thread can get rid of stuff
			threadLock = false;
			sleep(223);
		}
		// Record the command in the buffer
		ringBuffer[head] = cmd;
		threadLock = false;
		Debug.c("G-code: " + cmd + " queued");
	}
	
	/**
	 * Loop getting the next thing in the buffer and transmitting it 
	 * (or waiting for something to send if there's nothing there).
	 *
	 */
	private void bufferDeQueue()
	{
		for(;;)
		{
			// Are we locked out by the queuing thread?
			while(threadLock) sleep(211);
			// Wait for something to be there to send
			while(head == tail)
			{
				// If nothing more is ever coming, finish
				if(threadKilled)
				{
					threadKilled = false;
					return;
				}
				sleep(29);
			}
			// Lock out the queuing thread
			threadLock = true;
			// Pick up the next command in the buffer
			tail++;
			if(tail >= buflen) tail = 0;
			// Strip any comment and send the command to the machine
			String cmd = ringBuffer[tail];
			int com = cmd.indexOf(';');
			if(com > 0)
				cmd = cmd.substring(0, com);
			if(com != 0)
			{
				cmd = cmd.trim();
				outStream.print(cmd + "\n");
				// Message has effectively gone to the machine, so we can release the queuing thread
				threadLock = false;				
				outStream.flush();
				Debug.c("G-code: " + cmd + " dequeued and sent");
				// Wait for the machine to respond before we send the next command
				waitForOK();
			} else
				Debug.c("G-code: " + ringBuffer[tail] + " not sent");
			// Just for safety
			threadLock = false;
		}
	}

	/**
	 * Wait for the GCode interpreter in the RepRap machine to send back "ok\n".
	 *
	 */
	private void waitForOK()
	{
		int i, count;
		String resp = "";
		count = 0;
		
		for(;;)
		{
			try
			{
				i = inStream.read();
			} catch (Exception e)
			{
				i = -1;
			}

			//anything found?
			if (i >= 0)
			{
				char c = (char)i;

				//is it at the end of the line?
				if (c == '\n' || c == '\r')
				{
					if (resp.startsWith("ok"))
					{
						Debug.c("GCode acknowledged");
						return;
					} else if (resp.startsWith("T:"))
					{
						Debug.c("GCodeWriter.waitForOK() - temperature reading: " + resp);
						if(responsesExpected > 0)
						{
							response = resp;
							responseAvailable = true;
						} else
							System.err.println("GCodeWriter.waitForOK(): temperature response returned when none expected.");
					} 
					else if (resp.startsWith("start") || resp.contentEquals(""))
					{	
						// That was the reset string from the machine or a null line; ignore it.
					}else
					{
						//Gone wrong.  Start again.
						Debug.c("GCodeWriter.waitForOK() dud response: " + resp);
						count++;
						if(count >= 3)
						{
							System.err.println("GCodeWriter.waitForOK(): try count exceeded.  Last line received was: " + resp);
							return;
						}
					}
					// If we get here we need a new string
					resp = "";
				} else
					resp += c;
			}
		}
	}
	
	/**
	 * Send a G-code command to the machine or into a file.
	 * @param cmd
	 */
	public void queue(String cmd)
	{
		//trim it and cleanup.
		cmd = cmd.trim();
		cmd = cmd.replaceAll("  ", " ");
		
		//add to list.
		//commands.add(cmd);
		
		if (printToFile)
		{
			outStream.println(cmd);
			Debug.c("G-code: " + cmd + " written to file");
		} else
			bufferQueue(cmd);
	}
	
	/**
	 * Send a G-code command to the machine and flag that
	 * a response is expected.
	 * @param cmd
	 */
	public void queueRespond(String cmd)
	{
		//trim it and cleanup.
		cmd = cmd.trim();
		cmd = cmd.replaceAll("  ", " ");
		
		if (printToFile)
		{
			System.err.println("GCodeWriter.queueRespond() called when file being created.");
			return;
		}
		responsesExpected++;
		bufferQueue(cmd);
	}
	
	/**
	 * This sleeps until the command's response is available
	 * @return
	 */
	public String getResponse()
	{
		if(printToFile || responsesExpected <= 0)
		{
			System.err.println("GCodeWriter.getResponse() called when no response expected.");
			responsesExpected = 0;
			responseAvailable = false;
			return "0000"; // Safest compromise
		}
		while(!responseAvailable) sleep(31);
		responseAvailable = false;
		responsesExpected--;
		return response;
	}
	
//	private void cleanSerialBuffer()
//	{
//		for (currentCommand = 0; currentCommand < commands.size(); currentCommand++)
//		{
//			String next = (String)commands.get(currentCommand);
//			String oldString = next;
//			
//			//strip comments
//			int commentIndex = next.indexOf(';');
//			if (commentIndex >= -1)
//				next = next.substring(0, commentIndex);
//			
//			//trim whitespace
//			next = next.trim();	
//			
//			//remove spaces
//			next = next.replaceAll(" ", "");
//			
//			//save it back.
//			commands.set(currentCommand, next);
//			
//			Debug.c(oldString + " converted to: " + next);
//		}
//	}
	
//	private void fillSerialBuffer()
//	{
//		cleanSerialBuffer();
//		
//		currentCommand = 0;
//		nextCommandToSend = 0;
//		
//		//keep trying until we send all commands.
//		while(nextCommandToSend < commands.size())
//		{
//			//check to see if we got a response.
//			readResponse();
//			
//			//whats our next command?
//			String next = (String)commands.get(nextCommandToSend);
//			
//			//skip empty commands.
//			if (next.length() == 0)
//			{
//				nextCommandToSend++;
//				continue;
//			}
//			
//			//will it fit into our buffer?
//			while (bufferSize + next.length() < maxBufferSize)
//			{
//				//send it a byte at a time.
//				for (int i=0; i<next.length(); i++)
//				{
//					outStream.write(next.charAt(i));
//					outStream.flush();
//										
//					//wait 5us between bytes.
//					try{
//						Thread.sleep(5);
//					} catch (Exception e){}
//				}
//
//				//newline is our delimiter.
//				outStream.write('\n');
//				outStream.flush();
//				
//				//wait between commands.
//				try{
//					Thread.sleep(5);
//				} catch (Exception e){}
//				
//				//record it in our buffer tracker.
//				nextCommandToSend++;
//
//				bufferSize += next.length() + 1;
//				bufferLength++;
//				
//				//debug... let us know whts up!
//				Debug.c("Sent: " + next);
//				Debug.c("Buffer: " + bufferSize + " (" + bufferLength + " commands)");
//				
//				if (nextCommandToSend == commands.size())
//					break;
//				
//				next = (String)commands.get(nextCommandToSend);
//			}
//		}
//	}
	
//	private void readResponse()
//	{
//		String cmd = "";
//		
//		//read for any results.
//		for (;;)
//		{
//			try
//			{
//				//read a byte.
//				int i = inStream.read();
//
//				//nothing found.
//				if (i == -1)
//					break;
//				else
//				{
//					//get it as ascii.
//					char c = (char)i;
//					result += c;
//				
//					//is it a done command?
//					if (c == '\n')
//					{
//						if (result.startsWith("ok"))
//						{
//							cmd = (String)commands.get(currentCommand);
//
//							if (result.length() > 2)
//								Debug.c("got: " + result.substring(0, result.length()-2) + "(" + bufferSize + " - " + (cmd.length() + 1) + " = " + (bufferSize - (cmd.length() + 1)) + ")");
//
//							bufferSize -= cmd.length() + 1;
//							bufferLength--;
//							
//							currentCommand++;
//							result = "";
//							
//							Debug.c("Buffer: " + bufferSize + " (" + bufferLength + " commands)");
//
//							//bail, buffer is almost empty.  fill it!
//							if (bufferLength < 2)
//								break;
//							
//							//we'll never get here.. for testing.
//							if (bufferLength == 0)
//								Debug.c("Empy buffer!! :(");
//						}
//						else if (result.startsWith("T:"))
//							Debug.c(result.substring(0, result.length()-2));
//						else
//							Debug.c(result.substring(0, result.length()-2));
//							
//						result = "";
//					}
//				}					
//			} catch (IOException e) {
//				break;
//			}
//		}	
//	}
	
	private void openSerialConnection(String portName)
	{
		printToFile = false;
		
		int baudRate = 19200;
		
		//open our port.
		Debug.c("GCode opening port " + portName);
		try 
		{
			CommPortIdentifier commId = CommPortIdentifier.getPortIdentifier(portName);
			port = (SerialPort)commId.open(portName, 30000);
		} catch (NoSuchPortException e) {
			System.err.println("Error opening port: " + portName);
			openFile("stdout");
			return;
		}
		catch (PortInUseException e){
			System.err.println("Port '" + portName + "' is already in use.");
			openFile("stdout");
			return;			
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
			Debug.c("An unsupported comms operation was encountered.");
			openFile("stdout");
			return;		
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
			Debug.c("Read timeouts unsupported on this platform");
		}

		//create our steams
		try {
			OutputStream writeStream = port.getOutputStream();
			inStream = port.getInputStream();
			outStream = new PrintStream(writeStream);
		} catch (IOException e) {
			Debug.c("Error opening serial port stream.");
			openFile("stdout");
			return;		
		}

		//arduino bootloader skip.
		Debug.c("Attempting to initialize Arduino");
        try {Thread.sleep(1000);} catch (Exception e) {}
        for(int i = 0; i < 10; i++)
                outStream.write('0');
        try {Thread.sleep(1000);} catch (Exception e) {}
	}
	
	private void openFile(String filename)
	{
		printToFile = true;
		
		Debug.c("Opening file for GCode output: " + filename);
		if (filename.equals("stdout"))
		{
			outStream = System.out;
		}
		else
		{
			try
			{
				Debug.c("opening: " + filename);
				
				FileOutputStream fileStream = new FileOutputStream(filename);
				outStream = new PrintStream(fileStream);
			} catch (FileNotFoundException e) {
				Debug.c("File '" + filename + "' not found, printing to stdout");
				outStream = System.out;
			}
		}
	}
	
	private void openFile()
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