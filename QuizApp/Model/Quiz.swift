//
//  Quiz.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

public struct Quiz: Codable {
    let id:Int
    let title:String
    let lernstoff:String
    let questions:[Question]
}
