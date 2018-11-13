//
//  Player.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class Player: Codable {
    
    var name: String
    var score: Int?
    var passedThruThisRound : Bool
    var roundWinner: Bool
    
    init(name: String, score: Int?, passedThruThisRound: Bool = false, roundWinner: Bool = false){
        self.name = name
        self.score = score
        self.passedThruThisRound = passedThruThisRound
        self.roundWinner = roundWinner
    }
}
