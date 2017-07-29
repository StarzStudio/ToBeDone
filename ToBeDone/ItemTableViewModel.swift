//
//  ItemTableViewModel.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

enum ActionOnCellType {
    case Log
    case Delete
    case Select
    case DisSelect
    case Restore
}

class ItemTableViewModel {
    
    static var sharedInstance = ItemTableViewModel()
    private let itemStore = TodoItemStore.sharedInstance
    var currentTableContentType = "" {
        didSet {
            updateData()
        }
    }
    var itemsCollection = [TodoItemDTO]() {
        didSet {
            getItemCellsStateContentFromCollection()
        }
    }
    
    var itemCellModelsCollection = [ItemCellModel]()
    
    
    
    private func getItemCellsStateContentFromCollection() {
        //clear all old data
        itemCellModelsCollection.removeAll()
        
        for (index, item) in itemsCollection.enumerated() {
            let itemModel = ItemCellModel()
            itemModel.cellIndex = index
            itemModel.title = item.title
            itemModel.note = item.note
            itemModel.state = item.state
            itemModel.tags = item.tags
            itemModel.createdDate = item.createdDate
            itemModel.scheduledDate = item.scheduledDate
            itemModel.alertDate = item.alertDate
            itemModel.images = Array( item.images.values)
            itemCellModelsCollection.append(itemModel)
        }
    }
    
    
    
    // triggered when user click the action button in table view
    func actionOnSelectedCells (actionType : ActionOnCellType) {
        switch actionType {
        case .Log:
            updateItemsState(newState: "Archived")
        case .Delete:
            updateItemsState(newState: "Trash")
    
        default:
            break
        }
         updateTableViewAction()
    }
    
    func actionOnSingleCell (itemCellIndex : Int, actionType : ActionOnCellType) {
       
        let item = itemsCollection[itemCellIndex]
        switch actionType {
        case .Log:
            updateItemState(item: item, newState: "Archived")
            AlertMessage.successStatusline(body:  "Logged the stick successfully!")
        case .Delete:
            updateItemState(item: item, newState: "Trash")
        case .Select:
            self.itemCellModelsCollection[itemCellIndex].isChecked = true
        case .DisSelect:
            self.itemCellModelsCollection[itemCellIndex].isChecked = false
        case .Restore:
            updateItemState(item: item, newState: "Inbox")
            AlertMessage.successStatusline(body:  "Restored the stick successfully!")


        }
         updateTableViewAction()
    }
    
    private let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")

    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
    }
    
    
   
    
    
    
    // change all selected item cells' items' state
    fileprivate func updateItemsState (newState : String) {
        for (itemIndex, ItemCellModel) in itemCellModelsCollection.enumerated() {
            if ItemCellModel.isChecked == true {
                let selectedItem = itemsCollection[itemIndex]
                selectedItem.state =  newState
                itemStore.update(item: selectedItem)
            }
        }
    }
    
    
    fileprivate func updateItemState (item : TodoItemDTO, newState : String) {
        item.state =  newState
        itemStore.update(item: item)
       
    }
    
    func updateData() {
        itemsCollection = itemStore.queryItems(withState: currentTableContentType)
    }

    
}
