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

    /*--------------------------------
        Destination Options:
        1. ECE Office
        2. Professor Kuhl's Office
        3. 4th Floor Bathroom
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
                else if (selectedDestination == 2){
                    if(secondClosest != w2){
                        currentDirections = "Turn around and proceed the opposite way"
                    }
                    else{
                        currentDirections = "Proceed toward the stairwell"
                    }
                }
                else{
                    if(secondClosest != w2){
                        currentDirections = "Turn around and proceed the opposite way"
                    }
                    else{
                        currentDirections = "Proceed toward the stairwell"
                    }
                }
                //pastLocation = 1
            }
                
            //You are closest to Worksation 2
            else if(closest == w2){
                if (selectedDestination == 1){
                    currentDirections = "Turn around and proceed forward"

                }
                else if (selectedDestination == 2){
                    currentDirections = "Turn right and proceed forward"
                }
                else{
                    currentDirections = "Turn right and proceed forward"
                }

            /* orientation problems
 
                //starting point
                if(pastLocation == 0){
                    
                    if (selectedDestination == 1){
                        currentDirections = "Turn right and proceed forward"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "Continue forward"
                    }
                    else{
                        currentDirections = "Continue forward"
                    }
                
                }
                //coming from ECE office
                else if(pastLocation == 1){
                    if (selectedDestination == 1){
                        currentDirections = "Turn around and walk straight"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "Turn right and proceed forward"
                    }
                    else{
                        currentDirections = "Turn right and proceed forward"

                    }
                }
                //coming from hallway
                else{
                    if (selectedDestination == 1){
                        //turn left and walk straight
                        currentDirections = "Turn left and walk straight"
                    }
                    else if (selectedDestination == 2){
                        //turn around and walk straight
                        currentDirections = "Turn around and walk straight"
                    }
                    else{
                        //turn around and walk straight
                        currentDirections = "Turn around and walk straight"
                    }

                }
                //pastLocation = 2
            */
            }
                
            //You are closest to Worksation 3
            else if(closest == w3){
                if (selectedDestination == 1){
                    currentDirections = "Turn around and proceed forward"
                    
                }
                else if (selectedDestination == 2){
                    currentDirections = "Continue forward"
                }
                else{
                    currentDirections = "Continue forward"
                }
                
                /* orientation problems
 
                if(pastLocation == 0){
                    if (selectedDestination == 1){
                    }
                    else if (selectedDestination == 2){
                    }
                    else{
                    }
                }
                //coming from stairs
                else if(pastLocation == 2){
                    if (selectedDestination == 1){
                        currentDirections = "Turn around and walk straight"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "Continue forward"
                    }
                    else{
                        currentDirections = "Continue forward"
                    }
                }
                //coming from hallway
                else{
                    if (selectedDestination == 1){
                        currentDirections = "Continue forward"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "Turn around and walk straight"
                    }
                    else{
                        currentDirections = "Turn around and walk straight"
                    }
                }
                //pastLocation = 3
            */
            }
                
            //You are closest to Worksation 4
            else if(closest == w4){
                if (selectedDestination == 1){
                    currentDirections = "Turn around and proceed forward"
                    
                }
                else if (selectedDestination == 2){
                    currentDirections = "You have reached Professor Kuhl's Office"
                }
                else{
                    currentDirections = "Continue forward"
                }

                
                /*
                if(pastLocation == 0){
                 
                    if (selectedDestination == 1){
                    }
                    else if (selectedDestination == 2){
                    }
                    else{
                    }
                }
                //coming from ECE office direction
                else if(pastLocation == 3){
                    if (selectedDestination == 1){
                        currentDirections = "Turn around and walk straight"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "You have reached Professor Kuhl's Office!"
                    }
                    else{
                        currentDirections = "Continue forward"
                    }
                }
                //coming from hallway opposite ECE office
                else{
                    if (selectedDestination == 1){
                        currentDirections = "Continue forward"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "You have reached Professor Kuhl's Office!"                    }
                    else{
                        currentDirections = "Turn around and walk straight"
                    }
                    
                }
                pastLocation = 4
                */
            }
            
            else if(closest == w5){
                if (selectedDestination == 1){
                    currentDirections = "Turn around and proceed forward"
                    
                }
                else if (selectedDestination == 2){
                    currentDirections = "Turn around and proceed forward"
                }
                else{
                    currentDirections = "Turn left"
                }
                /*
                if(pastLocation == 0){
                    if (selectedDestination == 1){
                    }
                    else if (selectedDestination == 2){
                    }
                    else{
                    }
                }
                    //coming from ECE office direction
                else if(pastLocation == 4){
                    if (selectedDestination == 1){
                        currentDirections = "Turn around and walk straight"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "Turn around and walk straight"
                    }
                    else{
                        currentDirections = "Turn left and walk straight"
                    }
                }
                //coming from bathroom
                else{
                    if (selectedDestination == 1){
                        currentDirections = "Turn right and walk straight"
                    }
                    else if (selectedDestination == 2){
                        currentDirections = "Turn right and walk straight"                   }
                    else{
                        currentDirections = "Turn around and walk straight"
                    }
                }
                pastLocation = 5
            */
            }

            
            
            //self.view.backgroundColor = self.colors[closestBeacon.minor.intValue]
            //self.closestWorkstation.text = self.workstation[nextClosest]
            
            self.text.text = self.workstation[closestBeacon.minor.intValue]
            self.closestWorkstation.text = self.workstation[secondClosestBeacon.minor.intValue]
            
            
            self.directionsMessage.text = currentDirections
            
        }
        
    }

    
    
}
















































