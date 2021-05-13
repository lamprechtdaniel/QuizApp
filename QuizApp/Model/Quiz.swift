//
//  Quiz.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

class Quiz: Fetchable {
    
    static var items: [Quiz] = []
    
    var questions: [Question]
}
