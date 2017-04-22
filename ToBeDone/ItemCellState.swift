//
//  ItemCellState.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


enum ItemCellType {
    case NormalCellWithImages
    case NormailCellWithoutImages
    case ArchivedCell
}

class ItemCellState {
    var isChecked = false;
    var createdDate : String?
    var state : String?
    var title : String = ""
    var note : String?
    var images = [UIImage]()
    var checkedImageName : String = "ic_CheckedCheckBox"
    var unCheckedImageName : String = "ic_UncheckedCheckBox"
    
    var cellType : ItemCellType {
        get {
            if images.count > 0 {
                return .NormalCellWithImages
            } else if  state == "Archived" {
                return .ArchivedCell
            } else {
                return .NormailCellWithoutImages
            }
        }
    }
}
