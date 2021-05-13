//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    
    private var buttons: [UIButton]?
    private static var questionNo: Int = 1
    private static var maxQuestionNo: Int = 10
//    private var question: Question?
//    private var answers: [Answer]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [firstAnswerButton, secondAnswerButton, thirdAnswerButton, fourthAnswerButton]
        styleUI()
//        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func styleUI() {
        guard let buttons = buttons else { return }
        for button in buttons {
            button.setupCornerRadius(cornerRadius: 20)
        }
    }
    
//    private func fetchData() {
//        guard let question = question, let answers = answers else { return }
//        questionNoLabel.text = "Question \(questionNo) of \(maxQuestionNo)"
//        questionLabel.text = question
//        var count = 0
//        for answer in answers {
//            buttons[count].text = answer
//            count += 1
//        }
//    }
}

extension UIButton {
    public func setupCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}
