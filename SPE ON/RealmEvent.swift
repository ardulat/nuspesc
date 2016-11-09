//
//  RealmObjects.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEvent: Object {
    dynamic var eventid = ""
    dynamic var title = ""
    dynamic var date = ""
    
    func setDateAsString(date: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        
        var ldh = "", ldm = ""
        if hour < 10 { ldh = "0"}
        if minute < 10 { ldm = "0"}
        self.date = "\(day).\(month).\(year), \(ldh)\(hour):\(ldm)\(minute)"
    }
    
    func getDateAsNSDate() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.dateFromString(date)!
    }
}

class RealmEventManager: NSObject {
    let realm = try! Realm()
    
    func addEventToRealm(eventid: String, title: String, date: String) {
        let re = RealmEvent()
        re.eventid = eventid
        re.date = date
        re.title = title
        try! realm.write {
            realm.add(re)
        }
    }
    
    func getEvents() -> [String] {
        let result = Array(realm.objects(RealmEvent.self))
        var dates = [String]()
        for e in result {
            dates.append(e.date)
        }
        return dates
    }
}