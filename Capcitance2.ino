/* code adapted from https://www.instructables.com/Measure-Capacitance-with-Arduino/
 https://docs.arduino.cc/tutorials/generic/capacitance-meter

*/

// Initialize Pins
int analogPin = A0;
int chargePin = 13;
int dischargePin = 11; //speeds up discharging process, not necessary though

// Initialize Resistor
int resistorValue = 10000.;

// Initialize Timer
unsigned long startTime;
unsigned long elapsedTime;

// Initialize Capacitance Variable               
float picoFarads;

//Initialize LED 
int ledPin = 12;

void setup()
{
  pinMode(chargePin, OUTPUT);     //cap
  digitalWrite(chargePin, LOW);  
  Serial.begin(9600); // Necessary to print data to serial monitor over USB

  pinMode(ledPin, OUTPUT);  //led
  digitalWrite(ledPin, LOW);
}

void loop()
{
 
  digitalWrite(chargePin, HIGH); // Begins charging the capacitor
  startTime = micros(); // Begins the timer
  
  while(analogRead(analogPin) < 648)
  {       
    // Does nothing until capacitor reaches 63.2% of total voltage
  }

  elapsedTime= micros() - startTime; // Determines how much time it took to charge capacitor
  picoFarads = ((float)elapsedTime / resistorValue) * 1000000.0;
  Serial.print(elapsedTime);       
  Serial.print(" microS    ");         
      
  Serial.print((long)picoFarads);         
  Serial.println(" picoFarads"); 


//  delay(300);
//  if (picoFarads>10000){
//    digitalWrite(ledPin, HIGH);
//    delay(1000);
//   
//  }
//  digitalWrite(ledPin, LOW);         
  delay(500); 


  digitalWrite(chargePin, LOW); // Stops charging capacitor
  pinMode(dischargePin, OUTPUT); 
  digitalWrite(dischargePin, LOW); // Allows capacitor to discharge    
  while(analogRead(analogPin) > 0)
  {
    // Do nothing until capacitor is discharged      
  }

  pinMode(dischargePin, INPUT); // Prevents capacitor from discharging  
}
