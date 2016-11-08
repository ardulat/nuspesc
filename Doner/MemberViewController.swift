//
//  MemberViewController.swift
//  Doner
//
//  Created by Anuar's mac on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var textLabel: UITextView!
    
    var text = "Step 1\n\nFollow the link bellow and register\nhttp://www.spe.org/join/\n\nStep 2\n\nSend your membership number on spe@nu.edu.kz\n\nStep 3\n\nBe an active member of NU SPE SC :)"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.mainColor().CGColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame =  CGRectMake(0, CGRectGetHeight(memberLabel.frame), CGRectGetWidth(memberLabel.frame), 1)
        memberLabel.layer.addSublayer(bottomBorder)
        
        textLabel.text = text
        textLabel.userInteractionEnabled = true // default: true
        textLabel.editable = false // default: true
        textLabel.selectable = true // default: true
        textLabel.dataDetectorTypes = [.Link]
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
