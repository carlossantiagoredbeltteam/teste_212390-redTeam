void rs485_transmit(byte b)
{
  //set our proper lines
  rs485_enable_tx();
  rs485_enable_rx();

  //actually send the byte
  Serial.print(b, BYTE);

  //wait until we read our own transmission.
  while (Serial.read() != b)
    true;

  //disable transmit.
  rs485_disable_tx();	
}

void rs485_enable_tx()
{
  digitalWrite(TX_ENABLE_PIN, HIGH);
}

void rs485_enable_rx()
{
  digitalWrite(RX_ENABLE_PIN, LOW);
}

void rs485_disable_tx()
{
  digitalWrite(TX_ENABLE_PIN, LOW);
}

void rs485_disable_rx()
{
  digitalWrite(RX_ENABLE_PIN, HIGH);
}
