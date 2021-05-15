//
//  Score.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation

public struct Score: Codable {
    let _id: String
    let quizId: String
    let username: String
    let record: Int
    let Created_date: Date
}
