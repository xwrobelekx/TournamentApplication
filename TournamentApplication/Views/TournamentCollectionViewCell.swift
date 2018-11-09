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
    
    
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var playersNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerTwoTextField: UITextField!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerOneScoreTextField.delegate = self
        playerTwoTextField.delegate = self
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 9
        
        NotificationCenter.default.addObserver(self, selector: #selector(runThisCodeToSaveMyScore), name: NSNotification.Name("userPressedNextRoundButtonNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("userPressedNextRoundButtonNotification"), object: self)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        saveScoreforPlayer()
        return true
    }
    
    @objc func runThisCodeToSaveMyScore(){
        saveScoreforPlayer()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveScoreforPlayer()
    }
    
    //keyboard should return here but
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        
    }
    
    func saveScoreforPlayer(){
//        guard let score = playerOneScoreTextField.text, score != "" else {return}
//        guard let intScore = Int(score) else {return}
//        delegate?.assignPlayerScore(cell: self, score: intScore)
//
        if let score = playerOneScoreTextField.text, score != "" {
            guard let intScore = Int(score) else {return}
            guard let player = playerOne else {return}
            delegate?.assignPlayerScore(cell: self, score: intScore, player: player)
            
            
        }
        
        if let scoreTwo = playerTwoTextField.text, scoreTwo != "" {
             guard let intScore = Int(scoreTwo) else {return}
             guard let player = playerTwo else {return}
            delegate?.assignPlayerScore(cell: self, score: intScore, player: player)
            
            
        }
        
    }
    
    func updateViews() {
        if let playerOne = playerOne, let playerTwo = playerTwo {
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
