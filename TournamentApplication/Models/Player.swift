//
//  Player.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class Player {
    
    var name: String
    var score: Int?
    var passedThruThisRound : Bool = false
    
    init(name: String, score: Int?, passedThruThisRound: Bool = false){
        self.name = name
        self.score = score
        self.passedThruThisRound = passedThruThisRound
    }
}
