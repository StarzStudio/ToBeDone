//
//  IGListImage.swift
//  ToBeDone
//
//  Created by 周星 on 11/26/16.
//  Copyright © 2016 周星. All rights reserved.
//

import  UIKit
import IGListKit

class IGListImageModel :UIImage {
 
    let id = UUID()
    var image : UIImage?
    init(image: UIImage) {
        super.init()
        self.image = image
    }
    
    required convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteralResourceName:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if let object = object as? IGListImageModel {
            return self.id == object.id
        }
        return false
    }
}
