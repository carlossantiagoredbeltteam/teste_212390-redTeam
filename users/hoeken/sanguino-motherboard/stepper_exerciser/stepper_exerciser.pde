#define X_STEP_PIN 15
#define X_DIR_PIN 18
#define X_ENABLE_PIN 19

#define Y_STEP_PIN 23
#define Y_DIR_PIN 22
#define Y_ENABLE_PIN 19

#define Z_STEP_PIN 29
#define Z_DIR_PIN 30
#define Z_ENABLE_PIN 31

void setup()
{
  Serial.begin(19200);
  Serial.println("Starting stepper exerciser.");

  pinMode(X_STEP_PIN, OUTPUT);
  pinMode(X_DIR_PIN, OUTPUT);
  pinMode(X_ENABLE_PIN, OUTPUT);
  pinMode(Y_STEP_PIN, OUTPUT);
  pinMode(Y_DIR_PIN, OUTPUT);
  pinMode(Y_ENABLE_PIN, OUTPUT);
  pinMode(Z_STEP_PIN, OUTPUT);
  pinMode(Z_DIR_PIN, OUTPUT);
  pinMode(Z_ENABLE_PIN, OUTPUT);

  digitalWrite(X_STEP_PIN, HIGH);
  digitalWrite(X_DIR_PIN, LOW);
  digitalWrite(X_ENABLE_PIN, HIGH);
  digitalWrite(Y_STEP_PIN, HIGH);
  digitalWrite(Y_DIR_PIN, LOW);
  digitalWrite(Y_ENABLE_PIN, HIGH);
  digitalWrite(Z_STEP_PIN, HIGH);
  digitalWrite(Z_DIR_PIN, LOW);
  digitalWrite(Z_ENABLE_PIN, HIGH);
}

void loop()
{
  int i, j;

  for (i=1650; i>=500; i-=150)
  {
    digitalWrite(X_ENABLE_PIN, HIGH);
    digitalWrite(Y_ENABLE_PIN, HIGH);
    digitalWrite(Z_ENABLE_PIN, HIGH);

    Serial.print("Speed: ");
    Serial.println(i);

    for (j=0; j<1000; j++)
    {
      digitalWrite(X_STEP_PIN, HIGH);
      digitalWrite(Y_STEP_PIN, HIGH);
      digitalWrite(Z_STEP_PIN, HIGH);

      delayMicroseconds(2);

      digitalWrite(X_STEP_PIN, LOW);
      digitalWrite(Y_STEP_PIN, LOW);
      digitalWrite(Z_STEP_PIN, LOW);

      delayMicroseconds(i);
    }

    digitalWrite(X_ENABLE_PIN, LOW);
    digitalWrite(Y_ENABLE_PIN, LOW);
    digitalWrite(Z_ENABLE_PIN, LOW);

  }

  delay(500);
  
  Serial.println("Switching directions.");
  digitalWrite(X_DIR_PIN, !digitalRead(X_DIR_PIN));
  digitalWrite(Y_DIR_PIN, !digitalRead(Y_DIR_PIN));
  digitalWrite(Z_DIR_PIN, !digitalRead(Z_DIR_PIN));
}
