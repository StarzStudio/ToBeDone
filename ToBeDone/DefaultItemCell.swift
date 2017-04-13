//
//  DefaultItemCell.swift
//  2BDone
//
//  Created by Xinghe Lu on 10/26/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit


class DefaultItemCell: UITableViewCell{

    @IBOutlet var checkBox: UIButton!
    @IBOutlet var itemTitle: UILabel!
    // @IBOutlet var elapsedTimeLabel : KDEDateLabel!
    var checkedImage = UIImage(named: "ic_CheckedCheckBox")! as UIImage
    var uncheckedImage = UIImage(named: "ic_UncheckedCheckBox")! as UIImage
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
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
