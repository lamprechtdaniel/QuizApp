//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    private let scoreViewController = ScoreViewController()
    
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var jokerButton: UIButton!
    
    private var buttons: [UIButton]?
    private var maxQuestionNo: Int?
    public var quiz: Quiz?
    private var correctAnswer: Int?
    private var selectedAnswer: Int?
    private var score: Int = 0
    private var questionNo: Int = 1 {
        didSet {
            moveForward()
        }
    }
    private var jokerUsed = false {
        didSet {
            UIView.animate(withDuration: 0.5, animations: {
                self.jokerButton.alpha = 0
            }, completion: { completed in
                self.jokerButton.isEnabled = false
            })
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
        cancelButton.layer.cornerRadius = 8
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func fetchQuiz() {
//        quiz = quizData
        maxQuestionNo = quiz?.questions.count ?? 0
        
        fetchQuestion()
    }
    
    private func fetchQuestion() {
        guard let quiz = quiz,
              let maxQuestionNo = maxQuestionNo,
              let buttons = buttons
        else { return }
        if questionNo-1 >= quiz.questions.count {
            moveToQuizList()
            performSegue(withIdentifier: "showLeaderboard", sender: nil)
            return
        }
        
        for button in buttons {
            button.layer.borderWidth = 0
            button.isUserInteractionEnabled = true
            button.backgroundColor = UIColor(hexString: "DEE0E4", alpha: 1.00)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ScoreViewController {
            destinationViewController.score = score
        }
    }
    
    @IBAction func onAnswerTap(_ sender: UIButton) {
        guard let correctAnswer = correctAnswer, let buttons = buttons else { return }
        
        selectedAnswer = sender.tag
        
        if selectedAnswer == correctAnswer {
            buttons[sender.tag].layer.borderWidth = 3
            buttons[sender.tag].layer.borderColor = UIColor.green.cgColor
            buttons[sender.tag].backgroundColor = UIColor.green.withAlphaComponent(0.2)
            score += 1
        } else {
            buttons[sender.tag].layer.borderWidth = 3
            buttons[sender.tag].layer.borderColor = UIColor.red.cgColor
            buttons[correctAnswer].backgroundColor = UIColor.green.withAlphaComponent(0.2)
        }
        
        for button in buttons {
            button.isUserInteractionEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.questionNo += 1
        }
    }
    @IBAction func onCancelTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "Achtung", message: "Möchtest du das Quiz wirklich beenden?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            self.navigationController?.isNavigationBarHidden = false
            self.moveToQuizList(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func moveToQuizList(animated: Bool = false) {
        if let nc = self.navigationController, let quizListVC = nc.viewControllers.filter({ $0 is QuizListTableViewController }).first {
            nc.popToViewController(quizListVC, animated: animated)
        }
    }
    
    @IBAction func onJokerTap(_ sender: UIButton) {
        jokerUsed = true
        
        guard let quiz = quiz, let buttons = buttons else { return }
        let incorrectAnswers = quiz.questions[questionNo-1].answers.filter { $0.isCorrect == false }
        let pickedIncorrectAnswers = incorrectAnswers[randomPick: 2]
        _ = buttons.filter({ (button: UIButton) -> Bool in
            return pickedIncorrectAnswers.contains(where: { (answer: Answer) -> Bool in
                return answer.text == button.title(for: .normal)
            })
        }).map({ button in
            button.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                button.backgroundColor = UIColor(hexString: "DEE0E4", alpha: 0.3)
            })
        })
    }
}
