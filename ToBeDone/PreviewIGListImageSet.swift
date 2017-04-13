//
//  File.swift
//  ToBeDone
//
//  Created by 周星 on 11/28/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import IGListKit



class previewIGListImageSectionController : IGListSectionController, IGListSectionType {
    
    var object: IGListImageModel?
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        //let height = collectionContext!.containerSize.height
        return CGSize(width: 120, height: 120)
    }
    
     func didUpdate(to object: Any) {
        self.object = object as? IGListImageModel
        
    }
    
    func didSelectItem(at index: Int) {}
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
      //  [self.phtotLocationTableview registerNib:[UINib nibWithNibName:@"placePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"placePhotoTableViewCell"];
        let cell = collectionContext!.dequeueReusableCell(withNibName: "PreviewIGListImageSetCell", bundle: nil, for: self, at:index)  as! PreviewIGListImageSetCell
        
        if let object = object {
            cell.image.image = object.image
            cell.contentMode = .scaleAspectFit
        }
        else {
            print("object in section controller is nil")
        }
        return cell
    }
}
