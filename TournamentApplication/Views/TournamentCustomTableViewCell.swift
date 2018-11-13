//
//  TournamentCustomTableViewCell.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/8/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class TournamentCustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var tournamentNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
