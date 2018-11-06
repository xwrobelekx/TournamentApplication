//
//  RoundNames.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation

enum RoundName : String {
    case roundOfSixteen = "RoundOfSixteen"  // 32 players
    case roundOfEight = "RoundOfEight"      // 16 players
    case quarterFinal = "QuarterFinal"      // 8 players
    case semiFinal = "SemiFinal"            // 4 players
    case final = "Final"                    // 2 players
    case champion = "Champion"              // 1 player
    case invalid = "Invalid"                // default - invalid value
}
