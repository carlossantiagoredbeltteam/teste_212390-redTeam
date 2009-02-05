void rs485_tx(byte b)
{
  digitalWrite(TX_ENABLE_PIN, HIGH); //enable tx
  Serial.print(b, BYTE);

  //read for our own byte.
  long now = millis();
  long end = now + 10;
  int tmp = Serial.read();
  while (tmp != b)
  {
    tmp = Serial.read();
	if (millis() > tmp)
		break;
  }

  digitalWrite(TX_ENABLE_PIN, LOW); //disable tx
}
