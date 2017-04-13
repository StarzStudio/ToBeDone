//
//  SubTaskTableCell.swift
//  ToBeDone
//
//  Created by 周星 on 11/9/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public  class SubTaskTableCell: Cell<SubTaskModel>, CellType {
    
    
    @IBOutlet weak var checkButton: UIButton!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    public override func setup() {
        super.setup()
        let uncheckedImage = UIImage.init(named: "ic_UncheckedCheckBox")
        checkButton.setImage(uncheckedImage, for: UIControlState.normal )
    }
    
    public override func update() {
        super.update()
        
    }
    
}
