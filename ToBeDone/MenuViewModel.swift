//
//  MenuViewModel.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

struct MenuItemState {
    let name : String?
    let image : UIImage?
    var unfinishedNum : Int?
}

class MenuViewModel {
    
    static let sharedInstance = MenuViewModel()
    
    let db = TodoItemStore.sharedInstance
    
    var menuList : [MenuItemState]
    
    init () {
        menuList = [MenuItemState(name: "Inbox",
                                  image: UIImage(named: "inbox_menu"),
                                  unfinishedNum: 0),
                    MenuItemState(name: "Today",
                                  image: UIImage(named: "today_menu"),
                                  unfinishedNum: 0) ,
                    MenuItemState(name: "Schedule",
                                  image: UIImage(named: "scheduled_menu"),
                                  unfinishedNum: 0),
                    MenuItemState(name: "Archived",
                                  image: UIImage(named: "logbook_menu"),
                                  unfinishedNum: 0)]
//                    MenuItemState(name: "Setting",
//                                  image: UIImage(named: "setting_menu"),
//                                  unfinishedNum: 0)]
    }
    func updateMenuList() {
        calculateRemainingItems()
    }
    
    private func calculateRemainingItems() {
        menuList[0].unfinishedNum = db.queryItems(withState: "Inbox").count
        menuList[1].unfinishedNum = db.queryItems(withState: "Today").count
        menuList[2].unfinishedNum = db.queryItems(withState: "Scheduled").count
        menuList[3].unfinishedNum = db.queryItems(withState: "Archived").count

    }
    
    
}
