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
  
    
    
    var numberofSections: Int = 0
    var round : Round?
    var nextRnd: Round?
    var players = [Player]()
    let userPressedNextRoundButtonNotification = "userPressedNextRoundButtonNotification"
    
    var tournamentName : Tournament? {
        didSet{
            loadViewIfNeeded()
            self.collectionView.reloadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let curentRound = round else {return}
        print("🔥 \(curentRound.round.rawValue)")
        players = curentRound.players
        self.collectionView.reloadData()
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: , withReuseIdentifier: <#T##String#>, for: indexPath)
//        return header
//    }
    

    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return players.count/2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TournamentCollectionViewCell
            let player = players[alteredIndexPath(indexPath: indexPath)]
        cell?.delegate = self
        
        if let score = player.score {
            cell?.scoreTextField.isHidden = true
            cell?.scoreLabel.isHidden = false
            print("🖖 \(score)")
            cell?.scoreLabel.text = "\(score)"
        }
        
        cell?.playersNameLabel.text = player.name
        return cell ?? UICollectionViewCell()
        }

    
    //MARK: - Actions
    @IBAction func nextRoundButtonTapped(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(userPressedNextRoundButtonNotification), object: nil)
        
        for player in players {
            if player.score == nil {
                showAlert(title: "Hold on.", message: "Yo need to complete this round games before going to the next round")
                return
            }
        }
        
        let pairedPlayers = splitInPairs(array: players)
        var winers = [Player]()
        
        if !pairedPlayers.isEmpty {
            for pair in pairedPlayers {
                
                if let playerONeScore = pair[0].score, let playerTwoScore = pair[1].score,  !pair[0].passedThruThisRound,  !pair[1].passedThruThisRound {
                    print("💙 Player one score \(playerONeScore),player two \(playerTwoScore)")
                    if playerONeScore > playerTwoScore {
                        let winerName = pair[0].name
                        let player = Player(name: winerName, score: nil)
                        winers.append(player)
                        print("💙 appending \(player.name) to winners")
                    } else if playerONeScore < playerTwoScore{
                        let winerName = pair[1].name
                        let player = Player(name: winerName, score: nil )
                        winers.append(player)
                        print("💙 appending \(player.name) to winners")
                    } else if playerONeScore == playerTwoScore {
                        showAlert(title: "Hola Hola", message: "You need to resolve that tie between \(pair[0].name) and  \(pair[1].name)")
                        return
                    }
                }
            }
        }
        
        players.forEach({ $0.passedThruThisRound = true})
        for player in players{
            print(player.passedThruThisRound)
        }
        
        guard let tournamentName = tournamentName, let round = round else {return}
        var nextRound = RoundName.invalid
        var background = UIColor.green
        
        switch round.round {
        case .champion:
            nextRound = .champion
            print("☢️next round set to: \(nextRound)")
            background = .purple
        case .final:
            nextRound = .champion
            print("☢️next round set to: \(nextRound)")
            background = .red
        case .semiFinal:
            nextRound = .final
            print("☢️next round set to: \(nextRound)")
            background = .yellow
        case .quarterFinal:
            nextRound = .semiFinal
            print("☢️next round set to: \(nextRound)")
            background = .blue
        case .roundOfEight:
            nextRound = .quarterFinal
            print("☢️next round set to: \(nextRound)")
            background = .cyan
        case .roundOfSixteen:
            nextRound = .roundOfEight
            print("☢️next round set to: \(nextRound)")
            background = .lightGray
        default:
            print("default case")
            print("☢️next round set to: \(nextRound)")
        }
        
        if !winers.isEmpty {
            nextRnd = Round(round: nextRound, players: winers)
            tournamentName.round.append(nextRnd!)
        } else {
            //when were going thru the app to see the tournament we nee to tell it what round is next
            if let index = tournamentName.round.index(of: round) {
                nextRnd = tournamentName.round[index + 1]
            }
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if nextRound == .champion {
            if let championVC = storyboard.instantiateViewController(withIdentifier: "championVC") as? ChampionViewController {
                championVC.tournamentName = tournamentName
                championVC.round = nextRnd
                print("🔥🔥 \(nextRound.rawValue)")
                self.navigationController?.pushViewController(championVC, animated: true)
            }
        } else {
            if let viewController = storyboard.instantiateViewController(withIdentifier: "GameCVC") as? GameCollectionViewController {
                viewController.view.backgroundColor = .yellow
                viewController.tournamentName = tournamentName
                viewController.round = nextRnd
                print("🔥🔥🔥 \(nextRound.rawValue)")
                viewController.view.backgroundColor = background
                print("‼️ game: \(tournamentName), round: \(nextRound)")
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        
        
    }
    
    
    
    
    //MARK: - Protocol Conformance Method
    func assignPlayerScore(cell: TournamentCollectionViewCell, score: Int) {
        guard let index = collectionView.indexPath(for: cell) else {return}
        players[alteredIndexPath(indexPath: index)].score = score
    }
    
    func alteredIndexPath(indexPath: IndexPath) -> Int {
        return (indexPath.section * 2) + (indexPath.row)
    }
    
    
    //this should iterate thru array and organize the playiers into pairs
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
