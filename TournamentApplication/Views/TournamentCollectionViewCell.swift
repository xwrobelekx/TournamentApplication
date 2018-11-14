//
//  TournamentCollectionViewCell.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit


protocol PlayerCollectionViewCellDelegate {
    func callAlertForInvalidNumber(playersName: String)
}

class TournamentCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    
    //MARK: - Properties
    var currentPlayers : [Player]? {
        didSet{
            saveScoreforPlayer()
        }
    }
    var delegate : PlayerCollectionViewCellDelegate?
    var userEnteredScoreNotofication = "userEnteredScoreNotofication"
    
    
    //MARK: - Outlets
    @IBOutlet weak var playersNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerTwoTextField: UITextField!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    
    
    //MARK: - LifeCycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        playerOneScoreTextField.delegate = self
        playerTwoTextField.delegate = self
        playerOneScoreTextField.addDoneButtonOnKeyboard()
        playerTwoTextField.addDoneButtonOnKeyboard()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 9
        
        NotificationCenter.default.addObserver(self, selector: #selector(runThisCodeToSaveMyScore), name: NSNotification.Name("userPressedNextRoundButtonNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("userPressedNextRoundButtonNotification"), object: self)
    }
    
    ///notification method to save players score and update views
    @objc func runThisCodeToSaveMyScore(){
        playerOneScoreTextField.resignFirstResponder()
        playerTwoTextField.resignFirstResponder()
        saveScoreforPlayer()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveScoreforPlayer()
    }
    
    //restores the cell to its original state
    override func prepareForReuse() {
        playerOneScoreTextField.text = ""
        playerTwoTextField.text = ""
        playersNameLabel.textColor = .white
        playerOneScoreTextField.textColor = .white
        playerTwoNameLabel.textColor = .white
        playerTwoScoreLabel.textColor = .white
        playerTwoScoreLabel.text = nil
        scoreLabel.text = nil
        scoreLabel.isHidden = true
        playerTwoScoreLabel.isHidden = true
        playerOneScoreTextField.isHidden = false
        playerTwoTextField.isHidden = false
        
    }
    
    func saveScoreforPlayer(){
        //check if we have both players
        guard let currentPlayers = currentPlayers else {return}
        let playerOne = currentPlayers[0]
        let playerTwo = currentPlayers[1]
        
        // check is we have score inputed, and assigns it to the first player
        if let scoreOne = playerOneScoreTextField.text, scoreOne != "" {
            guard let intScore = Int(scoreOne) else {
                delegate?.callAlertForInvalidNumber(playersName: playerOne.name)
                return}
            playerOne.score = intScore
        }
        
        //check if we have score in second textfield, and assigns it to player two
        if let scoreTwo = playerTwoTextField.text, scoreTwo != "" {
            guard let intScore = Int(scoreTwo) else {
                delegate?.callAlertForInvalidNumber(playersName: playerTwo.name)
                return}
            playerTwo.score = intScore
        }
        
        //checks if both players have score and assign a winning player
        if let scoreOne = playerOne.score, let scoreTwo = playerTwo.score {
            if scoreOne > scoreTwo {
                playerOne.roundWinner = true
                playerTwo.roundWinner = false
            } else if scoreOne < scoreTwo {
                playerTwo.roundWinner = true
                playerOne.roundWinner = false
            }
        }
        updateViews()        
    }
    
    
    
    ///updates views based on players properties
    func updateViews() {
        middleLabel.text = "VS"
        
        guard let currentPlayers = currentPlayers else {return}
        
        //checks if we have both players
        let playerOne = currentPlayers[0]
        let playerTwo = currentPlayers[1]
        
        //it assigns players name to the label
        playersNameLabel.text = playerOne.name
        playerTwoNameLabel.text = playerTwo.name
        
        //asigns scores to player one label if it hapens to have them
        if let scoreOne = playerOne.score {
            playerOneScoreTextField.isHidden = true
            scoreLabel.isHidden = false
            scoreLabel.text = "\(scoreOne)"
        }
        
        //asigns scores to player two label if it happens to have them
        if let scoreTwo = playerTwo.score {
            playerTwoTextField.isHidden = true
            playerTwoScoreLabel.isHidden = false
            playerTwoScoreLabel.text = "\(scoreTwo)"
        }
        
        
        
        
        //checks if we have both players scores
        if let scoreOne = playerOne.score, let scoreTwo = playerTwo.score {
            
            //checks for tie
            if scoreOne == scoreTwo {
                middleLabel.text = "TIE"
                playerOne.roundWinner = false
                playerTwo.roundWinner = false
                
                playersNameLabel.textColor = .white
                scoreLabel.textColor = .white
                playerTwoScoreLabel.textColor = .white
                playerTwoNameLabel.textColor = .white
            }
            
            //if player one is the winner of the round make the label orange
            if playerOne.roundWinner == true {
                playersNameLabel.textColor = .orange
                scoreLabel.textColor = .orange
                playerTwoScoreLabel.textColor = .white
                playerTwoNameLabel.textColor = .white
                
                //if player two is the winner make the label orange
            } else if playerTwo.roundWinner == true {
                playerTwoScoreLabel.textColor = .orange
                playerTwoNameLabel.textColor = .orange
                playersNameLabel.textColor = .white
                scoreLabel.textColor = .white
                
            }
        }
    }
}


