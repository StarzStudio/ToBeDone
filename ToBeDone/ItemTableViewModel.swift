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
    
    var itemsCollection = [TodoItemDTO]() {
        didSet {
            getItemCellsStateContent()
        }
    }
    
    var itemCellsStateCollection = [ItemCellState]()
    private let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    
    private func getItemCellsStateContent() {
        for (index, item) in itemsCollection.enumerated() {
            let itemState = itemCellsStateCollection[index]
            itemState.title = item.title
            itemState.note = item.note
            itemState.state = item.state
            itemState.images = item.images!
        }
    }
    
    private func getItemDataFromDB(itemType: String) {
    switch itemType {
        case "Scheduled"
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
    }
    
    func actionOnSingleCell (itemCellIndex : Int, actionType : ActionOnCellType) {
        let item = itemsCollection[itemCellIndex]
        switch actionType {
        case .Log:
            updateItemState(item: item, newState: "LogBook")
        case .Delete:
            updateItemState(item: item, newState: "Trash")
        case .Select:
            self.itemCellsStateCollection[itemCellIndex].isChecked = true
        case .DisSelect:
            self.itemCellsStateCollection[itemCellIndex].isChecked = false
        }
    }
    
    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
    }
    
    
    
    // change all selected item cells' items' state
    private func updateItemsState (newState : String) {
        for (itemIndex, itemCellState) in itemCellsStateCollection.enumerated() {
            if itemCellState.isChecked == true {
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
    
    
}
