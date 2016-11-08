//
//  Event.swift
//  Doner
//
//  Created by Anuar's mac on 23.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import Foundation
import UIKit

struct Event {
    var date: String
    var title: String
    var id: String
    
    init(id: String, date: String, title: String) {
        self.id = id
        self.date = date
        self.title = title
    }
}