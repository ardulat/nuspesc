//
//  AboutViewController.swift
//  Doner
//
//  Created by Anuar's mac on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var history: UIButton!
    @IBOutlet weak var nuspesc: UIButton!
    @IBOutlet weak var member: UIButton!
    
    var about = "We are the largest individual-member organization serving managers, engineers, scientists and other professionals worldwide in the upstream segment of the oil and gas industry."
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBarHidden = true

        aboutLabel.text = about
        
        let topBorder1: CALayer = CALayer()
        topBorder1.borderColor = UIColor.mainColor().CGColor
        topBorder1.borderWidth = 10
        topBorder1.frame = CGRectMake(0, 0, CGRectGetWidth(history.frame) - 1, 1)
        history.layer.addSublayer(topBorder1)
        
        let bottomBorder1: CALayer = CALayer()
        bottomBorder1.borderColor = UIColor.mainColor().CGColor
        bottomBorder1.borderWidth = 10
        bottomBorder1.frame =  CGRectMake(0, CGRectGetHeight(history.frame), CGRectGetWidth(history.frame) - 100, 1)
        history.layer.addSublayer(bottomBorder1)
        
        let bottomBorder2: CALayer = CALayer()
        bottomBorder2.borderColor = UIColor.mainColor().CGColor
        bottomBorder2.borderWidth = 10
        bottomBorder2.frame = CGRectMake(0, CGRectGetHeight(nuspesc.frame), CGRectGetWidth(nuspesc.frame) - 100, 1)
        nuspesc.layer.addSublayer(bottomBorder2)
        
        let bottomBorder3: CALayer = CALayer()
        bottomBorder3.borderColor = UIColor.mainColor().CGColor
        bottomBorder3.borderWidth = 10
        bottomBorder3.frame = CGRectMake(0, CGRectGetHeight(member.frame), CGRectGetWidth(member.frame) - 100, 1)
        member.layer.addSublayer(bottomBorder3)
        
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
