//
//  CustomCell.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit


class CustomViewWithRoundedCorners: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 9
    }
}
