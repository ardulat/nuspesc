//
//  EventScoreboardViewController.swift
//  Doner
//
//  Created by MacBook on 23.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

class EventScoreboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var ref: FIRDatabaseReference!
    
    var eventScores = [EventScore]()
    
    var isAdmin: Bool = false
    
    var addParticipant: UIBarButtonItem! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        SwiftSpinner.show("Loading Scoreboard")
        downloadScores()
        checkingForAdmin()
        if isAdmin {
            addParticipant = UIBarButtonItem(title: "Add participant", style: .Plain, target: self, action: #selector(EventScoreboardViewController.addParticipantButtonPressed))
            self.navigationItem.setRightBarButtonItems([addParticipant], animated: true)
            
        }
    }
    
    func checkingForAdmin() {
        isAdmin = NSUserDefaults.standardUserDefaults().boolForKey("admin")
    }
    
    func downloadScores() {
        ref = FIRDatabase.database().reference().child("/eventScores")

        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.value != nil {
                let postDict = snap.value as! [String : AnyObject]
                self.eventScores.removeAll()
                for (key, inside) in postDict {
                    let eventScore = EventScore(esid: key as String!, fullName: inside["fullName"] as! String!, score: Int(inside["score"] as! String)!)
                    if eventScore.fullName != "example" {
                        self.eventScores.append(eventScore)
                    }
                }
                
                self.sortByScore()
                self.tableView.reloadData()
                SwiftSpinner.hide()
            }
        }
    }
    
    func sortByScore() {
        eventScores.sortInPlace { (a, b) -> Bool in
            a.score > b.score
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventScores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventScoreCell", forIndexPath: indexPath) as! EventScoreCell
        let index = indexPath.row
        
        if index == 0 {
            cell.positionLabel.text = "#"
            cell.fullNameLabel.text = "Full Name"
            cell.scoreLabel.text = "Points"
        } else {
            cell.positionLabel.text = String(index)
            cell.fullNameLabel.text = eventScores[index].fullName
            cell.scoreLabel.text = String(eventScores[index].score)
        }
        
        if index % 2 == 0 {
            cell.backgroundColor = .lightGrayColor()
        } else {
            cell.backgroundColor = .whiteColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isAdmin {
            performSegueWithIdentifier("SegueEditEventScore", sender: indexPath)
        }
    }
    
    func addParticipantButtonPressed() {
        self.performSegueWithIdentifier("AddNewEventScore", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueEditEventScore" {
            let vc = segue.destinationViewController as! AddEventScoreViewController
            vc.eventScore = eventScores[(sender as! NSIndexPath).row]
        } else
            if segue.identifier == "AddNewEventScore" {
                
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isAdmin
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteEventScore(eventScores[indexPath.row].esid)
        } else {
            
        }
    }
    
    func tableView(tableView: UITableView, canRemoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isAdmin
    }
    
    func deleteEventScore(id: String) {
        ref = FIRDatabase.database().reference().child("/eventScores/\(id)")
        ref.removeValue()
        tableView.reloadData()
    }
}
