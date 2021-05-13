//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation
import UIKit

private var quizData: Quiz = Quiz(
    id: 1,
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

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    
    private var buttons: [UIButton]?
    private var maxQuestionNo: Int?
    private var quiz: Quiz?
    private var correctAnswer: Int?
    private var selectedAnswer: Int?
    private var questionNo: Int = 1 {
        didSet {
            moveForward()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [firstAnswerButton, secondAnswerButton, thirdAnswerButton, fourthAnswerButton]
        styleUI()
        fetchQuiz()
    }
    
    private func styleUI() {
        guard let buttons = buttons else { return }
        for button in buttons {
            button.setupCornerRadius(cornerRadius: 20)
        }
    }
    
    private func fetchQuiz() {
        quiz = quizData
        maxQuestionNo = quiz?.questions.count ?? 0
        
        fetchQuestion()
    }
    
    private func fetchQuestion() {
        guard let quiz = quiz,
              let maxQuestionNo = maxQuestionNo,
              let buttons = buttons
        else { return }
        if questionNo-1 >= quiz.questions.count {
            // TODO: replace with move to scoreview
            return
        }
        
        if let selectedAnswer = selectedAnswer, let correctAnswer = correctAnswer {
            buttons[selectedAnswer].layer.borderWidth = 0
            buttons[selectedAnswer].backgroundColor = UIColor(hexString: "DEE0E4", alpha: 1.00)
            buttons[correctAnswer].backgroundColor = UIColor(hexString: "DEE0E4", alpha: 1.00)
        }
        
        questionNoLabel.text = "Question \(questionNo) of \(maxQuestionNo)"
        questionLabel.text = quiz.questions[questionNo-1].question
        var count = 0
        for answer in quiz.questions[questionNo-1].answers {
            buttons[count].setTitle(answer.text, for: .normal)
            if answer.isCorrect { correctAnswer = count }
            count += 1
        }
    }
    
    private func moveForward() {
        fetchQuestion()
    }
    
    @IBAction func onAnswerTap(_ sender: UIButton) {
        guard let correctAnswer = correctAnswer, let buttons = buttons else { return }
        
        selectedAnswer = sender.tag
        
        if selectedAnswer == correctAnswer {
            buttons[sender.tag].layer.borderWidth = 3
            buttons[sender.tag].layer.borderColor = UIColor.green.cgColor
            buttons[sender.tag].backgroundColor = UIColor.green.withAlphaComponent(0.2)
        } else {
            buttons[sender.tag].layer.borderWidth = 3
            buttons[sender.tag].layer.borderColor = UIColor.red.cgColor
            buttons[correctAnswer].backgroundColor = UIColor.green.withAlphaComponent(0.2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.questionNo += 1
        }
    }
}
