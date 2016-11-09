//
//  QuizViewController.swift
//  Doner
//
//  Created by MacBook on 30.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import SwiftSpinner
import Firebase
import RealmSwift


protocol QuizDelegate {
    func setUserAnswer(current: Int, userAnswer: String)
    func getQuestion(current: Int) -> Question
}

class QuizViewController: UIViewController, QuizDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var quiz: Quiz!
    var started = false
    var submitted = false
    var delegate: QuizVerifier!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 5
        startButton.backgroundColor = UIColor.mainColor()
        startButton.setTitleColor(.whiteColor(), forState: .Normal)
        
        let doneQuiz = delegate.getDoneQuiz(quiz.qid)
        if doneQuiz.qid == quiz.qid {
            startButton.setTitle("Go to leaderboard", forState: .Normal)
            infoLabel.text = "\(doneQuiz.points)/\(doneQuiz.total)"
        } else {
            self.downloadQuestions()
        }
    }
    
    func downloadQuestions() {
        let ref = FIRDatabase.database().reference().child("questions/\(quiz.qid)")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.exists() && snap.value != nil {
                self.quiz.questions.removeAll()
                for (key, value) in snap.value as! [String: AnyObject] {
                    let q = Question(qid: key, question: value["question"] as! String, answer: value["option1"] as! String)
                    q.addOption(value["option1"] as! String)
                    q.addOption(value["option2"] as! String)
                    q.addOption(value["option3"] as! String)
                    q.addOption(value["option4"] as! String)
                    q.randomizeQuestion()
                    self.quiz.addQuestion(q)
                }
            }
            self.infoLabel.text = "-/\(self.quiz.questions.count)"
            SwiftSpinner.hide()
        }
    }
    
    @IBAction func startButtonPressed(sender: AnyObject) {
        let button = (sender as! UIButton)
        if button.titleLabel!.text! == "Start" {
            started = true
            button.setTitle("Submit", forState: .Normal)
            performSegueWithIdentifier("SegueStartQuiz", sender: nil)
        } else
        if button.titleLabel!.text! == "Submit" {
            submitted = true
            button.setTitle("Go to leaderboard", forState: .Normal)
            submitPressed()
        } else
        if button.titleLabel!.text! == "Go to leaderboard" {
            performSegueWithIdentifier("SegueFromQuizToGlobalScoreboard", sender: nil)
        } else {
            
        }
    }
    
    func submitPressed() {
        SwiftSpinner.show("Getting your results")
        let points = countPoints()
        let email = FIRAuth.auth()?.currentUser?.email
        let ref = FIRDatabase.database().reference().child("globalScores/")
        var handle: UInt = 0
        handle = ref.observeEventType(.Value, withBlock: { snap in
            if  snap.value != nil {
                var exist = false
                ref.removeObserverWithHandle(handle)
                for (key, value) in snap.value as! [String: AnyObject] {
                    if value["email"] as? String == email {
                        let dict: NSDictionary = ["email": email!,
                                                      "bonusPoints": value["bonusPoints"] as! String,
                                                      "quizPoints": String(Int(value["quizPoints"] as! String)! + points)]
                        let newRef = ref.child("\(key)")
                        newRef.setValue(dict)
                        exist = true
                        break
                    }
                }
                
                if !exist {
                    let dict: NSDictionary = ["email": email!,
                                              "bonusPoints": "0",
                                              "quizPoints": String(points)]
                    let newRef = ref.childByAutoId()
                    newRef.setValue(dict)
                    exist = true
                }
                
                self.infoLabel.text = "\(points)/\(self.quiz.questions.count)"
                
                // marking quiz as passed on Firebase
                if let user = FIRAuth.auth()?.currentUser {
                    let uid = user.uid;  // The user's ID, unique to the Firebase project.
                    let qauref = FIRDatabase.database().reference().child("quizAndUsers/\(uid)").childByAutoId()
                    let dict2: NSDictionary = ["qid" : self.quiz.qid, "points" : points, "total" : self.quiz.questions.count]
                    qauref.setValue(dict2)
                }
                SwiftSpinner.hide()
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueStartQuiz" {
            let vc = segue.destinationViewController as! QuestionViewController
            vc.delegate = self
            vc.current = 0
            vc.total = quiz.questions.count
        } else
            if segue.identifier == "SegueFromQuizToGlobalScoreboard" {
                
        }
    }
    
    func setUserAnswer(current: Int, userAnswer: String) {
        quiz.questions[current].userAnswer = userAnswer
    }
    
    func getQuestion(current: Int) -> Question {
        return quiz.questions[current]
    }
    
    func countPoints() -> Int {
        var result = 0
        for question in quiz.questions {
            if question.answer == question.userAnswer {
                result += 1
            }
        }
        return result
    }
}
