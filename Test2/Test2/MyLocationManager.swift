//
//  MyLocationManager.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

var myLocationManager: MyLocationManager!

protocol NavigationInstructor{
    
    func receivedNewInstruction(command: String)
    
    func calibrateCommpass(initialReading: Double)
    
    func currentBeaconKnown(closestBeacon: Int)
    
    func currentKnownHeading(heading: String)
}

class MyLocationManager: NSObject, CLLocationManagerDelegate, CommandReceiver {
    
    enum Beacon: Int {
        case ECE_OFFICE = 62098 // w1
        case WEST_TINTERSECTION = 73 // w2
        case SMALL_HALL = 4053 // w3
        case KUHL_OFFICE = 28583 //w4
        case EAST_TINTERSECTION = 43767 //w5
        case BATHROOM = 49435 //w6
        
    }
    enum Direction:Int {
        case RIGHT = 0, LEFT, UTURN, STRAIGHT, ARRIVED
    }
    var directions: Array<String> = ["TURN RIGHT", "TURN LEFT", "MAKE A U TURN", "MOVE STRAIGHT FORWARD", "YOU HAVE ARRIVED" ]
    
    struct Threshold{
        var lower: Double = 0
        var upper: Double = 0
    }
    
    struct Headings {
        var north: Threshold!
        var south: Threshold!
        var west:  Threshold!
        var east: Threshold!
    }
   
    // core location manager
    let locationManager: CLLocationManager = CLLocationManager()
    
    // region is based on that device's proximity to the bluetooth beacon
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID, identifier: "Estimotes")
    
    // NOTE: might make this it's own object
    static var currentHeading: Double = 0.0
    
    private var selectedDestination: MyLocations.Location!
    private var delegate: NavigationInstructor!
    private var calibrate: Int = 0
    private var doCalibrate: Bool = false
    
    static var stopNav: Bool = false
    static var headings: Headings!
    
    // motion test
    // let motionManager: CMMotionManager = CMMotionManager()
    
    init(destination: MyLocations.Location, delegate: NavigationInstructor, calibrate: Bool){
        
        super.init()
        self.delegate = delegate
        selectedDestination = destination
        locationManager.delegate = self
        doCalibrate = calibrate
        
        createGuide()
        
        // authorize location services if not authorized
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization()
        }
        // start ranging beacons with location delegate
        locationManager.startRangingBeacons(in: region)
        
        // start getting compass heading with location delegate
        locationManager.startUpdatingHeading()
        
        print("end of constructor")
        
    }
    func createGuide(){
        if(selectedDestination == MyLocations.Location.KUHL_OFFICE){
            destinationGuide = KuhlOfficeGuide(delegate: self)
        }
        else if(selectedDestination == MyLocations.Location.ECE_OFFICE){
            print("des guide is ece office")
            destinationGuide = ECEOfficeGuide(delegate: self)
        }
        else if(selectedDestination == MyLocations.Location.BATHROOM){
            destinationGuide = BathroomGuide(delegate: self)
        }
        
    }
    func reveiceNewCommand(command: MyLocationManager.Direction){
        
        delegate.receivedNewInstruction(command: directions[command.rawValue])
        
    }
    func currentHeading(heading: String){
        delegate.currentKnownHeading(heading: heading)
    }
    // called when one or more beacons are in range
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0)
        {
            let closestBeacon = knownBeacons[0] as CLBeacon
            let closest:Int = closestBeacon.minor.intValue
            if ( calibrate >= 2 && !MyLocationManager.stopNav) {
                delegate.currentBeaconKnown(closestBeacon: closest)
                destinationGuide.goToDesitation(closestBeacon: closest)
            }
        }
       
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        // let str: String = "accuracy \(newHeading.headingAccuracy)" + "heading \(newHeading.magneticHeading)\n"
       // print(str)
        
        if(calibrate == 1 && doCalibrate){
            print("calibrate compass")
            delegate.calibrateCommpass(initialReading: newHeading.magneticHeading)
        }
        calibrate = calibrate + 1
        MyLocationManager.currentHeading = newHeading.magneticHeading
        //delegate.currentKnownHeading(heading: MyLocationManager.currentHeading)
        
    }

}
