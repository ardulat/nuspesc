//
//  EditGlobalScoreViewController.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase

class EditGlobalScoreViewController: UIViewController {

    @IBOutlet weak var quizPoints: UILabel!
    @IBOutlet weak var bonusPoints: UILabel!
    @IBOutlet weak var addPoints: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var score: GlobalScore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 5
        addButton.backgroundColor = UIColor.mainColor()
        addButton.setTitleColor(.whiteColor(), forState: .Normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEventScoreViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
        quizPoints.text = String(score.quizPoints)
        bonusPoints.text = String(score.bonusPoints)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func updateGlobaScore(sender: UIButton) {
        if addPoints.text == nil || addPoints.text?.characters.count == 0 {
            addPoints.text = "0"
        }
        
        score.bonusPoints += Int(addPoints.text!)!
        
        let ref = FIRDatabase.database().reference().child("globalScores/\(score.gsid)")
        
        let dict: NSDictionary = ["email": score.fullName,
                                  "bonusPoints": String(score.bonusPoints), "quizPoints" : String(score.quizPoints)]
        ref.setValue(dict)
        navigationController?.popViewControllerAnimated(true)
    }
}
