#include "messages.h"
#include "motors.h"

#define DEBUG 1

const float distance_threshold = 2.0 * 40;
const float vi = 3.3/512;
const int motor_pins[MOTOR_COUNT] = {RIGHT, LEFT};
/**
 * description: initialize I/O pins & set up serial for bluetooth
 * */
void setup() {
  Serial.begin(9600);
  pinMode(7, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT); //Just for test. REMOVE THIS LINE.
    
  // initialize motor pins to be outputs
//  for(int i = 0; i < MOTOR_COUNT; i++){
//    pinMode(motor_pins[i], OUTPUT);
//  }
 // digitalWrite(motor_pins[0], OUTPUT)
  
  blink();
  blink();
  blink();
}
/**
 *  reads from the distance sensor, runs bluetooth test
 * */
void loop() {
 //  blink();
//  int distance = read_distance();
//  if(distance <= distance_threshold && distance > 0){
//    #ifdef DEBUG
//      Serial.println("within distance");
//    #endif 
//  }
  
    blue_tooth_test();
 
}
void blink(){
   digitalWrite(7, HIGH);
   delay(1000);
   digitalWrite(7, LOW);
   delay(1000);
}

void blue_tooth_test(){
  // blink();
//  digitalWrite(9, HIGH);
//  delay(1000);
//  digitalWrite(9, LOW);
//  delay(1000);
  // switch LED on & off
  if (Serial.available()) {
    blink();
   // blink();
    // blink();
    
  char inChar = Serial.read();
    switch(inChar) {
      case '1':
       // digitalWrite(7, HIGH);
      break;
      case '0':
        // digitalWrite(7, LOW);
      break;
    }
   // vibrate_motors(inChar - 48);
    Serial.write(inChar);
   }
}

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
   // pulse_single(CENTER);
  }
  else if(message == TURN_AROUND){
   // digitalWrite(CENTER, HIGH);
    delay(500);
    // digitalWrite(CENTER, LOW);
    // digitalWrite(CENTER, HIGH);
    delay(500);
   // digitalWrite(CENTER, LOW);
  }
  else if(message == ARRIVED){
    set_all(HIGH);
    delay(1000);
    set_all(LOW);
  }
  
}

