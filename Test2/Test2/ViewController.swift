//
//  ViewController.swift
//  Test2
//
//  Created by Armond Luthens on 10/5/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
   
    let locationManager = CLLocationManager()
    //let compassLocationManager = CLLocationManager()
    
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID, identifier: "Estimotes")
    
    let colors = [
        //purple --> estimote beacon: blueberry1
        62098: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        
        //green --> estimote beacon: mint1
        73: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1),
        
        //? --> estimote beacon: mint
        4053: UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1),
        
        //? --> estimote beacon: blueberry
        28583: UIColor(red: 75/255, green: 175/255, blue: 125/255, alpha: 1),
        
        //? --> estimote beacon: ice
        43767: UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    ]
    
    let workstation = [
        62098: "Workstation 1",
        73: "Workstation 2",
        4053: "Workstation 3",
        28583: "Workstation 4",
        43767: "Workstation 5"
    ]
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var closestWorkstation: UILabel!
    @IBOutlet weak var directionsMessage: UILabel!
    @IBOutlet weak var displaySelectDestination: UILabel!
    
    var pastLocation = 0
    
    var currentHeading:Double = 0.0

    /*--------------------------------
        Destination Options:
        1. ECE Office
        2. Professor Kuhl's Office
        3. 4th Floor Bathroom
     
     armond git test
    --------------------------------*/
    
    var selectedDestination = 1;
    
    @IBAction func ece(_ sender: AnyObject) {
        selectedDestination = 1
    }
    
    @IBAction func kuhl(_ sender: AnyObject) {
        selectedDestination = 2
    }
    
    @IBAction func restroom(_ sender: AnyObject) {
        selectedDestination = 3
    }
    
    

    var destinationList = ["Workstation 2", "Workstation 3", "Workstation 4", "Workstation 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        //COMPASS HEADING STUFF
        
        //compassLocationManager.delegate = self
        
        locationManager.startUpdatingHeading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        let w1 = 62098
        let w2 = 73
        let w3 = 4053
        let w4 = 28583
        let w5 = 43767

        var closest=0
        var secondClosest=0
        var currentDirections=""
        var curDes=""
        
        print(beacons) //printing beacon info to console for testing
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            
            let closestBeacon = knownBeacons[0] as CLBeacon
            let secondClosestBeacon = knownBeacons[1] as CLBeacon
            closest = closestBeacon.minor.intValue
            secondClosest = secondClosestBeacon.minor.intValue
            
            

            if(selectedDestination == 1){
                curDes = "Selected Destination: ECE Office"
            }
            else if(selectedDestination == 2){
                curDes = "Selected Destination: Kuhl's Office"
            }
            else{
                curDes = "Selected Destination: 4th Floor Bathroom"
            }
            self.displaySelectDestination.text = curDes
            
            
            //You are closest to Workstation 1
            if(closest == w1){
                
                if (selectedDestination == 1){
                    currentDirections = "You are at the ECE office!"
                }
                else {
                    if(currentHeading < 140.0){
                        currentDirections = "Turn in place to your right"
                    }
                    else if(currentHeading > 200.0){
                        currentDirections = "Turn in place to your left"
                    }
                    else{
                        currentDirections = "Proceed Straight"
                    }
                }
            }
                
            //You are closest to Worksation 2
            else if(closest == w2){
                if (selectedDestination == 1){
                    if(currentHeading > 160.0 && currentHeading < 320.0){
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading <= 160.0 && currentHeading > 20.0){
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        currentDirections = "Proceed Forward"
                    }
                }
                else{
                    if(currentHeading < 230.0){
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 290.0){
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        currentDirections = "Proceed Forward"
                    }
                }
            }
                
            else if(closest == w3){
                currentDirections = "no reading"
                /*
                if (selectedDestination == 1){
                    
                }
                else{
                    if(currentHeading < 230.0){
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 270.0){
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        currentDirections = "Proceed Forward"
                    }

                }
                */
                
            }

            else if(closest == w4){
                currentDirections = "no reading"
                /*
                if (selectedDestination == 1){
                    
                }
                else if (selectedDestination == 2){
                    currentDirections = "You have reached Professor Kuhl's Office"
                }
                else{
                    
                }
                */
            }
            else if(closest == w5){
                currentDirections = "no reading"
                /*
                if (selectedDestination == 1){
                    
                }
                else if (selectedDestination == 2){
                    
                }
                else{
                    
                }
                */
            }

            //print the beacon you are closest to
            self.text.text = self.workstation[closestBeacon.minor.intValue]
            
            //provide current directions to user
            self.directionsMessage.text = currentDirections
            
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading!) {
        currentHeading = newHeading.magneticHeading
        let headingString:String = String(currentHeading)
        self.closestWorkstation.text = headingString
    }
    
    
}
















































