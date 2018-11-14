//
//  Tournament.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class Tournament: Codable, Equatable {
    
    
    var name: String
    var round: [Round]
    var isCompleted: Bool
    
    init(name: String, round: [Round], isCompleted: Bool = false){
        self.name = name
        self.round = round
        self.isCompleted = isCompleted
    }
    
    
    static func == (lhs: Tournament, rhs: Tournament) -> Bool {
        if lhs.name != rhs.name {return false}
        if lhs.round != rhs.round {return false}
        if lhs.isCompleted != rhs.isCompleted {return false}
        return true
    }
}
