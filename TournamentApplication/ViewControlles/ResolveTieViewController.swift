//
//  ResolveTiePoPViewController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/8/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class ResolveTieViewController: UIViewController {
    
    
    //MARK: - Properties
    var playerOne: Player?
    var playerTwo: Player?
    var playerOneScore = 0
    var playerTwoScore = 0
    
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playerOneNameLabel: UILabel!
    @IBOutlet weak var playerOneOldScore: UILabel!
    @IBOutlet weak var playerOneNewScore: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerTwoOldScore: UILabel!
    @IBOutlet weak var playerTwoNewScore: UILabel!
    
    
    //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Game Time"
        titleLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.07182494551, alpha: 1)
        playerOneOldScore.isHidden = true
        playerTwoOldScore.isHidden = true
        playerOneNewScore.text = "0"
        playerTwoNewScore.text = "0"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    
    //MARK: - UpdateViews Method
    func updateViews() {
        guard let playerOne = playerOne, let playerTwo = playerTwo else {return}
        playerOneNameLabel.text = playerOne.name
        playerTwoNameLabel.text = playerTwo.name
        if let scoreOne = playerOne.score, let scoreTwo = playerTwo.score {
            if scoreOne == scoreTwo {
                titleLabel.text = "Resolve Tie"
                titleLabel.textColor = .orange
            }
            playerOneOldScore.isHidden = false
            playerTwoOldScore.isHidden = false
            playerOneOldScore.text = "\(scoreOne)"
            playerTwoOldScore.text = "\(scoreTwo)"
        }
    }
    
    
    
    //MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
        //save the score
        guard let playerOne = playerOne, let playerTwo = playerTwo else {return}
        playerOne.score = playerOneScore
        playerTwo.score = playerTwoScore        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playerOneStepperPressed(_ sender: UIStepper) {
        playerOneNewScore.text = String(Int(sender.value))
        playerOneScore = Int(sender.value)
    }
    
    @IBAction func playerTwoStepperPressed(_ sender: UIStepper) {
        playerTwoNewScore.text = String(Int(sender.value))
        playerTwoScore = Int(sender.value)
    }
}
