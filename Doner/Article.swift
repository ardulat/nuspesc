//
//  Article.swift
//  Doner
//
//  Created by MacBook on 13.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import Foundation


class Article {
    var aid: String = ""
    var title: String = ""
    var text: String = ""
    var date: String = ""
    var hasEvent: Bool = false
    var eventDate: String = ""
    var imageUrl: String = ""
    
    init(aid: String, title: String, text: String, date: String, hasEvent: Bool, eventDate: String) {
        self.aid = aid
        self.title = title
        self.text = text
        self.date = date
        self.hasEvent = hasEvent
        self.eventDate = eventDate
    }
}