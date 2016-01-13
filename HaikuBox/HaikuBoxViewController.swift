//
//  HaikuBoxViewController.swift
//  HaikuBox
//
//  Created by Yu Liu on 2015-12-28.
//
//

import UIKit

class HaikuBoxViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties

    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var haikuDisplay: UITextView!

    var manager = HaikuManager()
    
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTextField.delegate = self
        manager.loadSamples()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text != nil {
            let replacer = manager.oneWord(textField.text!)
            if replacer != nil {
                let split_lines = replacer!.componentsSeparatedByString(",")
                var returnstr = ""
                for i in split_lines {
                    returnstr += (i + "\n")
                }
                haikuDisplay.text = returnstr
            }
            
        }
    }

    
    // MARK: Actions

    @IBAction func wordTypeHasChanged(sender: UISegmentedControl) {
    }
}

