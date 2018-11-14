//
//  ChampionViewController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class ChampionViewController: UIViewController {
    
    
    //MARK: - Properties
    var tournamentName : Tournament?
    var round : Round?
    var pulsatingLayer: CAShapeLayer!
    
    
    //MARK: - Outlets
    @IBOutlet weak var championNameLabel: UILabel!
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let round = round else {return}
        guard let champion = round.players.first else {return}
        championNameLabel.text = champion.name
        tournamentName?.isCompleted = true
        animateLabel()
        TournamentController.shared.save(tournament: TournamentController.shared.tournaments)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    //MARK: - Animation
    func animateLabel(){
        let height = championNameLabel.bounds.height * 2
        let widht = championNameLabel.bounds.width * 2
        UIView.animate(withDuration: 2, animations: {
            self.championNameLabel.bounds.size = CGSize(width: widht, height: height)
        })
    }
    
    
    //MARK: - Actions
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
