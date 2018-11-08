//
//  SelfSizingTableViews.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/6/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    
    
    //MARK: - Properties
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    
    //MARK: - Reload Data
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    
    //MARK: - Settings
    override var intrinsicContentSize: CGSize {
           let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height) //+ contentSize.height)
    }
}
