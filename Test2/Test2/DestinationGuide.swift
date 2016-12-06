//
//  DestinationGuide.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//


var destinationGuide: DestinationGuide!

protocol CommandReceiver {
    
    func reveiceNewCommand(command: MyLocationManager.Direction);
}

class DestinationGuide: NSObject {
    
    private var delegate: CommandReceiver!
    
    init(delegate: CommandReceiver){
        self.delegate = delegate
    }
    
    func goToDesitation(closestBeacon: Int){}
    
    
    func isFacingSouth() -> Bool {
        if((MyLocationManager.currentHeading) > Double(MyLocationManager.headings.south.lower) &&
            (MyLocationManager.currentHeading) < Double(MyLocationManager.headings.south.upper)){
            return true
        }
        else{
            return false
        }
    
        
        
    }
    
    func isFacingNorth() -> Bool {
//        print("is facing north")
//        print("current heading")
//        print(MyLocationManager.currentHeading)
//        print(Double(MyLocationManager.headings.north.lower))
        if((MyLocationManager.currentHeading) > Double(MyLocationManager.headings.north.lower) &&
            (MyLocationManager.currentHeading) < Double(MyLocationManager.headings.north.upper)){
            return true
        }
        else{
            return false
        }
      //  return false
    }
    
    func isFacingEast() -> Bool {
        if((MyLocationManager.currentHeading) > Double(MyLocationManager.headings.east.lower) &&
            (MyLocationManager.currentHeading) < Double(MyLocationManager.headings.east.upper)){
            return true
        }
        else{
            return false
        }
    }
    
    func isFacingWest() -> Bool {
        if((MyLocationManager.currentHeading) > Double(MyLocationManager.headings.west.lower) &&
            (MyLocationManager.currentHeading) < Double(MyLocationManager.headings.west.upper)){
            return true
        }
        else{
            return false
        }
    }
    func moveNorth(){
        print("move north")
        if(isFacingNorth()){
            print("straight")
            moveStraight()
        }
        else if(isFacingSouth()){
            print("u turn")
            turnAround();
        }
        else if(isFacingEast()){
            print("right")
            turnRight()
        }
        else if(isFacingWest()){
            print("left")
            turnLeft();
        }
        else{
            print("error determining orientation")
        }
    }
    func moveSouth(){
        if(isFacingNorth()){
            turnAround()
        }
        else if(isFacingSouth()){
            moveStraight()
            
        }
        else if(isFacingEast()){
            turnLeft()
        }
        else if(isFacingWest()){
            turnRight();
        }
        else{
            print("error determining orientation")
        }
    }
    func moveEast(){
        if(isFacingNorth()){
            turnLeft()
        }
        else if(isFacingSouth()){
            turnRight()
        }
        else if(isFacingEast()){
            moveStraight()
        }
        else if(isFacingWest()){
            turnAround()
        }
        else{
            print("error determining orientation")
        }
    }
    func moveWest(){
        if(isFacingNorth()){
            turnRight()
        }
        else if(isFacingSouth()){
           turnLeft()
        }
        else if(isFacingEast()){
           turnAround()
        }
        else if(isFacingWest()){
            moveStraight()
        }
        else{
            print("error determining orientation")
        }
    }
    func turnRight() {
        sendUpdatedCommand(myCommand: MyLocationManager.Direction.RIGHT)
    }
    func turnLeft() {
        sendUpdatedCommand(myCommand: MyLocationManager.Direction.LEFT)
    }
    func moveStraight() {
        sendUpdatedCommand(myCommand: MyLocationManager.Direction.STRAIGHT)
    }
    func turnAround() {
        sendUpdatedCommand(myCommand: MyLocationManager.Direction.UTURN)
    }
    func arrived() {
        sendUpdatedCommand(myCommand: MyLocationManager.Direction.ARRIVED)
    }
    func sendUpdatedCommand(myCommand: MyLocationManager.Direction){
        delegate.reveiceNewCommand(command: myCommand)
    }
    
}
