//
//  GlobalScoreViewController.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import SwiftSpinner
import Firebase

class GlobalScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var scores = [GlobalScore]()
    
    var isAdmin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        SwiftSpinner.show("Loading scoreboard")
        downloadGlobalScores()
        checkingForAdmin()
    }
    
    func checkingForAdmin() {
        isAdmin = NSUserDefaults.standardUserDefaults().boolForKey("admin")
    }
    
    func downloadGlobalScores() {
        let ref = FIRDatabase.database().reference().child("globalScores")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.value != nil {
                let postDict = snap.value as! [String : AnyObject]
                self.scores.removeAll()
                for (key, inside) in postDict {
                    let score = GlobalScore(gsid: key, fullName: inside["email"] as! String, quizPoints: Int(inside["quizPoints"] as! String)!, bonusPoints: Int(inside["bonusPoints"] as! String)!)
                    self.scores.append(score)
                }
                self.sortByScore()
                let score = GlobalScore(gsid: "dasd", fullName: "E-mail", quizPoints: 0, bonusPoints: 0)
                self.scores.insert(score, atIndex: 0)
                self.tableView.reloadData()
                SwiftSpinner.hide()
            }
        }
    }
    
    func sortByScore() {
        scores.sortInPlace { (a, b) -> Bool in
            a.bonusPoints + a.quizPoints > b.bonusPoints + b.quizPoints
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventScoreCell") as! EventScoreCell
        let index = indexPath.row
        if index == 0 {
            cell.positionLabel.text = "#"
            cell.fullNameLabel.text = "Full Name"
            cell.scoreLabel.text = "Points"
        } else {
            cell.positionLabel.text = String(index)
            cell.fullNameLabel.text = extractFullName(scores[index].fullName)
            cell.scoreLabel.text = String(scores[index].quizPoints + scores[index].bonusPoints)
        }
        
        if index % 2 == 0 {
            cell.backgroundColor = .lightGrayColor()
        } else {
            cell.backgroundColor = .whiteColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 && isAdmin {
            performSegueWithIdentifier("SegueEditGlobalScore", sender: indexPath)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueEditGlobalScore" {
            let vc = segue.destinationViewController as! EditGlobalScoreViewController
            let index = (sender as! NSIndexPath).row
            vc.title = extractFullName(scores[index].fullName)
            vc.score = scores[index]
        }
    }
    
    func extractFullName(email: String) -> String {
        var arr = Array(email.characters)
        var firstname = ""
        var lastname = ""
        var i = 0
        var newLen = arr.count - 1
        
        while arr[newLen] != "@" {
            newLen -= 1
        }
        
        while i < newLen && arr[i] != "." {
            firstname += String(arr[i])
            i = i + 1
        }
        i = i + 1
        while i < newLen {
            lastname += String(arr[i])
            i = i + 1
        }
        
        if lastname != "" {
            return firstname.capitalizingFirstLetter() + " " + lastname.capitalizingFirstLetter()
        } else {
            let index = firstname.startIndex
            let index2 = index.successor()
            return firstname.substringToIndex(index2).capitalizingFirstLetter() + " " + firstname.substringFromIndex(index2).capitalizingFirstLetter()
        }
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).uppercaseString
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
