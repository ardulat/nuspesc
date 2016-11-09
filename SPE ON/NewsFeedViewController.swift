//
//  NewsFeedViewController.swift
//  Doner
//
//  Created by MacBook on 13.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import KFSwiftImageLoader

class NewsFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var newsFeedCollectionView: UICollectionView!
    
    @IBOutlet weak var addArticleButton: UIBarButtonItem!
    
    private let leftAndRightPaddins: CGFloat = 300.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 30.0
    
    var isAdmin: Bool = false
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAllArticles()
        
        newsFeedCollectionView.delegate = self
        newsFeedCollectionView.dataSource = self
        newsFeedCollectionView.showsVerticalScrollIndicator = false
        
        checkingForAdmin()
        if !isAdmin {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func checkingForAdmin() {
        isAdmin = NSUserDefaults.standardUserDefaults().boolForKey("admin")
    }
    
    func downloadAllArticles() {
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
                self.newsFeedCollectionView.reloadData()
            }
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        let widthAvailableForAllItems = (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)
        let widthForOneItem = widthAvailableForAllItems / numberOfItemsPerRow - flowLayout.minimumInteritemSpacing
        return CGSize(width: CGFloat(widthForOneItem), height: CGFloat(widthForOneItem + 40.0))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ArticleCell", forIndexPath: indexPath) as! AllNewsCollectionViewCell
        let index = indexPath.row
        cell.titleLabel.text = articles[index].title
        cell.dateLabel.text = articles[index].date
        
        if articles[index].imageUrl == "" {
            let reference = FIRStorage.storage().reference().child("images/\(articles[index].aid).jpg")
            reference.downloadURLWithCompletion { (URL, error) -> Void in
                if (error != nil) {
                    // Handle any errors
                } else {
                    //print(URL)
                    let url = (URL?.absoluteString)!
                    cell.mainImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "enot"), completion: nil)
                    self.articles[index].imageUrl = url
                }
            }
        } else {
            cell.mainImageView.loadImageFromURLString(articles[index].imageUrl, placeholderImage: UIImage(named: "enot"), completion: nil)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }
    
    @IBAction func addNewArticle(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("SegueNewsToArticle", sender: nil)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SegueNewsToArticle", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueNewsToArticle" {
            let vc = segue.destinationViewController as! ArticleViewController
            if sender != nil {
                vc.currentArticle = articles[(sender as! NSIndexPath).row]
                vc.articlePassed = true
            }
        }
    }
}
