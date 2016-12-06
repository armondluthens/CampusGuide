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
        
        //print("ece go to des")
        //super.moveNorth()
       
        if(closestBeacon == MyLocationManager.Beacon.ECE_OFFICE.rawValue){
            print("arrived")
            super.arrived()
        }
        else if(closestBeacon == MyLocationManager.Beacon.KUHL_OFFICE.rawValue || closestBeacon == MyLocationManager.Beacon.EAST_TINTERSECTION.rawValue || closestBeacon == MyLocationManager.Beacon.SMALL_HALL.rawValue){
            print("east")
            super.moveEast()
        }
        else if(closestBeacon == MyLocationManager.Beacon.BATHROOM.rawValue || closestBeacon == MyLocationManager.Beacon.WEST_TINTERSECTION.rawValue) {
            print("north")
            super.moveNorth()
        }
        
          // test
//        if(closestBeacon == MyLocationManager.Beacon.WEST_TINTERSECTION.rawValue){
//            super.moveNorth()
//        }
//        else if(closestBeacon == MyLocationManager.Beacon.ECE_OFFICE.rawValue){
//            super.arrived()
//        }
       
    }

}
