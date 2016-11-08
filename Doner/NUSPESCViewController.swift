//
//  NUSPESCViewController.swift
//  Doner
//
//  Created by Anuar's mac on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class NUSPESCViewController: UIViewController {

    @IBOutlet weak var nuspescLabel: UILabel!
    @IBOutlet weak var textLabel: UITextView!
    
    var text = "Nazarbayev University Society of Petroleum Engineers Student Chapter is established so as to gather together the students who relate their future career with Oil and Gas Industry, provide them useful technical knowledge, and network them with global student members and professionals."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.mainColor().CGColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame =  CGRectMake(0, CGRectGetHeight(nuspescLabel.frame), CGRectGetWidth(nuspescLabel.frame), 1)
        nuspescLabel.layer.addSublayer(bottomBorder)
        
        textLabel.text = text

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
