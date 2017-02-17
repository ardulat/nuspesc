//
//  OverviewViewController.swift
//  Doner
//
//  Created by MacBook on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

class OverviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    @IBOutlet weak var newsOutlet: UIButton!
    
    var articles = [Article]()
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading...")
        downloadRecentArticles()
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        
        let topBorder1: CALayer = CALayer()
        topBorder1.borderColor = UIColor.mainColor().CGColor
        topBorder1.borderWidth = 1
        topBorder1.frame = CGRectMake(0, 0, CGRectGetWidth(newsOutlet.frame) - 1, 1)
        newsOutlet.layer.addSublayer(topBorder1)
        
        let bottomBorder1: CALayer = CALayer()
        bottomBorder1.borderColor = UIColor.mainColor().CGColor
        bottomBorder1.borderWidth = 1
        bottomBorder1.frame =  CGRectMake(0, CGRectGetHeight(newsOutlet.frame), CGRectGetWidth(newsOutlet.frame) - 100, 1)
        newsOutlet.layer.addSublayer(bottomBorder1)
    }
    
    func downloadRecentArticles() {
        let ref = FIRDatabase.database().reference().child("articles/")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            if  snap.exists() && snap.value != nil {
                let postDict = snap.value as! [String : AnyObject]
                for article in self.articles {
                    article.imageUrl = ""
                }
                self.articles.removeAll()
                for (key, inside) in postDict {
                    
                    let article = Article(aid: key, title: inside["title"] as! String, text: inside["text"] as! String, date: inside["date"] as! String, hasEvent: inside["hasEvent"] as! Bool, eventDate: inside["eventDate"] as! String)
                    
                    if (!article.hasEvent) {
                        self.articles.append(article)
                    } else {
                        let diff = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: NSDate(), toDate: self.gdate(article.eventDate), options: NSCalendarOptions.init(rawValue: 0))
                        if (article.hasEvent && diff.year == 0 && diff.month == 0 && diff.day <= 7) {
                            self.articles.append(article)
                        }
                    }
                }
                self.sortByDate()
                self.recentCollectionView.reloadData()
            }
            SwiftSpinner.hide()
        }
    }
    
    func sortByDate() {
        articles.sortInPlace { (a, b) -> Bool in
            gdate(a.date).compare(gdate(b.date)) == .OrderedDescending
        }
    }
    
    func gdate(str: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.dateFromString(str)!
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ArticleCell", forIndexPath: indexPath) as! RecentCollectionViewCell
        
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = cell.center
        cell.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let index = indexPath.row
        cell.titleLabel.text = articles[index].title
        cell.dateLabel.text = articles[index].date
        if articles[index].imageUrl == "" {
            let reference = FIRStorage.storage().reference().child("images/\(articles[index].aid).jpg")
            reference.downloadURLWithCompletion { (URL, error) -> Void in
                if (error != nil) {
                    // Handle any errors
                } else {
                    print(URL)
                    let url = (URL?.absoluteString)!
                    cell.mainImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "enot"), completion: nil)
                    self.articles[index].imageUrl = url
                    self.activityIndicator.stopAnimating()
                }
            }
        } else {
            cell.mainImageView.loadImageFromURLString(articles[index].imageUrl, placeholderImage: UIImage(named: "enot"), completion: nil)
        }

        return cell
    }
    
    @IBAction func logOutPressed(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewControllerWithIdentifier("RegistrationViewController") as! RegistrationViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SegueOverviewToArticle", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueOverviewToArticle" {
            let vc = segue.destinationViewController as! ArticleViewController
            vc.currentArticle = articles[(sender as! NSIndexPath).row]
            vc.articlePassed = true
        }
    }
}
