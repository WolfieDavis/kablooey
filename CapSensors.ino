/* code adapted from https://www.instructables.com/Measure-Capacitance-with-Arduino/
 https://docs.arduino.cc/tutorials/generic/capacitance-meter

*/
//initialize caps
int num_sensors=2;

int analogPins[]={A0, A1, A2, A3, A4, A5, A6};

int chargePins[]={0, 2, 4, 6, 8, 10};

int dischargePins[]={1, 3, 5, 7, 9, 11};


//capacitances when not stepped on
long capbases[]={11600, 22800};


// Initialize Resistor
int resistorValue = 10000;

// Initialize Timer
unsigned long startTimes[]={ };

//initilize time constants
unsigned long taus[]={ };

// Initialize Capacitance Variables  
float picoFarads[]={};             

//these are the sensor nums of the caps (cap1=10)
int writes[]={10, 11, 12, 13, 14, 15};


void setup()
{
  for (int sensor=0; sensor<num_sensors; sensor++){
    pinMode(chargePins[sensor], OUTPUT);
    digitalWrite(chargePins[sensor], LOW); 
  }

  Serial.begin(9600); // Necessary to print data to serial monitor over USB

}

void loop(){
  
  for (int sensor=0; sensor<num_sensors; sensor++){
    digitalWrite(chargePins[sensor], LOW); //stops charging caps
    pinMode(dischargePins[sensor], OUTPUT);
    digitalWrite(dischargePins[sensor], LOW); //lets caps discharge
    
  }

  //take voltage readings, get tau, find capacitance for each sensor
  for (int sensor=0; sensor<num_sensors; sensor++){
    
    while(analogRead[sensor]>0){
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
    Serial.println(sensor); 

    if (picoFarads[sensor]>capbases[sensor]){   //prints the cap num if stepped on 
//      Serial.write(writes[sensor]);
      Serial.println(sensor);
    }

  }
}

//how will this translate to 15 sensors? if done all sequentially, will there be too much of a delay with cap15? prob not hopefully
//like the delay would just be you'd have to stand there for a bit to get the sensor to sense (i think right?) but that could be ok depending on how long that is? do the math/collect data?
//cap1=number 10
//arrays for pin vars
