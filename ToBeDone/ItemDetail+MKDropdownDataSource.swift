//
//  ItemDetail_MKDropdownMenuDataSource.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import MKDropdownMenu

extension ItemDetailViewController: MKDropdownMenuDataSource {

    // Data Source
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString.init(string: "Tools",
                                       attributes:  [NSFontAttributeName: UIFont.init(name: "Chalkboard SE", size: 17)!, NSForegroundColorAttributeName: UIColor.flatBlack])
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForSelectedComponent component: Int) -> NSAttributedString? {
        return NSAttributedString.init(string: "Tools",
                                       attributes:  [NSFontAttributeName: UIFont.init(name: "Chalkboard SE", size: 17)!, NSForegroundColorAttributeName: UIColor.flatBlack])
        
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, backgroundColorForRow row: Int, forComponent component: Int) -> UIColor? {
        return .clear
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return rowItems[row] as! UIView
    }
}
