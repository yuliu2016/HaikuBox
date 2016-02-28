//
//  HaikuBoxViewController.swift
//  HaikuBox
//
//  Created by Yu Liu on 2015-12-28.
//

import UIKit

class HaikuBoxViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties

    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var haikuDisplay: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    
    var manager = HaikuManager()
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTextField.delegate = self
        manager.loadAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            if manager.currentWord == nil {
                haikuDisplay.text = "You havn't entered a word yet"
                return
            }
            let formatted = manager.oneWord(manager.currentWord!)
            haikuDisplay.text = formatted
            self.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    Converts the haiku and make it display on haikuDisplay
    */
    func textFieldDidEndEditing(textField: UITextField) {
        
        if var text = textField.text {
            let formatted = manager.oneWord(text)
            haikuDisplay.text = formatted
            manager.currentWord = text
            text.replaceRange(text.startIndex...text.startIndex, with: String(text[text.startIndex]).uppercaseString)
            titleLabel.text = text
            titleLabel.alpha = 1
            repeatButton.alpha = 1
        }
    }

    // MARK: Actions
    
    /*
    changes the type in the manager between Noun, Verb, and Adjective
    */
    @IBAction func wordTypeHasChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            manager.setType(haikuWordTypes.noun)
            wordTextField.placeholder = "Enter a noun"
            wordTextField.text = ""
            print("Changed To Noun")
        case 1:
            manager.setType(haikuWordTypes.verb)
            wordTextField.placeholder = "Enter a verb"
            wordTextField.text = ""
            print("Changed To Verb")
        case 2:
            manager.setType(haikuWordTypes.adjective)
            wordTextField.placeholder = "Enter an adjective"
            wordTextField.text = ""
            print("Changed To Adjective")
        default:
            manager.setType(haikuWordTypes.noun)
            wordTextField.placeholder = "Enter an noun"
            wordTextField.text = ""
            print("Changed To Noun")
        }
        manager.currentHaiku = nil
        manager.currentWord = nil
        repeatButton.alpha = 0
    }
    
    /*
    Repeat the actions with the same word
    */
    @IBAction func RepeatClicked() {
        if manager.currentWord == nil {
            haikuDisplay.text = "You havn't entered a word yet"
            return
        }
        let formatted = manager.oneWord(manager.currentWord!)
        haikuDisplay.text = formatted
    }
}

