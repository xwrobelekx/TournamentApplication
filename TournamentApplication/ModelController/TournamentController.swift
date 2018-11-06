//
//  TournamentController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation

class TournamentController {
    
    //MARK: - Singelton
    static let shared = TournamentController()
    private init() {}
    
    
    //MARK: - Source Of Truth
    var tournaments = [Tournament]()
    
    
    //MARK: - CRUD Methods
    func addTournament(tournament: Tournament){
        tournaments.append(tournament)
    }
    
    
}
