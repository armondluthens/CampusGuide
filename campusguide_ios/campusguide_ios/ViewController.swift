//
//  ViewController.swift
//  campusguide_ios
//
//  Created by Stephanie Smith on 9/21/16.
//  Copyright © 2016 FantasticFour. All rights reserved.
//

import UIKit

// UITextFieldDelegate
// adopting protocol UITextFieldDelegate ...make ViewController the text box's delegate
class ViewController: UIViewController,UITextFieldDelegate  {
    // MARK: Properties
    
    @IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        

    }
    
    // keep but am not overriding right now

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    // MARK: UITextFieldDelegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
        // returning the value true indicates that the text field should respond to the user pressing the Return key by dismissing the keyboard.
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        mealNameLabel.text = textField.text
    }
    

    

    
    // MARK: Actions

    @IBAction func etDefaultLabelText(sender: UIButton) {
        
        
        mealNameLabel.text = "Default Text"
        

    }

}

