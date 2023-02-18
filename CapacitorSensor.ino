/*
Capacitive pressure sensor interface - https://blog.yavilevich.com/
Copyright (c) 2017, AY Garage Ltd.  All rights reserved.
 
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see &lt;http://www.gnu.org/licenses/&gt;.
*/
 
#define TIMEOUT_ATTEMPTS 1000 // how many rounds to do in the loop before deciding to timeout
#define DISCHARGE_FACTOR 4 // how much discharging is slower than charging
 
int readSensor(uint8_t senseAndChargePin)
{
    // pin registers
    // do this once at setup - https://forum.arduino.cc/index.php?topic=337578.0
    uint8_t myPin_mask = digitalPinToBitMask(senseAndChargePin);
    volatile uint8_t *myPin_port = portInputRegister(digitalPinToPort(senseAndChargePin));
 
    // Start charging the capacitor with the internal pullup
    int left = TIMEOUT_ATTEMPTS;
    noInterrupts();
    pinMode(senseAndChargePin, INPUT_PULLUP);
 
    // Charge to a HIGH level, somewhere between 2.6V (practice) and 3V (guaranteed)
    // Best not to use analogRead() here because it's not really quick enough
    // Want to do as little as possible in this loop to get good resolution
    do
    {
        left--;
    } while (((*myPin_port & myPin_mask) == 0) && left>0); // An iteration takes approximately 1us
 
    interrupts();
    pinMode(senseAndChargePin, INPUT);  //Stop charging
    int roundsMade = TIMEOUT_ATTEMPTS - left;
 
    // Discharge is slower than charge, typically goes through a 100K resistor where charge is a ~40K resistor
    // Charge time is approximately "roundsMade" micro-seconds, so use that approximation for discharge delay as well
    delayMicroseconds(roundsMade * DISCHARGE_FACTOR);
 
    return roundsMade;
}
