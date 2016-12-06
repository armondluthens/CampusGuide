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
        var changingDestination:Bool = false
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
        if(myBluetooth.isReady){
            myBluetooth.sendMessageToWearable(string: "0")
        }
       
    }
    @IBAction func kuhl(_ sender: AnyObject) {
        
        print("in kuhl")
        speaker.speak(wordsToSay: "test string")
    }
    @IBAction func restroom(_ sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        print("on view load")
        super.viewDidLoad()
        myLocationManager = MyLocationManager(destination: MyLocations.Location.BATHROOM, delegate: self)
        myBluetooth = MyBluetooth(delegate: self)
        speechRecognizer = SpeechRecognizer(delegate: self)
        speaker = Speaker()
        
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNewDestination(){
        navigationState.inProgress = false
        navigationState.destinationConfirmed = false
        speaker.speak(wordsToSay: "WHAT IS YOUR NEW INFORMATION?")
        
    }
    func startNavigation(mydestination: MyLocations.Location){
        myLocationManager = MyLocationManager(destination: mydestination, delegate: self)
    }
    // starting navigation
    func retrievePhrase(command: String){
        
        if(speechRecognizer.isStartNavCommand(string: command) && !navigationState.startRequested){
            if(navigationState.inProgress){
                navigationState.changingDestination = false
                getNewDestination()
                navigationState.startRequested = true
            }
            else{
                navigationState.inProgress = true
                speaker.speak(wordsToSay: "NAVIGATION STARTED, CHOOSE DESTINATION")
            }
        }
        else if(speechRecognizer.isStopNavCommand(string: command)){
            speaker.speak(wordsToSay: "STOPPING NAVIGATION")
            navigationState.startRequested = false
            navigationState.inProgress = false
            navigationState.destinationConfirmed = false
            
        }
        else if(speechRecognizer.isDestinationCommand(string: command)){
            navigationState.destination = speechRecognizer.getDestination(string: command)
        }
        else if(speechRecognizer.isYesCommand(string: command)){
            speaker.speak(wordsToSay: "STARTING NAVIGATION TO \(command)")
            startNavigation(mydestination: navigationState.destination)
        }
        else if(speechRecognizer.isNoCommand(string: command)){
            speaker.speak(wordsToSay: "REPEAT DESTINATION")
        }
    }
    func receivedNewInstruction(command: String){
        speaker.speak(wordsToSay: command)
    }

}

