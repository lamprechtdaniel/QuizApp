//
//  ScoreViewController.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation
import UIKit



class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var leaderboardLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    let tableViewController = LeaderboardTableViewController()
    
    public var score: Int?
    public var scores: [Score]?
    public var quizId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
        
        self.leaderboardTableView.delegate = self.tableViewController
        self.leaderboardTableView.dataSource = self.tableViewController
        
        if let score = score {
            scoreLabel.text = String(score)
        }
        
        uploadScore()
    }
    
    private func styleUI() {
        leaderboardTableView.isHidden = true
        leaderboardLabel.isHidden = true
        tryAgainButton.layer.cornerRadius = 8
    }
    
    private func uploadScore() {
        guard let quizId = quizId, let score = score, let username = AppDelegate.storedUserName else {
            return
        }
        
        // TODO: post score
        SyncManager.shared.postScore(quizId: quizId, username: username, record: score, completion: { success in
            if success {
                print("update successful")
                self.fetchData()
            } else {
                DispatchQueue.main.async {
                    self.tryAgainButton.isHidden = false
                }
                print("update not successful")
            }
            
        })
    }
    
    private func fetchData() {
        guard let quizId = quizId else {
            return
        }
        SyncManager.shared.syncScores(of: quizId, completion: { (success, scores) in
            if success {
                self.scores = scores
                guard var scores = self.scores else { return }
                scores.sort { $0.record > $1.record }
                
                DispatchQueue.main.async {
                    self.tableViewController.scores = scores
                    self.leaderboardTableView.reloadData()
                    self.leaderboardTableView.isHidden = false
                    self.leaderboardLabel.isHidden = false
                    if !self.tryAgainButton.isHidden {
                        self.tryAgainButton.isHidden = true
                    }
                }
            } else {
                // TODO: present failure
            }
        })
    }
    @IBAction func onTryAgainTap(_ sender: UIButton) {
        uploadScore()
    }
}
