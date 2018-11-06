//
//  Tournament.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class Tournament {
    
    var name: String
    var round: [Round]
    var isCompleted: Bool
    
    init(name: String, round: [Round], isCompleted: Bool = false){
        self.name = name
        self.round = round
        self.isCompleted = isCompleted
    }
}
