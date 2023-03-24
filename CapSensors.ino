/* code adapted from https://www.instructables.com/Measure-Capacitance-with-Arduino/
 https://docs.arduino.cc/tutorials/generic/capacitance-meter

*/
//initialize caps
int numSensors=10;

int analogPins[]={A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14};

int chargePins[]={22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};

int dischargePins[]={23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53};

//capacitances when not stepped on
long capbases[]={13000, 13000, 13000, 13000, 13000,     13000, 13000, 13000, 13000, 13000,    13000, 13000, 13000, 13000, 13000};


// Initialize Resistor
int resistorValue = 10000;

// Initialize Timer
unsigned long startTimes[]={0, 0, 0 , 0, 0,    0, 0, 0, 0 , 0,    0, 0, 0, 0, 0};

//initilize time constants
unsigned long taus[]={0, 0, 0 , 0, 0,    0, 0, 0, 0 , 0,    0, 0, 0, 0, 0};

// Initialize Capacitance Variables  
float picoFarads[]={0, 0, 0 , 0, 0,    0, 0, 0, 0 , 0,    0, 0, 0, 0, 0};             

//these are the sensor nums of the caps (cap1=10)
int writes[]={0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14};


void setup()
{
  for (int sensor=0; sensor<numSensors; sensor++){
    pinMode(chargePins[sensor], OUTPUT);
    digitalWrite(chargePins[sensor], LOW); 
  }

  Serial.begin(9600); // Necessary to print data to serial monitor over USB

}

void loop(){
  
  for (int sensor=0; sensor<numSensors; sensor++){
    digitalWrite(chargePins[sensor], LOW); //stops charging caps
    pinMode(dischargePins[sensor], OUTPUT);
    digitalWrite(dischargePins[sensor], LOW); //lets caps discharge
    
  }

  //take voltage readings, get tau, find capacitance for each sensor
  for (int sensor=0; sensor<numSensors; sensor++){
    
    while(analogRead(analogPins[sensor])>0){
      // do nothing until cap discharged
    }

    pinMode(dischargePins[sensor],INPUT);  //prevents cap from discharging
    startTimes[sensor]=micros();  //starts time
    digitalWrite(chargePins[sensor], HIGH); // Begins charging cap1
  
    while(analogRead(analogPins[sensor]) < 648){       
    // Does nothing until capacitor reaches 63.2% of total voltage
    }

    taus[sensor]=micros()-startTimes[sensor];
  
    picoFarads[sensor] = ((float)taus[sensor] / resistorValue) * 1000000.0;

    Serial.print(taus[sensor]);       
    Serial.print(" microS    ");         
      
    Serial.print((long)picoFarads[sensor]);         
    Serial.print(" picoFarads");
    Serial.println(sensor+1); 

    if (picoFarads[sensor]>capbases[sensor]){   //prints the cap num if stepped on 
//      Serial.write(writes[sensor]);
      Serial.println(sensor+1);
    }

  }
  delay(500);
}


//base cap is like 11600, but sometimes jumps up a bit to like 12000, so only write if it goes above to like 13000 (22800 is what it is when stepped on)

//also when we have the physical board, how does that aspect effect these sensors (like standing, more pressure from board, idk)

//works great for 2, something funny with 5 (something funny with A4 and A5)
