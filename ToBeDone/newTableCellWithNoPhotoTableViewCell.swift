//
//  newTableCellWithNoPhotoTableViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 12/6/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit

class newTableCellWithNoPhoto: newTableCell {
    
    @IBOutlet weak var note: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        note.numberOfLines = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // wrap the super class's fillDataFunction
    func fillDataWrapper (item : TodoItem) {
        fillDataIntoCollectionCellViewController(item)
        note.text = item.note
    }

    
}
