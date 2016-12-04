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


class SpeechRecognizer: NSObject, OEEventsObserverDelegate {
    
    private var openEarsEventsObserver: OEEventsObserver! // forced unwrapping
    private var startupFailedDueToLackOfPermissions: Bool = false;
    private var recognizedWords: Array<String> = []
    /**
     * path to language model which holds the words
     **/
    private var lmPath: String!
    /**
     * path to dictionary which holds the words
     **/
    private var dicPath: String!
    
    override init(){
        super.init()
        OEPocketsphinxController.sharedInstance().requestMicPermission()
        loadOpenEars()
    }
    
    func createRecognizedWords(){
        // add anything here that you want to be recognized.
        // must be in capital letters
        recognizedWords.append("SUNDAY")
        recognizedWords.append("MONDAY")
        recognizedWords.append("TUESDAY")
        recognizedWords.append("WEDNESDAY")
        recognizedWords.append("THURSDAY")
        recognizedWords.append("FRIDAY")
        recognizedWords.append("SATURDAY")
        recognizedWords.append("JANUARY")
        recognizedWords.append("FEBRUARY")
        recognizedWords.append("MARCH")
        recognizedWords.append("APRIL")
        recognizedWords.append("MAY")
        recognizedWords.append("JUNE")
        recognizedWords.append("JULY")
        recognizedWords.append("AUGUST")
        recognizedWords.append("SEPTEMBER")
        recognizedWords.append("OCTOBER")
        recognizedWords.append("NOVEMBER")
        recognizedWords.append("DECEMBER")
        
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
        print("started listening")
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
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidStartListening() {
        print("Pocketsphinx is now listening.")
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidDetectSpeech() {
        print("Pocketsphinx has detected speech.")
    }
    /**
     * note: is a delegate method of OEEventsObserver
     **/
    func pocketsphinxDidDetectFinishedSpeech() {
        print("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
}
class Speaker: NSObject {
    
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
        
        prevWords = curWords
        curWords = wordsToSay
        // if(prevWords != curWords){
        myUtterance = AVSpeechUtterance(string: curWords)
        synth.speak(myUtterance)
        // }
        
        
        
    }
}
