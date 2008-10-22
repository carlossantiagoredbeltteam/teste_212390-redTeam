package org.reprap.comms;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.OutputStream;
import java.io.PrintStream;

import gnu.io.CommPortIdentifier;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import gnu.io.SerialPort;
import gnu.io.UnsupportedCommOperationException;

import org.reprap.utilities.Debug;
import org.reprap.utilities.ExtensionFileFilter;
import org.reprap.Preferences;

public class GCodeWriter
{
	
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
	 * This is used for file input
	 */
	private BufferedReader fileInStream;

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
	
	/**
	 * The transmission to the RepRap machine is handled by
	 * a separate thread.  These control that.
	 */
	private boolean threadLock = false;
	private Thread bufferThread;
	private int myPriority;
	
	/**
	 * Some commands (at the moment just M105 - get temperature) generate
	 * a response.  Return that as a string.
	 */
	private int responsesExpected = 0;
	private boolean responseAvailable = false;
	private String response;
	
	private boolean sendFileToMachine = false;
		
	public GCodeWriter()
	{
		
		ringBuffer = new String[buflen];
		head = 0;
		tail = 0;
		threadLock = false;
		threadKilled = false;
		responsesExpected = 0;
		responseAvailable = false;
		response = "0000";
		try
		{
			portName = Preferences.loadGlobalString("Port(name)");
		} catch (Exception ex)
		{
			portName = "stdout";
		}
		
		openSerialConnection(portName);
		
	    /*
         * If comms is direct, fork off a thread to send buffered commands to the RepRap
         */		
		myPriority = Thread.currentThread().getPriority();
		bufferThread = null;
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
	
	public void setSendFileToMachine(boolean sftm)
	{
		sendFileToMachine = sftm;
	}
	
	/**
	 * Start the production run
	 * (as opposed to driving the machine interactively).
	 */
	public void startRun()
	{
		/**
		 * Are we talking to the RepRap machine directly?
		 */
		boolean useSerialPort = false;
		
		try
		{
			useSerialPort = Preferences.loadGlobalBool("GCodeUseSerial") || sendFileToMachine;
		} catch (Exception ex)
		{
			portName = "stdout";
			useSerialPort = false;
		}
		
		if (useSerialPort)
		{
			if(sendFileToMachine)
				openFile();
		} else
			openFile();		
	}
	
	public void playFile()
	{
		String line;
		try 
		{
	        while ((line = fileInStream.readLine()) != null) 
	        {
	        	bufferQueue(line);
	        }
	        fileInStream.close();
	    } catch (IOException e) 
	    {  }
	}
	
	/**
	 * Wrapper for Thread.sleep()
	 * @param millis
	 */
	public void sleep(int millis)
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
	 * Anything in the buffer?  (NB this still works if we aren't
	 * using the buffer as then head == tail == 0 always).
	 * @return
	 */
	public boolean bufferEmpty()
	{
		return head == tail;
	}
	
	/**
	 * Between layers othing will be queued.  Use the next two
	 * functions to stop and start the buffer spinning.
	 *
	 */
	public void slowBufferThread()
	{
		if(bufferThread != null)
			bufferThread.setPriority(1);
	}
	
	public void speedBufferThread()
	{
		if(bufferThread != null)		
			bufferThread.setPriority(myPriority);
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
			while(threadLock) sleep(29);
			// Wait for something to be there to send
			while(head == tail)
			{
				// If nothing more is ever coming, finish
				if(threadKilled)
				{
					threadKilled = false;
					return;
				}
				sleep(211);
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
			// We are running at high priority - give others a look in
			//sleep(7);
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
				// We are running at high priority; give others a look in
				//sleep(5);
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
	 * Send a G-code command to the machine and return
	 * a response.
	 * @param cmd
	 */
	public String queueRespond(String cmd)
	{
		//trim it and cleanup.
		cmd = cmd.trim();
		cmd = cmd.replaceAll("  ", " ");
		
		if (printToFile)
		{
			System.err.println("GCodeWriter.queueRespond() called when file being created.");
			return "0000"; // Safest compromise
		}
		responsesExpected++;
		bufferQueue(cmd);
		if(responsesExpected <= 0)
		{
			System.err.println("GCodeWriter.getResponse() called when no response expected.");
			responsesExpected = 0;
			responseAvailable = false;
			return "0000";
		}
		while(!responseAvailable) sleep(31);
		responseAvailable = false;
		responsesExpected--;
		return response;		
	}
	

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
		if(!sendFileToMachine)
		{
			printToFile = true;
			Debug.c("Opening file for GCode output: " + filename);
		} else
			Debug.c("Opening file for GCode input: " + filename);
		
		if (filename.equals("stdout"))
		{
			sendFileToMachine = false;
			outStream = System.out;
		}else
		{
			try
			{
				Debug.c("opening: " + filename);
				if(sendFileToMachine)
				{
					fileInStream = new BufferedReader(new FileReader(filename));
				} else
				{
					FileOutputStream fileStream = new FileOutputStream(filename);
					outStream = new PrintStream(fileStream);
				}
			} catch (FileNotFoundException e) {
				Debug.c("File '" + filename + "' not found, printing to stdout");
				sendFileToMachine = false;
				outStream = System.out;
			}
		}
	}
	
	private void openFile()
	{
		JFileChooser chooser = new JFileChooser();
        FileFilter filter;
        if(sendFileToMachine)
        	filter = new ExtensionFileFilter("G Code for reading", new String[] { "gcode" });
        else
        	filter = new ExtensionFileFilter("G Code for writing", new String[] { "gcode" });
        chooser.setFileFilter(filter);
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
			sendFileToMachine = false;
			openFile("stdout");
		}
	}
}