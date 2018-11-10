//
//  TournamentCollectionViewCell.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit


protocol PlayerCollectionViewCellDelegate {
    func assignPlayerScore(cell: TournamentCollectionViewCell, score: Int, player: Player)
}

class TournamentCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    
    //MARK: - Properties
    var delegate: PlayerCollectionViewCellDelegate?
    var playerOne: Player?{
        didSet{
            updateViews()
        }
    }
    var playerTwo: Player?{
        didSet{
            updateViews()
        }
    }
    var userEnteredScoreNotofication = "userEnteredScoreNotofication"
    
    
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var playersNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerTwoTextField: UITextField!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    
    @IBOutlet weak var middleLabel: UILabel!
    
    
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("😱called textField SHOULD EndEditing in cell")
        saveScoreforPlayer()
        return true
    }
    
    @objc func runThisCodeToSaveMyScore(){
        playerOneScoreTextField.resignFirstResponder()
        playerTwoScoreLabel.resignFirstResponder()
        saveScoreforPlayer()
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("😱called textField DID EndEditing in cell")
        saveScoreforPlayer()
    }
    
    //keyboard should return here but
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("😱called textField SHOULD RETURN in cell")
        playerOneScoreTextField.returnKeyType = .done
        playerTwoTextField.returnKeyType = .done
        playerOneScoreTextField.resignFirstResponder()
        playerTwoScoreLabel.resignFirstResponder()
        return true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerOneScoreTextField.text = ""
        playerTwoTextField.text = ""
        playersNameLabel.textColor = .white
        playerTwoScoreLabel.textColor = .white
        
        
    }
    
    func saveScoreforPlayer(){
        if let score = playerOneScoreTextField.text, score != "" {
            guard let intScore = Int(score) else {return}
            guard let player = playerOne else {return}
            player.score = intScore
        }
        
        if let scoreTwo = playerTwoTextField.text, scoreTwo != "" {
             guard let intScore = Int(scoreTwo) else {return}
             guard let player = playerTwo else {return}
            player.score = intScore
        }
        
        updateViews()
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: userEnteredScoreNotofication) , object: nil)
        
    }
    
    func updateViews() {
        middleLabel.text = "VS"
        if let playerOne = playerOne, let playerTwo = playerTwo {
            
            //assign winner if both playes has score already
            if let playerOneScore = playerOne.score, let playerTwoScore = playerTwo.score {
                if playerOneScore > playerTwoScore {
                    playerOne.roundWinner = true
                    playersNameLabel.textColor = UIColor.orange
                }
                if playerOneScore < playerTwoScore {
                    playerTwo.roundWinner = true
                    playerTwoNameLabel.textColor = .orange
                }
                if playerOneScore == playerTwoScore {
                    middleLabel.text = "TIE"
                }
            }
    
            playersNameLabel.text = playerOne.name
            playerTwoNameLabel.text = playerTwo.name

            
            if let scoreOne = playerOne.score {
                playerOneScoreTextField.isHidden = true
                scoreLabel.isHidden = false
                scoreLabel.text = "\(scoreOne)"
            }
            
            if let scoreTwo = playerTwo.score {
                playerTwoScoreLabel.isHidden = false
                playerTwoTextField.isHidden = true
                playerTwoScoreLabel.text = "\(scoreTwo)"
                
            }
            
        }
    }

}


