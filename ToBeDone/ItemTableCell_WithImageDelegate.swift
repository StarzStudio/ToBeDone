//
//  ItemTableCell_WithImageDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

extension ItemTableCell_WithImage : UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemCount = self.imageCollection.numberOfItems(inSection: section)
        
        
        let firstIndexPath = IndexPath(item: 0, section: section)
        let firstSize = self.collectionView(self.imageCollection, layout: imageCollection.collectionViewLayout, sizeForItemAt: firstIndexPath)
        
        let latIndexPath = IndexPath(item: itemCount - 1, section: section)
        let lastSize = self.collectionView(self.imageCollection, layout: imageCollection.collectionViewLayout, sizeForItemAt: latIndexPath)
       
        
        return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                                0, (collectionView.bounds.size.width - lastSize.width) / 2);
    }
}
