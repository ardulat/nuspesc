//
//  Article.swift
//  Doner
//
//  Created by MacBook on 13.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import Foundation

class DoneQuiz {
    var qid: String = ""
    var points: Int = 0
    var total: Int = 0
    init(qid: String, points: Int, total: Int) {
        self.qid = qid
        self.points = points
        self.total = total
    }
}

class Quiz {
    var qid: String = ""
    var title: String = ""
    var creationdate: NSDate
    var questions = [Question]()
    
    init(qid: String, title: String, creationdate: String) {
        self.qid = qid
        self.title = title
        self.creationdate = gdate(creationdate)
    }
    
    func addQuestion(question: Question) {
        self.questions.append(question)
    }
    
    func getScore() -> Int {
        var score = 0
        for question in questions {
            if question.answer == question.userAnswer {
                score = score + 1
            }
        }
        return score
    }
    
    func reserAnswers() {
        for question in questions {
            question.userAnswer = ""
        }
    }
    
    func randomizeQuiz() {
        for question in questions {
            question.randomizeQuestion()
        }
    }
}

class Question {
    var qid: String = ""
    var order: Int = 0
    var question: String = ""
    var answer: String = ""
    var userAnswer: String = ""
    var options = [String]()
    
    init(qid: String, question: String, answer: String) {
        self.qid = qid
        self.question = question
        self.answer = answer
        self.options = [String]()
    }
    
    func addOption(option: String) {
        self.options.append(option)
    }
    
    func isCorrect(option: String) -> Bool {
        if answer == option {
            return true
        }
        return false
    }
    
    func randomizeQuestion() {
        for _ in 0..<4 {
            let a = generateRandomNumber(0, upperLimit: 3)
            let b = generateRandomNumber(0, upperLimit: 3)
            if a != b {
                swap(&options[a], &options[b])
            }
        }
    }
    
    func generateRandomNumber(lowerLimit: Int, upperLimit: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperLimit - lowerLimit + 1))) + lowerLimit
    }
}

func gdate(str: String) -> NSDate {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
    return dateFormatter.dateFromString(str)!
}