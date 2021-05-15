//
//  QuizListTableViewController.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation
import UIKit

class QuizListTableViewController: UITableViewController {
    
    @IBOutlet weak var labelWelcome: UILabel!
    var quizzes: [Quiz]? {
        return Quiz.items
    }
    override func viewDidLoad() {
        labelWelcome.text = "Willkommen \(AppDelegate.storedUserName ?? "Anonymos")"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        if let quizzes = quizzes, quizzes.count > indexPath.row {
            let quiz = quizzes[indexPath.row]
            cell.contentView.largeContentTitle = quiz.title
            cell.textLabel?.text = quiz.title
            
            let numberOfQuestions = quiz.questions.count
            cell.detailTextLabel?.text = "\(numberOfQuestions) \(numberOfQuestions == 1 ? "Frage" : "Fragen")"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, let quizzes = quizzes {
            return quizzes.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let quizzes = quizzes, quizzes.count > indexPath.row {
            let quiz = quizzes[indexPath.row]
            performSegue(withIdentifier: "showQuizDetail", sender: quiz._id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quizDetailVC = segue.destination as? QuizDetailViewController, let quizId = sender as? String {
            quizDetailVC.quizId = quizId
        }
    }
}
