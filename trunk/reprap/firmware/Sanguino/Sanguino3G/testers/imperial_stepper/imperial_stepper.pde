// Yep, this is actually -*- c++ -*-

#define stepPin 15
#define dirPin 18
#define enablePin 19
#define minPin 20
#define maxPin 21
//pin for controlling the PSU.
#define PS_ON_PIN       14

void init_psu()
{
#ifdef PS_ON_PIN
  pinMode(PS_ON_PIN, OUTPUT);
  turn_psu_on();
#endif
}

void turn_psu_on()
{
#ifdef PS_ON_PIN
  digitalWrite(PS_ON_PIN, LOW);
  delay(2000); //wait for PSU to actually turn on.
#endif
}

void turn_psu_off()
{
#ifdef PS_ON_PIN
  digitalWrite(PS_ON_PIN, HIGH);
#endif
}

void setup()
{
  Serial.begin(19200);
  Serial.println("You have failed me for the last time.");

  pinMode(stepPin, OUTPUT);
  pinMode(dirPin, OUTPUT);
  pinMode(enablePin, OUTPUT);
  pinMode(minPin, INPUT);
  pinMode(maxPin, INPUT);
  digitalWrite(minPin, HIGH); //turn on internal pullup
  digitalWrite(maxPin, HIGH); //other pullup

  digitalWrite(dirPin, HIGH);
  digitalWrite(stepPin, LOW);
  digitalWrite(enablePin, HIGH); //disable

  init_psu();
  calculate_tones();
}

void loop()
{
  Serial.println("Forward!");
  digitalWrite(dirPin, HIGH);
  play_song(maxPin);

  delay(500);

  Serial.println("Reverse!");
  digitalWrite(dirPin, LOW);
  play_song(minPin);

  delay(500);
}

boolean at_switch(byte pin)
{
  return !digitalRead(pin); 
}

#define TONE_COUNT 27

float frequencies[TONE_COUNT] = {
  196.00, //G2   0
  207.65, //G#2   1
  220.00, //A2    2
  233.08, //Bb2   3
  246.94, //B2    4
  261.63, //C3    5
  277.18, //C#3   6
  293.66, //D3    7
  311.13, //D#3   8
  329.63, //E3    9
  349.23, //F3    10
  369.99, //F#3   11
  392.00, //G3    12
  415.30, //G#3   13
  440.00, //A3    14
  466.16, //Bb3   15
  493.88, //B3    16
  523.25, //C4    17
  554.37, //C#4   18
  587.33, //D4    19
  622.25, //D#4   20
  659.26, //E4    21
  698.46, //F4    22
  739.99, //F#4   23
  783.99, //G4    24
  830.61, //G#4   25
  880.00  //A4    26
};


int tones[TONE_COUNT];

#define NOTE_COUNT 66
int notes[] = {
  12,12,12, 8,15,12, 8,15,12,   // 9
  19,19,19,20,15,12, 8,15,12,   // 9
  24,12,12,24,23,22,21,20,21,   // 9
  13,18,17,16,15,14,15,         // 7
   8,11, 8,11,15,12,15,19,      // 8
  24,12,12,24,23,22,21,20,21,   // 9
  13,18,17,16,15,14,15,         // 7
   8,11, 8,15,12, 8,15,12       // 8
};
int lengths[] = {
    4, 4, 4, 3, 1, 4, 3, 1, 8,
    4, 4, 4, 3, 1, 4, 3, 1, 8,
    4, 3, 1, 4, 3, 1, 1, 1, 4,
    2, 4, 3, 1, 1, 1, 4,
    2, 4, 3, 1, 4, 3, 1, 8,
    4, 3, 1, 4, 3, 1, 1, 1, 4,
    2, 4, 3, 1, 1, 1, 4,
    2, 4, 3, 1, 4, 3, 1, 8
};

void calculate_tones()
{
  for (byte i=0; i<TONE_COUNT; i++)
    tones[i] = (int)(1000000.0/ (2.0 * frequencies[i]));
}

void play_song(byte switchPin)
{
  digitalWrite(enablePin, LOW); //enable

  for (byte i=0; i<NOTE_COUNT; i++)
  {
    if (!at_switch(switchPin))
    {
      play_note(tones[notes[i]], 80000*lengths[i]);
      delay(10); 
    }
  }
  digitalWrite(enablePin, HIGH); //disable
}

void play_note(int note, long time)
{
  int count = round(time / note);

  for (int i=0; i<count; i++)
  {
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(note);
    digitalWrite(stepPin, LOW); 
    delayMicroseconds(note);
  }
}
