//
//  newTableCellTableViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 12/4/16.
//  Copyright © 2016 周星. All rights reserved.
//
//
import UIKit
import IGListKit


class ItemTableCell_WithImage: ItemTableCell_WithoutImage {
    
    @IBOutlet weak var imageCollection: UICollectionView!

    override var cellModel : ItemCellModel? {
        didSet {
            titleLabel.text = cellModel!.title
            noteLabel.text = cellModel!.note
            imageCollection.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initImageCollectionView()
    }
    
    
    func initImageCollectionView() {
        imageCollection.showsHorizontalScrollIndicator = false
        imageCollection.backgroundColor = .clear
        let layout = HorizontalFlowLayout.init()
        imageCollection.collectionViewLayout = layout
        imageCollection.dataSource = self
        imageCollection.delegate = self
        imageCollection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
}
