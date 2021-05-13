//
//  Question.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

public struct Question: Codable {
    let id: Int
    let question: String
    let answers: [Answer]
}
