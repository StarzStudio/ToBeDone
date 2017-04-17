
///////////////////////////////////////////////////////////////////////////
// ItemState.swift                                                       //
// ToBeDone                                                              //
// ver 1.0                                                               //
// Language:      Swift, Xcode 8.3                                       //
// Platform:      Mac Book Pro, OS X Sierra 10.12.3                      //
// Application:   2BDone                                                 //
// Created by     Xing Zhou on 4/16/17.                                  //
// Personal Web:  http://www.xingzhou.us                                 //
// work email:    business.xingzhou@gmail.com                            //
// Copyright © 2017 Xing Zhou. All rights reserved.                      //
///////////////////////////////////////////////////////////////////////////
/*
 * File Operation:
 * -------------------
 * cache the item's state in itemDetailViewController
 *
 * --------------
 * Required Files:
 * None.
 
   Public Interface:
   modifyItem(Item)  : inject the item to be modified
   saveState()       : store the item into db
 
   Note :
   ----------------
   All the computing properties are supposed to be set before call saveState()
 
 *
 * Maintenance History:
 * --------------------
 * ver 1.0 : 04-16-2017
 * - first release
 *
 
 
  ToDo:
  1. update the item immediately after setting one of its property if this 
     is a Modifing state
 */


import Foundation
import UIKit



class ItemState {
    
    enum State : String {
        case Initializing
        case Modifing
    }
    private var itemStore = TodoItemStore.sharedInstance
    private var currentState = State.Initializing
    private var item : TodoItem!
    private var todoItemStore = TodoItemStore.sharedInstance
    func modifyItem (itemToBeModified in_item: TodoItem!) {
        item = in_item;
        currentState = State.Modifing
    }
    
    var itemTitle : String {
        get {
            return item.title
        }
        set(newValue) {
            item.title = newValue
        }
    }
    
    var itemAlertDate : String? {
        get {
            return item.alertDate
        }
        set(newValue) {
            item.title = newValue
        }
    }
    var itemScheduledDate : String? {
        get {
            return item.scheduledDate
        }
        set(newValue) {
            item.scheduledDate = newValue
        }
    }
    var itemLocation : String? {
        get {
            return item.location;
        }
        set(newValue) {
            item.location = newValue
        }
    }
    var itemState : String {
        get {
            return item.state;
        }
        set(newValue) {
            item.state = newValue
        }
    }
    var itemChecked : Bool {
        get {
            return item.checked;
        }
        set(newValue) {
            item.checked = newValue
        }
    }
    var itemNote : String? {
        get {
            return item.note;
        }
        set(newValue) {
            item.note = newValue;
        }
    }
    
    var itemTags : [String]? {
        get {
            if item.tags.count > 0 {
                var tags = [String]()
                for tag in item.tags {
                    tags.append(tag.tagName)
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
                // ....
                
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
    
    var itemImages : [UIImage]? {
        get {
            if item.images.count > 0 {
                var images = [UIImage]()
                for e in item.images {
                    if let temp = UIImage(contentsOfFile: e.fileURL) {
                        let image : UIImage = temp
                        images.append(image)
                    } else {
                        print("  Cannot get any images from itemState class")
                    }
                }
            } else {
                return nil
            }
        }
        set(newValue) {
            if let imagesCollection = newValue {
                
                // delete item.images
                // ....
                
                // add new tags
                for image in imagesCollection {
                    let dbImageModel = ImageFile()
                    let imageName = dbImageModel.imageId
                    dbImageModel.fileURL = storeImageToFile(image: image, imageName: imageName)
                    dbImageModel.itemId = item.id
                    
                    item.images.append(dbImageModel)
                }
            }
        }
    }
    
    
    
    fileprivate func storeImageToFile(image: UIImage, imageName: String) -> String? {
        if let data = UIImagePNGRepresentation(image) {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageName = imageName
            let destinationPath = documentsURL.appendingPathComponent(imageName)
            try? data.write(to: destinationPath)
            return destinationPath.absoluteString
        }
        else {
            return nil
        }
    }
//    func addItemTag (newTag in_tag: String) {
//        itemTags.append(in_tag)
//    }
//    
//    
//    
//    func removeItemTag (deleteTag in_tag: String) {
//        var deleteIndex = 0
//        for (i, e) in itemTags.enumerated() {
//            if e == in_tag {
//                deleteIndex = i;
//            }
//        }
//        itemTags.remove(at: deleteIndex)
//    }
    
    
    func saveState() {
        todoItemStore.add(item: item)
    }
}
