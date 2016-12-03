//
//  MyLocationManager.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import Foundation
import CoreLocation

class MyLocationManager: NSObject, CLLocationManagerDelegate {
    
    enum Beacon: Int {
        case ECE_OFFICE = 62098
        case TWO = 73
        case THREE = 4053
        case KUHL_OFFICE = 28583
        case FIVE = 43767
        case BATHROOM = 49435
        
    }
    
    // core location manager
    private let locationManager: CLLocationManager = CLLocationManager()
    
    // region is based on that device's proximity to the bluetooth beacon
    // QUESTION: does it matter which beacon?
    private let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID, identifier: "Estimotes")
    
    // NOTE: might make this it's own object
    private var currentHeading: Double = 0.0
    
    private var selectedDestination: MyLocations.Location!
    
    private var destinationGuide: DestinationGuide!;
    
    init(destination: MyLocations.Location){
        
        super.init()
        selectedDestination = destination
        locationManager.delegate = self
        
        // authorize location services if not authorized
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization()
        }
        // start ranging beacons with location delegate
        locationManager.startRangingBeacons(in: region)
        // start getting compass heading with location delegate
        locationManager.startUpdatingHeading()
    }
    // called when one or more beacons are in range
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0)
        {
            let closestBeacon = knownBeacons[0] as CLBeacon
            let closest:Int = closestBeacon.minor.intValue
            
            if(selectedDestination == MyLocations.Location.KUHL_OFFICE){
                destinationGuide = KuhlOfficeGuide()
            }
            else if(selectedDestination == MyLocations.Location.ECE_OFFICE){
                destinationGuide = ECEOfficeGuide()
            }
            else if(selectedDestination == MyLocations.Location.RESTROOM){
                destinationGuide = BathroomGuide()
            }
            destinationGuide.goToDesitation(startingPosition: closest)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {}
    
   
    
    
    
    
}
