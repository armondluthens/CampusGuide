#include "messages.h"
#include "motors.h"

#define DEBUG 1

const float distance_threshold = 2.0 * 40;
const float vi = 3.3/512;
const int motor_pins[MOTOR_COUNT] = {RIGHT, LEFT, CENTER};
/**
 * description: initialize I/O pins & set up serial for bluetooth
 * */
void setup() {
  Serial.begin(9600);
  #ifdef DEBUG
    pinMode(13, OUTPUT);
  #endif  
  // initialize motor pins to be outputs
  for(int i = 0; i < MOTOR_COUNT; i++){
    pinMode(motor_pins[i], OUTPUT);
  }
}
/**
 *  reads from the distance sensor, runs bluetooth test
 * */
void loop() {
  int distance = read_distance();
  if(distance <= distance_threshold && distance > 0){
    #ifdef DEBUG
      Serial.println("within distance");
    #endif 
  }
  #ifdef DEBUG
    blue_tooth_test();
  #endif  
}
#ifdef DEBUG
void blue_tooth_test(){
  // switch LED on & off
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
    Serial.println("sent: " + inChar);
  }
}
#endif
/**
 * description: reads the sonar sensor from the analog pin, and then convert to appropriate range
 * calculate distance from analog input: http://www.maxbotix.com/articles/032.html
 * */
int read_distance(){
   float distance_sensor = -1;
   // average out over 8 readings   
   int i = 0;
   for (i=0; i<8; i++) {
     distance_sensor += analogRead(0);
     delay(50);
   }
   distance_sensor /= 8;
}
/**
 * description: sets all of the motor pins to high or low
 **/
void set_all(int level){
  
  for(int i = 0; i < MOTOR_COUNT; i++){
      digitalWrite(motor_pins[i], level);
  }
}
/**
 * description: sets a single pin high then low
 **/
void pulse_single(int pin){
   digitalWrite(pin, HIGH);
   delay(1000);
   digitalWrite(pin, LOW);
}
/**
 * desciption: depending on the message, vibrate the appropriate motors
 **/
void vibrate_motors(int message){
  
  if(message == OBJECT_DETECTED){
    set_all(HIGH);
    delay(500);
    set_all(LOW);
    delay(500);
    set_all(HIGH);
    delay(500);
    set_all(LOW);
  }
  else if(message == TURN_RIGHT){
    pulse_single(RIGHT);
  }
  else if(message == TURN_LEFT){
    pulse_single(LEFT);
  }
  else if(message == MOVE_STRAIGHT){
    pulse_single(CENTER);
  }
  else if(message == TURN_AROUND){
    digitalWrite(CENTER, HIGH);
    delay(500);
    digitalWrite(CENTER, LOW);
    digitalWrite(CENTER, HIGH);
    delay(500);
    digitalWrite(CENTER, LOW);
  }
  else if(message == ARRIVED){
    set_all(HIGH);
    delay(1000);
    set_all(LOW);
  }
  
}

