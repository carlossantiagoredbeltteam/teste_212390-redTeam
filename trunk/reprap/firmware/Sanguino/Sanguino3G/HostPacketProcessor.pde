//handle our packets.
void process_packets()
{
  //read through our available data
  while (Serial.available() > 0)
  {
    //grab a byte and process it.
    byte d = Serial.read();
    hostPacket.process_byte(d);

    //do we have a finished packet?
    if (hostPacket.isFinished())
    {
      //are we cool?
      if (hostPacket.isQuery())
        handle_query();		

      //okay, send our response
      hostPacket.sendReply();

      //only process one packet at a time.
      break;		
    }
  }
}
