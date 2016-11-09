//
//  ScoreBoardMenuViewController.swift
//  Doner
//
//  Created by MacBook on 23.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class ScoreBoardMenuViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    let padding: CGFloat = 10.0
    var image: UIImage! = nil
    var imageView: UIImageView! = nil
    var imageView2: UIImageView! = nil
    
    var subview: UIView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    // title: String, text: String, imageUrl: String
    func initUI() {
        let subview = UIView(frame: view.frame)
        let width = self.view.frame.width - 2 * padding
        let height = (self.view.frame.height - (self.tabBarController?.tabBar.frame.height)! - (self.navigationController?.navigationBar.frame.height)!) - 6 * padding
        
        image = UIImage(named: "blue")
        
        imageView = UIImageView(image: image)
        //imageView.loadImageFromURLString(imageUrl, placeholderImage: UIImage(named: "enot"), completion: nil)
        imageView.frame = CGRect(x: padding, y: padding, width: width, height: height / 2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(ScoreBoardMenuViewController.goToEventScoreBoard))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        subview.addSubview(imageView)
    
        imageView2 = UIImageView(image: image)
        //imageView2.loadImageFromURLString(imageUrl, placeholderImage: UIImage(named: "enot"), completion: nil)
        imageView2.frame = CGRect(x: padding, y: imageView.frame.height + 2 * padding, width: width, height: height / 2)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action: #selector(ScoreBoardMenuViewController.goToGlobalScoreBoard))
        imageView2.userInteractionEnabled = true
        imageView2.addGestureRecognizer(tapGestureRecognizer2)
        
        subview.addSubview(imageView2)
        scrollView.addSubview(subview)
    }

    func goToEventScoreBoard() {
        performSegueWithIdentifier("SegueEventScoreboard", sender: nil)
    }
    
    func goToGlobalScoreBoard() {
        performSegueWithIdentifier("SegueGlobalScoreboard", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueEventScoreboard" {
            let vc = segue.destinationViewController as! EventScoreboardViewController
            vc.title = "Group 7"
        } else
            if segue.identifier == "SegueGlobalScoreboard" {
            let vc = segue.destinationViewController as! GlobalScoreViewController
            vc.title = "Group 8"
        }
    }
}
