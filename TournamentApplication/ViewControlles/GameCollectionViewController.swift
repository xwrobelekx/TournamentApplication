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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postNotificationToSaveUserScore) )
        view.addGestureRecognizer(tap)
        self.collectionView.keyboardDismissMode = .onDrag
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let curentRound = round else {return}
        print("🔥 \(curentRound.round.rawValue)")
        players = curentRound.players
        playerPairs = PlayerController.shared.convertToPairs(array: players)
        self.collectionView.reloadData()
    }

    
    //MARK: - CollectionView Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerPairs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TournamentCollectionViewCell
            let players = playerPairs[indexPath.row]
        cell?.delegate = self
        cell?.backgroundColor = .black
        cell?.playerOne = players[0]
        cell?.playerTwo = players[1]
        return cell ?? UICollectionViewCell()
        }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let players = playerPairs[indexPath.row]
        
        //go to next screen where you can increment or decrement scores
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resolveTieVc = storyboard.instantiateViewController(withIdentifier: "tieVC") as? ResolveTieViewController {
       resolveTieVc.playerOne = playerPairs[indexPath.row][0]
            resolveTieVc.playerTwo = playerPairs[indexPath.row][1]
            self.navigationController?.pushViewController(resolveTieVc, animated: true)

        }
        
        
    }
    
    
    //MARK: - 3DTouch delegate methods
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//
//        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as? ResolveTiePoPViewController else {return UIViewController()}
//        popVC.preferredContentSize = CGSize(width: 0.0, height: 300)
//        return popVC
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//
//    }

    
    @objc func postNotificationToSaveUserScore(){
         NotificationCenter.default.post(name: NSNotification.Name(userPressedNextRoundButtonNotification), object: nil)
    }
    
    
    //MARK: - Actions
    @IBAction func nextRoundButtonTapped(_ sender: Any) {
        
       postNotificationToSaveUserScore()
        
        for player in players {
            if player.score == nil {
                showAlert(title: "Hold on.", message: "Yo need to complete this round games before going to the next round")
                return
            }
        }
        players.forEach({ $0.passedThruThisRound = true})

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
        
        let winers = checkForwinners()
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
    func assignPlayerScore(cell: TournamentCollectionViewCell, score: Int, player: Player) {
        guard let index = collectionView.indexPath(for: cell) else {return}
        var players = playerPairs[index.row]
        if player.name == players[0].name {
            players[0].score = score
        } else {
            print("🚨 not player 1")
        }
        if player.name == players[1].name {
            players[1].score = score
        } else {
            print("🚨 not player 2")
        }
        
        if let scoreOne = players[0].score, let scoreTwo = players[1].score {
            if scoreOne > scoreTwo {
                players[0].roundWinner = true
            }
            if scoreTwo > scoreOne {
                players[1].roundWinner = true
            }
            if scoreOne == scoreTwo {
                print("❌❌❌ its a tie")
                     showAlert(title: "Hola Hola", message: "You need to resolve that tie between \(players[0].name) and  \(players[1].name)")
            }
        }
    }
    
    @objc func reloadCollectionView(){
        self.collectionView.reloadData()
    }

    
    func checkForwinners() -> [Player] {
        let pairedPlayers = splitInPairs(array: players)
        var winers = [Player]()
        
        if !pairedPlayers.isEmpty {
            for pair in pairedPlayers {
                
                if let playerONeScore = pair[0].score, let playerTwoScore = pair[1].score,  !pair[0].passedThruThisRound,  !pair[1].passedThruThisRound {
                    print("💙 Player one score \(playerONeScore),player two \(playerTwoScore)")
                    if playerONeScore > playerTwoScore {
                        pair[0].roundWinner = true
                        let winerName = pair[0].name
                        let player = Player(name: winerName, score: nil)
                        winers.append(player)
                        print("💙 appending \(player.name) to winners")
                    } else if playerONeScore < playerTwoScore{
                        pair[1].roundWinner = true
                        let winerName = pair[1].name
                        let player = Player(name: winerName, score: nil )
                        winers.append(player)
                        print("💙 appending \(player.name) to winners")
                    } else if playerONeScore == playerTwoScore {
                        showAlert(title: "Hola Hola", message: "You need to resolve that tie between \(pair[0].name) and  \(pair[1].name)")
                        return []
                    }
                }
            }
        }
        return winers
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
