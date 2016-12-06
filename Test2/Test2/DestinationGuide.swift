//
//  DestinationGuide.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//


var destinationGuide: DestinationGuide!

protocol CommandReceiver {
    
    func reveiceNewCommand(command: MyLocationManager.Direction)
    
    func currentHeading(heading: String)
    
}

class DestinationGuide: NSObject {
    
    private var delegate: CommandReceiver!
    
    init(delegate: CommandReceiver){
        self.delegate = delegate
    }
    
    func goToDesitation(closestBeacon: Int){
        
    }
    
    
    func isFacingSouth() -> Bool {
        if((MyLocationManager.currentHeading) > Double(MyLocationManager.headings.south.lower) &&
            (MyLocationManager.currentHeading) < Double(MyLocationManager.headings.south.upper)){
            delegate.currentHeading(heading: "SOUTH")
            return true
        }
        else{
            return false
        }

    }
    
    func isFacingNorth() -> Bool {
        print("current heading north: \(MyLocationManager.currentHeading)")
        print("north: > \(Double(MyLocationManager.headings.north.lower)) < \(Double(MyLocationManager.headings.north.upper))")
        
        var lowerIncrease: Double = 0.0
        var upperIncrease: Double = 0.0
        if(MyLocationManager.headings.north.lower > 300 && MyLocationManager.currentHeading < 50){
            lowerIncrease = 360
        }
        else if(MyLocationManager.headings.north.lower < 50 && MyLocationManager.currentHeading > 300){
            upperIncrease = -360
        }
        if((MyLocationManager.currentHeading + lowerIncrease) > Double(MyLocationManager.headings.north.lower) &&
            (MyLocationManager.currentHeading) < abs(Double(MyLocationManager.headings.north.upper + upperIncrease))){
            delegate.currentHeading(heading: "NORTH")
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
            delegate.currentHeading(heading: "EAST")
            return true
        }
        else{
            return false
        }
    }
    
    func isFacingWest() -> Bool {
        if((MyLocationManager.currentHeading) > Double(MyLocationManager.headings.west.lower) &&
            (MyLocationManager.currentHeading) < Double(MyLocationManager.headings.west.upper)){
            delegate.currentHeading(heading: "WEST")
            return true
        }
        else{
            return false
        }
    }
    func moveNorth(){
        print("move north")
//        if(isFacingNorth()){
//            print("straight")
//            moveStraight()
//        }
        if(isFacingSouth()){
            print("u turn")
            turnAround();
        }
        else if(isFacingEast()){
            print("right")
            turnLeft()
        }
        else if(isFacingWest()){
            print("left")
            turnRight();
        }
        else{
            //print("error determining orientation")
            moveStraight() //default to north
            delegate.currentHeading(heading: "NORTH")
        }
    }
    func moveSouth(){
//        if(isFacingNorth()){
//            turnAround()
//        }
        if(isFacingSouth()){
            moveStraight()
            
        }
        else if(isFacingEast()){
            turnRight()
        }
        else if(isFacingWest()){
            turnLeft();
        }
        else{
            //print("error determining orientation")
            turnAround() //default to north
            delegate.currentHeading(heading: "NORTH")
        }
    }
    func moveEast(){
//        if(isFacingNorth()){
//            turnRight()
//        }
        if(isFacingSouth()){
            turnLeft()
        }
        else if(isFacingEast()){
            moveStraight()
        }
        else if(isFacingWest()){
            turnAround()
        }
        else{
            //print("error determining orientation")
            turnRight() //default to north
            delegate.currentHeading(heading: "NORTH")
        }
    }
    func moveWest(){
//        if(isFacingNorth()){
//            turnLeft()
//        }
        if(isFacingSouth()){
           turnRight()
        }
        else if(isFacingEast()){
           turnAround()
        }
        else if(isFacingWest()){
            moveStraight()
        }
        else{
            print("error determining orientation")
            turnLeft() //default to north
            delegate.currentHeading(heading: "NORTH")
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
