//
//  ForgotViewController.swift
//  Doner
//
//  Created by Anuar's mac on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var emailVerificationAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        txtEmail.textColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        txtEmail.tintColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)

        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.whiteColor().CGColor
        sendButton.layer.cornerRadius = 5
        
        errorLabel.text = ""
        
        sendButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sendButton.titleLabel?.minimumScaleFactor = 0.5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func editTextField(textField: UITextField) {
        print(textField)
        txtEmail.text = textField.text
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        editTextField(txtEmail)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        editTextField(txtEmail)
        return true
    }
    
    @IBAction func sendButtonTapped(sender: UIButton) {
        
        if txtEmail.text == "" {
            self.dismissKeyboard()
            self.txtEmail.shake()
            self.errorLabel.fadeTransition(0.4)
            self.errorLabel.text = "Enter your e-mail and password."
            self.errorLabel.textColor = .redColor()
        } else {
        
            let domain = String(txtEmail.text!.characters.suffix(10))
            
            if txtEmail.text == "" || domain != "@nu.edu.kz" {
                
                dismissKeyboard()
                txtEmail.shake()
                errorLabel.fadeTransition(0.4)
                self.errorLabel.text = "Please enter your @nu.edu.kz e-mail."
                
            } else {
                
                if sendButton.currentTitle != "Reset Password has been sent" {
                    
                    FIRAuth.auth()?.sendPasswordResetWithEmail(self.txtEmail.text!, completion: { (error) in
                        
                        print(error?.localizedDescription)
                        
                        if error != nil {
                            
                            print(error!.localizedDescription)
                            self.errorLabel.fadeTransition(0.4)
                            self.errorLabel.text = error!.localizedDescription
                            
                        } else {
                            
                            print("reset password email has been sent")
                            dispatch_async(dispatch_get_main_queue()) {
                                self.sendButton.setTitle("Reset Password has been sent", forState: .Normal)
                                self.txtEmail.text = ""
                            }
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}