//
//  Answer.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

struct Answer: Codable {
    let id: Int
    let text: String
    let isCorrect: Bool
}
