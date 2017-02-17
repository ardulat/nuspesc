//
//  QuizzesListViewController.swift
//  Doner
//
//  Created by MacBook on 30.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

protocol QuizVerifier {
    func getDoneQuiz(qid: String) -> DoneQuiz
}

class QuizzesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QuizVerifier {
    
    var quizzes = [Quiz]()
    var donequizzes = [DoneQuiz]()
    var isAdmin = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        SwiftSpinner.show("Loading your quiz records")
        downloadQuizzesList()
        checkingForAdmin()
        if !isAdmin {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func checkingForAdmin() {
        isAdmin = NSUserDefaults.standardUserDefaults().boolForKey("admin")
    }
    

    func getDoneQuiz(qid: String) -> DoneQuiz {
        for q in donequizzes {
            if qid == q.qid {
                return q
            }
        }
        let q = DoneQuiz(qid: "no", points: 0, total: 0)
        return q
    }
    
    func downloadQuizzesList() {
        let ref = FIRDatabase.database().reference().child("quizzes/")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.exists() && snap.value != nil {
                self.quizzes.removeAll()
                for (key, value) in snap.value as! [String: AnyObject] {
                    let quiz = Quiz(qid: key, title: value["title"] as! String, creationdate: value["creationDate"] as! String)
                    
                    let diff = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: quiz.creationdate, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
                    
                    if diff.year == 0 && diff.month == 0 && diff.day <= 7 {
                        self.quizzes.append(quiz)
                    }
                }
                self.sortByDate()
                self.tableView.reloadData()
                self.downloadUserDoneQuiz()
            }
        }
    }
    
    func downloadUserDoneQuiz() {
        let id = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("quizAndUsers/\(id!)")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.exists() && snap.value != nil {
                self.donequizzes.removeAll()
                let arr = snap.value as! [String: AnyObject]
                for (_, value) in arr {
                    let quiz = DoneQuiz(qid: value["qid"] as! String, points: value["points"] as! Int, total: value["total"] as! Int)
                    self.donequizzes.append(quiz)
                }
                self.tableView.reloadData()
            }
            SwiftSpinner.hide()
        }
    }
    
    func sortByDate() {
        quizzes.sortInPlace { (a, b) -> Bool in
            a.creationdate.compare(b.creationdate) == .OrderedDescending
        }
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isAdmin
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            SwiftSpinner.show("Deleting your quiz, be patient")
            self.deleteQuizWithId(quizzes[indexPath.row].qid)
        } else {
            
        }
    }
    
    func deleteQuizWithId(qid: String) {
        let ref = FIRDatabase.database().reference().child("quizzes/\(qid)")
        ref.setValue(nil)
        SwiftSpinner.hide()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuizCell", forIndexPath: indexPath) as UITableViewCell as! QuizTableViewCell
        let index = indexPath.row
        cell.quizTitle!.text = quizzes[index].title
        cell.dateTitle!.text = getDateAsString(quizzes[index].creationdate)
        cell.markImageView.image = UIImage(named: "undone")
        for done in donequizzes {
            if quizzes[index].qid == done.qid {
                cell.markImageView.image = UIImage(named: "done")
                break
            }
        }
        return cell
    }
    
    func getDateAsString(date: NSDate) -> String {
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
        
        return "\(day).\(ldh)\(month).\(ldm)\(year)"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SegueQuiz", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueQuiz" {
            let vc = segue.destinationViewController as! QuizViewController
            vc.quiz = self.quizzes[(sender as! NSIndexPath).row]
            vc.delegate = self
        } else
            if segue.identifier == "SegueAddQuiz" {
                _ = segue.destinationViewController as! AddQuizViewController
        }
    }
}
