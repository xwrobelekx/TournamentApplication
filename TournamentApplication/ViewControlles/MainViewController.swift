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
    @IBOutlet weak var tournamentListTVHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tournamentsTableView.delegate = self
        tournamentsTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tournamentsTableView.reloadData()
        tournamentListTVHeightConstraint.constant = tournamentsTableView.contentSize.height
    }
    

    //MARK: - Table View DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CustomViewWithRoundedCorners()
        view.backgroundColor = .orange
        let label = UILabel()
        label.textColor = .white
        if section == 0 {
            label.text = "Current Tournaments"
        } else {
            label.text = "Completed Tournaments"
        }
        label.frame = CGRect(x: 15, y: 5, width: 200, height: 20)
        view.addSubview(label)
       
        return view
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return TournamentController.shared.tournaments.filter({!$0.isCompleted}).count
        } else {
            return TournamentController.shared.tournaments.filter({$0.isCompleted}).count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as? TournamentCustomTableViewCell
        var turnamentName = ""
        
        if indexPath.section == 0 {
            let turnaments = TournamentController.shared.tournaments.filter({!$0.isCompleted})
            turnamentName = turnaments[indexPath.row].name
        } else {
            let turnaments = TournamentController.shared.tournaments.filter({$0.isCompleted})
            turnamentName = turnaments[indexPath.row].name
        }
        
        cell?.tournamentNameLabel.text = turnamentName
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tournament : Tournament?
        
        if indexPath.section == 0 {
            let turnaments = TournamentController.shared.tournaments.filter({!$0.isCompleted})
            tournament = turnaments[indexPath.row]
        } else {
            let turnaments = TournamentController.shared.tournaments.filter({$0.isCompleted})
            tournament = turnaments[indexPath.row]
        }
        
        guard let turnament = tournament else {return}
        let round = turnament.round.first
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "GameCVC") as? GameCollectionViewController {
            viewController.tournamentName = turnament
            viewController.round = round
            viewController.navigationItem.title = turnament.name
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
  
    
    
    
    

}
