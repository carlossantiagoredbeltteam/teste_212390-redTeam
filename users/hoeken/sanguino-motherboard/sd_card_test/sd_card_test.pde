#include <RepRapSDCard.h>

RepRapSDCard card;
File f;

//our buffer of bytes.
#define BUFFSIZE 64
char buffer[BUFFSIZE];
byte bufferIndex = 0;
byte error = 0;

void setup()
{
  Serial.begin(19200);
  Serial.println("start");

  if (!card.init_card())
  {
    if (!card.isAvailable())
    {
      Serial.println("No card present"); 
      error = 1;
    }
    else
    {
      Serial.println("Card init failed"); 
      error = 2;
    }
  }
  else if (!card.open_partition())
  {
    Serial.println("No partition"); 
    error = 3;
  }
  else if (!card.open_filesys())
  {
    Serial.println("Can't open filesys"); 
    error = 4;
  }
  else if (!card.open_dir("/"))
  {
    Serial.println("Can't open /");
    error = 5;
  }
  else if (card.isLocked())
  {
    Serial.println("Card is locked");
    error = 6;
  }

  open_file();

  if (error == 0)
  {
    bufferIndex = 0;
    for (char c = 'a'; c<= 'z'; c++)
    {
      buffer[bufferIndex] = c;
      bufferIndex++;
    }

    card.write_file(f, (uint8_t *) buffer, bufferIndex);
    card.close_file(f);
  }
}

void loop()
{
}

void open_file()
{
  strcpy(buffer, "RRJOB00.TXT");
  for (buffer[5] = '0'; buffer[5] <= '9'; buffer[5]++)
  {
    for (buffer[6] = '0'; buffer[6] <= '9'; buffer[6]++)
    {
      f = card.open_file(buffer);
      if (!f)
        break;        // found a file!      
      card.close_file(f);
    }
    if (!f) 
      break;
  }

  if(!card.create_file(buffer))
  {
    Serial.println("couldnt create: ");
    Serial.println(buffer);
    error = 7;
  }
  else
  {
    f = card.open_file(buffer);
    if (!f)
    {
      Serial.println("error opening: ");
      Serial.println(buffer);
      error = 8;
    }
    else
    {
      Serial.println("writing to: ");
      Serial.println(buffer);
    }
  }
}
