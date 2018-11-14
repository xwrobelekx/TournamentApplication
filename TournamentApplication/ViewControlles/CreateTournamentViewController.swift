//
//  CreateTournamentViewController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class CreateTournamentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    
    //MARK: - Properties
    var playerCount = 0
    var curentPlayerCount = 0
    var currentPlayers = [Player]()
    var createTeam = [[Player]]()

    
    //MARK: - Outlets
    @IBOutlet weak var tournamentNameTextField: UITextField!
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var playerNameView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPlayerStackViewOutlet: UIStackView!
    
    
    @IBOutlet weak var fourPlayersOutlet: customRoundedButtons!
    @IBOutlet weak var eightPlayersOutlet: customRoundedButtons!
    @IBOutlet weak var sixteenPlayerOutlet: customRoundedButtons!
    @IBOutlet weak var thirtyTwoPlayersOutlet: customRoundedButtons!
    var playersOutlets = [customRoundedButtons]()
    
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTableView.delegate = self
        playersTableView.dataSource = self
        playersTableView.keyboardDismissMode = .onDrag
        addPlayerStackViewOutlet.isHidden = true
        playerNameTextField.delegate = self
        scrollView.keyboardDismissMode = .onDrag
        playersTableView.separatorStyle = .none
        tableViewHeightConstraint.constant = playersTableView.contentSize.height
        playersOutlets = [fourPlayersOutlet, eightPlayersOutlet, sixteenPlayerOutlet, thirtyTwoPlayersOutlet]
    }
    
    
    //MARK: - Table View data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return createTeam.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CustomViewWithRoundedCorners()
        view.backgroundColor = .orange
        let label = UILabel()
        label.textColor = .white
        label.text = "Group \(tableView.numberOfSections - section):"
        label.frame = CGRect(x: 15, y: 5, width: 200, height: 20)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createTeam[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createPlayerCell", for: indexPath) as? PlayerCustomTableViewCell
        let player = createTeam[indexPath.section][indexPath.row]
        cell?.playerNameLabel.text =  "\(player.name)"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            createTeam[indexPath.section].remove(at: indexPath.row)
            if curentPlayerCount != 0 {
                curentPlayerCount -= 1
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        guard to.row >= 0 else {return}
        let player = createTeam[fromIndexPath.section].remove(at: fromIndexPath.row)
        if to.row == 0 {
            createTeam = insert(player: player, to: createTeam, at: modified(indexPath: to))
        } else {
            createTeam = insert(player: player, to: createTeam, at: modified(indexPath: to) - 1)
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Actions
    @IBAction func rearangePlayersButtonTapped(_ sender: Any) {
        if !playersTableView.isEditing {
            self.playersTableView.setEditing(true, animated: true)
        } else {
            self.playersTableView.setEditing(false, animated: true)
        }
    }
    
    @IBAction func shufflePlayersButtonTapped(_ sender: Any) {
        createTeam = shufflePlayers(at: createTeam)
        playersTableView.reloadData()
    }
    
    @IBAction func fourPlayersButtonTapped(_ sender: Any) {
        changeButtonsToOriginlState()
        fourPlayersOutlet.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5, blue: 0, alpha: 1)
        blockFromAddingMorePlayers(at: 4)
        unhideViews()
    }
    
    @IBAction func eightPlayersButtonTapped(_ sender: Any) {
        changeButtonsToOriginlState()
        eightPlayersOutlet.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5, blue: 0, alpha: 1)
        blockFromAddingMorePlayers(at: 8)
        unhideViews()

    }
    
    @IBAction func sixteenPlayersButtonTapped(_ sender: Any) {
        changeButtonsToOriginlState()
        sixteenPlayerOutlet.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5, blue: 0, alpha: 1)
        blockFromAddingMorePlayers(at: 16)
        unhideViews()
    }
    
    @IBAction func thirtytwoPlayersButtonTapped(_ sender: Any) {
        changeButtonsToOriginlState()
        thirtyTwoPlayersOutlet.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5, blue: 0, alpha: 1)
        blockFromAddingMorePlayers(at: 32)
        unhideViews()
    }
    
    @IBAction func addPlayerButtonTapped(_ sender: Any) {
        addPlayer()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if curentPlayerCount == 0 {
            showAlert(title: "Not Enough Players", message: "Please add more players.")
            return
        }
        currentPlayers = convertToSingleArray(doubleArray: createTeam)
        guard let tournamentName = tournamentNameTextField.text, tournamentName != "" else {
            showAlert(title: "Missing Tournament Name", message: "Please add a tournament name.")
            return}
        
        
        if currentPlayers.count != playerCount {
            notEnoughPlayersAlert()
            return
        }
        
        //here we would assign our local array to main dictionary inder curent turnament name
        var roundName: RoundName = .invalid
        var rounds = [Round]()
        var round = Round(round: .invalid, players: [])
        
        
        switch currentPlayers.count {
        case 32:
            roundName = .roundOfSixteen
            round = Round(round: .roundOfSixteen, players: currentPlayers)
        case 16:
            roundName = .roundOfEight
            round = Round(round: .roundOfEight, players: currentPlayers)
        case 8:
            roundName = .quarterFinal
            round = Round(round: .quarterFinal, players: currentPlayers)
        case 4:
            roundName = .semiFinal
            round = Round(round: .semiFinal, players: currentPlayers)
        case 2:
            roundName = .final
            round = Round(round: .final, players: currentPlayers)
        case 1:
            roundName = .champion
            round = Round(round: .champion, players: currentPlayers)
        default:
            roundName = .invalid
            round = Round(round: .invalid, players: currentPlayers)
        }
        
        rounds.append(round)
        let tournament = Tournament(name: tournamentName, round: rounds)
        TournamentController.shared.addTournament(tournament: tournament)
        TournamentController.shared.save(tournament: TournamentController.shared.tournaments)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK: - Helper Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addPlayer()
        return true
    }
    
    func changeButtonsToOriginlState(){
        playersOutlets.forEach({ $0.layer.backgroundColor = UIColor.orange.cgColor})
    }
    
    func addPlayer(){
        guard let playerName = playerNameTextField.text else {return}
        if playerName != "" && curentPlayerCount < playerCount {
            let player = Player(name: playerName, score: nil)
            createTeam = insert(player: player, to: createTeam, at: 0)
            playersTableView.reloadData()
            playerNameTextField.text = ""
            curentPlayerCount += 1
            tableViewHeightConstraint.constant = playersTableView.contentSize.height + 10
        } else {
            showAlert(title: "Cannot add Player", message: "this tab has to many players already, try picking a differend tab.")
            print("got enough players, curent count: \(playerCount),\n or need to enter a name for a player, curent player name: \(playerName).")
        }
    }
    
    func unhideViews(){
        playerNameTextField.becomeFirstResponder()
        playersTableView.isHidden = false
        //playerNameView.isHidden = false
        addPlayerStackViewOutlet.isHidden = false
        loadViewIfNeeded()
    }
    
    func modified(indexPath: IndexPath) -> Int {
        return (indexPath.section * 2) + (indexPath.row)
    }
    
    func newIndex(indexPath: IndexPath) -> Int{
        if currentPlayers.count % 2 == 0{
            return modified(indexPath: indexPath)
        } else {
            switch indexPath.section {
            case 0:
                return modified(indexPath: indexPath)
            default:
                return modified(indexPath: indexPath) - 1
            }
            
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            self.playerNameTextField.text = ""
        }))
        present(alert, animated: true)
    }
    
    func notEnoughPlayersAlert(){
        let alert = UIAlertController(title: "Not Enough Players", message: "Please add (number) more players.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func blockFromAddingMorePlayers(at number: Int){
        playerCount = number
        if currentPlayers.count != 0 && currentPlayers.count <= number{
            curentPlayerCount = currentPlayers.count
        } else if currentPlayers.count >= number {
            curentPlayerCount = currentPlayers.count
            showAlert(title: "Cannot add Player", message: "this tab has to many players already, try picking a differend tab.")
        } else {
            playerCount = number
        }
    }
    
    
    //this should iterate thru array and organize the playiers into pairs
    func convertToPairs<T>(array: [T]) -> [[T]]{
        var index = 0
        var masterarray = [[T]]()
        var pair = [T]()
        if array.count % 2 == 0 {
            var counter = 1
            while index <= (array.count - 1) {
                if counter <= 2 {
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
        } else {
            var counter = 2
            while index <= (array.count - 1) {
                if counter <= 2 {
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
        }
        return masterarray
    }
    
    
    func convertToSingleArray<T>(doubleArray: [[T]]) -> [T] {
        var tempArray = [T]()
        
        for singleArray in doubleArray {
            for item in singleArray {
                tempArray.append(item)
            }
        }
        return tempArray
    }
    
    
    func insert(player: Player, to array: [[Player]], at index: Int) -> [[Player]]{
        var tempSingleArray = convertToSingleArray(doubleArray: array)
        tempSingleArray.insert(player, at: index)
        return convertToPairs(array: tempSingleArray)
    }
    
    
    func shufflePlayers(at: [[Player]]) -> [[Player]]{
        var tempSingleArray = convertToSingleArray(doubleArray: at)
        tempSingleArray.shuffle()
        return convertToPairs(array: tempSingleArray)
    }
}
