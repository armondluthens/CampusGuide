#include "messages.h"

// 2 meters... there are 39.3701 inches in a meter
const float distance_threshold = 2.0 * 39.3701;
const int bluetooth_pin; 
Messages message;
float vi = 3.3/512;
// calculate distance from analog input: http://www.maxbotix.com/articles/032.htm

void setup() {
  Serial.begin(9600);

}

void loop() {
  if(read_distance() <= distance_threshold){
      Serial.println("within distance");
  }

}
int read_distance(){
   int distance_sensor = -1;
     // average out over 8 readings   
//   int i = 0;
//   for (i=0; i<8; i++) {
//     distance_sensor += analogRead(0);
//     delay(50);
//   }
//   distance_sensor /= 8;
   distance_sensor = analogRead(0)/vi;
}
void vibrate_motors(){
  
}

