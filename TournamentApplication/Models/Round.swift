//
//  Round.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation

class Round: Equatable, Codable {
    
    var round: RoundName
    var players: [Player]
    var isCompleted: Bool
    
    init(round: RoundName, players: [Player], isCompleted: Bool = false){
        self.round = round
        self.players = players
        self.isCompleted = isCompleted
    }
    
    static func == (lhs: Round, rhs: Round) -> Bool {
        if lhs.round != rhs.round {return false}
        return true
    }
}



