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
    private let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    
    
    
    private func getItemCellsStateContentFromCollection() {
        //clear all old data
        itemCellModelsCollection.removeAll()
        
        for (index, item) in itemsCollection.enumerated() {
            let itemModel = ItemCellModel()
            itemModel.cellIndex = index
            itemModel.title = item.title
            itemModel.note = item.note
            itemModel.state = item.state
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
        case .Delete:
            updateItemState(item: item, newState: "Trash")
        case .Select:
            self.itemCellModelsCollection[itemCellIndex].isChecked = true
        case .DisSelect:
            self.itemCellModelsCollection[itemCellIndex].isChecked = false
        }
         updateTableViewAction()
    }
    
    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
    }
    
    
    
    // change all selected item cells' items' state
    private func updateItemsState (newState : String) {
        for (itemIndex, ItemCellModel) in itemCellModelsCollection.enumerated() {
            if ItemCellModel.isChecked == true {
                let selectedItem = itemsCollection[itemIndex]
                selectedItem.state =  newState
                itemStore.update(item: selectedItem)
            }
        }
    }
    
    private func updateItemState (item : TodoItemDTO, newState : String) {
        item.state =  newState
        itemStore.update(item: item)
       
    }
    
    func updateData() {
        itemsCollection = itemStore.queryItems(withState: currentTableContentType)
    }

    
}
