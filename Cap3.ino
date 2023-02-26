/* code modified from https://www.instructables.com/Measure-Capacitance-with-Arduino/
 https://docs.arduino.cc/tutorials/generic/capacitance-meter

*/
#define analogPin A0 //measures cap voltage
#define chargePin 13 //charges cap
#define dischargePin 11 //discharge cap
#define resistorVal 10000. //10k ohm resistor

unsigned long startTime;
unsigned long elapsedTime;
float nanoFarads;

void setup() {
  pinMode(chargePin, OUTPUT);
  digitalWrite(chargePin, LOW);
  Serial.begin(9600);

}

void loop() {
  digitalWrite(chargePin, HIGH);
  startTime=millis();
  while(analogRead(analogPin)<648){   //647=63.2% of 1023, do nothing until 63.2% charged (1 time constant elapsed)
    
  }
elapsedTime=millis()-startTime;
nanoFarads=((float)elapsedTime/resistorVal)*1000000.;  //mult by 1000000 for proper units
Serial.print(elapsedTime);  //prints time in ms
Serial.print(" ms ");

Serial.print((long)nanoFarads);  //prints cap in nF
Serial.println(" nF");
delay(500);

digitalWrite(chargePin, LOW);  //stop charging0
pinMode(dischargePin, OUTPUT);
digitalWrite(dischargePin, LOW); //to discharge cap
while(analogRead(analogPin)>0){
  
}

pinMode(dischargePin, INPUT);

}
