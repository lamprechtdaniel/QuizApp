//
//  LeaderboardTableViewController.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 14.05.21.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
}

class LeaderboardTableViewController: UITableViewController {
    
    public var scores: [Score]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let scores = scores, section == 0 {
            return scores.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! LeaderboardTableViewCell
        
        if let scores = scores, scores.count > indexPath.row {
            let score = scores[indexPath.row]
            cell.usernameLabel.text = score.username
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "dd.MM.yyyy"
            cell.timestampLabel.text = dateFormatter.string(from: score.Created_date)
            cell.pointsLabel.text = String(score.record)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


