//
//  ItemTableViewModel.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import AFDateHelper
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
    
    var scheduledSections = [ScheduledItemSectionModel]() 
    
    
    private func getItemCellsStateContentFromCollection() {
        
        if currentTableContentType == "Scheduled" {
            getItemCellsStateContent_schduled()
        } else {
            getItemCellsStateContent_normal()
        }
        
    }
    
    
    private func  getItemCellsStateContent_normal() {
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
    private func  getItemCellsStateContent_schduled() {
        
        scheduledSections.removeAll()
        
        let schedulePast = ScheduledItemSectionModel()
        let scheduledThisWeek = ScheduledItemSectionModel()
        let scheduledNextWeek = ScheduledItemSectionModel()
        let scheduledThisMonth = ScheduledItemSectionModel()
        let scheduledThisYear = ScheduledItemSectionModel()
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
            
            let date =  DateUtilities.dateFrom(dateString: itemModel.scheduledDate!)!
            
            if date.compare(.isEarlier(than: Date())) {
                schedulePast.itemCells.append(itemModel)
                continue
            } else if date.compare(.isThisWeek) {
                scheduledThisWeek.itemCells.append(itemModel)
                continue
            } else if date.compare(.isNextWeek) {
                scheduledNextWeek.itemCells.append(itemModel)
                continue
            } else if date.compare(.isSameMonth(as:Date())) {
                scheduledThisMonth.itemCells.append(itemModel)
                continue
            } else if date.compare(.isThisYear) {
                scheduledThisYear.itemCells.append(itemModel)
                continue
            }
        }
        
         schedulePast.title = "In the past"
         scheduledThisWeek.title = "This week"
         scheduledNextWeek.title = "Next week"
         scheduledThisMonth.title = "This month"
         scheduledThisYear.title = "This year"
        if schedulePast.itemCells.count > 0  {
            scheduledSections.append(schedulePast)

        }
        if scheduledThisWeek.itemCells.count > 0  {
            scheduledSections.append(scheduledThisWeek)
            
        }
        if scheduledNextWeek.itemCells.count > 0  {
            scheduledSections.append(scheduledNextWeek)
            
        }
        if scheduledThisMonth.itemCells.count > 0  {
            scheduledSections.append(scheduledThisMonth)
            
        }
        if scheduledThisYear.itemCells.count > 0  {
            scheduledSections.append(scheduledThisYear)
            
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
