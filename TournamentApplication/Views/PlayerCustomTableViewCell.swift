//
//  PlayerCustomTableViewCell.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/7/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class PlayerCustomTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
