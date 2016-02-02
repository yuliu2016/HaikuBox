//
//  HaikuBoxViewController.swift
//  HaikuBox
//
//  Created by Yu Liu on 2015-12-28.
//
//Add action for clicking outside of the text field
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
            if wordTextField.isFirstResponder() {
                return
            }
            let av = UIAlertController(title: "Shake", message: "Shaking to be implemented", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in return }
            av.addAction(OKAction)
            presentViewController(av, animated: true, completion: nil)
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
        
        if textField.text != nil {
            let formatted = manager.oneWordFormatted(textField.text!)
            haikuDisplay.text = formatted
            manager.currentWord = textField.text
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
        case 1:
            manager.setType(haikuWordTypes.verb)
            wordTextField.placeholder = "Enter a verb"
            wordTextField.text = ""
        case 2:
            manager.setType(haikuWordTypes.adjective)
            wordTextField.placeholder = "Enter an adjective"
            wordTextField.text = ""
        default:
            manager.setType(haikuWordTypes.noun)
            wordTextField.placeholder = "Enter an adjective"
            wordTextField.text = ""
        }
    }
    
    /*
    Repeat the actions with the same word
    */
    @IBAction func RepeatClicked() {
        if manager.currentWord == nil {
            return
        }
        let formatted = manager.oneWordFormatted(manager.currentWord!)
        haikuDisplay.text = formatted
    }
}

