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
                buttonEdit.setTitle(enabled ? "Abbrechen" : "Ändern" , for: .normal)
                buttonStartQuiz.isEnabled = !enabled
                buttonStartQuiz.backgroundColor = !enabled ? .systemBlue : .systemGray
                
            }
        }
    }
    
    @IBOutlet weak var buttonStartQuiz: UIButton!
    @IBOutlet weak var labelQuizTitle: UILabel!
    @IBOutlet weak var textViewLearning: UITextView!
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
                if let quiz = self.quiz {
                    SyncManager.shared.updateLearning(of: quiz._id, with: self.textViewLearning.text, changedAt: quiz.last_change, completion: { success in
                        if !success {
                            let alertViewController = UIAlertController(title: "Update fehlgeschlagen", message: "Der Lernstoff wurde in der Zwischenzeit geändert. Dein Text wurde in die Zwischenablage kopiert!", preferredStyle: .alert)
                            alertViewController.addAction(UIAlertAction(title: "Verstanden", style: .cancel, handler: nil))
                            DispatchQueue.main.async {
                                self.present(alertViewController, animated: true, completion: nil)
                            }
                            UIPasteboard.general.string = self.textViewLearning.text
                    
                            //TODO: auf antwort reagieren
                            //lernstoff laden und einfügen
                        }
                    })
                }
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
        performSegue(withIdentifier: "showQuizgame", sender: quiz)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? QuizViewController, let sender = sender as? Quiz {
            viewController.quiz = sender
        }
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
