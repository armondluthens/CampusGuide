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
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate, MyBluetoothManager {
    
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
    var previousMessage=""
    var headingReadCount=0
    
    var calibrated = false
    
    
    var lastVoiceCommand = 0
    
    var NORTH=0
    var EAST=0
    var SOUTH=0
    var WEST=0
    
    var NORTHWEST=0
    var NORTHEAST=0
    var SOUTHWEST=0
    var SOUTHEAST=0
    
    /*----------------------------------------------------------------
     UI Button Action Methods:
     
     Destination Options:
        1. ECE Office
        2. Professor Kuhl's Office
        3. 4th Floor Bathroom
    ----------------------------------------------------------------*/
    @IBAction func ece(_ sender: AnyObject) {
//        if(myBluetooth.isReady){
//            myBluetooth.sendMessageToWearable(string: "0")
//        }
        selectedDestination = 1
    }
    
    @IBAction func kuhl(_ sender: AnyObject) {
        selectedDestination = 2
        print("in kuhl")
        //speaker.speak(wordsToSay: "test string")
    }
    
    @IBAction func restroom(_ sender: AnyObject) {
        selectedDestination = 3
    }
    
    func failedToConnectToPeripheral(_ peripheral: CBPeripheral, error: NSError?) {
        
        directionsMessage.text = "error"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up region
//        self.region.notifyEntryStateOnDisplay = true
//        self.region.notifyOnEntry = true
//        self.region.notifyOnExit = true
//        
//        myBluetooth = MyBluetooth(delegate: self)
        locationManager.delegate = self;
//        
//        speechRecognizer = SpeechRecognizer()
//        speaker = Speaker()
        

        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        // start ranging beacons with location delegate
        locationManager.startRangingBeacons(in: region)
        
        
        // start getting compass heading with location delegate
        locationManager.startUpdatingHeading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //beacons
        let w1 = 62098
        let w2 = 73
        let w3 = 4053
        let w4 = 28583
        let w5 = 43767
        let w6 = 49435
        
        //walking commands
        let commandLeft = "Stop. Turn in place to your left"
        let commandRight = "Stop. Turn in place to your right"
        let commandStraight = "Proceed Forward"
        let commandDestination = "You have reached your destination"
        
        //closest beacon
        var closest=0
        var currentDirections=""
        var curDes=""
    
        //printing beacon info to console for testing
        //print(beacons)
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            
            let closestBeacon = knownBeacons[0] as CLBeacon
            closest = closestBeacon.minor.intValue
            
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
            
            
            if(closest == w1){
                if (selectedDestination == 1){
                    currentDirections = commandDestination
                }
                else {
                    if(currentHeading < Double(SOUTH-45)){
                        currentDirections = commandRight
                    }
                    else if(currentHeading > Double(SOUTH+45)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
            }
            else if(closest == w2){
                if (selectedDestination == 1){
                    if(currentHeading < Double(SOUTHWEST) && currentHeading > Double(SOUTH+1)){
                        currentDirections = commandRight
                    }
                    else if(currentHeading > Double(SOUTHEAST) && currentHeading < Double(SOUTH)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
                else{
                    if(currentHeading < Double(SOUTHWEST)){
                        currentDirections = commandRight
                    }
                    else if(currentHeading > Double(NORTHWEST)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
            }
            else if(closest == w3){
                if (selectedDestination == 1){
                    if(currentHeading > Double(SOUTHEAST)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
                else{
                    if(currentHeading < Double(SOUTHWEST)){
                        currentDirections = commandRight
                    }
                    else if(currentHeading > Double(NORTHWEST)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
            }
            else if(closest == w4){
                if (selectedDestination == 1){
                    if(currentHeading > Double(SOUTHEAST)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
                else if (selectedDestination == 2){
                    currentDirections = commandDestination
                    
                }
                else{
                    if(currentHeading < Double(SOUTHWEST)){
                        currentDirections = commandRight
                    }
                    else if(currentHeading > Double(NORTHWEST)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
            }
            else if(closest == w5){
                if (selectedDestination == 1 || selectedDestination == 2){
                    if(currentHeading > Double(SOUTHEAST)){
                        currentDirections = commandLeft
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
                else{
                    if(currentHeading < Double(SOUTHEAST)){
                        currentDirections = commandRight
                    }
                    if(currentHeading > Double(SOUTHWEST)){
                        currentDirections = commandRight
                    }
                    else{
                        currentDirections = commandStraight
                    }
                }
            }
            
            //You are closest to Worksation 6
            else if(closest == w6){
                if (selectedDestination == 1 || selectedDestination == 2){
                    currentDirections = "Turn Around"
                }
                else{
                    currentDirections = commandDestination
                }
            }
            
            //call speech function (currentDirections)
            textToSpeech(wordsToSay: currentDirections)
            
            //print the beacon you are closest to
            self.text.text = self.workstation[closestBeacon.minor.intValue]
            
            //provide current directions to user
            self.directionsMessage.text = currentDirections
        }
        
    }
 
    
    /******************************************************************************************
                Navigation code WITHOUT COMPASS HEADING
     ******************************************************************************************/
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        
//        let w1 = 62098
//        let w2 = 73
//        let w3 = 4053
//        let w4 = 28583
//        let w5 = 43767
//        let w6 = 49435
//        
//        let commandLeft = "Turn left and proceed forward"
//        let commandRight = "Turn right and proceed forward"
//        let commandStraight = "Proceed Forward"
//        let commandDestination = "You have reached your destination"
//        let commandTurnAround = "Turn around and proceed forward"
//        
//        var closest=0
//        var currentDirections=""
//        var curDes=""
//        
//        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
//        if (knownBeacons.count > 0) {
//            
//            let closestBeacon = knownBeacons[0] as CLBeacon
//            closest = closestBeacon.minor.intValue
//            
//            if(selectedDestination == 1){
//                curDes = "Selected Destination: ECE Office"
//            }
//            else if(selectedDestination == 2){
//                curDes = "Selected Destination: Kuhl's Office"
//            }
//            else{
//                curDes = "Selected Destination: 4th Floor Bathroom"
//            }
//            self.displaySelectDestination.text = curDes
//            
//            if(closest == w1){
//                if (selectedDestination == 1){
//                    currentDirections = commandDestination
//                }
//                else{
//                    currentDirections = commandStraight
//                }
//            }
//            else if(closest == w2){
//                if (selectedDestination == 1){
//                    currentDirections = commandTurnAround
//                }
//                else{
//                    currentDirections = commandRight
//                }
//            }
//            else if(closest == w3){
//                if (selectedDestination == 1){
//                    currentDirections = commandTurnAround
//                }
//                else{
//                    currentDirections = commandStraight
//                }
//            }
//            else if(closest == w4){
//                if (selectedDestination == 1){
//                    currentDirections = commandTurnAround
//                }
//                else if(selectedDestination == 2){
//                    currentDirections = commandDestination
//                }
//                else{
//                    currentDirections = commandStraight
//                }
//            }
//            else if(closest == w5){
//                if (selectedDestination == 1){
//                    currentDirections = commandTurnAround
//                }
//                else if(selectedDestination == 2){
//                    currentDirections = commandTurnAround
//                }
//                else{
//                    currentDirections = commandLeft
//                }
//            }
//            else if(closest == w6){
//                if (selectedDestination == 1){
//                    currentDirections = commandTurnAround
//                }
//                else if(selectedDestination == 2){
//                    currentDirections = commandTurnAround
//                }
//                else{
//                    currentDirections = commandDestination
//                }
//            }
//            
//            //call speech function (currentDirections)
//            textToSpeech(wordsToSay: currentDirections)
//            //print the beacon you are closest to
//            self.text.text = self.workstation[closestBeacon.minor.intValue]
//            
//            //provide current directions to user
//            self.directionsMessage.text = currentDirections
//            
//        }
//        
//    }

    
    /******************************************************************************************
                Compass Heading Function
    ******************************************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingReadCount = headingReadCount+1
        currentHeading = newHeading.magneticHeading

        print("initial read in COMPASS FUNC: \(currentHeading)")
        
        if(calibrated == false && headingReadCount==5){
            let curHeadingInt = Int(currentHeading)
            calibration(initialReading: curHeadingInt)
        }
        
        let headingString:String = String(currentHeading)
        print("heading: \(currentHeading)")
        
        //display heading in app UI
        self.closestWorkstation.text = headingString
    }
    
    /******************************************************************************************
                Speech Function
     ******************************************************************************************/
    func textToSpeech(wordsToSay: String) {
        let synth = AVSpeechSynthesizer()
        var myUtterance = AVSpeechUtterance(string: "")
        myUtterance = AVSpeechUtterance(string: wordsToSay)
        myUtterance.rate = 0.3
        if(wordsToSay != previousMessage){
            synth.speak(myUtterance)
        }
        previousMessage = wordsToSay
    }
    
    /******************************************************************************************
                Compass Calibration Function
    ******************************************************************************************/
    func calibration(initialReading: Int){
        SOUTH=initialReading
        
        if(SOUTH>180){
            NORTH=SOUTH-180
        }
        else{
            NORTH=SOUTH+180
        }
        if(NORTH>0 && NORTH<180){
            EAST=NORTH+90
        }
        else{
            EAST=SOUTH-90
        }
        if(EAST>180){
            WEST=EAST-180
        }
        else{
            WEST=EAST+180
        }
        NORTHEAST=NORTH+45
        if(NORTHEAST > 360){
            NORTHEAST=NORTHEAST-360
        }
        NORTHWEST=NORTH-45
        if(NORTHWEST<0){
            NORTHWEST=NORTH+360
        }
        SOUTHWEST=SOUTH+45
        if(SOUTHWEST > 360){
            SOUTHWEST=SOUTHWEST-360
        }
        SOUTHEAST=SOUTH-45
        if(SOUTHEAST<0){
            SOUTHEAST=SOUTHEAST+360
        }

        print("NORTH: \(NORTH)")
        print("WEST: \(WEST)")
        print("SOUTH: \(SOUTH)")
        print("EAST: \(EAST)")
        
        calibrated = true
    }
    
    
}
















