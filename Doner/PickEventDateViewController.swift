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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
