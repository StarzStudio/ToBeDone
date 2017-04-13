//
//  AppDelegate.swift
//  2BDone
//
//  Created by 周星 on 10/20/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?
     let dbManager = RealmDBManager.sharedInstance
     let store = TodoItemStore.sharedInstance;
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NotificationUtility.enableLocalNotifications(application: application)//enable notification
        
        FIRApp.configure()//configure Firebase
        
        // fill realm db for test purpose

        fillDBWithTestData()

        
        FirebaseUtility.syncData()
    
        return true
    }
    
    func fillDBWithTestData() {
        // inbox
        let item1 = TodoItem()
        item1.title = "item1_InBox"
           item1.state = "Inbox"
        item1.modifiedDate = item1.createdDate
        // scheduled
        let item2 = TodoItem()
        item2.title = "item2_Scheduled"
        item2.state = "Scheduled"
        item2.scheduledDate = DateUtility.stringFromScheduledDate(numOfDatesSinceToday: 1)
        item2.modifiedDate = item2.createdDate
        let item6 = TodoItem()
        item6.title = "item6_Scheduled"
        item6.state = "Scheduled"
        item6.scheduledDate =  DateUtility.stringFromScheduledDate(numOfDatesSinceToday: 2)
        item6.modifiedDate = item6.createdDate
        let item7 = TodoItem()
        item7.title = "item7_Scheduled"
        item7.state = "Scheduled"
        item7.scheduledDate =  DateUtility.stringFromScheduledDate(numOfDatesSinceToday: 4)
        item7.modifiedDate = item7.createdDate
        let item8 = TodoItem()
        item8.title = "item8_TScheduled"
        item8.state = "Scheduled"
        item8.modifiedDate = item8.createdDate
        item8.scheduledDate =  DateUtility.stringFromScheduledDate(numOfDatesSinceToday: 7)
        let item9 = TodoItem()
        item9.title = "item9_Scheduled"
        item9.checked = true
        item9.state = "Scheduled"
        item9.modifiedDate = item9.createdDate
        item9.scheduledDate = DateUtility.stringFromScheduledDate(numOfDatesSinceToday: 11)
        let item10 = TodoItem()
        item10.title = "item10_Scheduled"
        item10.checked = true
        item10.state = "Scheduled"
        item10.modifiedDate = item10.createdDate
        item10.scheduledDate = DateUtility.stringFromScheduledDate(numOfDatesSinceToday: 1)
        // today
        let item3 = TodoItem()
        item3.title = "item3_today"
        item3.state = "Today"
        item3.modifiedDate = item3.createdDate
        item3.scheduledDate =  DateUtility.stringFromScheduledDate(numOfDatesSinceToday: 0)
        // logbook
        let item4 = TodoItem()
        item4.title = "item4_logbook"
        item4.checked = true
        item4.modifiedDate = item4.createdDate
        item4.scheduledDate =  DateUtility.stringFromScheduledDate(numOfDatesSinceToday:0)
        item4.state = "LogBook"
        let item11 = TodoItem()
        item11.title = "item11_logbook"
        item11.checked = true
        item11.modifiedDate = item11.createdDate
        item11.scheduledDate =  DateUtility.stringFromScheduledDate(numOfDatesSinceToday:-28)
        item11.state = "LogBook"
        // trash
        let item5 = TodoItem()
        item5.title = "item5_trash"
        item5.modifiedDate = item5.createdDate
        item5.scheduledDate =  DateUtility.stringFromScheduledDate(numOfDatesSinceToday:-11)
        item5.state = "Trash"
        
        
        
        
       
        
        store.add(item: item1)
        //FirebaseUtility.addItemToFirebase(with: item1)
        store.add(item: item2)
       // FirebaseUtility.addItemToFirebase(with: item2)
        store.add(item: item3)
        //FirebaseUtility.addItemToFirebase(with: item3)
        store.add(item: item4)
       // FirebaseUtility.addItemToFirebase(with: item4)
        store.add(item: item5)
       // FirebaseUtility.addItemToFirebase(with: item5)
        store.add(item: item6)
       // FirebaseUtility.addItemToFirebase(with: item6)
        store.add(item: item7)
      //  FirebaseUtility.addItemToFirebase(with: item7)
        store.add(item: item8)
      //  FirebaseUtility.addItemToFirebase(with: item8)
        store.add(item: item9)
       // FirebaseUtility.addItemToFirebase(with: item9)
        store.add(item: item10)
       // FirebaseUtility.addItemToFirebase(with: item10)
        store.add(item: item11)
       // FirebaseUtility.addItemToFirebase(with: item11)
        print("adding success");
        
        let allTodoItems = store.getAllTodoItems()
        for (index, value) in allTodoItems.enumerated() {
            print(" item \(index) is  \(value.title!)")
        }
        
        //FirebaseUtility.addDatabaseToFirebase(database: <#T##Dictionary<String, Any>#>)
        
        // print out db path
        
       dbManager.printDBFilePath()

        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //FirebaseUtility.removeDatabaseFromFirebase()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //FirebaseUtility.syncData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }


}

