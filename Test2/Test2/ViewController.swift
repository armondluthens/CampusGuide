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

class ViewController: UIViewController, MyBluetoothManager, DestinationRetriever, NavigationInstructor {
    

    /*----------------------------------------------------------------
     Define Global Variables
     ----------------------------------------------------------------*/
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
        super.viewDidLoad()
        myBluetooth = MyBluetooth(delegate: self)
        speechRecognizer = SpeechRecognizer(delegate: self)
        speaker = Speaker()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func retrieveDestination(command: String){
        print("commands: /()/"))
        // myLocationManager = MyLocationManager(destination: MyLocations.Location.KUHL_OFFICE, delegate: self)
    }
    func receivedNewInstruction(command: String){
        speaker.speak(wordsToSay: command)
    }

}
