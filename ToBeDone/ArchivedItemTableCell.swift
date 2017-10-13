//
//  archivedItemTableCell.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


class ArchivedItemTableCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var restoreButton :UIButton!
    
    
    var viewModel = ItemTableViewModel.sharedInstance
    
    
    var cellModel : ItemCellModel? {
        didSet {
            dateLabel.text = cellModel!.createdDate
            titleLabel.text = cellModel!.title
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // do all the pre setting
    override func awakeFromNib() {
        super.awakeFromNib()
        initTitleLabel()
        initDateLabel()
        initRestoreButton()
        
    }
    
    fileprivate func initTitleLabel () {
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.textColor = UIColor.flatGray
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        // automatica number of lines
        titleLabel.numberOfLines = 0

    }
    
    fileprivate func initRestoreButton() {
         self.restoreButton.addTarget(self, action: #selector(self.tapRestoreButton) , for: .touchUpInside)
    }
    
    fileprivate func initDateLabel() {
        dateLabel.textAlignment = NSTextAlignment.left
        dateLabel.textColor = UIColor.flatGray
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        // automatica number of lines
        dateLabel.numberOfLines = 0

    }
    
    func tapRestoreButton() {
        viewModel.actionOnSingleCell(itemCellIndex: cellModel!.cellIndex!, actionType: .Restore)
        viewModel.updateTableViewAction()

    }
    
    
    
    
    

}
