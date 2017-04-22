//
//  TodoItemDTO.swift
//  ToBeDone
//
//  Created by 周星 on 4/20/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

class TodoItemDTO {
    
    private var item = TodoItem()
    
    var itemObj : TodoItem {
        get {
            return item
        }
        set(newValue) {
            item = newValue
        }
    }
   
    
    var title : String {
        get {
            return item.title
        }
        set(newValue) {
            item.title = newValue
        }
    }
    
    var alertDate : String? {
        get {
            return item.alertDate
        }
        set(newValue) {
            item.title = newValue
        }
    }
    var scheduledDate : String? {
        get {
            return item.scheduledDate
        }
        set(newValue) {
            item.scheduledDate = newValue
        }
    }
    var location : String? {
        get {
            return item.location;
        }
        set(newValue) {
            item.location = newValue
        }
    }
    var state : String {
        get {
            return item.state;
        }
        set(newValue) {
            item.state = newValue
        }
    }
    var checked : Bool {
        get {
            return item.checked;
        }
        set(newValue) {
            item.checked = newValue
        }
    }
    var note : String? {
        get {
            return item.note;
        }
        set(newValue) {
            item.note = newValue;
        }
    }
    
    var tags : [String]? {
        get {
            if item.tags.count > 0 {
                var tags = [String]()
                for tag in item.tags {
                    tags.append(tag.tagName!)
                }
                
                return tags;
                
            }
            else {
                return nil
            }
        }
        set(newValue) {
            if let tagsCollection = newValue {
                
                // delete item.tags
                item.tags.removeAll()
                
                // add new tags
                for tag in tagsCollection {
                    let tagObj = Tag()
                    tagObj.tagName = tag
                    tagObj.itemId = item.id
                    item.tags.append(tagObj)
                }
            }
        }
    }
    
    var images : [UIImage]? {
        get {
            if item.images.count > 0 {
                var images = [UIImage]()
                for e in item.images {
                    if let temp = UIImage(contentsOfFile: (e.fileURL?.absoluteString)!) {
                        let image : UIImage = temp
                        images.append(image)
                    } else {
                        print("  Cannot get any images from itemState class")
                    }
                }
                return images
            } else {
                return nil
            }
        }
        set(newValue) {
            if let imagesCollection = newValue {
                
                // delete item.images
                item.images.removeAll()
                
                // add new tags
                for image in imagesCollection {
                    let dbImageModel = ImageFile()
                    let imageName = dbImageModel.imageId
                    let fileURL = getImageFilePath(imageName: imageName)
                    dbImageModel.fileURL = fileURL
                    imageStore[fileURL] = image
                    dbImageModel.itemId = item.id
                    item.images.append(dbImageModel)
                }
            }
        }
    }
    
    
    var imageStore = Dictionary<URL, UIImage>()
    
    
    private func getImageFilePath(imageName : String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageName = imageName
        let destinationPath = documentsURL.appendingPathComponent(imageName)
        return destinationPath
    }
    

    func addTag (_ tag : String) {
        let tagObj = Tag()
        tagObj.tagName = tag
        tagObj.itemId = item.id
        item.tags.append(tagObj)
    }
    
    func addImage(_ image : UIImage) {
        
        let dbImageModel = ImageFile()
        let imageName = dbImageModel.imageId
        let fileURL = getImageFilePath(imageName: imageName)
        dbImageModel.fileURL = fileURL
        imageStore[fileURL] = image
        dbImageModel.itemId = item.id
        item.images.append(dbImageModel)
    }
}
