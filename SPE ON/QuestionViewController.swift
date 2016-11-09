//
//  QuestionViewController.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var delegate: QuizDelegate!
    var current: Int = 0
    var total: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestion(current)
        
        option1.layer.borderWidth = 2
        option1.layer.borderColor = UIColor.mainColor().CGColor
        option1.layer.cornerRadius = 5
        
        option2.layer.borderWidth = 2
        option2.layer.borderColor = UIColor.mainColor().CGColor
        option2.layer.cornerRadius = 5
        
        option3.layer.borderWidth = 2
        option3.layer.borderColor = UIColor.mainColor().CGColor
        option3.layer.cornerRadius = 5
        
        option4.layer.borderWidth = 2
        option4.layer.borderColor = UIColor.mainColor().CGColor
        option4.layer.cornerRadius = 5
        
    }
    
    func setQuestion(current: Int) {
        
        if current == 0 {
            prevButton.hidden = true
        } else {
            prevButton.hidden = false
        }
        
        let question = delegate.getQuestion(current)
        title = "\(current + 1)/\(total)"
        questionLabel.text = question.question
        option1.setTitle("\(question.options[0])", forState: .Normal)
        option2.setTitle("\(question.options[1])", forState: .Normal)
        option3.setTitle("\(question.options[2])", forState: .Normal)
        option4.setTitle("\(question.options[3])", forState: .Normal)
        
        option1.backgroundColor = UIColor.whiteColor()
        option2.backgroundColor = UIColor.whiteColor()
        option3.backgroundColor = UIColor.whiteColor()
        option4.backgroundColor = UIColor.whiteColor()
        
        option1.setTitleColor(.mainColor(), forState: .Normal)
        option2.setTitleColor(.mainColor(), forState: .Normal)
        option3.setTitleColor(.mainColor(), forState: .Normal)
        option4.setTitleColor(.mainColor(), forState: .Normal)
        
        let userAnswer = question.userAnswer
        if userAnswer != "" {
            if question.options[0] == userAnswer {
                option1.backgroundColor = UIColor.mainColor()
                option1.setTitleColor(.whiteColor(), forState: .Normal)
            }
            if question.options[1] == userAnswer {
                option2.backgroundColor = UIColor.mainColor()
                option2.setTitleColor(.whiteColor(), forState: .Normal)
            }
            if question.options[2] == userAnswer {
                option3.backgroundColor = UIColor.mainColor()
                option3.setTitleColor(.whiteColor(), forState: .Normal)
            }
            if question.options[3] == userAnswer {
                option4.backgroundColor = UIColor.mainColor()
                option4.setTitleColor(.whiteColor(), forState: .Normal)
            }
        }
    }
    
    @IBAction func prevButtonPressed(sender: AnyObject) {
        if current - 1 >= 0 {
            current -= 1
            setQuestion(current)
        }
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        if current + 1 < total {
            current += 1
            setQuestion(current)
        }
        if current == total - 1 {
            nextButton.setTitle("Finish", forState: .Normal)
            
        }
        if nextButton.titleLabel?.text == "Finish" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func b1pressed(sender: AnyObject) {
        delegate.setUserAnswer(current, userAnswer: (sender as! UIButton).titleLabel!.text!)
        setQuestion(current)
    }
    
    @IBAction func b2pressed(sender: AnyObject) {
        delegate.setUserAnswer(current, userAnswer: (sender as! UIButton).titleLabel!.text!)
        setQuestion(current)
    }
    
    @IBAction func b3pressed(sender: AnyObject) {
        delegate.setUserAnswer(current, userAnswer: (sender as! UIButton).titleLabel!.text!)
        setQuestion(current)
    }
    
    @IBAction func b4pressed(sender: AnyObject) {
        delegate.setUserAnswer(current, userAnswer: (sender as! UIButton).titleLabel!.text!)
        setQuestion(current)
    }
}
