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
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    let tableViewController = LeaderboardTableViewController()
    
    public var score: Int?
    public var scores: [Score]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderboardTableView.delegate = tableViewController
        leaderboardTableView.dataSource = tableViewController
        
        styleUI()
        fetchData()
    }
    
    private func styleUI() {
        
    }
    
    private func fetchData() {
        scores = scoreData
        guard let score = score, var scores = scores else { return }
        scoreLabel.text = String(score)
        scores.sort { $0.points > $1.points }
        tableViewController.scores = scores
    }
}
