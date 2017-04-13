//
//  SwipeViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 12/5/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit

class SwipeViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var  containerView: UIView!
    var itemDetailViewController : ItemDetailViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func getInfoAndDisplay(item : TodoItem) {
        let itemDetailStoryboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        itemDetailViewController = itemDetailStoryboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
            itemDetailViewController.item = item
            containerView = itemDetailViewController.view
    }
    

}



