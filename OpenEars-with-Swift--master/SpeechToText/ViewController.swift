//
//  ViewController.swift
//  SpeechToText
//
//  Created by Stephanie Smith on 10/15/2016.

import UIKit
var currentWord: String!
var kLevelUpdatesPerSecond = 18
class ViewController: UIViewController, OEEventsObserverDelegate {
    /**
     * keeps you continuously updated about the status of your listening sesion
     **/
    var openEarsEventsObserver: OEEventsObserver! // forced unwrapping
    var startupFailedDueToLackOfPermissions: Bool = false;
    var buttonFlashing: Bool = false
    var words: Array<String> = []
    /**
     * path to language model which holds the words
     **/
    var lmPath: String!
    /**
     * path to dictionary which holds the words
     **/
    var dicPath: String!
    /**
     * the record button
     **/
    @IBOutlet weak var recordButton: UIButton!
    /**
     * text view that displays the text that the speech recoginition API interprets
     **/
    @IBOutlet weak var heardTextView: UITextView!
    /**
     *  text view that displays the status of the speech recognition API
     **/
    @IBOutlet weak var statusTextView: UITextView!
    /**
     * description: adding words to the language model
     **/
    func addWords() {
        // add anything here that you want to be recognized. Must be in capital letters
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
        // more confusion
//        do{
//            try (OEPocketsphinxController.sharedInstance().setActive(true))
//        }
//        catch{
//        }
//        (OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false))
//
        // end confusion
    }
    /**
     * description: called when the view controller is loaded
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        OEPocketsphinxController.sharedInstance().requestMicPermission()
        loadOpenEars()
    }
    /**
     * description: called when the view controller is loaded
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
           //  print("error")
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
    @IBAction func record(_ sender: AnyObject) {
        // print("button press")
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
    func getNewWord() {
        let randomWord = Int(arc4random_uniform(UInt32(words.count)))
        currentWord = words[randomWord]
    }
    /**
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
        statusTextView.text = "results"
    }
}
