//
//  DestinationGuide.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import Foundation

protocol Guiding {
    
    func goToDesitation(startingPosition: Int)
    
    func moveUpOneBeacon(position: Int)
    
    func moveDownOneBeacon(position: Int)
    
}

class DestinationGuide: NSObject {
    
    func goToDesitation(startingPosition: Int){}
    
    func moveUpOneBeacon(position: Int){}
    
    func moveDownOneBeacon(position: Int){}
}
