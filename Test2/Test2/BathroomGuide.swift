//
//  BathroomGuide.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import Foundation

class BathroomGuide : DestinationGuide {
    
    override func goToDesitation(closestBeacon: Int){
        
        if(closestBeacon == MyLocationManager.Beacon.BATHROOM.rawValue){
            arrived()
        }
        else if(closestBeacon == MyLocationManager.Beacon.EAST_TINTERSECTION.rawValue || closestBeacon == MyLocationManager.Beacon.ECE_OFFICE.rawValue){
            moveSouth()
        }
        else if(closestBeacon == MyLocationManager.Beacon.SMALL_HALL.rawValue || closestBeacon == MyLocationManager.Beacon.EAST_TINTERSECTION.rawValue || closestBeacon == MyLocationManager.Beacon.KUHL_OFFICE.rawValue){
            moveEast()
        }
    }
}
