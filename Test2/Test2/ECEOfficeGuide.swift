//
//  ECEOfficeGuide.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import Foundation

class ECEOfficeGuide : DestinationGuide {
    // function is only called if destination is determined and beacons are in range
    override func goToDesitation(closestBeacon: Int){
        
        if(closestBeacon == MyLocationManager.Beacon.ECE_OFFICE.rawValue){
            arrived()
        }
        else if(closestBeacon == MyLocationManager.Beacon.KUHL_OFFICE.rawValue || closestBeacon == MyLocationManager.Beacon.EAST_TINTERSECTION.rawValue || closestBeacon == MyLocationManager.Beacon.SMALL_HALL.rawValue){
            moveWest()
        }
        else if(closestBeacon == MyLocationManager.Beacon.BATHROOM.rawValue || closestBeacon == MyLocationManager.Beacon.WEST_TINTERSECTION.rawValue) {
            moveNorth()
        }
       
    }

}
