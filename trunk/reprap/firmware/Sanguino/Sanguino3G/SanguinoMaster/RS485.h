void rs485_tx(byte b)
{
  digitalWrite(TX_ENABLE_PIN, HIGH); //enable tx
  Serial1.print(b, BYTE);

  //read for our own byte.
  long now = millis();
  long end = now + 10;
  int tmp = Serial1.read();
  while (tmp != b)
  {
    tmp = Serial1.read();
	if (millis() > end)
	{
#ifdef ENABLE_COMMS_DEBUG
  Serial.println("Loopback Fail");
#endif
		break;		
	}
  }

  digitalWrite(TX_ENABLE_PIN, LOW); //disable tx
}

void serial_tx(byte b)
{
	Serial.print(b, BYTE);
}