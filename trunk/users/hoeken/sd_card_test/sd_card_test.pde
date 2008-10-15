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
    Serial.println("Card init failed!"); 
    error = 1;
  }
  else if (!card.open_partition())
  {
    Serial.println("No partition!"); 
    error = 2;
  }
  else if (!card.open_filesys())
  {
    Serial.println("Can't open filesys"); 
    error = 3;
  }
  else if (!card.open_dir("/"))
  {
    Serial.println("Can't open /");
    error = 4;
  }
}

void loop()
{
  if (error == 0)
  {
    for (int i=0; i<10; i++)
    {
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
      else
        break;
    }
  }
}

void open_file()
{
  strcpy(buffer, "RRJOB00.TXT");
  for (buffer[5] = '0'; buffer[5] <= '9'; buffer[5]++) {
    for (buffer[6] = '0'; buffer[6] <= '9'; buffer[6]++) {
      //putstring("\n\rtrying to open ");Serial.println(buffer);
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
    error = 5;
  }

  f = card.open_file(buffer);
  if (!f)
  {
    Serial.println("error opening: ");
    Serial.println(buffer);
    error = 6;
  }

  Serial.println("writing to: ");
  Serial.println(buffer);
}
