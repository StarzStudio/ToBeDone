//
//  MenuItemCellViewTableViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 11/28/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit


final class MenuItemCell: UITableViewCell {
    
    
    @IBOutlet weak var menuItemImageView: UIImageView! {
        didSet {
            menuItemImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var menuItemName: UILabel!
  
    @IBOutlet weak var unfinishedNumLabel: UILabel!

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
      
        contentView.layoutSubviews()
        
        menuItemImageView.layer.cornerRadius = menuItemImageView.bounds.width / 2
        unfinishedNumLabel.layer.cornerRadius      = unfinishedNumLabel.bounds.width / 2
    }
}
