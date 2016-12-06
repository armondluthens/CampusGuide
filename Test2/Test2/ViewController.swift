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
    

    struct NavigationState {
        
        var startRequested:Bool = false
        var destinationConfirmed:Bool = false
        var setDestination:Bool = false
        var inProgress:Bool = false
        var destination:MyLocations.Location!
    }
    /*----------------------------------------------------------------
     Define Global Variables
     ----------------------------------------------------------------*/ 
    private var navigationState: NavigationState = NavigationState()
    
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
        startNavigation(mydestination: MyLocations.Location.KUHL_OFFICE)
    }
    @IBAction func restroom(_ sender: AnyObject) {
       startNavigation(mydestination: MyLocations.Location.BATHROOM)
    }
    override func viewDidLoad() {
        print("on view load")
        super.viewDidLoad()
        myBluetooth = MyBluetooth(delegate: self)
        // speechRecognizer = SpeechRecognizer(delegate: self)
        speaker = Speaker()
        
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNewDestination(){
        navigationState.inProgress = false
        navigationState.destinationConfirmed = false
        navigationState.setDestination = false
        speaker.speak(wordsToSay: "WHAT IS YOUR NEW DESTINATION?")
        
    }
    func startNavigation(mydestination: MyLocations.Location){
        myLocationManager = MyLocationManager(destination: mydestination, delegate: self)
        print("START NAVIGATION")
    }
    
    
    
    // starting navigation
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
    func receivedNewInstruction(command: String){
        speaker.speak(wordsToSay: command)
        if(command == "YOU HAVE ARRIVED"){
            navigationState.startRequested = false
            navigationState.inProgress = false
            navigationState.setDestination = false
            navigationState.destinationConfirmed = false
            
        }
    }

}

