//
//  TournamentCollectionViewCell.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit


protocol PlayerCollectionViewCellDelegate {
    func assignPlayerScore(cell: TournamentCollectionViewCell, score: Int)
}

class TournamentCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    var delegate: PlayerCollectionViewCellDelegate?
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var playersNameLabel: UILabel!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreTextField.delegate = self
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 9
        
        NotificationCenter.default.addObserver(self, selector: #selector(runThisCodeToSaveMyScore), name: NSNotification.Name("userPressedNextRoundButtonNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("userPressedNextRoundButtonNotification"), object: self)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let score = scoreTextField.text, score != "" else {return false}
        guard let intScore = Int(score) else {return false}
        delegate?.assignPlayerScore(cell: self, score: intScore)
        return true
    }
    
    @objc func runThisCodeToSaveMyScore(){
        guard let score = scoreTextField.text, score != "" else {return}
        guard let intScore = Int(score) else {return}
        delegate?.assignPlayerScore(cell: self, score: intScore)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let score = scoreTextField.text, score != "" else {return}
        guard let intScore = Int(score) else {return}
        delegate?.assignPlayerScore(cell: self, score: intScore)
    }
    
    //keyboard should return here but
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        scoreTextField.returnKeyType = .done
        scoreTextField.resignFirstResponder()
        
        return true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scoreTextField.text = ""
        
    }
    
    
    
    
    
}
