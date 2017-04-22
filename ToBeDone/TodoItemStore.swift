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
        let results = db.objects(TodoItem.self);
        var itemsCollection = [TodoItemDTO]()
        for realmObj in results {
            let itemDTO = TodoItemDTO()
            itemDTO.itemObj = realmObj
            itemsCollection.append(itemDTO)
        }
        
        return itemsCollection;
    }
    

    public func queryItems(withState: String) -> [TodoItemDTO] {
    
        let state = "state == \(stateName)"
        let itemObjs = db.objects(TodoItem.self).filter(state)
        var itemsCollection = [TodoItemDTO]()
        for itemObj in itemObjs {
            let itemDTO = TodoItemDTO()
            itemDTO.itemObj = itemObj
            itemsCollection.append(itemDTO)
        }
        return itemsCollection
    }
    
    
    public func add(item : TodoItemDTO) {
        
        storeImagesToDisk(item: item)
        try! db.write {
            db.add(item.itemObj)
        }
    }
    
    public func update(item : TodoItemDTO) {
        
        updateImagesInDisk(item: item)
        try! db.write {
            db.add(item.itemObj, update: true)
        }
    }
    

    
    public func delete(item: TodoItemDTO){
        deleteImagesFromDisk(item: item)
        try! db.write {
            db.delete(item.itemObj)
        }
    }
    
    
    
    public func deleteAll(){
        let todoItemDTOsCollection = getAllTodoItems()
        for itemDTO in todoItemDTOsCollection {
            deleteImagesFromDisk(item: itemDTO)
        }
        try! db.write {
            db.deleteAll()
        }
    }
    
}

extension TodoItemStore {
    
    fileprivate func updateImagesInDisk(item: TodoItemDTO) {
        let oldItemObj = findItemInRealmDB(withID: item.itemObj.id)
        // delete old images from the disk
        for oldImageObj in oldItemObj.images {
            let tempURL = oldImageObj.fileURL!
            if !item.imageStore.keys.contains(tempURL) {
                self.deleteImageFromDisk(fileURL: tempURL)
            }
        }
        // store new images to the disk
        var isContainedInOldImageObj = true;
        for (fileURL, image) in item.imageStore {
            for oldImageObj in oldItemObj.images {
                if oldImageObj.fileURL! == fileURL {
                    isContainedInOldImageObj = true
                    break
                }
            }
            if isContainedInOldImageObj == false {
                storeImageToDisk(image: image, imageFilePath: fileURL)
            }
        }
    }
    // store all the images of an item to the disk
    fileprivate func storeImagesToDisk(item: TodoItemDTO) {
        for (fileURL, image) in item.imageStore {
            storeImageToDisk(image: image, imageFilePath: fileURL)
        }
    }
    
    // delte all the images of an item from the disk
    fileprivate func deleteImagesFromDisk(item: TodoItemDTO) {
        for fileURL in item.imageStore.keys {
            deleteImageFromDisk(fileURL: fileURL)
        }
    }
    
    // delete a single image from the disk
    fileprivate func deleteImageFromDisk(fileURL : URL) {
        let fileManager = FileManager.default
        
        // Delete 'hello.swift' file
        
        do {
            try fileManager.removeItem(atPath: fileURL.path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong when deleting the file: \(error)")
        }
    }
    
    
    // store a single image to the disk
    fileprivate func storeImageToDisk(image: UIImage, imageFilePath: URL) {
        if let data = UIImagePNGRepresentation(image) {
            try? data.write(to: imageFilePath)
        }
        
    }
    
    
    fileprivate func findItemInRealmDB(withID id: String) -> TodoItem {
        
        let item = db.objects(TodoItem.self).filter("id == '\(id)'").first
        //        if(item != nil){
        //            delete(item: item!)
        //        }
        //        else{
        //            print("no such item.")
        //        }
        return item!
        
    }

}
