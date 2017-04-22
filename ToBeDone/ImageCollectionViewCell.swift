//
//  ImageCollectionViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

class ImageCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView : UIImageView!
    
    // do all the pre setting
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.contentMode = .center;
        self.imageView.autoresizingMask = .flexibleHeight
            //| UIViewAutoresizingFlexibleHeight;
        
    }

}
