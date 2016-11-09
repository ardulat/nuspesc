//
//  RealmObjects.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import Foundation
import RealmSwift

class RealmQuiz: Object {
    dynamic var qid = ""
    dynamic var score = 0
    dynamic var total = 0
}