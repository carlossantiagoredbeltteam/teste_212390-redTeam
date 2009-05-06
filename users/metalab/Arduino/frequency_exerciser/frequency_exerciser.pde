// Yep, this is actually -*- c++ -*-

// Z axis pins for the Motherboard 1.1
// #define STEP_PIN 27
// #define DIR_PIN 28
// #define ENABLE_PIN 29
// #define MIN_PIN 30
// #define MAX_PIN 31

// X axis pins
// #define STEP_PIN 15
// #define DIR_PIN 18
// #define ENABLE_PIN 19
// #define MIN_PIN 20
// #define MAX_PIN 21

// Y axis pins
#define STEP_PIN      23
#define DIR_PIN       22
#define ENABLE_PIN    24
#define MIN_PIN       25
#define MAX_PIN       26

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
  Serial.begin(38400);
  Serial.println("You have failed me for the last time.");

  pinMode(STEP_PIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);
  pinMode(MIN_PIN, INPUT);
  pinMode(MAX_PIN, INPUT);
  digitalWrite(MIN_PIN, HIGH); //turn on internal pullup
  digitalWrite(MAX_PIN, HIGH); //other pullup

  digitalWrite(DIR_PIN, HIGH);
  digitalWrite(STEP_PIN, LOW);
  digitalWrite(ENABLE_PIN, HIGH); //disable

  init_psu();
  calculate_tones();
}

void loop()
{
  play_song();

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
   0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
  10,11,12,13,14,15,16,17,18,19,
  20,21,22,23,24,25,26,27,28,29,
  30,31,32,33,34,35,36,37,38,39,
};

void calculate_tones()
{
  for (byte i=0; i<TONE_COUNT; i++)
    tones[i] = (int)(1000000.0/ (2.0 * frequencies[i]));
}

void play_song()
{
  digitalWrite(ENABLE_PIN, LOW); //enable
  uint32_t f = 1000;
  bool dir = true;
  for (int i=0;i<100;i++) {
    digitalWrite(DIR_PIN, dir);
    dir = !dir;
    f = f * 1.1;
    int delayus = 500000 / 2 / f ;
    int count = f;

    for (int i=0; i<count; i++) {
      digitalWrite(STEP_PIN, HIGH);
      delayMicroseconds(delayus);
      digitalWrite(STEP_PIN, LOW); 
      delayMicroseconds(delayus);
    }

    Serial.println(f);
    delay(10); 
  }
  digitalWrite(ENABLE_PIN, HIGH); //disable
}
