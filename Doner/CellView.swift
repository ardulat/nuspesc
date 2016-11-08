//
//  CellView.swift
//  Doner
//
//  Created by Anuar's mac on 18.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CellView: JTAppleDayCellView {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dotLabel: UIView!
    
    var normalDayColor = UIColor.blackColor()
    var weekendDayColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate, displayDot: Bool) {
        // Setup Cell text
        dayLabel.text =  cellState.text
        
        // Setup text color
        configureTextColor(cellState)
        
        dotLabel.layer.cornerRadius = min(dotLabel.frame.size.height, dotLabel.frame.size.width) / 2.0
        
        // Display dot
        if displayDot {
            dotLabel.hidden = false
        } else {
            dotLabel.hidden = true
        }
        
    }
    
    func configureTextColor(cellState: CellState) {
        if cellState.dateBelongsTo == .ThisMonth {
            dayLabel.textColor = normalDayColor
        } else {
            dayLabel.textColor = weekendDayColor
        }
    }
    
    
    func setSelected(){
        
        self.layer.cornerRadius = min(self.frame.height, self.frame.width) / 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        
    }
    
    func setDeselected() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    
}
