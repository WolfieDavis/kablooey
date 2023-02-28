/* code adapted from https://www.instructables.com/Measure-Capacitance-with-Arduino/
 https://docs.arduino.cc/tutorials/generic/capacitance-meter

*/
//initialize caps
int numSensors=5;

int analogPins[]={A0, A1, A2, A3, A4, A5};

int chargePins[]={13, 11, 9, 7, 5, 3};

int dischargePins[]={12, 10, 8, 6, 4, 2};


//capacitances when not stepped on
long capbases[]={13000, 13000, 13000, 13000, 13000, 13000, 13000};


// Initialize Resistor
int resistorValue = 10000;

// Initialize Timer
unsigned long startTimes[]={0, 0, 0 , 0, 0, 0 };

//initilize time constants
unsigned long taus[]={ 0, 0, 0, 0, 0, 0};

// Initialize Capacitance Variables  
float picoFarads[]={0, 0, 0, 0, 0, 0,};             

//these are the sensor nums of the caps (cap1=10)
int writes[]={10, 11, 12, 13, 14, 15};


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

//how will this translate to 15 sensors? if done all sequentially, will there be too much of a delay with cap15? prob not hopefully
//like the delay would just be you'd have to stand there for a bit to get the sensor to sense (i think right?) but that could be ok depending on how long that is? do the math/collect data?
//cap1=number 10
//arrays for pin vars
//yee it works for 2! now hook up 6 sensors, but first, hook up 2 at a time to check if they all have 11600 as base cap

//base cap is like 11600, but sometimes jumps up a bit to like 12000, so only write if it goes above to like 13000 (22800 is what it is when stepped on)

//also when we have the physical board, how does that aspect effect these sensors (like standing, more pressure from board, idk)

//works great for 2, something funny with 5 (could be just hooking up wrong) or maybe it's the sensors themsleves (check 3,4,5 again)
//working caps have duct tape
//can do 4 sensors well

//make extra sensors to use if something if funny with one?
