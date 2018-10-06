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
    var fromType = false
    
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
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if manager.currentWord == nil {
                haikuDisplay.text = "You havn't entered a word yet"
                return
            }
            let formatted = manager.oneWord(manager.currentWord!)
            haikuDisplay.text = formatted
            self.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    Converts the haiku and make it display on haikuDisplay
    */
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if var text = textField.text {
            if !self.fromType && !textField.text!.isEmpty{
                
                let formatted = manager.oneWord(text)
                haikuDisplay.text = formatted
                manager.currentWord = text
                text.replaceSubrange(text.startIndex...text.startIndex, with: String(text[text.startIndex]).uppercased())
                titleLabel.text = text
                titleLabel.alpha = 1
                repeatButton.alpha = 1
                
                textField.text = ""
            }
        }
    }

    // MARK: Actions
    /*
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
    }*/
    
    /*
    Repeat the actions with the same word
    */
    @IBAction func RepeatClicked() {
        if manager.currentWord == nil {
            haikuDisplay.text = "You havn't entered a word yet!"
            return
        }
        let formatted = manager.oneWord(manager.currentWord!)
        haikuDisplay.text = formatted
    }
    
    @IBAction func swipes() {
        if manager.currentWord == nil {
            haikuDisplay.text = "Please enter a word first!"
            return
        }
        let formatted = manager.oneWord(manager.currentWord!)
        haikuDisplay.text = formatted
    }
    
    @IBAction func typeChanger(_ sender:AnyObject){
        self.fromType=true;
        let changerAlert = UIAlertController(title: "Choose the Part of Speech", message: nil, preferredStyle: .alert)
        
        changerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel){action -> Void in
            
            changerAlert.dismiss(animated: true, completion: nil)
            self.fromType=false})
        
        changerAlert.addAction(UIAlertAction(title: "Noun", style: .default){action -> Void in
            
            self.manager.setType(haikuWordTypes.noun)
            self.wordTextField.placeholder = "Enter a noun"
            self.wordTextField.text = ""
            print("Changed To Noun")
            self.fromType=false
            
            self.manager.currentHaiku = nil
            self.manager.currentWord = nil
            self.repeatButton.alpha = 0
            
            changerAlert.dismiss(animated: true, completion: nil)})
        
        changerAlert.addAction(UIAlertAction(title: "Verb", style: .default){action -> Void in
            
            self.manager.setType(haikuWordTypes.verb)
            self.wordTextField.placeholder = "Enter a verb"
            self.wordTextField.text = ""
            print("Changed To Verb")
            self.fromType=false
            
            self.manager.currentHaiku = nil
            self.manager.currentWord = nil
            self.repeatButton.alpha = 0
            
            changerAlert.dismiss(animated: true, completion: nil)})
        
        changerAlert.addAction(UIAlertAction(title: "Adjective", style: .default){action -> Void in
            
            self.manager.setType(haikuWordTypes.adjective)
            self.wordTextField.placeholder = "Enter an adjective"
            self.wordTextField.text = ""
            print("Changed To Adjective")
            self.fromType=false
            
            self.manager.currentHaiku = nil
            self.manager.currentWord = nil
            self.repeatButton.alpha = 0
            
            changerAlert.dismiss(animated: true, completion: nil)})
        
        self.present(changerAlert, animated: true, completion: nil)
    }
    
}

