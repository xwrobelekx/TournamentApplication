//
//  ChampionViewController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class ChampionViewController: UIViewController {
    
    
    var tournamentName : Tournament?
    var round : Round?
    
    
    @IBOutlet weak var championNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let round = round else {return}
        guard let champion = round.players.first else {return}
        
        championNameLabel.text = champion.name
        tournamentName?.isCompleted = true
    }
    

 
    @IBAction func homeButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
