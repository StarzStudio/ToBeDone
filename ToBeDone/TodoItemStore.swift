//
//  TodoItemStore.swift
//  2BDone
//
//  Created by 周星 on 10/20/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import RealmSwift



class TodoItemStore {
    
    static let sharedInstance = TodoItemStore()
    
    fileprivate let db : Realm!
    
    let dbManager = RealmDBManager.sharedInstance
    
    init(){
      db = dbManager.createDB()
    }
    
    // delete all the items with "Trash" state
    deinit {
        let itemsToBeDeleted = queryItems(withState: "Trash")
        for item in itemsToBeDeleted {
            delete(item: item)
        }
       
    }
    public func getAllTodoItems() -> [TodoItemDTO] {
        let results = db.objects(TodoItem.self)
        var itemsCollection = [TodoItemDTO]()
        for realmObj in results {
            let itemDTO = transferToDTO(with: realmObj)
            itemsCollection.append(itemDTO)
        }
        
        return itemsCollection;
    }
    

    public func queryItems(withState stateName: String) -> [TodoItemDTO] {
        
        
        let itemObjs = db.objects(TodoItem.self).filter("state == '\(stateName)'")
        var itemsCollection = [TodoItemDTO]()
        for itemObj in itemObjs {
            let itemDTO = transferToDTO(with: itemObj)
            itemsCollection.append(itemDTO)
        }
        return itemsCollection
    }
    
    
    
    public func add(item : TodoItemDTO) {
        let itemObj = transferToRealObj(with: item)
        for (imageID, image) in item.images {
            storeImageToDisk(image: image, imageFilePath: getImageFilePath(imageName: imageID))
        }
        try! db.write {
            db.add(itemObj)
        }
    }
    
    public func update(item itemDTO: TodoItemDTO) {
        updateImagesInDisk(item: itemDTO)
        let newItemObj = transferToRealObj(with: itemDTO)
        Debug.log(message: newItemObj.state)
        try! db.write {
            db.add(newItemObj, update: true)
        }
    }
    
    
    
    public func delete(item: TodoItemDTO){

        let itemObj = findItem(withID: item.id)
        for image in itemObj.images {
            deleteImageFromDisk(fileURLPath: image.fileURL!)
        }

        try! db.write {
            db.delete(itemObj)
        }
    }
    
}

extension TodoItemStore {
    
    fileprivate func updateImagesInDisk(item: TodoItemDTO) {
        let oldItemObj = findItem(withID: item.id)
        // delete old images from the disk
        for oldImageObj in oldItemObj.images {

            if !item.images.keys.contains(oldImageObj.imageId) {
                self.deleteImageFromDisk(fileURLPath: getImageFilePath(imageName: oldImageObj.imageId))
            }
        }
        // store new images to the disk

        for (imageID, image) in item.images {
            var isContainedInOldImageObj = true;
            for oldImageObj in oldItemObj.images {
                if oldImageObj.imageId == imageID {
                    isContainedInOldImageObj = true
                    break
                }
            }
            if isContainedInOldImageObj == false {
                storeImageToDisk(image: image, imageFilePath: getImageFilePath(imageName: imageID))
            }
        }
    }


    // store a single image to the disk
    fileprivate func storeImageToDisk(image: UIImage, imageFilePath: String) {
        let fileURL = URL.init(string: imageFilePath)!
        if let data = UIImagePNGRepresentation(image) {
            try? data.write(to: fileURL)
        }
        
    }
    

    // delete a single image from the disk
    fileprivate func deleteImageFromDisk(fileURLPath : String) {
        let fileManager = FileManager.default
        
        // Delete 'hello.swift' file
        
        do {
            try fileManager.removeItem(atPath: fileURLPath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong when deleting the file: \(error)")
        }
    }
    
  
    
    fileprivate func findItem(withID id: String) -> TodoItem {
        let item = db.object(ofType: TodoItem.self, forPrimaryKey: id)!
        Debug.log(message: item.id)
        return item
    }
   
    fileprivate func transferToRealObj(with itemDTO: TodoItemDTO) -> TodoItem {
        let item = TodoItem()
        item.title = itemDTO.title
        item.note = itemDTO.note
        item.alertDate = itemDTO.alertDate
        item.scheduledDate = itemDTO.scheduledDate
        item.checked = itemDTO.checked
        item.location = itemDTO.location
        item.state = itemDTO.state
        item.id = itemDTO.id

        for (imageId, _) in itemDTO.images {
            let dbImageModel = ImageFile()
            dbImageModel.fileURL = getImageFilePath(imageName: imageId)
            dbImageModel.imageId = imageId
            dbImageModel.itemId = itemDTO.id
            item.images.append(dbImageModel)
        }

        for tag in itemDTO.tags {
            let tagObj = Tag()
            tagObj.tagName = tag
            tagObj.itemId = item.id
            item.tags.append(tagObj)
        }
        return item
    }

    fileprivate func transferToDTO(with itemObj: TodoItem) -> TodoItemDTO {
        let itemDTO = TodoItemDTO()
        itemDTO.title = itemObj.title
        itemDTO.note = itemObj.note
        itemDTO.alertDate = itemObj.alertDate
        itemDTO.checked = itemObj.checked
        itemDTO.location = itemObj.location
        itemDTO.scheduledDate = itemObj.scheduledDate
        itemDTO.state = itemObj.state
        itemDTO.id = itemObj.id

        var images = [String : UIImage]()
        for e in itemObj.images {
            if let temp = UIImage(contentsOfFile: e.fileURL!) {
                let image : UIImage = temp
                images[e.imageId] = image
            } else {
                Debug.log(message: "  Cannot get any images from this URL")
            }
        }
        itemDTO.images = images

        var tags = [String]()
        for tag in itemObj.tags {
            tags.append(tag.tagName!)
        }
        itemDTO.tags = tags;
        return itemDTO
    }
    
    fileprivate func getImageFilePath(imageName : String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageName = imageName
        let destinationPath = documentsURL.appendingPathComponent(imageName)
        return destinationPath.path
    }
}
