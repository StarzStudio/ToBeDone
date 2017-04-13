//
//  LogBookItemCell.swift
//  2BDone
//
//  Created by Xinghe Lu on 10/28/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit

class LogBookItemCell: UITableViewCell{
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var itemTitle: UILabel!
    
    var checkedImage = UIImage(named: "ic_CheckedCheckBox")! as UIImage
    var uncheckedImage = UIImage(named: "ic_UncheckedCheckBox")! as UIImage
    
    // Bool property
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                checkBox.setImage(checkedImage, for: .normal)
            } else {
                checkBox.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    @IBAction func buttonClicked(_ sender: AnyObject) {
        isChecked = !isChecked
    }
}
