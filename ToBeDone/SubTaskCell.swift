//
//  SubTaskCELLTableViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 11/11/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import M13Checkbox

class SubTaskCell: UITableViewCell {
    
    @IBOutlet weak var checkbox : M13Checkbox!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setCheckBox()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setCheckBox(){
//        // Set values to the checkbox to return depending on its state.
//        checkbox.checkedValue = 1.0
//        checkbox.uncheckedValue = 0.0
//        checkbox.mixedValue = 0.5
//        
//        //: Animations
//        //: ----------
//        
//        // Update the animation duration
//        checkbox.animationDuration = 1.0
//        
//        // Change the animation used when switching between states.
//        checkbox.stateChangeAnimation = .bounce(.fill)
//        
//        //: Appearance
//        //: ----------
//
//        
//        // The background color of the veiw.
//        checkbox.backgroundColor = .white
//        // The tint color when in the selected state.
//        checkbox.tintColor = .yellow
//        // The tint color when in the unselected state.
//        checkbox.secondaryTintColor = .green
//        // The color of the checkmark when the animation is a "fill" style animation.
//        checkbox.secondaryCheckmarkTintColor = .red
//        
//        // Whether or not to display a checkmark, or radio mark.
//        checkbox.markType = .checkmark
//        // The line width of the checkmark.
//        checkbox.checkmarkLineWidth = 2.0
//        
//        // The line width of the box.
//        checkbox.boxLineWidth = 2.0
//        // The corner radius of the box if it is a square.
//        checkbox.cornerRadius = 4.0
//        // Whether the box is a square, or circle.
//        checkbox.boxType = .square
//        // Whether or not to hide the box.
//        checkbox.hideBox = false
//        
//
//    }
    
    
}
