//
//  Quiz.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

public struct Quiz: Codable {
    var _id:String
    var title:String
    var lernstoff:String
    var questions:[Question]
    var last_change: Date
    
    
}
