//
//  RegistrationViewController.swift
//  Doner
//
//  Created by MacBook on 28.09.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftSpinner

class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forgotButton: UIButton!
    
    var type: Int = 2
    
    var ref: FIRDatabaseReference!
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                if user.email != "demo@gmail.com" {
                    self.emailTextField.text = user.email
                    self.passwordTextField.text = "qwerty123"
                    self.performSegueWithIdentifier("SegueLoginToOverview", sender: self)
                }
            } else {
                // No user is signed in.
            }
        }
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.cornerRadius = 5
        type = 2
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        errorLabel.text = ""
        
        emailTextField.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        passwordTextField.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        emailTextField.textColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        passwordTextField.textColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        emailTextField.tintColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        passwordTextField.tintColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        passwordTextField.secureTextEntry = true
    }
    
    func showAlert(error: NSError) {
        dismissKeyboard()
        emailTextField.shake()
        passwordTextField.shake()
        errorLabel.fadeTransition(0.4)
        self.errorLabel.textColor = .redColor()
        self.errorLabel.text = error.localizedDescription
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        if type == 2 {
            dismissKeyboard()
            if emailTextField.text == "" || passwordTextField.text == "" {
                self.dismissKeyboard()
                self.emailTextField.shake()
                self.passwordTextField.shake()
                self.errorLabel.fadeTransition(0.4)
                self.errorLabel.text = "Enter your e-mail and password."
                self.errorLabel.textColor = .redColor()
            } else {
                SwiftSpinner.show("Logging In...")
                FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    
                    if let user = FIRAuth.auth()?.currentUser {
                        print(user.email)
                        print(user.emailVerified)
                        
                        if user.emailVerified == false {
                            self.dismissKeyboard()
                            self.emailTextField.shake()
                            self.passwordTextField.shake()
                            self.errorLabel.fadeTransition(0.4)
                            self.errorLabel.text = "E-mail not verified. Please verify your e-mail first."
                            self.errorLabel.textColor = .redColor()
                        } else {
                            if error != nil {
                                print(error)
                                self.showAlert(error!)
                            } else {
                                print("Logged in")
                                self.checkForAdmin(user.email!)
                                SwiftSpinner.hide()
                            }
                        }
                    } else {
                        if error != nil {
                            print(error)
                            self.showAlert(error!)
                        }
                    }
                })
            }
        } else { // type == .SignUp
            dismissKeyboard()
            if emailTextField.text == "" || passwordTextField.text == "" {
                
                self.dismissKeyboard()
                self.emailTextField.shake()
                self.passwordTextField.shake()
                self.errorLabel.fadeTransition(0.4)
                self.errorLabel.text = "Enter your e-mail and password."
                self.errorLabel.textColor = .redColor()
                
            } else {
                let domain = String(emailTextField.text!.characters.suffix(10))
                
                if domain == "@nu.edu.kz" {
                    
                    FIRAuth.auth()?.createUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                        
                        if error != nil {
                            print(error)
                            self.showAlert(error!)
                        } else {
                            print("Signed in")
                            user?.sendEmailVerificationWithCompletion() { error in
                                if error != nil {
                                    // An error happened.
                                    self.showAlert(error!)
                                } else {
                                    // Email sent.
                                    print("email sent")
                                    self.dismissKeyboard()
                                    self.errorLabel.text = "The verification e-mail has been sent to you. Verify your e-mail."
                                    self.errorLabel.textColor = .whiteColor()
                                    self.toggleLoginSignUp(sender)
                                }
                            }
                        }
                    })

                } else {
                    
                    dismissKeyboard()
                    emailTextField.shake()
                    passwordTextField.shake()
                    errorLabel.fadeTransition(0.4)
                    errorLabel.text = "You need to have nu.edu.kz e-mail adress."
                }
            }
        }
        
    }
    
    func checkForAdmin(email: String) {
           
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "admin")
        NSUserDefaults.standardUserDefaults().synchronize()
            
        let newRef = FIRDatabase.database().reference().child("admins")
        newRef.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.value != nil {
                let postDict = snap.value as! [String : AnyObject]
                for (_, b) in postDict {
                    if b["email"] as! String == email {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "admin")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                }
                self.performSegueWithIdentifier("SegueLoginToOverview", sender: self)
            }
        }
    }
    
    @IBAction func toggleLoginSignUp(sender: UIButton) {
        
        print(type)
        
        if type == 2 { // Login
            print("login")
            type = 1
            loginButton.setTitle("Sign Up", forState: .Normal)
            toggleButton.setTitle("Have an account? Login", forState: .Normal)
            forgotButton.setTitle("", forState: .Normal)
        } else { // SignUp
            print("sing up")
            type = 2
            loginButton.setTitle("Log In", forState: .Normal)
            toggleButton.setTitle("Don't have an account? Sign Up", forState: .Normal)
            forgotButton.setTitle("Forgot Password?", forState: .Normal)
        }
    }

}
