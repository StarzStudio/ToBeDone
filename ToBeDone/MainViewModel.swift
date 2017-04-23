//
//  MainViewModel.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

class MainViewModel {
    
    static let sharedInstance = MainViewModel()
    
    let todoItemStore  = TodoItemStore.sharedInstance
    
    func pushItemsToTableView(withState tableContentType: String,
                              tableViewController : ItemTableViewController) {
       

        tableViewController.viewModel.currentTableContentType = tableContentType
    }
    
    let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    
    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
    }
    
}
