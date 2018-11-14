//
//  RoundedButton.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/8/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit


class customRoundedButtons: UIButton {
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.backgroundColor = UIColor.orange.cgColor
        self.layer.cornerRadius = 6
    }
}
