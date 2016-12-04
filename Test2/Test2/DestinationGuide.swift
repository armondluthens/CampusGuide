//
//  DestinationGuide.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//




class DestinationGuide: NSObject {
    
    func goToDesitation(closestBeacon: Int){}
    
    
    func isFacingSouth() -> Bool {
        return false
    }
    
    func isFacingNorth() -> Bool {
        return false
    }
    
    func isFacingEast() -> Bool {
        return false
    }
    
    func isFacingWest() -> Bool {
        return false
    }
    func moveNorth(){
        if(isFacingNorth()){
            moveStraight()
        }
        else if(isFacingSouth()){
            turnAround();
        }
        else if(isFacingEast()){
            turnRight()
        }
        else if(isFacingWest()){
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
    func turnRight(){}
    func turnLeft(){}
    func moveStraight(){}
    func turnAround(){}
    func arrived(){}
    
}
