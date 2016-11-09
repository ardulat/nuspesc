//
//  AddEventScoreViewController.swift
//  Doner
//
//  Created by MacBook on 23.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase

class AddEventScoreViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var initialScoreTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var ref: FIRDatabaseReference!
    var eventScore: EventScore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEventScoreViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
        if eventScore != nil {
            fullNameTextField.text = eventScore.fullName
            initialScoreTextField.text = String(eventScore.score)
        }
        ref = FIRDatabase.database().reference()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func saveButtonPressed(sender: UIButton) {
        if initialScoreTextField.text == "" {
            initialScoreTextField.text = "0"
        }
        
        if eventScore == nil {
            ref = ref.child("/eventScores").childByAutoId()
        } else {
            ref = ref.child("/eventScores/\(eventScore.esid)")
        }
        let dict: NSDictionary = ["fullName": fullNameTextField.text!,
                                  "score": initialScoreTextField.text!]
        ref.setValue(dict)
        navigationController?.popViewControllerAnimated(true)
    }
}
