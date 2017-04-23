//
//  IGListImageCell.swift
//  ToBeDone
//
//  Created by 周星 on 11/18/16.
//  Copyright © 2016 周星. All rights reserved.
//


import UIKit

class IGListImageSetCell: UICollectionViewCell {
    
    //@IBOutlet weak var  imageView: UIImageView!
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.backgroundColor = .white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

