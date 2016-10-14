//
//  ViewController.swift
//  IndoorTest
//
//  Created by Armond Luthens on 10/11/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

//TUTORIAL URL: http://developer.estimote.com/indoor/build-an-app/
//app ID: estimote-test-1-4zj
//app token: e8b955bec7c65a139677de6d0f9c95cb

import UIKit


// 1. Add the EILIndoorLocationManagerDelegate protocol
class ViewController: UIViewController, EILIndoorLocationManagerDelegate {
    
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    
    let desk = EILPoint(x: 0.32, y: 2.21)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3. Set the location manager's delegate
        self.locationManager.delegate = self
        
        //Need to map location first to get app id and token
        ESTConfig.setupAppID("estimote-test-1-4zj", andAppToken: "e8b955bec7c65a139677de6d0f9c95cb")
        
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "Work Station 1")
        fetchLocationRequest.sendRequest{ (location, error) in
            if location != nil {
                self.location = location!
                
                self.locationManager.startPositionUpdates(for: self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @nonobjc func indoorLocationManager(manager: EILIndoorLocationManager!,
                               didFailToUpdatePositionWithError error: NSError!) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!,
                               didUpdatePosition position: EILOrientedPoint!,
                               withAccuracy positionAccuracy: EILPositionAccuracy,
                               inLocation location: EILLocation!) {
        var accuracy: String!
        switch positionAccuracy {
        case .veryHigh: accuracy = "+/- 1.00m"
        case .high:     accuracy = "+/- 1.62m"
        case .medium:   accuracy = "+/- 2.62m"
        case .low:      accuracy = "+/- 4.24m"
        case .veryLow:  accuracy = "+/- ? :-("
        case .unknown:  accuracy = "unknown"
        }
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
                     position.x, position.y, position.orientation, accuracy))
    }


}

