#include "messages.h"

// 2 meters... there are 39.3701 inches in a meter
const float distance_threshold = 2.0 * 39.3701;
const int bluetooth_pin; 
Messages message;
float vi = 3.3/512;
String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete
// calculate distance from analog input: http://www.maxbotix.com/articles/032.htm

void setup() {
  Serial.begin(9600);
  // for bluetooth test
  pinMode(13, OUTPUT);
}

void loop() {
   int distance = read_distance();
  if(distance <= distance_threshold && distance > 0){
      Serial.println("within distance");
  }
  blue_tooth_test();
}
void blue_tooth_test(){
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    switch(inChar) {
      case '1':
        digitalWrite(13, HIGH);
      break;
      case '0':
        digitalWrite(13, LOW);
      break;
    }
    Serial.println(inChar);
  }
}
int read_distance(){
   float distance_sensor = -1;
     // average out over 8 readings   
   int i = 0;
   for (i=0; i<8; i++) {
     distance_sensor += analogRead(0);
     delay(50);
   }
   distance_sensor /= 8;
   distance_sensor = analogRead(0)/vi;
   Serial.println(distance_sensor);
}
void vibrate_motors(){
  
}

