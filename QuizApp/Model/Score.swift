//
//  Score.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation

public struct Score: Codable {
    let _id: String
    let timestamp: Date
    let quizId: Int
    let username: String
    let points: Int
}
