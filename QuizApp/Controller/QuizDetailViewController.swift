//
//  QuizDetailViewController.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation
import UIKit

class QuizDetailViewController: UIViewController, UITextViewDelegate {
    var quiz: Quiz?
    var learningTextHasChanged = false
    internal var editModeEnabled: Bool? {
        didSet {
            if let enabled = editModeEnabled {
                setTextfieldStyle(editEnabled: enabled)
                constraintTextViewHeight.constant = textViewLearning.contentSize.height
                buttonEdit.setTitle(enabled ? "Abbrechen" : "Ändern" , for: .normal)
                buttonStartQuiz.isEnabled = !enabled
                buttonStartQuiz.backgroundColor = !enabled ? .systemBlue : .systemGray
                self.textViewLearning.layoutIfNeeded()
                self.textViewLearning.layoutSubviews()
                buttonStartQuiz.layoutSubviews()
                self.buttonStartQuiz.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    @IBOutlet weak var buttonStartQuiz: UIButton!
    @IBOutlet weak var labelQuizTitle: UILabel!
    @IBOutlet weak var textViewLearning: UITextView!
    @IBOutlet weak var constraintTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintButtonVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var buttonEdit: UIButton!
    
    override func viewDidLoad() {
        textViewLearning.layer.borderWidth = 0.5
        textViewLearning.sizeToFit()
        buttonStartQuiz.layer.cornerRadius = 8.0
        if let quiz = quiz {
            textViewLearning.text = quiz.lernstoff
            labelQuizTitle.text = quiz.title
        }
        editModeEnabled = false
        textViewLearning.delegate = self
    }
    
    internal func setTextfieldStyle(editEnabled: Bool) {
        textViewLearning.isEditable = editEnabled
        if editEnabled {
            textViewLearning.backgroundColor = .systemGray6
            textViewLearning.layer.borderColor = UIColor.systemGray.cgColor
            textViewLearning.layer.cornerRadius = 8.0
        } else {
            textViewLearning.backgroundColor = .white
            textViewLearning.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func onButtonEdit(_ sender: UIButton) {
        if learningTextHasChanged {
            let alertVC = UIAlertController(title: "Lernstoff ändern", message: "Bist du dir sicher, dass den Lernstoff ändern möchtest?", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Änderungen übernehmen", style: .default, handler: { _ in
                //TODO: post Request
                self.learningTextHasChanged = false
            }))
            alertVC.addAction(UIAlertAction(title: "Änderungen verwefen", style: .cancel, handler: {_ in
                self.resetLernstoff()
            }))
            present(alertVC, animated: true, completion: nil)
        }
        editModeEnabled = !(editModeEnabled ?? false)
    }
    
    @IBAction func onButtonStartQuiz(_ sender: UIButton) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let quiz = quiz, quiz.lernstoff != textView.text {
            learningTextHasChanged = true
            buttonEdit.setTitle("Fertig", for: .normal)
        } else {
            learningTextHasChanged = false
            buttonEdit.setTitle("Abbrechen", for: .normal)
        }
    }
    
    internal func resetLernstoff() {
        textViewLearning.text = self.quiz?.lernstoff
        learningTextHasChanged = false
    }
}
