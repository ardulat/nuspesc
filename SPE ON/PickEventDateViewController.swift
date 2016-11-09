//
//  PickEventDateViewController.swift
//  Doner
//
//  Created by MacBook on 05.11.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class PickEventDateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: PickEventDateDelegate!
    
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var detachButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachButton.backgroundColor = UIColor.mainColor()
        attachButton.setTitleColor(.whiteColor(), forState: .Normal)
        attachButton.layer.cornerRadius = 5
        detachButton.backgroundColor = UIColor.mainColor()
        detachButton.setTitleColor(.whiteColor(), forState: .Normal)
        detachButton.layer.cornerRadius = 5
        
        if delegate.isArticlePassed() {
            datePicker.date = delegate.getPassedArticleDate()
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        delegate.setPickedEventDate(true, date: datePicker.date)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        delegate.setPickedEventDate(false, date: datePicker.date)
        navigationController?.popViewControllerAnimated(true)
    }
    
}
