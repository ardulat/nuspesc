//
//  AddQuizViewController.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

protocol QuizEditorDelegate {
    func addQuestion(question: Question, order: Int)
    func isItNewQuestion(order: Int) -> Bool
    func getQuestion(order: Int) -> Question
}

class AddQuizViewController: UIViewController, QuizEditorDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quizTitle: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    var quiz: Quiz!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadButton.layer.cornerRadius = 5
        uploadButton.backgroundColor = UIColor.mainColor()
        uploadButton.setTitleColor(.whiteColor(), forState: .Normal)
        
        initQuiz()
    }
    
    func initQuiz() {
        quiz = Quiz(qid: "nomatter", title: "", creationdate: getDateAsString())
        let addbuttonquestion = Question(qid: "addnewquiz", question: "nomatter", answer: "nomatter")
        quiz.addQuestion(addbuttonquestion)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Delegate methods
    
    func addQuestion(question: Question, order: Int) {
        if isItNewQuestion(order) {
            quiz.addQuestion(question)
        } else {
            quiz.questions[order] = question
        }
    }
    
    func isItNewQuestion(order: Int) -> Bool {
        if order == 0 {
            return true
        } else {
            return false
        }
    }
    
    func getQuestion(order: Int) -> Question {
        return quiz.questions[order]
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddQuestionCell") as! AddQuestionTableViewCell
        let index = indexPath.row
        if quiz.questions[index].qid != "addnewquiz" {
            cell.orderLabel.text = String(index)
            cell.questionLabel.text = quiz.questions[index].question
        } else {
            cell.orderLabel.text = "+"
            cell.questionLabel.text = "new question to quiz"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SegueAddQuestion", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let index = indexPath.row
            self.quiz.questions.removeAtIndex(index)
            self.tableView.reloadData()
        } else {
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueAddQuestion" {
            let vc = segue.destinationViewController as! AddQuestionViewController
            vc.delegate = self
            vc.order = (sender as! NSIndexPath).row
        }
    }
    
    @IBAction func uploadButtonPressed(sender: AnyObject) {
        SwiftSpinner.show("Uploading the quiz")
        let ref = FIRDatabase.database().reference().child("quizzes").childByAutoId()
        let quizDict: NSDictionary = ["title": quizTitle.text!,
                                  "creationDate": getDateAsString()]
        ref.setValue(quizDict)
        
        let newRef = FIRDatabase.database().reference().child("questions/\(ref.key)")
        for question in quiz.questions {
            if question.options.count > 0 {
                let dict: NSDictionary = ["question" : question.question, "option1" : question.options[0],
                                          "option2" : question.options[1], "option3" : question.options[2],
                                          "option4" : question.options[3], "answer" : ""]
                newRef.childByAutoId().setValue(dict)
            }
        }
        SwiftSpinner.hide()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func getDateAsString() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        
        var ldh = "", ldm = ""
        if hour < 10 { ldh = "0"}
        if minute < 10 { ldm = "0"}
        
        return "\(day).\(month).\(year), \(ldh)\(hour):\(ldm)\(minute)"
    }
}
