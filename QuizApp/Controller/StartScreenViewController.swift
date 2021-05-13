//
//  StartScreenViewController.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation
import UIKit

class StartScreenViewController: UIViewController {
    
    @IBOutlet weak var labelHeadline: UILabel!
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var labelActivityStatus: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    var quizzes: [Quiz]?
    
    override func viewDidLoad() {
        buttonSubmit.isHidden = true
        textfieldName.isHidden = true
        activityView.startAnimating()
        SyncManager.shared.syncQuizzes(completion: { result in
            
            switch result {
            case .success(let syncedQuizzes):
                self.quizzes = syncedQuizzes
                break
            case .failure( _, let loadedQuizzes):
                self.quizzes = loadedQuizzes
                break
            }
            
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                self.labelActivityStatus.isHidden = true
                self.buttonSubmit.isHidden = false
                self.textfieldName.isHidden = false
            }
        })
        
        labelWarning.isHidden = true
        labelName.isHidden = false
        textfieldName.tintColor = .systemGray
        textfieldName.placeholder = "Namen eingeben"
        
        if let userName = AppDelegate.storedUserName {
            textfieldName.text = userName
        } else {
            buttonSubmit.isEnabled = false
        }
        
        let cornerRadius = CGFloat(8.0)
        buttonSubmit.layer.cornerRadius = cornerRadius
        textfieldName.layer.cornerRadius = cornerRadius
        
        
    }
    
    @IBAction func onButtonSubmit(_ sender: Any) {
        AppDelegate.storedUserName = textfieldName.text
        performSegue(withIdentifier: "showQuizList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? QuizListTableViewController {
            destinationViewController.quizzes = quizzes
        } 
    }
    
    @IBAction func textfieldChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            let disable = textField.text == nil || textField.text?.count == 0
            enableOrDisableSubmit(enable: !disable)
            labelWarning.isHidden = !disable
            labelName.isHidden = disable
        }
    }
    @IBAction func textfieldBeginEditing(_ sender: Any) {
        textfieldName.backgroundColor = .white
        textfieldName.tintColor = .black
    }
    
    @IBAction func textfieldEndEditing(_ sender: Any) {
        textfieldName.backgroundColor = .systemGray6
        textfieldName.tintColor = .systemGray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textfieldName.endEditing(true)
    }
    
    internal func enableOrDisableSubmit(enable: Bool) {
        buttonSubmit.isEnabled = enable
        buttonSubmit.backgroundColor = enable ? .systemBlue : .lightGray
    }
    
    
}

