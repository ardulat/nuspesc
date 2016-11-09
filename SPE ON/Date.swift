//
//  Date.swift
//  Doner
//
//  Created by Anuar's mac on 23.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import Foundation

extension NSDate {
    
    /**
     Enter argument in "dd-mm-yyyy-H-mm-s"
     
     - parameter string: "dd mm yyyy"
     */
    
    func transformDateToCorrectString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd mm yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
}