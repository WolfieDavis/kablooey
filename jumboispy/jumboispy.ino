byte buttons[] = {6, 8, 10, 12};
byte pressed[sizeof(buttons)], justPressed[sizeof(buttons)], justReleased[sizeof(buttons)];

void setup() {
  for (short i = 0; i < sizeof(buttons); i++) {
    pinMode(buttons[i], INPUT_PULLUP);
    digitalWrite(buttons[i], HIGH);
  }
  Serial.begin(9600);
}

void loop() {
  checkButtons(); // update button states with debouncing

  if (justPressed[0]) Serial.write(0);
  else if (justPressed[1])Serial.write(1);
  else if (justPressed[2])Serial.write(2);
  else if (justPressed[3])Serial.write(3);


}

void checkButtons() {
  static float debounceTime = 10;            // ms to debounce
  static byte prevState[sizeof(buttons)];    // array for previous burron states
  static byte currentState[sizeof(buttons)]; // array for current button states
  static long lastTime;                      // time when it was last run

  if (millis() < lastTime)
    lastTime = millis(); // wrapped around, try again
  if ((lastTime + debounceTime) > millis())
    return; // not enough time has gone by yet

  lastTime = millis(); // waited past debounce time, reset timer

  for (short i = 0; i < sizeof(buttons); i++) {
    justPressed[i] = 0;  // clear just vars
    justReleased[i] = 0; // clear just vars

    currentState[i] = digitalRead(buttons[i]); // read button

    if (currentState[i] == prevState[i]) { // if it's the same as it just was
      if ((pressed[i] == LOW) && (currentState[i] == LOW))
        justPressed[i] = 1; // just pressed
      else if ((pressed[i] == HIGH) && (currentState[i] == HIGH))
        justReleased[i] = 1;         // just released
      pressed[i] = !currentState[i]; // change to opposite
    }
    prevState[i] = currentState[i]; // update buttons
  }
}
