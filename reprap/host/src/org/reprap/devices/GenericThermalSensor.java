package org.reprap.devices;

import java.io.IOException;

import org.reprap.Device;
import org.reprap.ReprapException;
import org.reprap.comms.Address;
import org.reprap.comms.Communicator;
import org.reprap.comms.IncomingContext;
import org.reprap.comms.IncomingMessage;
import org.reprap.comms.OutgoingMessage;

public class GenericThermalSensor extends Device {

	public class RequestTemperature extends OutgoingMessage {
		public static final int MSG_GetTemp = 1;		

		public byte[] getBinary() {
			return new byte [] { MSG_GetTemp };
		}
		
	}
	
	public class TemperatureResponse extends IncomingMessage {

		public TemperatureResponse(IncomingContext incomingContext) throws IOException {
			super(incomingContext);
		}
		
		int GetTemperature() throws InvalidPayloadException {
		    byte [] reply = getPayload();
		    if (reply.length != 3)
		    	throw new InvalidPayloadException();
		    if (reply[0] != 1)
		    	throw new InvalidPayloadException();
		    return reply[1] + reply[2] << 8;
		}

		protected boolean isExpectedPacketType(byte packetType) {
			return packetType == RequestTemperature.MSG_GetTemp;
		}

	}
	
	public GenericThermalSensor(Communicator communicator, Address address) {
		super(communicator, address);
	}

	double getTemperature() throws ReprapException, IOException {
		OutgoingMessage request = new RequestTemperature();
		IncomingContext replyContext = sendMessage(request);
		TemperatureResponse response = new TemperatureResponse(replyContext);
		
		int unscaled = response.GetTemperature();
		
		// TODO scale this according to callibration info 
		return unscaled;
	}
	
}
