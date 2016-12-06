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


class ViewController: UIViewController, MyBluetoothManager, PhraseRetriever, NavigationInstructor {
    
    // new type
    struct NavigationState {
        
        var startRequested:Bool = false
        var destinationConfirmed:Bool = false
        var setDestination:Bool = false
        var inProgress:Bool = false
        var destination:MyLocations.Location!
    }
    // private variables to keep track of app state
    private var navigationState: NavigationState = NavigationState()
    private var isCompassCalibrated: Bool = false
    
    // GUI vars
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var closestWorkstation: UILabel!
    @IBOutlet weak var directionsMessage: UILabel!
    @IBOutlet weak var displaySelectDestination: UILabel!
    
    
    /*----------------------------------------------------------------
     UI Button Action Methods:
     
     Destination Options:
     1. ECE Office
     2. Professor Kuhl's Office
     3. 4th Floor Bathroom
     ----------------------------------------------------------------*/
    @IBAction func ece(_ sender: AnyObject) {
        startNavigation(mydestination: MyLocations.Location.ECE_OFFICE)
    }
    @IBAction func kuhl(_ sender: AnyObject) {
        if(isCompassCalibrated){
            startNavigation(mydestination: MyLocations.Location.KUHL_OFFICE)
        }
        
    }
    @IBAction func restroom(_ sender: AnyObject) {
        if(isCompassCalibrated){
            startNavigation(mydestination: MyLocations.Location.BATHROOM)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myBluetooth = MyBluetooth(delegate: self)
        // speechRecognizer = SpeechRecognizer(delegate: self)
        speaker = Speaker()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // the following methods use voice recognition to control navigation process
    func getNewDestination(){
        navigationState.inProgress = false
        navigationState.destinationConfirmed = false
        navigationState.setDestination = false
        speaker.speak(wordsToSay: "WHAT IS YOUR NEW DESTINATION?")
        
    }
    func startNavigation(mydestination: MyLocations.Location){
        MyLocationManager.stopNav = false
        myLocationManager = MyLocationManager(destination: mydestination, delegate: self, calibrate: !isCompassCalibrated)
        print("START NAVIGATION")
    }
    
    // call is delegated to this
    func retrievePhrase(command: String){
        
        // stop while processing command
        speechRecognizer.stopListening()
        if(speechRecognizer.isStartNavCommand(string: command) && !navigationState.startRequested){
            if(navigationState.inProgress){
                getNewDestination()
            }
            else{
                speaker.speak(wordsToSay: "NAVIGATION STARTED, CHOOSE DESTINATION")
            }
            navigationState.startRequested = true
        }
        else if(speechRecognizer.isStopNavCommand(string: command)){
            speaker.speak(wordsToSay: "STOPPING NAVIGATION")
            navigationState.startRequested = false
            navigationState.inProgress = false
            navigationState.destinationConfirmed = false
            navigationState.setDestination = false
            
        }
        else if(speechRecognizer.isDestinationCommand(string: command)){
            // set destination
            navigationState.destination = speechRecognizer.getDestination(string: command)
            navigationState.setDestination = true
        }
        else if(speechRecognizer.isYesCommand(string: command)){
            if(navigationState.setDestination){
                navigationState.destinationConfirmed = true
                speaker.speak(wordsToSay: "STARTING NAVIGATION TO \(navigationState.destination)")
                startNavigation(mydestination: navigationState.destination)
                navigationState.inProgress = true
                navigationState.startRequested = false
                navigationState.destinationConfirmed = false
                navigationState.setDestination = false
            }
            
        }
        else if(speechRecognizer.isNoCommand(string: command)){
            speaker.speak(wordsToSay: "REPEAT DESTINATION")
        }
        // start listening again now that command is processed
        speechRecognizer.startListening()
    }
    
    // function is delegated to us
    func receivedNewInstruction(command: String){
        
        speaker.speak(wordsToSay: command)
        directionsMessage.text = command
        if(command == "YOU HAVE ARRIVED"){
            navigationState.startRequested = false
            navigationState.inProgress = false
            navigationState.setDestination = false
            navigationState.destinationConfirmed = false
            MyLocationManager.stopNav = true
            
        }
    }
    
    // should be called right away
    func calibrateCommpass(initialReading: Double) {
        closestWorkstation.text = "calibrating"
        
        let SOUTH: Double = initialReading
        var NORTH: Double!
        var EAST: Double!
        var WEST: Double!
    
        
        // getting the normal directions
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
        print("NORTH: \(NORTH)")
        print("SOUTH: \(SOUTH)")
        print("EAST: \(EAST)")
        print("WEST: \(WEST)")
        
        setThresholdVal(north: NORTH, south: SOUTH, east: EAST, west: WEST)
        
        
    }
   
    func getTVal(val: Double, isLower: Bool) -> Double{
        var thresholdVal: Double = 0
        if(isLower){
            thresholdVal = val - 45
            if(thresholdVal < 0){
                thresholdVal = thresholdVal + 360
            }
            
        }
        else{
            thresholdVal = val + 45
            if(thresholdVal > 360){
                thresholdVal = abs(thresholdVal - 360)
            }
        }
        return thresholdVal
    }
    func setThresholdVal(north: Double, south: Double, east: Double, west: Double){
        let tNorth = MyLocationManager.Threshold(lower: getTVal(val: north, isLower: true), upper: getTVal(val: north, isLower: false))
        let tSouth = MyLocationManager.Threshold(lower: getTVal(val: south,isLower: true), upper: getTVal(val: south, isLower: false))
        let tWest = MyLocationManager.Threshold(lower: getTVal(val: west, isLower: true), upper: getTVal(val: west, isLower: false))
        let tEast = MyLocationManager.Threshold(lower: getTVal(val: east, isLower: true), upper: getTVal(val: east, isLower: false))
        MyLocationManager.headings = MyLocationManager.Headings(north: tNorth, south: tSouth, west: tWest, east: tEast)
        isCompassCalibrated = true
    }
    func currentBeaconKnown(closestBeacon: Int){
        
        var str: String!
        if(closestBeacon == MyLocationManager.Beacon.ECE_OFFICE.rawValue){
            str = "ECE Office"
        }
        else if(closestBeacon == MyLocationManager.Beacon.WEST_TINTERSECTION.rawValue){
            str = "ALMOST ECE"
        }
        else if(closestBeacon == MyLocationManager.Beacon.EAST_TINTERSECTION.rawValue){
            str = "ALMOST BATHROOM"
        }
        else if(closestBeacon == MyLocationManager.Beacon.SMALL_HALL.rawValue){
            str = "SMALL HALL"
        }
        else if(closestBeacon == MyLocationManager.Beacon.KUHL_OFFICE.rawValue){
            str = "KUHL OFFICE"
        }
        else{
            str = "BATHROOM"
        }
        text.text = str
        //print("in here")
    }
    func currentKnownHeading(heading: String) {
        closestWorkstation.text = heading
    }
    


}

