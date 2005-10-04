package org.reprap.comms.snap;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.comm.CommPortIdentifier;
import javax.comm.NoSuchPortException;
import javax.comm.PortInUseException;
import javax.comm.SerialPort;
import javax.comm.UnsupportedCommOperationException;

import org.reprap.Device;
import org.reprap.comms.Address;
import org.reprap.comms.Communicator;
import org.reprap.comms.IncomingContext;
import org.reprap.comms.IncomingMessage;
import org.reprap.comms.OutgoingMessage;

public class SNAPCommunicator implements Communicator {

	private SerialPort port;
	private OutputStream writeStream;
	private InputStream readStream;
	
	public SNAPCommunicator(String portName, int baudRate, Address localAddress)
	throws NoSuchPortException, PortInUseException, IOException, UnsupportedCommOperationException {
		CommPortIdentifier commId = CommPortIdentifier.getPortIdentifier(portName);
		port = (SerialPort)commId.open(portName, 30000);

		port.setSerialPortParams(baudRate,
				  SerialPort.DATABITS_8,
				  SerialPort.STOPBITS_1,
				  SerialPort.PARITY_NONE );
	    port.setFlowControlMode(SerialPort.FLOWCONTROL_NONE);

	    writeStream = port.getOutputStream();
	    readStream = port.getInputStream();
	}
	
	public void close()
	{
	  port.close();
	}
	
	public IncomingContext sendMessage(Device device,
			OutgoingMessage messageToSend) throws IOException {
		
		writeStream.write(messageToSend.getBinary());

		IncomingContext replyContext = messageToSend.getReplyContext(this,
				device);
		return replyContext;
	}

	public void ReceiveMessage(IncomingMessage message) throws IOException {
		// Here we collect one packet and notify the message
		// of its contents.  The message will respond
		// to indicate if it wants the message.  If not,
		// it will be discarded and we will wait for another
		// message.
		
		// Since this is a SNAP loop, we have to pass on
		// any packets that are not destined for us.
		
		// We will also only pass packed to the message if they are for
		// the local address.
		int c = readStream.read();
		System.out.println("Got read " + c);
	}
	
	// TODO Make an anonymous message receiver.  Use reflection? 

}
