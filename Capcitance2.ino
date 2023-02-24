/////* code adapted from https://www.instructables.com/Measure-Capacitance-with-Arduino/
//// https://docs.arduino.cc/tutorials/generic/capacitance-meter
////
////*/
////
////// Initialize cap1
//int analogPin1 = A0;
//int chargePin1 = 11;
//int dischargePin1 = 13; //speeds up discharging process, not necessary though
//long cap1base=24000;  //capacitance of cap1 when not stepped on, tau=232 uS (R=10k)
//
//// Initialize cap2
//int analogPin2 = A1;
//int chargePin2 = 6;
//int dischargePin2 = 7; //speeds up discharging process, not necessary though
//long cap2base=96000;  //capacitance of cap2 when not stepped on
//
//
//// Initialize Resistor
//int resistorValue = 10000.;
//
//// Initialize Timer
//unsigned long startTime1;
//unsigned long startTime2;
//
//unsigned long tau1;
//unsigned long tau2;
////
//// Initialize Capacitance Variable               
//float picoFarads1;
//float picoFarads2;
//
//
//void setup()
//{
//  pinMode(chargePin1, OUTPUT);     //cap 1
//  digitalWrite(chargePin1, LOW);    
//  
//  pinMode(chargePin2, OUTPUT);     //cap 2
//  digitalWrite(chargePin2, LOW);    
//  Serial.begin(9600); // Necessary to print data to serial monitor over USB
//
//}
//
//void loop()
//{
//  digitalWrite(chargePin1, LOW); // Stops charging capacitor
//  digitalWrite(chargePin2, LOW);
//  
//  pinMode(dischargePin1, OUTPUT); 
//  pinMode(dischargePin2, OUTPUT);
//  
//  digitalWrite(dischargePin1, LOW); // Allows capacitor to discharge   
//  digitalWrite(dischargePin2, LOW);
//  
//
//  while(analogRead(analogPin1) > 0 or analogRead(analogPin2)>0)
//  {
//    // Do nothing until all capacitors discharged      
//  }
//
//  
//  pinMode(dischargePin1, INPUT); // Prevents capacitor from discharging  
//  pinMode(dischargePin2, INPUT); // Prevents capacitor from discharging
//
//
//
//  
//  startTime1=micros();  //starts time
//  digitalWrite(chargePin1, HIGH); // Begins charging cap1
//
//  startTime2=micros();
//  digitalWrite(chargePin2, HIGH); // Begins charging cap2
//  
//
//  
//  while(analogRead(analogPin1) < 646 and analogRead(analogPin2)<646)
//  {       
//    // Does nothing until a capacitor reaches 63.2% of total voltage
//  }
//
//  
//  if (analogRead(analogPin1)>=646){ // cap1 reached 63.2%, tau is how long it took to reach 63.2%
//    tau1=micros()-startTime1;
//  
//  }
//
//  
////   if (analogRead(analogPin2)>=646&&analogRead(analogPin2<685)){ // cap2 reached 63.2%
////    tau2=micros()-startTime2;   
////  }
////  } 
//  
////  while(analogRead(analogPin1) < 648 and analogRead(analogPin2)<648)
////  {       
////    // Does nothing until a capacitor reaches 63.2% of total voltage
////  }
////  ana1=analogRead(analogPin1)/1023*255;
////  ana2=analogRead(analogPin2)/1023*255;
////  unsigned long checkpoint2=micros();
////  analogWrite(chargePin1, ana1);
////  analogWrite(chargePin2, ana2);
////  
////  
////  if (analogRead(analogPin1)>=648){ // cap1 reached 63.2%, tau is how long it took to reach 63.2%
////    tau1=checkpoint2-startTime1;
////    digitalWrite(chargePin1, LOW);
////  }
////   if (analogRead(analogPin2)>=648){ // cap2 reached 63.2%
////    tau2=checkpoint2-startTime2;
////    digitalWrite(chargePin2, LOW);
////  }
//
//
//  
//  
//  picoFarads1 = ((float)tau1 / resistorValue) * 1000000.0;
//
//  Serial.print(tau1);       
//  Serial.print(" microS    ");         
//      
//  Serial.print((long)picoFarads1);         
//  Serial.println(" picoFarads1"); 
//
//  if (picoFarads1>cap1base){   //prints the cap num if stepped on 
//    Serial.println("1");
// }
//  
//
//
//  
//  picoFarads2 = ((float)tau2 / resistorValue) * 1000000.0;
//
//  Serial.print(tau2);       
//  Serial.print(" microS    ");         
//      
//  Serial.print((long)picoFarads2);         
//  Serial.println(" picoFarads2"); 
//
//  if (picoFarads2>cap2base){   //prints the cap num if stepped on 
//    Serial.println("2");
//  }
//  
//
// 
//  
//
//delay(500);
//  
//
//}


//if cap is stepped on, its num is printed to serial monitor
//so, 1 sensor works--how to connect up multiple? rn, w/ i cap, stepping on it prints 1, but when there are 2 caps, steppping on 2 has no effect, stepping on 1 prints 2 when cap1 code commented out
//with both codes and both sensors, cap of 2 is really big lke 96000, why


//the measured tau of cap2 is higher than it should be b/c the code runs thru all of cap1's stuff first, this makes the cap of cap2 higher than it should be






//working 1 cap sensor

// Initialize cap1
//int analogPin1 = A0;
//int chargePin1 = 13;
//int dischargePin1 = 11; //speeds up discharging process, not necessary though
//long cap1base=11600;  //capacitance of cap1 when not stepped on, tau=116 uS (R=10k)
//
//
//
//// Initialize Resistor
//int resistorValue = 10000.;
//
//// Initialize Timer
//unsigned long startTime1;
//
//
//unsigned long tau1;
//
//
//// Initialize Capacitance Variable               
//float picoFarads1;
//
//
//
//void setup()
//{
//  pinMode(chargePin1, OUTPUT);     //cap 1
//  digitalWrite(chargePin1, LOW);    
//    
//  Serial.begin(9600); // Necessary to print data to serial monitor over USB
//
//}
//
//void loop()
//{
//  digitalWrite(chargePin1, LOW); // Stops charging capacitor
//
//  
//  pinMode(dischargePin1, OUTPUT); 
//
//  
//  digitalWrite(dischargePin1, LOW); // Allows capacitor to discharge   
//
//  
//
//  while(analogRead(analogPin1) > 0 )
//  {
//    // Do nothing until capacitor discharged      
//  }
//
//  
//  pinMode(dischargePin1, INPUT); // Prevents capacitor from discharging  
//
//
//  
//  startTime1=micros();  //starts time
//  digitalWrite(chargePin1, HIGH); // Begins charging cap1
//  
//
//  
//  while(analogRead(analogPin1) < 648)
//  {       
//    // Does nothing until a capacitor reaches 63.2% of total voltage
//  }
//
//  tau1=micros()-startTime1;
//  
//  picoFarads1 = ((float)tau1 / resistorValue) * 1000000.0;
//
//  Serial.print(tau1);       
//  Serial.print(" microS    ");         
//      
//  Serial.print((long)picoFarads1);         
//  Serial.println(" picoFarads1"); 
//
//  if (picoFarads1>cap1base){   //prints the cap num if stepped on 
//    Serial.println("1");
// }
//  
//
//
//
//
//delay(500);
//  
//
//}



//attempt3
int analogPin1 = A0;
int chargePin1 = 11;
int dischargePin1 = 13; //speeds up discharging process, not necessary though
long cap1base=11600;  //capacitance of cap1 when not stepped on, tau=232 uS (R=10k)

// Initialize cap2
int analogPin2 = A1;
int chargePin2 = 6;
int dischargePin2 = 7; //speeds up discharging process, not necessary though
long cap2base=22800;  //capacitance of cap2 when not stepped on


// Initialize Resistor
int resistorValue = 10000;

// Initialize Timer
unsigned long startTime1;
unsigned long startTime2;

unsigned long tau1;
unsigned long tau2;
//
// Initialize Capacitance Variable               
float picoFarads1;
float picoFarads2;



void setup()
{
  pinMode(chargePin1, OUTPUT);     //cap 1
  digitalWrite(chargePin1, LOW);    
    
  Serial.begin(9600); // Necessary to print data to serial monitor over USB

}

void loop()
{
  digitalWrite(chargePin1, LOW); // Stops charging capacitor
  digitalWrite(chargePin2, LOW);

  
  pinMode(dischargePin1, OUTPUT); 
  pinMode(dischargePin2, OUTPUT);
  
  digitalWrite(dischargePin1, LOW); // Allows capacitor to discharge   
digitalWrite(dischargePin2, LOW);
  
//cap1
  while(analogRead(analogPin1) > 0 )
  {
    // Do nothing until capacitor discharged      
  }

  
  pinMode(dischargePin1, INPUT); // Prevents capacitor from discharging  

  
  startTime1=micros();  //starts time
  digitalWrite(chargePin1, HIGH); // Begins charging cap1
  

  
  while(analogRead(analogPin1) < 648)
  {       
    // Does nothing until a capacitor reaches 63.2% of total voltage
  }

  tau1=micros()-startTime1;
  
  picoFarads1 = ((float)tau1 / resistorValue) * 1000000.0;

//  Serial.print(tau1);       
//  Serial.print(" microS    ");         
//      
//  Serial.print((long)picoFarads1);         
//  Serial.println(" picoFarads1"); 

  if (picoFarads1>cap1base){   //prints the cap num if stepped on 
    Serial.println("1");
 }

  
//cap2
while(analogRead(analogPin2) > 0 )
  {
    // Do nothing until capacitor discharged      
  }

  
  pinMode(dischargePin2, INPUT); // Prevents capacitor from discharging  

  
  startTime2=micros();  //starts time
  digitalWrite(chargePin2, HIGH); // Begins charging cap1
  

  
  while(analogRead(analogPin2) < 648)
  {       
    // Does nothing until capacitor reaches 63.2% of total voltage
  }

  tau2=micros()-startTime2;
  
  picoFarads2 = ((float)tau2 / resistorValue) * 1000000.0;
//
//  Serial.print(tau2);       
//  Serial.print(" microS    ");         
//      
//  Serial.print((long)picoFarads2);         
//  Serial.println(" picoFarads2"); 

  if (picoFarads2>cap2base){   //prints the cap num if stepped on 
    Serial.println("2");
 }



delay(500);
  

}

//ok so v3 work lol woo hoo that makes sense, but how will this translate to 15 sensors? if done all sequentially, will there be too much of a delay with cap15?
//like the delay would just be you'd have to stand there for a bit to get the sensor to sense (i think right?) but that could be ok depending on how long that is? do the math/collect data?
