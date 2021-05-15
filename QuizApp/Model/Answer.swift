//
//  Answer.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

public struct Answer: Codable {
    let _id: String
    let answer: String
    let isCorrect: Bool
}
