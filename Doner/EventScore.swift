//
//  EventScore.swift
//  Doner
//
//  Created by MacBook on 23.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import Foundation

class EventScore {
    var esid: String = ""
    var fullName: String = ""
    var score: Int = 0
    
    init(esid: String, fullName: String, score: Int) {
        self.esid = esid
        self.fullName = fullName
        self.score = score
    }
}

class GlobalScore {
    var gsid: String = ""
    var fullName: String = ""
    var quizPoints: Int = 0
    var bonusPoints: Int = 0
    
    init(gsid: String, fullName: String, quizPoints: Int, bonusPoints: Int) {
        self.gsid = gsid
        self.fullName = fullName
        self.bonusPoints = bonusPoints
        self.quizPoints = quizPoints
    }
}