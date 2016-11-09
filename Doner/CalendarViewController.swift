//
//  CalendarViewController.swift
//  Doner
//
//  Created by Anuar's mac on 18.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftSpinner
import Firebase

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var events: [Event] = []
    var currentEvents: [Event] = []
    var articles: [Article] = []
    var currentArticles: [Article] = []
    var selectedDay: String?
    var eventsCounter = 0
    
    var months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var monthsImgs: [UIImage] = []
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.calendarView.registerCellViewXib(fileName: "CellView")
        
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        daysOfTheWeek()
        setMonthsImages()
        
        let todayDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let dateString = dateFormatter.stringFromDate(todayDate)
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let monthNum = calendar.component(.Month, fromDate: todayDate)
        
        monthLabel.text = months[monthNum-1] + " " + dateString
        imageView.image = monthsImgs[monthNum-1]
        
        downloadRecentArticles()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func setMonthsImages() {
        
        for i in 0..<12 {
            let monthImg = UIImage(named: months[i])
            monthsImgs.append(monthImg!)
        }
    }
    
    func daysOfTheWeek() {
        let days = ["M", "T", "W", "R", "F", "S", "U"]
        
        for i in 0..<7 {
            let iFloat = CGFloat(i)
            let day = UILabel(frame: CGRectMake(iFloat*view.frame.width/7, imageView.frame.size.height - 30, view.frame.width/7, 30))
            day.text = days[i]
            day.textAlignment = .Center
            day.textColor = .whiteColor()
            
            self.view.addSubview(day)
        }
    }
    
    func downloadRecentArticles() {
        let ref = FIRDatabase.database().reference().child("articles/")
        SwiftSpinner.show("Loading events")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.value != nil {
                let postDict = snap.value as! [String : AnyObject]
                self.events.removeAll()
                self.articles.removeAll()
                for (key, inside) in postDict {
                    
                    let hasEvent = inside["hasEvent"] as! Bool
                    
                    if hasEvent == true {
                        let creationdate = inside["date"] as! String
                        let date = inside["eventDate"] as! String
                        let title = inside["title"] as! String
                        let text = inside["text"] as! String
                        
                        let event = Event(id: key, date: date, title: title)
                        self.events.append(event)
                        let article = Article(aid: key, title: title, text: text, date: creationdate, hasEvent: hasEvent, eventDate: date)
                        self.articles.append(article)
                    }
                }
                SwiftSpinner.hide()
            }
            self.sortByDate()
            self.tableView.reloadData()
        }
    }
    
    func sortByDate() {
        events.sortInPlace { (a, b) -> Bool in
            gdate(a.date).compare(gdate(b.date)) == .OrderedAscending
        }
    }
    
    func getMonthAndYear(string: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = dateFormatter.dateFromString(string)
        return dateFormatter.stringFromDate(date!)
    }
    
    func getDayAndMonth(string: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let date = dateFormatter.dateFromString(string)
        return dateFormatter.stringFromDate(date!)
    }
    
    func getCurrentDay() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.stringFromDate(NSDate())
    }
    
    // MARK: -TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArticles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        let index = indexPath.row
        let event = currentArticles[index]
        
        let eventTime = event.eventDate
        let time = eventTime.substringFromIndex(eventTime.endIndex.advancedBy(-5))
        cell.setEventCell(time, title: event.title)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Downloading images of articles
        let reference = FIRStorage.storage().reference().child("images/\(currentArticles[indexPath.row].aid).jpg")
        reference.downloadURLWithCompletion { (URL, error) -> Void in
            if (error != nil) {
                // Handle any errors
            } else {
                let url = (URL?.absoluteString)!
                self.currentArticles[indexPath.row].imageUrl = url
                self.performSegueWithIdentifier("EventToArticle", sender: indexPath)
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventToArticle" {
            let articleVC = segue.destinationViewController as! ArticleViewController
            let index = (sender as! NSIndexPath).row
            
            articleVC.currentArticle = currentArticles[index]
            articleVC.currentArticle.aid = currentEvents[index].id
            
            articleVC.articlePassed = true

            self.navigationController?.navigationBarHidden = false
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    // Setting up manditory protocol method
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        
        let numberOfRows = 6
        let aCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let currentDate = NSDate()
        let yearLater = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 12, toDate: currentDate, options: [])
        calendarView.firstDayOfWeek = .Monday
        
        return (startDate: currentDate, endDate: yearLater!, numberOfRows: numberOfRows, calendar: aCalendar)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        
        guard let cell = cell as? CellView else {
            NSLog("error cell calendar")
            return
        }
        cell.setupCellBeforeDisplay(cellState, date: date, displayDot: false)
        cell.setDeselected()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        if events.count != 0 {
            for index in 0..<events.count {
                let eventDate = dateFormatter.dateFromString(events[index].date)
                let calendar = NSCalendar.currentCalendar()
                let eventComponents = calendar.components([.Year, .Month, .Day], fromDate: eventDate!)
                let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                
                if eventComponents == dateComponents {
                    cell.setupCellBeforeDisplay(cellState, date: date, displayDot: true)
                }
            }
        }
    }
    
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        guard let cell = cell as? CellView else {
            NSLog("error cell")
            return
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        currentEvents.removeAll()
        for event in events {
            let eventDate = dateFormatter.dateFromString(event.date)
            let calendar = NSCalendar.currentCalendar()
            let eventComponents = calendar.components([.Year, .Month, .Day], fromDate: eventDate!)
            let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
            
            if eventComponents == dateComponents {
                currentEvents.append(event)
            }
        }
        
        currentArticles.removeAll()
        for article in articles {
            let articleDate = dateFormatter.dateFromString(article.eventDate)
            let calendar = NSCalendar.currentCalendar()
            let articleComponents = calendar.components([.Year, .Month, .Day], fromDate: articleDate!)
            let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
            
            if articleComponents == dateComponents {
                currentArticles.append(article)
            }
        }
        
        cell.setSelected()
        
        
        tableView.reloadData()
    }
    
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        guard let cell = cell as? CellView else {
            NSLog("no cellview")
            return
        }
        currentArticles.removeAll()
        cell.setDeselected()
    }
    
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let dateString = dateFormatter.stringFromDate(startDate)
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let monthNum = calendar.component(.Month, fromDate: startDate)
        
        monthLabel.text = months[monthNum-1] + " " + dateString
        imageView.image = monthsImgs[monthNum-1]
        
    }
}