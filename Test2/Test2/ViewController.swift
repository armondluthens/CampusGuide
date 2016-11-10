//
//  ViewController.swift
//  Test2
//
//  Created by Armond Luthens on 10/5/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    /*----------------------------------------------------------------
        Define Delegates
     ----------------------------------------------------------------*/
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID, identifier: "Estimotes")
    
    
    
    let workstation = [
        62098: "Workstation 1",
        73: "Workstation 2",
        4053: "Workstation 3",
        28583: "Workstation 4",
        43767: "Workstation 5"
    ]
    
    /*----------------------------------------------------------------
        Define Global Variables
    ----------------------------------------------------------------*/
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var closestWorkstation: UILabel!
    @IBOutlet weak var directionsMessage: UILabel!
    @IBOutlet weak var displaySelectDestination: UILabel!
    
    var currentHeading:Double = 0.0
    var selectedDestination = 1;
    
    var commandLeftCount = 0
    var commandRightCount = 0
    var commandStraightCount = 0
    var ECEcount = 0
    var KuhlCount = 0
    var restroomCount = 0
    

    /*----------------------------------------------------------------
     UI Button Action Methods:
     
     Destination Options:
        1. ECE Office
        2. Professor Kuhl's Office
        3. 4th Floor Bathroom
    ----------------------------------------------------------------*/
    @IBAction func ece(_ sender: AnyObject) {
        selectedDestination = 1
    }
    
    @IBAction func kuhl(_ sender: AnyObject) {
        selectedDestination = 2
    }
    
    @IBAction func restroom(_ sender: AnyObject) {
        selectedDestination = 3
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region) //start ranging beacons with location delegate
        locationManager.startUpdatingHeading() //start getting compass heading with location delegate
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
        let w6 = 49435
        
        let commandLeft = "Stop. Turn in place to your left"
        let commandRight = "Stop. Turn in place to your right"
        let commandStraight = "Proceed Forward"
        //let commandDestination = "You have reached your destination"

        var closest=0
        //var secondClosest=0
        var currentDirections=""
        var curDes=""
        
        print(beacons) //printing beacon info to console for testing
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            
            let closestBeacon = knownBeacons[0] as CLBeacon
            closest = closestBeacon.minor.intValue
            
            //let secondClosestBeacon = knownBeacons[1] as CLBeacon
            //secondClosest = secondClosestBeacon.minor.intValue
            
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
                    //commandDestination
                    currentDirections = "You are at the ECE office!"
                    if(ECEcount == 0){
                        textToSpeech(wordsToSay: "You are at the ECE office!")
                        ECEcount=ECEcount + 1
                    }
                    
                }
                else {
                    if(currentHeading < 140.0){
                        //commandRight
                        currentDirections = "Turn in place to your right"
                        textToSpeech(wordsToSay: commandRight)
                    }
                    else if(currentHeading > 200.0){
                        //commandLeft
                        currentDirections = "Turn in place to your left"
                        textToSpeech(wordsToSay: commandLeft)
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Straight"
                        textToSpeech(wordsToSay: commandStraight)
                    }
                }
            }
                
            //You are closest to Worksation 2
            else if(closest == w2){
                if (selectedDestination == 1){
                    if(currentHeading > 160.0 && currentHeading < 320.0){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading <= 160.0 && currentHeading > 20.0){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
                else{
                    if(currentHeading < 230.0){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 290.0){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
            }
            
            //You are closest to Worksation 3
            else if(closest == w3){
                if (selectedDestination == 1){
                    //ideal range: 50 deg - 110 deg
                    if(currentHeading < 50){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 110){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
                else{
                    if(currentHeading < 230.0){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 290.0){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
            }
            
            //You are closest to Worksation 4
            else if(closest == w4){
                if (selectedDestination == 1){
                    //ideal range: 50 deg - 110 deg
                    if(currentHeading < 50){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 110){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
                else if (selectedDestination == 2){
                    //commandDestination
                    currentDirections = "You have reached Professor Kuhl's Office"
                }
                else{
                    if(currentHeading < 230.0){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 290.0){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
            }
            
            //You are closest to Worksation 5
            else if(closest == w5){
                //ideal range: 50 deg - 110 deg
                if (selectedDestination == 1 || selectedDestination == 2){
                    if(currentHeading < 50){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 110){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
                //ideal range: 140 deg - 200 deg
                else{
                    if(currentHeading < 140){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else if(currentHeading > 200){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                }
            }
            
            //You are closest to Worksation 6
            else if(closest == w6){
                 if (selectedDestination == 1 || selectedDestination == 2){
                    //ideal range: 320 deg to 20 deg
                    if(currentHeading < 170 && currentHeading > 20){
                        //commandLeft
                        currentDirections = "Stop. Turn in place to your left"
                    }
                    else if(currentHeading >= 170 && currentHeading < 320){
                        //commandRight
                        currentDirections = "Stop. Turn in place to your right"
                    }
                    else{
                        //commandStraight
                        currentDirections = "Proceed Forward"
                    }
                 }
                 else{
                    //commandDestination
                    currentDirections = "You have reached the bathroom"
                 }
                
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
    
    func textToSpeech(wordsToSay: String) {
        let synth = AVSpeechSynthesizer()
        var myUtterance = AVSpeechUtterance(string: "")
        myUtterance = AVSpeechUtterance(string: wordsToSay)
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
    }
    
    
}
















































