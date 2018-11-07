//
//  MainViewController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    

    @IBOutlet weak var tournamentsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tournamentsTableView.delegate = self
        tournamentsTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tournamentsTableView.reloadData()
    }
    

    //MARK: - Table View DataSource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Open Tournaments"
        } else {
            return "Completed Tournaments"
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return TournamentController.shared.tournaments.filter({!$0.isCompleted}).count
        } else {
            return TournamentController.shared.tournaments.filter({$0.isCompleted}).count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath)
        var turnamentName = ""
        
        if indexPath.section == 0 {
            let turnaments = TournamentController.shared.tournaments.filter({!$0.isCompleted})
            turnamentName = turnaments[indexPath.row].name
        } else {
            let turnaments = TournamentController.shared.tournaments.filter({$0.isCompleted})
            turnamentName = turnaments[indexPath.row].name
        }
        
        cell.textLabel?.text = turnamentName
        return cell
    }
    
    
  
    
    
    
    

}
