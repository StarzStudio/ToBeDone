//
//  IGListImageSectionController.swift
//  ToBeDone
//
//  Created by 周星 on 11/18/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import IGListKit

class SwipeIGListController: IGListSectionController, IGListSectionType {
    
    var object: TodoItem?
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        //let height = collectionContext!.containerSize.height
        return CGSize(width: 340, height: 500)
    }
    
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "SwipeViewCell", for: self, at: index) as! SwipeViewCell
        
        if let object = object {
            cell.getInfoAndDisplay(item: object)
        }
        else {
            print("object in section controller is nil")
        }
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.object = object as? TodoItem
        
    }
    
    func didSelectItem(at index: Int) {}
}

