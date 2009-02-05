void rs485_tx(byte b)
{
  digitalWrite(TX_ENABLE_PIN, HIGH); //enable tx
  Serial.print(b, BYTE);

  int tmp = Serial.read();
  while (tmp != b)
    tmp = Serial.read();

  digitalWrite(TX_ENABLE_PIN, LOW); //disable tx
}
