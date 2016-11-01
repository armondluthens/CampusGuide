//
//  ViewController.swift
//  SpeechToText
//
//  Created by Stephanie Smith on 10/15/2016.

import UIKit
import CoreBluetooth


class ViewController: UIViewController, OEEventsObserverDelegate, CBCentralManagerDelegate,CBPeripheralDelegate {
    
   
    
    // speech recognition fields
    
    /**
     * object keeps you continuously updated about the status of your listening sesion
     **/
    private var openEarsEventsObserver: OEEventsObserver! // forced unwrapping
    /**
     * true if there are no microphone permissions
     */
    private var startupFailedDueToLackOfPermissions: Bool = false;
    /**
     * true if the mic button is flashing
     */
    private var buttonFlashing: Bool = false
    /**
     * holds list of words that open ears will interpret
     **/
    private var words: Array<String> = []
    /**
     * path to language model which holds the words
     **/
    private var lmPath: String!
    /**
     * path to dictionary which holds the words
     **/
    private var dicPath: String!
    /**
     * the record button in the storyboard
     **/
    // note: IBOutlet attribute means that the property is accessible to the storyboard
    @IBOutlet private weak var recordButton: UIButton!
    /**
     * text view (in the storyboard) that displays the text that the speech recoginition
     * API interprets
     **/
    @IBOutlet private weak var heardTextView: UITextView!
    /**
     *  text view (in the storyboard) that displays the status of the speech recognition API
     **/
    @IBOutlet weak var statusTextView: UITextView!
    
    
    // bluetooth fields
    
    /**
     * text view to display status of bluetooth
     * data
     **/
     @IBOutlet weak var bluetoothTextView: UITextView!
    
    /**
     * object that are used to manage discovered or connected remote
     * peripheral devices (represened by CBPeripheral objects), including scanning for,
     * discovering and connecting to advertising perpherals
     **/
    private var centralManager: CBCentralManager!
    /**
     * object represents remote peripheral devices that your app - by means of a central manager 
     * - has discovered
     **/
    private var discoveredPeripheral: CBPeripheral!
    /**
     * stored the incoming data sent by the peripheral
     **/
    private let data: NSMutableData = NSMutableData()
    
    // speech recognition functions
    
    /**
     * description: adding words to the language model
     **/
    func addWords() {
        // add anything here that you want to be recognized. 
        // must be in capital letters
        words.append("SUNDAY")
        words.append("MONDAY")
        words.append("TUESDAY")
        words.append("WEDNESDAY")
        words.append("THURSDAY")
        words.append("FRIDAY")
        words.append("SATURDAY")
        words.append("JANUARY")
        words.append("FEBRUARY")
        words.append("MARCH")
        words.append("APRIL")
        words.append("MAY")
        words.append("JUNE")
        words.append("JULY")
        words.append("AUGUST")
        words.append("SEPTEMBER")
        words.append("OCTOBER")
        words.append("NOVEMBER")
        words.append("DECEMBER")
    }
    /**
     * description: instantiate API
     */
    func loadOpenEars() {
       
        // instantiate this before any method of sphinxController or OEFliteController
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        // create languate model
        let lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        let name = "LanguageModelFileStarSaver"
        addWords()
        lmGenerator.generateLanguageModel(from: words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"))
        
        lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: name)
        dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: name)
    }
    /**
     * description: called when the view controller is loaded
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        // start up the CBCentralManager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // configure speech recongition
        OEPocketsphinxController.sharedInstance().requestMicPermission()
        loadOpenEars()
    }
    /**
     * description: flashed recordButton
     **/
    func startFlashingbutton() {
        buttonFlashing = true
        // how visible it is
        recordButton.alpha = 1
        UIView.animate(withDuration: 0.5 , delay: 0.0, options: [UIViewAnimationOptions.curveEaseInOut,UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse, UIViewAnimationOptions.allowUserInteraction], animations: {
            self.recordButton.alpha = 0.1
            }, completion: {Bool in
        })
    }
    /**
     * description: stop flashing button
     **/
    func stopFlashingbutton() {
        buttonFlashing = false
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [UIViewAnimationOptions.curveEaseInOut, UIViewAnimationOptions.beginFromCurrentState], animations: {
            self.recordButton.alpha = 1
            }, completion: {Bool in
        })
    }
    /**
     * description: turn on the API
     **/
    func startListening() {
        do{
            try OEPocketsphinxController.sharedInstance().setActive(true)
        }
        catch{
            statusTextView.text = "error in startListening"
        }
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    /**
     * description: turn off the API
     **/
    func stopListening() {
        OEPocketsphinxController.sharedInstance().stopListening()
    }
    /**
     * description: when the user presses the record button
     **/
    @IBAction func record(sender: AnyObject) {
        if(!buttonFlashing) {
            self.startFlashingbutton()
            self.startListening()
        }
        else {
            self.stopFlashingbutton()
            self.stopListening()
        }
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidStartListening() {
        statusTextView.text = "Pocketsphinx is now listening."
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidDetectSpeech() {
        statusTextView.text = "Pocketsphinx has detected speech."
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidDetectFinishedSpeech() {
        statusTextView.text = "Pocketsphinx has detected a period of silence, concluding an utterance."
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidStopListening() {
        statusTextView.text = "Pocketsphinx has stopped listening."
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidSuspendRecognition() {
        statusTextView.text = "Pocketsphinx has suspended recognition."
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidResumeRecognition() {
        statusTextView.text = "Pocketsphinx has resumed recognition."
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidChangeLanguageModel(newLanguageModelPathAsString: String!, newDictionaryPathAsString: String!) {
        statusTextView.text = ("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketSphinxContinuousTeardownDidFail(withReason reasonForFailure: String) {
        statusTextView.text = "Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)"
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
        statusTextView.text = "Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)"
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func testRecognitionCompleted() {
            statusTextView.text = "A test file that was submitted for recognition is now complete."
    }
    /**
     * note: is a delegate method of OEEventsObserver
     * description: handle when there aren't the proper mic permissions
     **/
    func pocketsphinxFailedNoMicPermissions() {
        statusTextView.text = "no mic permissions"
        self.startupFailedDueToLackOfPermissions = true
        // Stop listening if we are listening
        if (OEPocketsphinxController.sharedInstance()).isListening {
            let error = (OEPocketsphinxController.sharedInstance()).stopListening()
            if(error != nil) {
                statusTextView.text = "Error while stopping listening in micPermissionCheckCompleted: \(error)"
            }
        }
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        heardTextView.text = "Heard: \(hypothesis)"
    }
    func micPermissionCheckCompleted(_ result: Bool){
        statusTextView.text = "results \(result)"
    }
    
    // blue tooth functions 
    
    
    /** 
     * notes: centralManagerDidUpdateState is a required protocol method.
     * Usually, you'd check for other states to make sure the current device supports LE, is 
     * powered on, etc.
     * In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, 
     * which indicates the Central is ready to be used.
     * defintion: check if phone is ready to use bluetooth
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // if bluetooth is not ready on phone
        guard central.state  == .poweredOn else {
            // In a real app, you'd deal with all the states correctly
            return
        }
        // The state must be CBCentralManagerStatePoweredOn...
        // ... so start scanning
        scan()
    }
    /**
     * description: scan for peripherals - specifically for our service's 128bit CBUUID
     */
    func scan() {
        centralManager.scanForPeripherals(
            withServices: [transferServiceUUID], options: [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true)
            ]
        )
        bluetoothTextView.text = "scanning"
    }
    /** 
     * note: CBCentralManagerDelegate method
     * description: This callback comes whenever a peripheral that is advertising the 
     * TRANSFER_SERVICE_UUID is discovered.
     * We check the RSSI, to make sure it's close enough that we're interested in it, and if it
     * is, we start the connection process
     */
    func centralManager(_: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        
        // Reject any where the value is above reasonable range
        // Reject if the signal strength is too low to be close enough (Close is around -22dB)
        //        if  RSSI.integerValue < -15 && RSSI.integerValue > -35 {
        //            println("Device not at correct range")
        //            return
        //        }
        
        print("Discovered \(peripheral.name) at \(rssi)")
        
        // Ok, it's in range - have we already seen it?
        
        if discoveredPeripheral != peripheral {
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral = peripheral
            
            // And connect
            print("Connecting to peripheral \(peripheral)")
            
            centralManager?.connect(peripheral, options: nil)
        }
    }
    /** If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(_: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        
        cleanup()
    }
    /** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
     */
    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        
        // Stop scanning
        centralManager?.stopScan()
        print("Scanning stopped")
        
        // Clear the data that we may already have
        data.length = 0
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // Search only for services that match our UUID
        peripheral.discoverServices([transferServiceUUID])
    }
    
    /** The Transfer Service was discovered
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        for service in services {
            peripheral.discoverCharacteristics([transferCharacteristicUUID], for: service)
        }
    }
    
    /** The Transfer characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any)
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        guard let characteristics = service.characteristics else {
            return
        }
        
        // Again, we loop through the array, just in case.
        for characteristic in characteristics {
            // And check if it's the right one
            if characteristic.uuid.isEqual(transferCharacteristicUUID) {
                // If it is, subscribe to it
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        // Once this is complete, we just need to wait for the data to come in.
    }
    /** This callback lets us know more data has arrived via notification on the characteristic
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let stringFromData = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            print("Invalid data")
            return
        }
        
        // Have we got everything we need?
        if stringFromData.isEqual(to: "EOM") {
            // We have, so show the data,
           //  textView.text = String(data: data.copy() as! NSData, encoding: NSUTF8StringEncoding)
            
            // Cancel our subscription to the characteristic
            peripheral.setNotifyValue(false, for: characteristic)
            
            // and disconnect from the peripehral
            centralManager?.cancelPeripheralConnection(peripheral)
        } else {
            // Otherwise, just add the data on to what we already have
            data.append(characteristic.value!)
            
            // Log it
            print("Received: \(stringFromData)")
        }
    }
    /** Once the disconnection happens, we need to clean up our local copy of the peripheral
     */
    func centralManager(_: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral Disconnected")
        discoveredPeripheral = nil
        
        // We're disconnected, so start scanning again
        scan()
    }
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    private func cleanup() {
        // Don't do anything if we're not connected
        // self.discoveredPeripheral.isConnected is deprecated
        guard discoveredPeripheral?.state == .connected else {
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        guard let services = discoveredPeripheral?.services else {
            cancelPeripheralConnection()
            return
        }
        
        for service in services {
            guard let characteristics = service.characteristics else {
                continue
            }
            
            for characteristic in characteristics {
                if characteristic.uuid.isEqual(transferCharacteristicUUID) && characteristic.isNotifying {
                    discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                    // And we're done.
                    return
                }
            }
        }
    }
    private func cancelPeripheralConnection() {
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
    }


}
