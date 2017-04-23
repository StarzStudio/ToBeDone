//
//  ItemDetailViewModel.swift
//  ToBeDone
//
//  Created by 周星 on 4/18/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import CoreLocation


enum ResultSavingItem {
    case Success
    case Failure(FailureSavingItemTypes)
}

enum FailureSavingItemTypes {
    case FailNoTitleProvided
}

class ItemDetailViewModel : Observer {
    
    enum State : String {
        case Initializing
        case Modifing
    }
    
    static var sharedInstance = ItemDetailViewModel()
    
    // Const 
    let defaultTitleContent = "title..."
    let defaultNoteContent = "Note..."
    let defaultPlaceContent = ""
    let defaultTagsContent = "Add tag..."
    
    
    private var itemStore = TodoItemStore.sharedInstance
    internal var currentState = State.Initializing
    private var itemDTO = TodoItemDTO()
    private var todoItemStore = TodoItemStore.sharedInstance
    private let locationService = LocationService.sharedInstance
    
    var item : TodoItemDTO {
        get {
            return itemDTO
        }
        
    }
    
    // call this func each time when leaving the itemDetailView
    func clean() {
        itemDTO = TodoItemDTO()
    }
    
    func modifyItem (itemToBeModified in_item: TodoItemDTO!) {
        // replace the default item
        itemDTO = in_item;
        currentState = State.Modifing
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
    
    
    // this function is designed to be called by itemViewController's tapConfirmButton func
    func saveState()  {
    
        localServiceStorage()
        remoteServiceStorage()
        

    }
    
    func updateState()  {
        todoItemStore.update(item: itemDTO)
    }
    
    func detectErrorsBeforePersistence () -> ResultSavingItem {
        if itemDTO.title == "" {
            return ResultSavingItem.Failure(.FailNoTitleProvided)
        } else {
            return ResultSavingItem.Success
        }
    }
    private func localServiceStorage() {
        // add item into local  database
        todoItemStore.add(item: itemDTO)
    }
    
    private func remoteServiceStorage() {
        //  FirebaseService.addPhotoToFirebase(from: item)
        //  FirebaseService.addItemToFirebase(with: item)
    }
    
   
    
    // MARK: - location service
    
    func getLocationCentent (completionHandler : @escaping (String) -> Void ) {
        
        locationService.getCurrentPlaceName(placeNameDisplayMode: .concise) { (generatedPlaceName) -> Void in
        
            self.itemDTO.location = generatedPlaceName
            if let unwrapped_generatedPlaceName = generatedPlaceName {
                completionHandler(unwrapped_generatedPlaceName)
            }
    
        }
    }
    
    func getCurrentCLLocation (completionHandler : @escaping (CLLocation) -> Void ) {
        
        locationService.getCurrentCLLocation() { (cllocation) -> Void in
            if let unwrapped_cllocation = cllocation {
                completionHandler(unwrapped_cllocation)
            }
        }

    }
    let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    
    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
    }
  
}
