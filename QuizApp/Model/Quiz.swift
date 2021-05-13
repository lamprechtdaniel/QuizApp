//
//  Quiz.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

struct Quiz: Codable {
    let id:Int
    let lernstoff:String
    let questions:[Question]
}
