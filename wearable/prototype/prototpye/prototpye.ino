#include "messages.h"

// 2 meters... there are 39.3701 inches in a meter
const float distance_threshold = 2.0 * 39.3701;
const int bluetooth_pin; 
Messages message;
float vi = 3.3/512;
const int motor_pins[] = {2, 3, 4};
// calculate distance from analog input: http://www.maxbotix.com/articles/032.htm

void setup() {
  Serial.begin(9600);
  // for bluetooth test
  pinMode(13, OUTPUT);
  // initialize motor pins to be outputs
  for(int i = 0; i < 3; i++){
    pinMode(motor_pins[i], OUTPUT);
  }
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
    vibrate_motors(inChar - 48);
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
   // Serial.println(distance_sensor);
}
void set_all(int level){
  
  for(int i = 0; i < 3; i++){
      digitalWrite(motor_pins[i], level);
  }
}
void vibrate_motors(int message){
  if(message == OBJECT_DETECTED){
    Serial.println("obj");
    set_all(HIGH);
    delay(500);
    set_all(LOW);
    delay(500);
    set_all(HIGH);
    delay(500);
    set_all(LOW);
  }
  else if(message == TURN_RIGHT){
    
  }
  else if(message == TURN_LEFT){
    
  }
  else if(message == MOVE_STRAIGHT){
    
  }
  else if(message == TURN_AROUND){
  }
  else if(message == ARRIVED){
  }
  
}

