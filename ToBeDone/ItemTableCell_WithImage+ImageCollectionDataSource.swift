//
//  ItemTableCell_WithImage+ImageCollectionDataSource.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

extension ItemTableCell_WithImage : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.itemCellsStateCollection[cellIndex!].images.count
    }
    //cellForItemAt indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.imageView.image = self.viewModel.itemCellsStateCollection[cellIndex!].images[indexPath.row]

        return cell
    }
}
