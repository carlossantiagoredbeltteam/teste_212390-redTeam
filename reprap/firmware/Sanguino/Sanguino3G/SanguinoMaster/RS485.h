void rs485_tx(byte b)
{
  digitalWrite(TX_ENABLE_PIN, HIGH); //enable tx
  Serial1.print(b, BYTE);

  int tmp = Serial1.read();
  while (tmp != b)
    tmp = Serial1.read();

  digitalWrite(TX_ENABLE_PIN, LOW); //disable tx
}

void serial_tx(byte b)
{
	Serial.print(b, BYTE);
}