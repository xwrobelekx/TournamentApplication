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
    
    
    func save(tournament: [Tournament]){
        let jasonEncoder = PropertyListEncoder()
        
        do {
            let data = try jasonEncoder.encode(tournament)
            try data.write(to: fileURL())
        }catch let error {
            print("Error encoding data: \(error)")
        }
    }
    
    func loadTournaments() -> [Tournament]?{
        let jasonDecoder = PropertyListDecoder()
        
        do{
            let data = try Data(contentsOf: fileURL())
            let tournaments = try jasonDecoder.decode([Tournament].self, from: data)
            return tournaments
        } catch let error {
            print("Error decoding data: \(error)")
        }
        return nil
    }
    
    
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "tournament JSON"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
        
    }
    
    
}
