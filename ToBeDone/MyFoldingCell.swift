//
//  MyFoldingCell.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 11/22/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import FoldingCell

class MyFoldingCell: FoldingCell {

    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var checkBox: UIButton!
    var checkedImage = UIImage(named: "ic_CheckedCheckBox")! as UIImage
    var uncheckedImage = UIImage(named: "ic_UncheckedCheckBox")! as UIImage
    @IBOutlet weak var dateLabel: UILabel!
    var todolistviewcontroller: ToDoItemsViewController2!
    var tableView: UITableView!
    var cellIndexPath: IndexPath!
    
    @IBAction func cellSelected(_ sender: UIButton) {
        todolistviewcontroller.tableView.selectRow(at: cellIndexPath, animated: true, scrollPosition: .middle)
        todolistviewcontroller.tableView.selectRow(at: cellIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        print("row is ")
        print(cellIndexPath.row)
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }

}
