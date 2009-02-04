/*
  Sanguino3GDriver.java

  This is a driver to control a machine that uses the Sanguino with 3rd Generation Electronics.

  Part of the ReplicatorG project - http://www.replicat.org
  Copyright (c) 2008 Zach Smith

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Vector;

import javax.vecmath.Point3d;

import processing.serial.*;

public class Sanguino3GDriver
{
    /**
     * An enumeration of the available command codes for the three-axis
     * CNC stage.
     */
    class CommandCodesMaster {
		public final static int GET_VERSION     =   0;
		public final static int INIT            =   1;
		public final static int GET_AVAIL_BUF   =   2;
		public final static int CLEAR_BUF       =   3;
		public final static int GET_POS         =   4;
		public final static int GET_RANGE       =   5;
		public final static int SET_RANGE       =   6;
		public final static int ABORT           =   7;
		public final static int PAUSE           =   8;
		public final static int PROBE           =   9;
		public final static int TOOL_QUERY      =  10;
		
		public final static int QUEUE_POINT_INC = 128;
		public final static int QUEUE_POINT_ABS = 129;
		public final static int SET_POS         = 130;
		public final static int FIND_MINS       = 131;
		public final static int FIND_MAXS       = 132;
		public final static int DELAY           = 133;
		public final static int CHANGE_TOOL     = 134;
		public final static int WAIT_FOR_TOOL   = 135;
		public final static int TOOL_COMMAND    = 136;
    };

    /**
     * An enumeration of the available command codes for a tool.
     */
    class CommandCodesSlave {
		public final static int GET_VERSION     =   0;
		public final static int INIT            =   1;
		public final static int GET_TEMPERATURE =   2;
		public final static int SET_TEMPERATURE =   3;
		public final static int SET_MOTOR_1_PWM =   4;
		public final static int SET_MOTOR_2_PWM =   5;
		public final static int SET_MOTOR_1_RPM =   6;
		public final static int SET_MOTOR_2_RPM =   7;
		public final static int SET_MOTOR_1_DIR =   8;
		public final static int SET_MOTOR_2_DIR =   9;
		public final static int TOGGLE_MOTOR_1  =  10;
		public final static int TOGGLE_MOTOR_2  =  11;
		public final static int TOGGLE_FAN      =  12;
		public final static int TOGGLE_VALVE    =  13;
		public final static int SET_SERVO_1_POS =  14;
		public final static int SET_SERVO_2_POS =  15;
		public final static int FILAMENT_STATUS =  16;
		public final static int GET_MOTOR_1_RPM =  17;
		public final static int GET_MOTOR_2_RPM =  18;
		public final static int GET_MOTOR_1_PWM =  19;
		public final static int GET_MOTOR_2_PWM =  20;
		public final static int ABORT           =  21;
		public final static int PAUSE           =  22;
    };


    /** The start byte that opens every packet. */
    private final byte START_BYTE = (byte)0xD5;

    /** The response codes at the start of every response packet. */
    class ResponseCode {
		final static int GENERIC_ERROR   = 0;
		final static int OK              = 1;
		final static int BUFFER_OVERFLOW = 2;
		final static int CRC_MISMATCH    = 3;
		final static int QUERY_OVERFLOW  = 4;
		final static int UNSUPPORTED     = 5;
    };

    /**
     * An object representing the serial connection.
     */
    public Serial serial;
    
    /**
     * Serial connection parameters
     **/
    String name;
    int    rate;
    char   parity;
    int    databits;
    float  stopbits;

    private int debugLevel = 2;

    private boolean isInitialized = false;
    
    /**
     * This is a Java implementation of the IButton/Maxim 8-bit CRC.
     * Code ported from the AVR-libc implementation, which is used
     * on the RR3G end.
     */
    protected class IButtonCrc {

		private int crc = 0;

		/**
		 * Construct a new, initialized object for keeping track of a CRC.
		 */
		public IButtonCrc() {
		    crc = 0;
		}

		/**
		 * Update the  CRC with a new byte of sequential data.
		 * See include/util/crc16.h in the avr-libc project for a 
		 * full explanation of the algorithm.
		 * @param data a byte of new data to be added to the crc.
		 */
		public void update(byte data) {
		    crc = (crc ^ data)&0xff; // i loathe java's promotion rules
		    for (int i=0; i<8; i++) {
			if ((crc & 0x01) != 0) {
			    crc = ((crc >>> 1) ^ 0x8c)&0xff;
			} else {
			    crc = (crc >>> 1)&0xff;
			}
		    }
		}

		/**
		 * Get the 8-bit crc value.
		 */
		public byte getCrc() {
		    return (byte)crc;
		}

		/**
		 * Reset the crc.
		 */
		public void reset() {
		    crc = 0;
		}
    }

    /**
     * A class for building a new packet to send down the wire to the
     * Sanguino3G.
     */
    class PacketBuilder {
		// yay magic numbers.
		byte[] data = new byte[256];
		// current end of packet.  Bytes 0 and 1 are reserved for start byte
		// and packet payload length.
		int idx = 2; 
		IButtonCrc crc = new IButtonCrc();

		/**
		 * Start building a new command packet.
		 * @param target the target identifier for this packet.
		 * @param command the command identifier for this packet.
		 */
		PacketBuilder(int command)
		{
			idx = 2;
		    data[0] = START_BYTE;
			//data[1] = length;  // just to avoid confusion
		    add8((byte)command);
		}

		/**
		 * Add an 8-bit value to the end of the packet payload.
		 * @param v the value to append.
		 */
		void add8( int v ) {
		    data[idx++] =  (byte)v;
		    crc.update((byte)v);
		}

		/**
		 * Add a 16-bit value to the end of the packet payload.
		 * @param v the value to append.
		 */
		void add16( int v ) {
		    add8((byte)(v & 0xff));
		    add8((byte)((v >> 8) & 0xff));
		}

		/**
		 * Add a 32-bit value to the end of the packet payload.
		 * @param v the value to append. Must be long to support unsigned ints.
		 */
		void add32( long v ) {
		    add16((int)(v & 0xffff));
		    add16((int)((v >> 16) & 0xffff));
		}

		/**
		 * Complete the packet.
		 * @return a byte array representing the completed packet.
		 */
		byte[] getPacket() {
		    data[idx] = crc.getCrc();
		    data[1] = (byte)(idx-2); // len does not count packet header
		    byte[] rv = new byte[idx+1];
		    System.arraycopy(data,0,rv,0,idx+1);
		    return rv;
		}
    };

    /**
     * A class for keeping track of the state of an incoming packet and
     * storing its payload.
     */
    class PacketProcessor {
		final static byte PS_START = 0;
		final static byte PS_LEN = 1;
		final static byte PS_PAYLOAD = 2;
		final static byte PS_CRC = 3;
		final static byte PS_LAST = 4;

		byte packetState = PS_START;
		int payloadLength = -1;
		int payloadIdx = 0;
		byte[] payload;
		byte targetCrc = 0;
		IButtonCrc crc;

		/**
		 * Reset the packet's state.  (The crc is (re-)generated on the length byte
		 * and thus doesn't need to be reset.(
		 */
		public void reset() {
		    packetState = PS_START;
		}

		/**
		 * Create a PacketResponse object that contains this packet's payload.
		 * @return A valid PacketResponse object
		 */
		public PacketResponse getResponse()
		{
			PacketResponse pr = new PacketResponse(payload);
			
			if (debugLevel >= 2)
				pr.printDebug();
				
			return pr;
		}

        /**
         * Process the next byte in an incoming packet.
         * @return true if the packet is complete and valid; false otherwise.
         */
        public boolean processByte(byte b)
        {
            
            if (debugLevel >= 2) {
                System.out.print(Integer.toHexString((int)b&0xff) + " ");
            }
            
            
            switch (packetState) {
            case PS_START:
                if (debugLevel >= 3)
                    System.out.println("Start byte?");
                
                if (b == START_BYTE) {
                    packetState = PS_LEN;
                } else {
                    // throw exception?
                }
                break;
		
            case PS_LEN:
                if (debugLevel >= 3)
                    System.out.println("Length: " + (int)b);
                
                payloadLength = ((int)b) & 0xFF;
                payload = new byte[payloadLength];
                crc = new IButtonCrc();
                packetState = PS_PAYLOAD;
                break;
		
            case PS_PAYLOAD:
                if (debugLevel >= 3)
                    System.out.println("payload.");
                
                // sanity check
                if (payloadIdx < payloadLength) {
                    payload[payloadIdx++] = b;
                    crc.update(b);
                }
                if (payloadIdx >= payloadLength) {
                    packetState = PS_CRC;
                }
                break;
		
            case PS_CRC:
                targetCrc = b;
                
                if (debugLevel >= 3) {
                    System.out.println("Target CRC: " + Integer.toHexString( (int)targetCrc&0xff ) +
                                       " - expected CRC: " + Integer.toHexString( (int)crc.getCrc()&0xff ));
                }

                if (crc.getCrc() != targetCrc) {
                    throw new java.lang.RuntimeException("CRC mismatch on reply");
                }
                return true;
            }
            return false;
        }
    }
    
    /**
     * Packet response wrapper, with convenience functions for 
     * reading off values in sequence and retrieving the response
     * code.
     */
    class PacketResponse {
		
		byte[] payload;
		int readPoint = 1;
		
		public PacketResponse(byte[] p) {
		    payload = p;
		}
		
		/**
		 * Prints a debug message with the packet response code decoded, along wiith the
		 * packet's contents in hex.
		 */
		public void printDebug() {
		    String msg = "Unknown";
		    switch(payload[0]) {
			    case ResponseCode.GENERIC_ERROR:
					msg = "Generic Error";
					break;
				
			    case ResponseCode.OK:
					msg = "OK";
					break;
			    
				case ResponseCode.BUFFER_OVERFLOW:
					msg = "Buffer overflow";
					break;
			    
				case ResponseCode.CRC_MISMATCH:
					msg = "CRC mismatch";
					break;
			    
				case ResponseCode.QUERY_OVERFLOW:
					msg = "Query overflow";
					break;
					
				case ResponseCode.UNSUPPORTED:
					msg = "Unsupported command";
					break;
		    }
		    System.out.println("Packet response code: " + msg);
		    System.out.print("Packet payload: ");
		    for (int i = 1; i < payload.length; i++) {
				System.out.print(Integer.toHexString(payload[i]&0xff) + " ");
		    }
		    System.out.print("\n");
		}

		/**
		 * Retrieve the packet payload.
		 * @return an array of bytes representing the payload.
		 */
		public byte[] getPayload() {
		    return payload;
		}

		/**
		 * Get the next 8-bit value from the packet payload.
		 */
		int get8() {
			if (payload.length > readPoint)
		    	return ((int)payload[readPoint++])&0xff;
			else
			{
				System.out.println("Error: payload not big enough.");
				return 0;
			}
		}
		/**
		 * Get the next 16-bit value from the packet payload.
		 */
		int get16() {
		    return get8() + (get8()<<8);
		}
		/**
		 * Get the next 32-bit value from the packet payload.
		 */
		int get32() {
		    return get16() + (get16()<<16);
		}

		/**
		 * Does the response code indicate that the command was successful?
		 */
		public boolean isOK() { 
		    return payload[0] == ResponseCode.OK;
		}
    };

    public Sanguino3GDriver()
    {
    }
	
    public void setInitialized(boolean status)
    {
        isInitialized = status;
    }
    
    public boolean isInitialized()
    {
        return isInitialized;
    }
	
    public void initialize(PApplet parent)
    {
        // List all the available serial ports
        println(Serial.list());
        //open the first port...
        this.serial = new Serial(parent, Serial.list()[0], 38400);
 
	//wait till we're initialized
        if (!isInitialized()) {
            // attempt to send version command and retrieve reply.
            try {
                //read our string that means we're started up.
                waitForStartup();
                
                //okay, take care of version info /etc.
                getVersion(2);
                sendInit();
                setInitialized(true);
                System.out.println("Ready to rock.");
            } catch (Exception e) {
                //todo: handle init exceptions here
                System.out.println("yarg! " + e.getMessage());
            }
        }        
    }

    protected void waitForStartup()
    {
        assert (serial != null);
        synchronized(serial) {
	    String cmd = "";
            byte[] responsebuffer = new byte[512];
            String result = "";

            while (!isInitialized()) {
                try {
                    int numread = serial.input.read(responsebuffer);
                    assert (numread != 0); // This should never happen since we know we have a buffer
                    if (numread < 0) {
		        // This signifies EOF. FIXME: How do we handle this?
                        System.out.println("RepRap3GDriver.readResponse(): EOF occured");
		        return;
                    }
                    else {
		        result += new String(responsebuffer , 0, numread, "US-ASCII");

		        int index;
		        while ((index = result.indexOf('\n')) >= 0) {
                            String line = result.substring(0, index).trim(); // trim to remove any trailing \r
                            result = result.substring(index+1);
                            if (line.length() == 0) continue;

                            //old arduino firmware sends "start"
                            if (line.startsWith("R3G Master v")) {
                                //todo: set version
                                setInitialized(true);
                                System.out.println(line);
                            }
		        }
                    }
                }
                catch (IOException e) {
                    System.out.println("inputstream.read() failed: " + e.toString());
                    // FIXME: Shut down communication somehow.
                }
            }			
        }
    }
		
    /**
     * Sends the command over the serial connection and retrieves a result.
     */
    protected PacketResponse runCommand(byte[] packet)
    {
        assert (serial != null);

        if (packet == null || packet.length < 4)
            return null; // skip empty commands or broken commands

        boolean checkQueue = false;
        if (packet[2] == 0x0 && (packet[3]&0x80) != 0x0) {
            checkQueue = true;
        }

        synchronized(serial) {
            //do the actual send.
            serial.write(packet);
        }

        if (debugLevel >= 2) {
            System.out.print("OUT: ");
            for (int i =0; i<packet.length;i++)
                {
                    System.out.print(Integer.toHexString((int)packet[i] & 0xff ));
                    System.out.print(" ");
                }
            System.out.print("\n");
        }

        PacketProcessor pp = new PacketProcessor();
        try {
            boolean c = false;
            System.out.print("IN: ");
            while (!c) {
                int b = serial.input.read();
                c = pp.processByte((byte)b);
                System.out.flush();
            }
            System.out.println();
        } catch (java.io.IOException ioe) {
            System.out.println(ioe.toString());
        } 
        return pp.getResponse();
    }
	
	
    public boolean isFinished()
    {
		// todo agm
		return true;
    }
	
    /****************************************************
     *  commands used internally to driver
     ****************************************************/
    public int getVersion(int ourVersion) 
    {
        PacketBuilder pb = new PacketBuilder(CommandCodesMaster.GET_VERSION);
        pb.add16(ourVersion);
        
        PacketResponse pr = runCommand(pb.getPacket());
        int version = pr.get16();
        
        System.out.println("Reported version: " + Integer.toHexString(version));
        
        return version;
    }
    
    public void sendInit()
    {
        PacketBuilder pb = new PacketBuilder(CommandCodesMaster.INIT);
        PacketResponse pr = runCommand(pb.getPacket());
    }
    
    /****************************************************
     *  commands for interfacing with the driver directly
     ****************************************************/

    public void queueDelta(Point3d delta)
    {
        if (debugLevel >= 1)
            System.out.println("Queued point " + delta);

        //sendCommand(cmd);
        PacketBuilder pb = new PacketBuilder(CommandCodesMaster.QUEUE_POINT_INC);

        //figure out our feedrate variables.
        long ticks = convertDeltaToTicks(delta, feedrate);
	Point3d steps = getDeltaSteps(delta);

        //figure out the axis with the most steps.
        int max = Math.max((int)steps.x, (int)steps.y);
        max = Math.max(max, (int)steps.z);
		
        //get the ratio of steps to take each segment
        double xRatio = steps.x / max;
        double yRatio = steps.y / max;
        double zRatio = steps.z / max;
		
        //how many segments will there be?
        int segmentCount = (int)Math.ceil(max / 32767.0);
		
        //within our range?  just do it.
        if (segmentCount == 1) {
            queueIncrementalPoint(pb, steps, ticks);
        }
        else {
            for (int i=0; i<segmentCount; i++) {
                Point3d segmentSteps = new Point3d();
                
                //TODO: is this accurate?
                //calculate our line segments
                segmentSteps.x = Math.round(32767 * xRatio);
                segmentSteps.y = Math.round(32767 * yRatio);
                segmentSteps.z = Math.round(32767 * zRatio);
                
                //keep track of them.
                steps.x -= segmentSteps.x;
                steps.y -= segmentSteps.y;
                steps.z -= segmentSteps.z;
                
                //send this segment
                queueIncrementalPoint(pb, segmentSteps, ticks);
            }
        }
    }

	private void queueIncrementalPoint(PacketBuilder pb, Point3d steps, long ticks)
	{
            //figure out our timer values.
            byte prescaler = convertTicksToPrescaler(ticks);
            int counter = convertTicksToCounter(ticks);

            if (debugLevel >= 1)
                System.out.println("Queued incremental point " + steps + " at " + counter + "/" + prescaler + " (" + ticks + ")");

            //just add them in now.
            pb.add16((int)steps.x);
            pb.add16((int)steps.y);
            pb.add16((int)steps.z);
            pb.add8(prescaler);
            pb.add16(counter);

            PacketResponse pr = runCommand(pb.getPacket());
	}
	
//     public void setCurrentPosition(Point3d p)
//     {
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.SET_POS);

// 		Point3d steps = machine.mmToSteps(p);
// 		pb.add32((long)steps.x);
// 		pb.add32((long)steps.y);
// 		pb.add32((long)steps.z);
		
// 		if (debugLevel >= 1)
// 			System.out.println("Set current position to " + p + " (" + steps + ")");

// 		PacketResponse pr = runCommand(pb.getPacket());

//     }
	
    public void homeXYZ()
    {
		if (debugLevel >= 1)
			System.out.println("Home XYZ");
		
		homeAxes(true, true, true);
    }

    public void homeXY()
    {
		if (debugLevel >= 1)
			System.out.println("Home XY");
		
		homeAxes(true, true, false);
    }

    public void homeX()
    {
		if (debugLevel >= 1)
			System.out.println("Home X");
		
		homeAxes(true, false, false);
    }

    public void homeY()
    {
		if (debugLevel >= 1)
			System.out.println("Home Y");
		
		homeAxes(false, true, false);
    }

    public void homeZ()
    {
		if (debugLevel >= 1)
			System.out.println("Home Z");
		
		homeAxes(false, false, false);
    }

	private void homeAxes(boolean x, boolean y, boolean z)
	{
		byte flags = 0x00;
		
		//figure out our fastest feedrate.
                Point3d maxFeedrates = new Point3d(200,200,200); //FIXME: real feedrate
		double feedrate = Math.max(maxFeedrates.x, maxFeedrates.y);
		feedrate = Math.max(maxFeedrates.z, feedrate);
		
		Point3d target = new Point3d();
		
		if (x)
		{
			flags += 1;
			feedrate = Math.min(feedrate, maxFeedrates.x);
			target.x = 1; //just to give us feedrate info.
		}
		if (y)
		{
			flags += 2;
			feedrate = Math.min(feedrate, maxFeedrates.y);
			target.y = 1; //just to give us feedrate info.
		}
		if (z)
		{
			flags += 4;
			feedrate = Math.min(feedrate, maxFeedrates.z);
			target.z = 1; //just to give us feedrate info.
		}

		//calculate ticks
		long ticks = convertDeltaToTicks(target, feedrate);

		//calculate prescaler/counter values
		byte prescaler = convertTicksToPrescaler(ticks);
		int counter = convertTicksToCounter(ticks);
		
		if (debugLevel >= 2)
			System.out.println("Homing w/ flags " + Integer.toBinaryString(flags) + " at " + counter + "/" + prescaler);
		
		//send it!
		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.FIND_MINS);
		pb.add8(prescaler);
		pb.add16(counter);
		pb.add16(300); //default to 5 minutes
		pb.add8(flags);

		PacketResponse pr = runCommand(pb.getPacket());
	}
	
    public void delay(long millis)
    {
		if (debugLevel >= 1)
			System.out.println("Delaying " + millis + " millis.");

		//send it!
		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.DELAY);
		pb.add32(millis);
		PacketResponse pr = runCommand(pb.getPacket());
    }
	
    public void openClamp(int clampIndex)
    {
		//TODO: throw some sort of unsupported exception.
    }
	
    public void closeClamp(int clampIndex)
    {
		//TODO: throw some sort of unsupported exception.
    }
	
    public void enableDrives()
    {
		//TODO: throw some sort of unsupported exception.
    }
	
    public void disableDrives()
    {
		//TODO: throw some sort of unsupported exception.
    }
	
    public void changeGearRatio(int ratioIndex)
    {
		//TODO: throw some sort of unsupported exception.
    }
	
	public void selectTool(int toolIndex)
	{
		if (debugLevel >= 1)
			System.out.println("Selecting tool #" + toolIndex);
		
		//send it!
		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.CHANGE_TOOL);
		pb.add8((byte)toolIndex);
		PacketResponse pr = runCommand(pb.getPacket());
		
	}

    /*************************************
     *  Motor interface functions
     *************************************/
    public void setMotorRPM(double rpm)
    {
		//convert RPM into microseconds and then send.
		long microseconds = (int)Math.round(60 * 1000000 / rpm); //no unsigned ints?!?
		microseconds = Math.min(microseconds, 2^32-1); // limit to uint32.
		
		if (debugLevel >= 1)
			System.out.println("Setting motor 1 speed to " + rpm + " RPM (" + microseconds + " microseconds)");
		
		//send it!
		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
		pb.add8((byte)1);
		pb.add8(CommandCodesSlave.SET_MOTOR_1_RPM);
		pb.add8((byte)4); //length of payload.
		pb.add32(microseconds);
		PacketResponse pr = runCommand(pb.getPacket());

    }

    public void setMotorSpeedPWM(int pwm)
    {
		if (debugLevel >= 1)
			System.out.println("Setting motor 1 speed to " + pwm + " PWM");

		//send it!
		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
		pb.add8((byte)1);
		pb.add8(CommandCodesSlave.SET_MOTOR_1_PWM);
		pb.add8((byte)1); //length of payload.
		pb.add8((byte)pwm);
		PacketResponse pr = runCommand(pb.getPacket());

    }
	
//     public void enableMotor()
//     {
// 		//our flag variable starts with motors enabled.
// 		byte flags = 1;
		
// 		//bit 1 determines direction...
// 		if (machine.currentTool().getMotorDirection() == ToolModel.MOTOR_CLOCKWISE)
// 			flags += 2;

// 		if (debugLevel >= 1)
// 			System.out.println("Toggling motor 1 w/ flags: " + Integer.toBinaryString(flags));

// 		//send it!
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_MOTOR_1);
// 		pb.add8((byte)1); //payload length
// 		pb.add8(flags);
// 		PacketResponse pr = runCommand(pb.getPacket());
		
//     }
	
//     public void disableMotor()
//     {
// 		//bit 1 determines direction...
// 		byte flags = 0;
// 		if (machine.currentTool().getSpindleDirection() == ToolModel.MOTOR_CLOCKWISE)
// 			flags += 2;
					
// 		if (debugLevel >= 1)
// 			System.out.println("Disabling motor 1");
		
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_MOTOR_1);
// 		pb.add8((byte)1); //payload length
// 		pb.add8(flags);
// 		PacketResponse pr = runCommand(pb.getPacket());

//     }

// 	public int getMotorSpeedPWM()
// 	{
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_QUERY);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.GET_MOTOR_1_PWM);
// 		PacketResponse pr = runCommand(pb.getPacket());

// 		//get it
// 		int pwm = pr.get8();
		
// 		if (debugLevel >= 1)
// 			System.out.println("Current motor 1 PWM: " + pwm);
		
// 		//set it.
// 		machine.currentTool().setMotorSpeedReadingPWM(pwm);
		
// 		return pwm;
// 	}

//     public double getMotorSpeedRPM()
//     {
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_QUERY);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.GET_MOTOR_1_RPM);
// 		PacketResponse pr = runCommand(pb.getPacket());
		
// 		//convert back to RPM
// 		long micros = pr.get32();
// 		double rpm = (60.0 * 1000000.0 / micros);

// 		if (debugLevel >= 1)
// 			System.out.println("Current motor 1 RPM: " + rpm + " (" + micros + ")");
		
// 		//set it.
// 		machine.currentTool().setMotorSpeedReadingRPM(rpm);
		
// 		return rpm;
//     }

//     /*************************************
//      *  Spindle interface functions
//      *************************************/
//     public void setSpindleRPM(double rpm)
//     {
// 		//convert RPM into microseconds and then send.
// 		long microseconds = (int)Math.round(60 * 1000000 / rpm); //no unsigned ints?!?
// 		microseconds = Math.min(microseconds, 2^32-1); // limit to uint32.
		
// 		if (debugLevel >= 1)
// 			System.out.println("Setting motor 2 speed to " + rpm + " RPM (" + microseconds + " microseconds)");

// 		//send it!
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.SET_MOTOR_2_RPM);
// 		pb.add8((byte)4); //payload length
// 		pb.add32(microseconds);
// 		PacketResponse pr = runCommand(pb.getPacket());

//     }

//     public void setSpindleSpeedPWM(int pwm)
//     {
// 		if (debugLevel >= 1)
// 			System.out.println("Setting motor 2 speed to " + pwm + " PWM");

// 		//send it!
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.SET_MOTOR_2_PWM);
// 		pb.add8((byte)1); //length of payload.
// 		pb.add8((byte)pwm);
// 		PacketResponse pr = runCommand(pb.getPacket());

//     }
	
//     public void enableSpindle()
//     {
// 		//our flag variable starts with spindles enabled.
// 		byte flags = 1;
		
// 		//bit 1 determines direction...
// 		if (machine.currentTool().getSpindleDirection() == ToolModel.MOTOR_CLOCKWISE)
// 			flags += 2;

// 		if (debugLevel >= 1)
// 			System.out.println("Toggling motor 2 w/ flags: " + Integer.toBinaryString(flags));

// 		//send it!
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_MOTOR_2);
// 		pb.add8((byte)1); //payload length
// 		pb.add8(flags);
// 		PacketResponse pr = runCommand(pb.getPacket());
		
//     }
	
//     public void disableSpindle()
//     {
// 		//bit 1 determines direction...
// 		byte flags = 0;
// 		if (machine.currentTool().getSpindleDirection() == ToolModel.MOTOR_CLOCKWISE)
// 			flags += 2;
		
// 		if (debugLevel >= 1)
// 			System.out.println("Disabling motor 2");
		
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_MOTOR_1);
// 		pb.add8((byte)1); //payload length
// 		pb.add8(flags);
// 		PacketResponse pr = runCommand(pb.getPacket());

//     }
	
//     public double getSpindleSpeedRPM()
//     {
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_QUERY);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.GET_MOTOR_2_RPM);
// 		PacketResponse pr = runCommand(pb.getPacket());
		
// 		//convert back to RPM
// 		long micros = pr.get32();
// 		double rpm = (60.0 * 1000000.0 / micros);

// 		if (debugLevel >= 1)
// 			System.out.println("Current motor 2 RPM: " + rpm + " (" + micros + ")");
		
// 		//set it.
// 		machine.currentTool().setSpindleSpeedReadingRPM(rpm);
		
// 		return rpm;
//     }

// 	public int getSpindleSpeedPWM()
// 	{
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_QUERY);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.GET_MOTOR_2_PWM);
// 		PacketResponse pr = runCommand(pb.getPacket());

// 		//get it
// 		int pwm = pr.get8();
		
// 		if (debugLevel >= 1)
// 			System.out.println("Current motor 1 PWM: " + pwm);
		
// 		//set it.
// 		machine.currentTool().setSpindleSpeedReadingPWM(pwm);
		
// 		return pwm;
// 	}

	
//     /*************************************
//      *  Temperature interface functions
//      *************************************/
//     public void setTemperature(double temperature)
//     {
// 		//constrain our temperature.
// 		int temp = (int)Math.round(temperature);
// 		temp = Math.min(temp, 65535);
		
// 		if (debugLevel >= 1)
// 			System.out.println("Setting temperature to " + temp + "C");
		
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.SET_TEMPERATURE);
// 		pb.add8((byte)2); //payload length
// 		pb.add16(temp);
// 		PacketResponse pr = runCommand(pb.getPacket());		
		
//     }

//     public void readTemperature()
//     {
//         PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_QUERY);
//         pb.add8((byte)machine.currentTool().getIndex());
//         pb.add8(CommandCodesSlave.GET_TEMPERATURE);
//         PacketResponse pr = runCommand(pb.getPacket());
	
//         int temp = pr.get16();
//         machine.currentTool().setCurrentTemperature(temp);
	
//         if (debugLevel >= 1)
//             System.out.println("Current temperature: " + temp + "C");
//     }

//     /*************************************
//      *  Flood Coolant interface functions
//      *************************************/
//     public void enableFloodCoolant()
//     {
// 		//TODO: throw unsupported exception
		
//     }
	
//     public void disableFloodCoolant()
//     {
// 		//TODO: throw unsupported exception
		
//     }

//     /*************************************
//      *  Mist Coolant interface functions
//      *************************************/
//     public void enableMistCoolant()
//     {
// 		//TODO: throw unsupported exception
		
//     }
	
//     public void disableMistCoolant()
//     {
// 		//TODO: throw unsupported exception

//     }

//     /*************************************
//      *  Fan interface functions
//      *************************************/
//     public void enableFan()
//     {
// 		if (debugLevel >= 1)
// 			System.out.println("Enabling fan");
		
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_FAN);
// 		pb.add8((byte)1); //payload length
// 		pb.add8((byte)1); //enable
// 		PacketResponse pr = runCommand(pb.getPacket());		
		
//     }
	
//     public void disableFan()
//     {
// 		if (debugLevel >= 1)
// 			System.out.println("Disabling fan");
		
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_FAN);
// 		pb.add8((byte)1); //payload length
// 		pb.add8((byte)0); //disable
// 		PacketResponse pr = runCommand(pb.getPacket());		
		
//     }
	
//     /*************************************
//      *  Valve interface functions
//      *************************************/
//     public void openValve()
//     {
// 		if (debugLevel >= 1)
// 			System.out.println("Opening valve");
		
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_VALVE);
// 		pb.add8((byte)1); //payload length
// 		pb.add8((byte)1); //enable
// 		PacketResponse pr = runCommand(pb.getPacket());		

//     }
	
//     public void closeValve()
//     {
// 		if (debugLevel >= 1)
// 			System.out.println("Closing valve");
		
// 		PacketBuilder pb = new PacketBuilder(CommandCodesMaster.TOOL_COMMAND);
// 		pb.add8((byte)machine.currentTool().getIndex());
// 		pb.add8(CommandCodesSlave.TOGGLE_VALVE);
// 		pb.add8((byte)1); //payload length
// 		pb.add8((byte)0); //disable
// 		PacketResponse pr = runCommand(pb.getPacket());		
		
//     }
	
//     /*************************************
//      *  Collet interface functions
//      *************************************/
//     public void openCollet()
//     {
// 		//TODO: throw unsupported exception.
		
//     }
	
//     public void closeCollet()
//     {
// 		//TODO: throw unsupported exception.
		
//     }

	/*************************************
     *  Various timer and math functions.
     *************************************/

    private Point3d getDeltaSteps(Point3d delta)
    {
        //calculate our deltas.
        delta.x = Math.abs(delta.x);
        delta.y = Math.abs(delta.y);
        delta.z = Math.abs(delta.z);
        
        return mmToSteps(delta);
    }
	
    private Point3d stepsPerMM = new Point3d(200,200,200);
    public Point3d mmToSteps(Point3d mm)
    {
        Point3d temp = new Point3d();
        
        temp.x = Math.round(mm.x * stepsPerMM.x);
        temp.y = Math.round(mm.y * stepsPerMM.y);
        temp.z = Math.round(mm.z * stepsPerMM.z);
        
        return temp;
    }
    
    private long convertDeltaToTicks(Point3d delta, double feedrate)
    {
        Point3d deltaSteps = getDeltaSteps(delta);
        
        //how long is our line length?
        double distance = Math.sqrt(deltaSteps.x * deltaSteps.x + 
                                    deltaSteps.y * deltaSteps.y + 
                                    deltaSteps.z * deltaSteps.z);
        
        long master_steps = 0;
        
        //find the dominant axis.
        if (deltaSteps.x > deltaSteps.y) {
            if (deltaSteps.z > deltaSteps.x)
                master_steps = (long)deltaSteps.z;
            else
                master_steps = (long)deltaSteps.x;
        }
        else {
            if (deltaSteps.z > deltaSteps.y)
                master_steps = (long)deltaSteps.z;
            else
                master_steps = (long)deltaSteps.y;
        }
        
        //calculate delay between steps in ticks.  this is sort of tricky, but not too bad.
        // 960,000,000 = number of ticks in a second at 16Mhz, the speed of an Arduino/Sanguino.
        //the formula has been condensed to save space.  here it is in english:
        // (feedrate is in mm/minute)
        // distance / feedrate * 960,000,000.0 = move duration in ticks
        // move duration / master_steps = time between steps for master axis.
        
        return (long)Math.floor(((distance * 960000000.0) / feedrate) / master_steps);
    }
    
	private byte convertTicksToPrescaler(long ticks)
	{
		// these also represent frequency: 1000000 / ticks / 2 = frequency in hz.

		// our slowest speed at our highest resolution ( (2^16-1) * 0.0625 usecs = 4095 usecs (4 millisecond max))
		// range: 8Mhz max - 122hz min
		if (ticks <= 65535L)
			return 1;
		// our slowest speed at our next highest resolution ( (2^16-1) * 0.5 usecs = 32767 usecs (32 millisecond max))
		// range:1Mhz max - 15.26hz min
		else if (ticks <= 524280L)
			return 2;
		// our slowest speed at our medium resolution ( (2^16-1) * 4 usecs = 262140 usecs (0.26 seconds max))
		// range: 125Khz max - 1.9hz min
		else if (ticks <= 4194240L)
			return 3;
		// our slowest speed at our medium-low resolution ( (2^16-1) * 16 usecs = 1048560 usecs (1.04 seconds max))
		// range: 31.25Khz max - 0.475hz min
		else if (ticks <= 16776960L)
			return 4;
		// our slowest speed at our lowest resolution ((2^16-1) * 64 usecs = 4194240 usecs (4.19 seconds max))
		// range: 7.812Khz max - 0.119hz min
		else if (ticks <= 67107840L)
			return 5;
		//its really slow... hopefully we can just get by with super slow.
		else
			return 5;		
	}
	
	private int convertTicksToCounter(long ticks)
	{
		// our slowest speed at our highest resolution ( (2^16-1) * 0.0625 usecs = 4095 usecs)
		if (ticks <= 65535)
			return ((int)(ticks & 0xffff));
		// our slowest speed at our next highest resolution ( (2^16-1) * 0.5 usecs = 32767 usecs)
		else if (ticks <= 524280)
			return ((int)((ticks / 8) & 0xffff));
		// our slowest speed at our medium resolution ( (2^16-1) * 4 usecs = 262140 usecs)
		else if (ticks <= 4194240)
			return ((int)((ticks / 64) & 0xffff));
		// our slowest speed at our medium-low resolution ( (2^16-1) * 16 usecs = 1048560 usecs)
		else if (ticks <= 16776960)
			return ((int)(ticks / 256));
		// our slowest speed at our lowest resolution ((2^16-1) * 64 usecs = 4194240 usecs)
		else if (ticks <= 67107840)
			return ((int)(ticks / 1024));
		//its really slow... hopefully we can just get by with super slow.
		else
			return 65535;
	}
}
