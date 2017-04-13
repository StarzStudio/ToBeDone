//
//  IGListImageSectionController.swift
//  ToBeDone
//
//  Created by 周星 on 11/18/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import IGListKit

class IGListImageSectionController: IGListSectionController, IGListSectionType {
    
    var object: IGListImageModel?
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        //let height = collectionContext!.containerSize.height
        return CGSize(width: 120, height: 120)
    }
    
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "IGListImageSetCell", for: self, at: index) as! IGListImageSetCell

        if let object = object {
            cell.image.image = object.image
            cell.contentMode = .scaleAspectFit
        }
        else {
            print("object in section controller is nil")
        }
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.object = object as? IGListImageModel

    }
    
    func didSelectItem(at index: Int) {}
}

