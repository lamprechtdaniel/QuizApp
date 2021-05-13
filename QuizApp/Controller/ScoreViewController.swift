//
//  ScoreViewController.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation
import UIKit

final class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func styleUI() {
        
    }
}
