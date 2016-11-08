//
//  HistoryViewController.swift
//  Doner
//
//  Created by Anuar's mac on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var textLabel: UITextView!
    
    var text = "In 1957, the organization was officially founded as SPE, a constituent society of AIME. SPE became a separately incorporated organization in 1985. Our history begins within the American Institute of Mining Engineers (AIME). AIME was founded in 1871 in Pennsylvania, USA, to advance the production of metals, minerals, and energy resources through the application of engineering. In 1913, a standing committee on oil and gas was created within AIME and proved to be the genesis of SPE. The Oil and Gas Committee of AIME soon evolved into the Petroleum Division of AIME as membership grew and as interest among the members was more clearly delineated among the mining, metallurgical, and petroleum specializations."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.mainColor().CGColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame =  CGRectMake(0, CGRectGetHeight(historyLabel.frame), CGRectGetWidth(historyLabel.frame), 1)
        historyLabel.layer.addSublayer(bottomBorder)
        
        textLabel.scrollEnabled = false
        
        textLabel.text = text
    }
    
    override func viewDidAppear(animated: Bool) {
        textLabel.scrollEnabled = true
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
