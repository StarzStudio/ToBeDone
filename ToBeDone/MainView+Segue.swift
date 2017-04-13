//
//  MainView+Segue.swift
//  ToBeDone
//
//  Created by 周星 on 11/8/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import RealmSwift

//extension MainViewController : SegueHandlerType{
//    
//    // MARK: - Segue
//    
//    enum SegueIdentifier: String {
//        // teble list
//        case ShowInbox
//        case ShowScheduled
//        case ShowToday
//        case ShowLogBook
//        case ShowTrash
//        // item's detail view
//        case ShowItemDetail
//    }
//    
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var items: Results<TodoItem>!
//        var collectionType: String!
//        var isTableList = false
//        switch segueIdentifierForSegue(segue: segue) {
//        case .ShowInbox:
//            items = todoItemStore.query(stateName: "'Inbox'", property:"scheduledDate");
//            collectionType = "Inbox"
//            isTableList = true
//        case .ShowScheduled:
//            items = todoItemStore.query(stateName: "'Scheduled'", property: "scheduledDate");
//            collectionType = "Scheduled"
//            isTableList = true
//        case .ShowToday:
//            items = todoItemStore.query(stateName: "'Today'", property: "scheduledDate");
//            collectionType = "Today"
//            isTableList = true
//        case .ShowLogBook:
//            items = todoItemStore.query(stateName: "'logged'", property: "scheduledDate");
//            collectionType = "LogBook"
//            isTableList = true
//        case .ShowTrash:
//            items = todoItemStore.query(stateName: "'deleted'", property: "scheduledDate");
//            collectionType = "Trash"
//            isTableList = true
//        case .ShowItemDetail:
//            break;
//        }
//        
//        if (isTableList == true) {
//            let toDoItemsViewController = segue.destination as! ToDoItemsViewController
//            toDoItemsViewController.items = items
//            toDoItemsViewController.collectionType = collectionType
//        }
//    }
//    
//}
