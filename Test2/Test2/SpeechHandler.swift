//
//  SpeechHandler.swift
//  Test2
//
//  Created by Stephanie Smith on 12/3/16.
//  Copyright © 2016 armondluthens. All rights reserved.
//

import Foundation
import AVFoundation

var speechRecognizer: SpeechRecognizer!
var speaker: Speaker!

protocol PhraseRetriever {
    func retrievePhrase(command: String)
}

class SpeechRecognizer: NSObject, OEEventsObserverDelegate {
    
    private var openEarsEventsObserver: OEEventsObserver! // forced unwrapping
    private var startupFailedDueToLackOfPermissions: Bool = false;
    var recognizedWords: Array<String> = []
    
    struct Range {
        var start: Int
        var end: Int
    }
    
    struct PhraseCategory {
        
        var startNavigation: Range = Range(start: 0, end: 3)
        var endNavigation: Range = Range(start: 4, end: 9)
        var confirmationYes: Range = Range(start: 10, end: 11)
        var confirmationNo: Range = Range(start: 12, end: 13)
        var kuhlOffice: Range = Range(start: 14, end: 14)
        var bathroom: Range = Range(start: 15, end: 15)
        var eceOffice: Range = Range(start: 16, end: 16)
        var numCategories: Int = 7
    }
    /**
     * path to language model which holds the words
     **/
    private var lmPath: String!
    /**
     * path to dictionary which holds the words
     **/
    private var dicPath: String!
    
    private var delegate:PhraseRetriever!
    
    let possiblePhrases: PhraseCategory = PhraseCategory()
    
    init(delegate: PhraseRetriever){
        
        super.init()
        self.delegate = delegate
        OEPocketsphinxController.sharedInstance().requestMicPermission()
        loadOpenEars()
    }
    
    func createRecognizedWords(){
        
        // add anything here that you want to be recognized.
        // must be in capital letters
        recognizedWords.append("START")
        recognizedWords.append("START NAVIGATION")
        recognizedWords.append("BEGIN NAVIGATION")
        recognizedWords.append("BEGIN")
        
        recognizedWords.append("END NAVIGATION")
        recognizedWords.append("END")
        recognizedWords.append("QUIT")
        recognizedWords.append("QUIT NAVIGATION")
        recognizedWords.append("FINISH")
        recognizedWords.append("FINISH NAVIGATION")
        
        recognizedWords.append("YES")
        recognizedWords.append("YEAH")
        recognizedWords.append("NO")
        recognizedWords.append("NOPE")
        
        recognizedWords.append("KUHLS OFFICE")
        recognizedWords.append("BATHROOM")
        recognizedWords.append("E C E OFFICE")
        
    }
    
    // starting the request nav process
    func isStartNavCommand(string: String) -> Bool {
        print("start nav")
        return comparePhrase(string: string, startIndex: possiblePhrases.startNavigation.start, endIndex: possiblePhrases.startNavigation.end)
    }
    func isStopNavCommand(string: String) -> Bool {
          print("stop nav")
          return comparePhrase(string: string, startIndex: possiblePhrases.endNavigation.start, endIndex: possiblePhrases.endNavigation.end)
    }
    func isYesCommand(string: String) -> Bool {
        print("is yes")
        return comparePhrase(string: string, startIndex: possiblePhrases.confirmationYes.start, endIndex: possiblePhrases.confirmationYes.end)
    }
    func isNoCommand(string: String) -> Bool {
        print("is new")
        return comparePhrase(string: string, startIndex: possiblePhrases.confirmationNo.start, endIndex: possiblePhrases.confirmationNo.end)
    }
    func isDestinationCommand(string: String) -> Bool {
        print("is destination")
        return comparePhrase(string: string, startIndex: possiblePhrases.kuhlOffice.start, endIndex: 16)
    }
    func getDestination(string: String) -> MyLocations.Location{
        print("get des")
        if(comparePhrase(string: string, startIndex: possiblePhrases.kuhlOffice.start, endIndex: possiblePhrases.kuhlOffice.end) == true){
            return MyLocations.Location.KUHL_OFFICE
        }
        else if(comparePhrase(string: string, startIndex: possiblePhrases.bathroom.start, endIndex: possiblePhrases.bathroom.end) == true){
            return MyLocations.Location.BATHROOM
        }
            
        else{
            return MyLocations.Location.ECE_OFFICE
        }
    }
    // utility
    private func comparePhrase(string: String, startIndex: Int, endIndex: Int) -> Bool {
        for index in startIndex...endIndex {
            if(string == recognizedWords[index]) {
                return true
            }
        }
        return false
    }
    /**
     * description: instantiate API
     */
    private func loadOpenEars() {
        
        // instantiate this before any method of sphinxController or OEFliteController
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        // create languate model
        let lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        let name = "LanguageModelFileStarSaver"
        createRecognizedWords()
        lmGenerator.generateLanguageModel(from: recognizedWords, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"))
        
        lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: name)
        dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: name)
        self.startListening()
    }
    /**
     * description: turn on the API
     **/
    func startListening() {
       //  print("started listening")
        do{
            try OEPocketsphinxController.sharedInstance().setActive(true)
        }
        catch{
            print("error in startListening")
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
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        
        print("Heard: \(hypothesis)")
        print("recognitionScore: \(recognitionScore)")
        if(Int(recognitionScore)! > -115000){
            delegate.retrievePhrase(command: hypothesis)
        }
        
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidStartListening() {
       // print("Pocketsphinx is now listening.")
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidDetectSpeech() {
       // print("Pocketsphinx has detected speech.")
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidDetectFinishedSpeech() {
        // print("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
}
class Speaker: NSObject {
    var previousDateTime = NSDate()
    var synth: AVSpeechSynthesizer!
    var myUtterance: AVSpeechUtterance!
    var curWords: String!
    var prevWords: String!
    
    override init(){
        super.init()
        synth = AVSpeechSynthesizer()
        myUtterance = AVSpeechUtterance(string: "")
        myUtterance.rate = 0.3
        
    }
    
    func speak(wordsToSay: String) {
       
        var elaspedTime = Date().timeIntervalSince(previousDateTime as Date)
        previousDateTime = NSDate()
        
        prevWords = curWords
        curWords = wordsToSay
        if(prevWords != curWords || elaspedTime > 10){
            myUtterance = AVSpeechUtterance(string: curWords)
            synth.speak(myUtterance)
        }
        
        
        
    }
}
