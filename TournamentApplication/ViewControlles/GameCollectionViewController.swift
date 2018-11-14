//
//  GameCollectionViewController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "playersCell"

class GameCollectionViewController: UICollectionViewController, PlayerCollectionViewCellDelegate {
    
    
    //MARK: - Properties
    var numberofSections: Int = 0
    var round : Round?
    var nextRnd: Round?
    var players = [Player]()
    var playerPairs = [[Player]]()
    let userPressedNextRoundButtonNotification = "userPressedNextRoundButtonNotification"
    var tournamentName : Tournament? {
        didSet{
            loadViewIfNeeded()
            self.collectionView.reloadData()
        }
    }
    
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.keyboardDismissMode = .onDrag
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let curentRound = round else {return}
        players = curentRound.players
        playerPairs = PlayerController.shared.convertToPairs(array: players)
        self.collectionView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - CollectionView Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerPairs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TournamentCollectionViewCell
        let players = playerPairs[indexPath.row]
        cell?.backgroundColor = .black
        cell?.delegate = self
        cell?.currentPlayers = players
        return cell ?? UICollectionViewCell()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //stops the player from going into this VC when the round was completed already
        if let round = round, round.isCompleted == false {
            
            //go to next screen where you can increment or decrement scores
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let resolveTieVc = storyboard.instantiateViewController(withIdentifier: "tieVC") as? ResolveTieViewController {
                resolveTieVc.playerOne = playerPairs[indexPath.row][0]
                resolveTieVc.playerTwo = playerPairs[indexPath.row][1]
                self.navigationController?.pushViewController(resolveTieVc, animated: true)
            }
        }
    }
    
    @objc func postNotificationToSaveUserScore(){
        NotificationCenter.default.post(name: NSNotification.Name(userPressedNextRoundButtonNotification), object: nil)
    }
    
    
    //MARK: - Actions
    @IBAction func nextRoundButtonTapped(_ sender: Any) {
        postNotificationToSaveUserScore()
        
        //checks if all players have score assigned
        for player in players {
            if player.score == nil {
                showAlert(title: "Complete All Games", message: "Please finish all games in this round first.")
                return
            }
        }
        
        //need to show alert if we have a tie
        let pairedPlaires = splitInPairs(array: players)
        var tie = false
        
        pairedPlaires.forEach({
            if $0[0].score == $0[1].score {
                tie = true
                showAlert(title: "Tie", message: "Please resolve the tie between \($0[0].name) and \($0[1].name)")
            }
        })
        
        //if no tie then do this
        if !tie {
            let winers = checkForwinners()
            players.forEach({ $0.passedThruThisRound = true})
            
            guard let tournamentName = tournamentName, let round = round else {return}
            var nextRound = RoundName.invalid
            var background = UIColor.green
            
            switch round.round {
            case .champion:
                nextRound = .champion
                background = .purple
            case .final:
                nextRound = .champion
                background = .red
            case .semiFinal:
                nextRound = .final
                background = .yellow
            case .quarterFinal:
                nextRound = .semiFinal
                background = .blue
            case .roundOfEight:
                nextRound = .quarterFinal
                background = .cyan
            case .roundOfSixteen:
                nextRound = .roundOfEight
                background = .lightGray
            default:
                print("default case")
            }
            
            
            if !winers.isEmpty {
                nextRnd = Round(round: nextRound, players: winers)
                tournamentName.round.append(nextRnd!)
            } else {
                //goies in here when winners are empty
                
                //when were going thru the app to see the tournament we nee to tell it what round is next
                if let index = tournamentName.round.index(of: round) {
                    print("\(tournamentName.round.count)")
                    nextRnd = tournamentName.round[index + 1]
                }
            }
            
            //show correct story board depending on round
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if nextRound == .champion {
                round.isCompleted = true
                if let championVC = storyboard.instantiateViewController(withIdentifier: "championVC") as? ChampionViewController {
                    championVC.tournamentName = tournamentName
                    championVC.navigationItem.title = nextRound.rawValue
                    championVC.round = nextRnd
                    self.navigationController?.pushViewController(championVC, animated: true)
                }
            } else {
                round.isCompleted = true
                if let viewController = storyboard.instantiateViewController(withIdentifier: "GameCVC") as? GameCollectionViewController {
                    viewController.view.backgroundColor = .yellow
                    viewController.tournamentName = tournamentName
                    viewController.round = nextRnd
                    viewController.navigationItem.title = nextRound.rawValue
                    viewController.view.backgroundColor = background
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    
    //MARK: protocol conformance method
    func callAlertForInvalidNumber(playersName: String) {
        showAlert(title: "Invalid Score", message: "Please enter valid score for \(playersName).")
    }
    
    //MARK: - Notification Selector Method
//    @objc func reloadCollectionView(){
//        self.collectionView.reloadData()
//    }
    
    
    //MARK: - Helper Methods
    func checkForwinners() -> [Player] {
        //  let pairedPlayers = splitInPairs(array: players)
        var winers = [Player]()
        
        players.forEach({
            if !$0.passedThruThisRound{
                if $0.roundWinner {
                    let player = Player(name: $0.name, score: nil)
                    winers.append(player)
                }}})
        
        return winers
    }
    
    ///This methods calculates corect index path for sectioned table / collection View
    func alteredIndexPath(indexPath: IndexPath) -> Int {
        return (indexPath.section * 2) + (indexPath.row)
    }
    
    ///This method iterate thru array and convert a single array into an array of arrays where each contains 2 elements
    func splitInPairs<T>(array: [T]) -> [[T]]{
        var counter = 1
        var index = 0
        var masterarray = [[T]]()
        var pair = [T]()
        while index <= (array.count - 1) {
            if counter <= 2{
                counter += 1
                pair.append(array[index])
                index += 1
            } else {
                masterarray.append(pair)
                counter = 1
                pair = []
            }
        }
        masterarray.append(pair)
        return masterarray
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            
        }))
        present(alert, animated: true)
    }
}
