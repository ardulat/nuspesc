
//
//  AddQuestionViewController.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var qField: UITextField!
    
    @IBOutlet weak var caField: UITextField!
    
    @IBOutlet weak var wa1Field: UITextField!
    
    @IBOutlet weak var wa2Field: UITextField!
    
    @IBOutlet weak var wa3Field: UITextField!
    
    @IBOutlet weak var addButtonPressed: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var cur: Question!
    var delegate: QuizEditorDelegate!
    var order: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonPressed.backgroundColor = UIColor.mainColor()
        addButtonPressed.layer.cornerRadius = 5
        addButtonPressed.setTitleColor(.whiteColor(), forState: .Normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        autoFill()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + 270)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func autoFill() {
        if delegate.isItNewQuestion(order) {
            cur = Question(qid: "nomatter", question: "", answer: "")
            addButtonPressed.setTitle("Add this question", forState: .Normal)
        } else {
            cur = delegate.getQuestion(order)
            qField.text = cur.question
            caField.text = cur.options[0]
            wa1Field.text = cur.options[1]
            wa2Field.text = cur.options[2]
            wa3Field.text = cur.options[3]
            addButtonPressed.setTitle("Update the question", forState: .Normal)
        }
    }
    
    @IBAction func saveQuestion(sender: UIButton) {
        cur.question = qField.text!
        if delegate.isItNewQuestion(order) {
            cur.addOption(caField.text!)
            cur.addOption(wa1Field.text!)
            cur.addOption(wa2Field.text!)
            cur.addOption(wa3Field.text!)
        } else {
            cur.options[0] = caField.text!
            cur.options[1] = wa1Field.text!
            cur.options[2] = wa2Field.text!
            cur.options[3] = wa3Field.text!
        }
        delegate.addQuestion(cur, order: order)
        navigationController?.popViewControllerAnimated(true)
    }
}
