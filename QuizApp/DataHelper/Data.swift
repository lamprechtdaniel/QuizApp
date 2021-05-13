//
//  Data.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation

public var quizData: Quiz = Quiz(
    id: 1,
    title: "Quiz 1",
    lernstoff: "tua lei brav lernen bua",
    questions: [
        Question(id: 1, question: "Question 1", answers: [
            Answer(id: 1, text: "Answer 1-1", isCorrect: false),
            Answer(id: 1, text: "Answer 1-2", isCorrect: true),
            Answer(id: 1, text: "Answer 1-3", isCorrect: false),
            Answer(id: 1, text: "Answer 1-4", isCorrect: false),
        ]),
        Question(id: 2, question: "Question 2", answers: [
            Answer(id: 1, text: "Answer 2-1", isCorrect: true),
            Answer(id: 2, text: "Answer 2-2", isCorrect: false),
            Answer(id: 3, text: "Answer 2-3", isCorrect: false),
            Answer(id: 4, text: "Answer 2-4", isCorrect: false),
        ]),
        Question(id: 3, question: "Question 3", answers: [
            Answer(id: 1, text: "Answer 3-1", isCorrect: false),
            Answer(id: 2, text: "Answer 3-2", isCorrect: false),
            Answer(id: 3, text: "Answer 3-3", isCorrect: false),
            Answer(id: 4, text: "Answer 3-4", isCorrect: true),
        ])
    ]
)

public var scoreData: [Score] = [
    Score(id: 1, timestamp: Date(), quizId: 1, username: "Motzl", points: 5),
    Score(id: 2, timestamp: Date(), quizId: 1, username: "Motzl", points: 7),
    Score(id: 3, timestamp: Date(), quizId: 1, username: "Motzl", points: 2),
    Score(id: 4, timestamp: Date(), quizId: 1, username: "Chrizz", points: 1),
    Score(id: 5, timestamp: Date(), quizId: 1, username: "Chrizz", points: 6),
    Score(id: 6, timestamp: Date(), quizId: 1, username: "Chrizz", points: 9),
    Score(id: 7, timestamp: Date(), quizId: 1, username: "Chrizz", points: 2),
    Score(id: 8, timestamp: Date(), quizId: 1, username: "Denno", points: 3),
    Score(id: 9, timestamp: Date(), quizId: 1, username: "Denno", points: 6),
    Score(id: 10, timestamp: Date(), quizId: 1, username: "Denno", points: 8)
]
